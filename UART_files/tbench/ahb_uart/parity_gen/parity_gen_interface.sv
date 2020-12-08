interface parity_gen_if(input bit clk, input bit baud_tick);
    logic [7:0] d_in;
    logic [8:0] d_out;
    logic is_even_parity;
    logic parity_fault_injection;
endinterface