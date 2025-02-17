//////////////////////////////////////////////////////////////////////////////////
//END USER LICENCE AGREEMENT                                                    //
//                                                                              //
//Copyright (c) 2012, ARM All rights reserved.                                  //
//                                                                              //
//THIS END USER LICENCE AGREEMENT (�LICENCE�) IS A LEGAL AGREEMENT BETWEEN      //
//YOU AND ARM LIMITED ("ARM") FOR THE USE OF THE SOFTWARE EXAMPLE ACCOMPANYING  //
//THIS LICENCE. ARM IS ONLY WILLING TO LICENSE THE SOFTWARE EXAMPLE TO YOU ON   //
//CONDITION THAT YOU ACCEPT ALL OF THE TERMS IN THIS LICENCE. BY INSTALLING OR  //
//OTHERWISE USING OR COPYING THE SOFTWARE EXAMPLE YOU INDICATE THAT YOU AGREE   //
//TO BE BOUND BY ALL OF THE TERMS OF THIS LICENCE. IF YOU DO NOT AGREE TO THE   //
//TERMS OF THIS LICENCE, ARM IS UNWILLING TO LICENSE THE SOFTWARE EXAMPLE TO    //
//YOU AND YOU MAY NOT INSTALL, USE OR COPY THE SOFTWARE EXAMPLE.                //
//                                                                              //
//ARM hereby grants to you, subject to the terms and conditions of this Licence,//
//a non-exclusive, worldwide, non-transferable, copyright licence only to       //
//redistribute and use in source and binary forms, with or without modification,//
//for academic purposes provided the following conditions are met:              //
//a) Redistributions of source code must retain the above copyright notice, this//
//list of conditions and the following disclaimer.                              //
//b) Redistributions in binary form must reproduce the above copyright notice,  //
//this list of conditions and the following disclaimer in the documentation     //
//and/or other materials provided with the distribution.                        //
//                                                                              //
//THIS SOFTWARE EXAMPLE IS PROVIDED BY THE COPYRIGHT HOLDER "AS IS" AND ARM     //
//EXPRESSLY DISCLAIMS ANY AND ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING     //
//WITHOUT LIMITATION WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR //
//PURPOSE, WITH RESPECT TO THIS SOFTWARE EXAMPLE. IN NO EVENT SHALL ARM BE LIABLE/
//FOR ANY DIRECT, INDIRECT, INCIDENTAL, PUNITIVE, OR CONSEQUENTIAL DAMAGES OF ANY/
//KIND WHATSOEVER WITH RESPECT TO THE SOFTWARE EXAMPLE. ARM SHALL NOT BE LIABLE //
//FOR ANY CLAIMS, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, //
//TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE    //
//EXAMPLE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE EXAMPLE. FOR THE AVOIDANCE/
// OF DOUBT, NO PATENT LICENSES ARE BEING LICENSED UNDER THIS LICENSE AGREEMENT.//
//////////////////////////////////////////////////////////////////////////////////


module AHBUART(
  //AHB Signals
  input wire         HCLK,
  input wire         HRESETn,
  input wire  [31:0] HADDR,
  input wire  [1:0]  HTRANS,
  input wire  [31:0] HWDATA,
  input wire         HWRITE,
  input wire         HREADY,
  
  output wire        HREADYOUT,
  output wire [31:0] HRDATA,
  
  input wire         HSEL,
  
  //Serial Port Signals
  input wire         RsRx,  //Input from RS-232
  output wire        RsTx,  //Output to RS-232
  //UART Interrupt
  
  output wire uart_irq,  //Interrupt

  input wire PARITYSEL, //1 for odd parity 0 for even (implemented like this because I saw it in the spec too late)
  input wire parity_fault_injection, //0 for no fault, 1 for fault
  output wire PARITYERR
  // input wire [17:0] baud_rate // we use the bottom 8 bits of HADDR to indicate an update to baud rate
);



//Internal Signals
  
  //Data I/O between AHB and FIFO
  wire [7:0] uart_wdata;  
  wire [7:0] uart_rdata;

  wire [8:0] uart_wdata_parity;  
  wire [8:0] uart_rdata_parity;  

  
  //Signals from TX/RX to FIFOs
  wire uart_wr;
  wire uart_rd;
  

  //wires between FIFO and TX/RX
  wire [8:0] rx_data_parity;
  wire [8:0] tx_data_parity;

  wire [31:0] status;


  //FIFO Status
  wire tx_full;
  wire tx_empty;
  wire rx_full;
  wire rx_empty;
  
  //UART status ticks
  wire tx_done;
  wire rx_done;
  
  //baud rate signal
  wire b_tick;
  
  //AHB Regs
  reg [1:0] last_HTRANS;
  reg [31:0] last_HADDR;
  reg last_HWRITE;
  reg last_HSEL;
  
  reg [15:0] parity_err_count; 
  reg [15:0] parity_err_count_next;
  
