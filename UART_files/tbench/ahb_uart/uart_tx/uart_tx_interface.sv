//Ethan Sarif-Kattan & LH Lee

interface uart_tx_if(input bit clk, input bit baud_tick); //can't be called if
    logic                resetn;
    logic                tx_start;
    logic [8:0]          d_in;
    logic                tx_done;
    logic                tx;
endinterface