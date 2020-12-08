class parity_gen_transaction;

    rand bit [7:0] d_in; 
    rand bit is_even_parity;
    rand bit parity_fault_injection;
    bit [8:0] d_out; 

    function void print(string tag="");
        $display ("T=%0t [Transaction] (Tag: %s) d_in=0x%0h d_out=0x%0h is_even_parity=%b parity_fault_injection=%b", $time, tag, d_in, d_out, is_even_parity, parity_fault_injection);
    endfunction
endclass