//Set Registers for AHB Address State
  always@ (posedge HCLK)
  begin
    if(HREADY)
    begin
      last_HTRANS <= HTRANS;
      last_HWRITE <= HWRITE;
      last_HSEL <= HSEL;
      last_HADDR <= HADDR;
      parity_err_count <= parity_err_count_next;
    end
  end
  
  
  //If Read and FIFO_RX is empty - wait.
  assign HREADYOUT = ~tx_full;
   
  //UART  write select
  assign uart_wr = last_HTRANS[1] & last_HWRITE & last_HSEL& (last_HADDR[7:0]==8'h00);
  //Only write last 8 bits of Data
  assign uart_wdata = HWDATA[7:0];

  //UART read select
  assign uart_rd = last_HTRANS[1] & ~last_HWRITE & last_HSEL & (last_HADDR[7:0]==8'h00);
  

  assign HRDATA = (last_HADDR[7:0]==8'h00) ? {24'h0000_00,uart_rdata}:status;
  assign status = {parity_err_count,14'b0,tx_full,rx_empty};
  
  assign uart_irq = ~rx_empty; 

  reg [17:0] baud_rate;
  wire set_baud_rate;

  initial baud_rate = 18'd19200;
  assign set_baud_rate = (last_HADDR[7:0] != 8'b0) &last_HWRITE & last_HSEL;

  
   BAUDGEN uBAUDGEN(
    .clk(HCLK),
    .resetn(HRESETn),
    .baud_rate(baud_rate),
    .baudtick(b_tick)
  );
  
  PARITY_GEN
    #(.DATA_IN_WIDTH(8))
  uPARITY_GEN
  (
      .is_even_parity(~PARITYSEL),
      .data_in(uart_wdata[7:0]),
      .parity_fault_injection(parity_fault_injection),
      .data_out(uart_wdata_parity[8:0])
  );   
  

  PARITY_CHECK
    #(.ORIG_DATA_IN_WIDTH(8))
  uPARITY_CHECK
  (
      .is_even_parity(~PARITYSEL),
      .data_in_parity(uart_rdata_parity[8:0]),
      .parity_fault_injection(parity_fault_injection),
      .PARITYERR(PARITYERR)
  );    

  //Transmitter FIFO
  FIFO  
   #(.DWIDTH(9), .AWIDTH(4))
	uFIFO_TX 
  (
    .clk(HCLK),
    .resetn(HRESETn),
    .rd(tx_done),
    .wr(uart_wr),
    .w_data(uart_wdata_parity[8:0]),
    .empty(tx_empty),
    .full(tx_full),
    .r_data(tx_data_parity[8:0])
  );
  
  //Receiver FIFO
  FIFO 
   #(.DWIDTH(9), .AWIDTH(4))
	uFIFO_RX(
    .clk(HCLK),
    .resetn(HRESETn),
    .rd(uart_rd),
    .wr(rx_done),
    .w_data(rx_data_parity[8:0]),
    .empty(rx_empty),
    .full(rx_full),
    .r_data(uart_rdata_parity[8:0]) 
  );

  assign uart_rdata = uart_rdata_parity [7:0]; //extract the actual data without parity so it can be sent to AHB interface

  always @*
  begin 
    parity_err_count_next = parity_err_count;
    if (PARITYERR)
      begin
        parity_err_count_next = parity_err_count + 1;
      end
  end
  //UART receiver
  UART_RX uUART_RX(
    .clk(HCLK),
    .resetn(HRESETn),
    .b_tick(b_tick),
    .rx(RsRx),
    .rx_done(rx_done),
    .dout(rx_data_parity[8:0])
  );
  
  //UART transmitter
  UART_TX uUART_TX(
    .clk(HCLK),
    .resetn(HRESETn),
    .tx_start(!tx_empty),
    .b_tick(b_tick),
    .d_in(tx_data_parity[8:0]),
    .tx_done(tx_done),
    .tx(RsTx)
  );

  

endmodule
