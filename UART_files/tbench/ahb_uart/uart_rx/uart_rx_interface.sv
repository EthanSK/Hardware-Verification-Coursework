interface uart_rx_if(input bit clk, input bit baud_tick);
    logic                resetn;
    logic                rx;
    logic [8:0]          dout;
    logic                rx_done;
 endinterface