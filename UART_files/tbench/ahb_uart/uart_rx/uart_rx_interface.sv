interface uart_rx_if(input bit clk, input bit baud_tick);
    logic                resetn;
    logic                rx;
    logic [8:0]          dout;
    logic [8:0]          d_in; //to allow the driver to send the input directly to the monitor for simplicity
    logic                rx_done;
 endinterface