//Ethan Sarif-Kattan & LH Lee

interface parity_check_if(input bit clk, input bit baud_tick);
    logic [8:0] d_in; //with parity
    logic is_even_parity;
    logic parity_fault_injection;
    logic PARITYERR;
endinterface