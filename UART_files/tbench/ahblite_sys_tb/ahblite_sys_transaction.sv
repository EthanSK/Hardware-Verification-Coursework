class ahblite_sys_transaction;
    
    rand bit [7:0] d_in; //goes to RsRx terminal (parity will be calculated in the driver)

    bit [7:0] d_out; //output at RsTx with parity stripped out
    
    bit[31:0] test_id;
    
    function void print(string tag="");
        $display ("T=%0t [Transaction] (Tag: %s) test_id=%0d d_in=0x%0h d_out=0x%0h", $time, tag, test_id, d_in, d_out);
    endfunction
endclass
