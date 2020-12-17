//Ethan Sarif-Kattan & LH Lee

interface ahb_uart_if(input bit clk, input bit baud_tick);
    logic          HRESETn;
    logic   [31:0] HADDR;
    logic   [1:0]  HTRANS;
    logic   [31:0] HWDATA;
    logic          HWRITE;
    logic          HREADY;

    logic         HREADYOUT; //output
    logic  [31:0] HRDATA; //output

    logic          HSEL;

    //Serial Port Signals
    logic          RsRx;  //logic from RS-232
    logic         RsTx;  //logic to RS-232 //output
    
    //UART Interrupt

    logic  uart_irq;  //Interrupt //output

    logic  PARITYSEL; //1 for odd parity 0 for even
    logic  parity_fault_injection; //0 for no fault; 1 for fault
    logic  PARITYERR; //output
    logic  [17:0] baud_rate;
endinterface