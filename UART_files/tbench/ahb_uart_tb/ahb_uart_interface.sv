interface ahb_uart_if(logic bit clk, logic bit baud_tick); //can't be called if
    logic wire         HRESETn,
    logic wire  [31:0] HADDR,
    logic wire  [1:0]  HTRANS,
    logic wire  [31:0] HWDATA,
    logic wire         HWRITE,
    logic wire         HREADY,

    logic wire        HREADYOUT, //output
    logic wire [31:0] HRDATA, //output

    logic wire         HSEL,

    //Serial Port Signals
    logic wire         RsRx,  //logic from RS-232
    logic wire        RsTx,  //logic to RS-232 //output
    //UART Interrupt

    logic wire uart_irq,  //Interrupt //output

    logic wire PARITYSEL, //1 for odd parity 0 for even
    logic wire parity_fault_injection, //0 for no fault, 1 for fault
    logic wire PARITYERR, //output
    logic wire [17:0] baud_rate
endinterface