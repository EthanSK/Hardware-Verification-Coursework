interface ahblite_sys_if(input bit clk, input bit baud_tick);
    //Serial Port Signals
    logic           RsRx;  //logic from RS-232
    logic           RsTx;  //logic to RS-232 //output
    logic           RESETn;
    logic [7:0]     LED;
    logic  [17:0]   baud_rate;
endinterface