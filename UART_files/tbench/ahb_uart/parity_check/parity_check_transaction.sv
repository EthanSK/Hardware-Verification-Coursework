//Ethan Sarif-Kattan & LH Lee

class parity_check_transaction;

    rand bit [8:0] d_in; //with parity
    rand bit is_even_parity;
    rand bit parity_fault_injection;
    constraint parity_fault_injection_dist {
        parity_fault_injection dist {
            0 :/ 90,
            1 :/ 10 };
    }
    bit PARITYERR; 

    function void print(string tag="");
        $display ("T=%0t [Transaction] (Tag: %s) d_in=0x%0h is_even_parity=%b parity_fault_injection=%b PARITYERR=%b", $time, tag, d_in, is_even_parity, parity_fault_injection, PARITYERR);
    endfunction
endclass