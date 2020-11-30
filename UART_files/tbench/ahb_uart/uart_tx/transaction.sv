class uart_tx_transaction;

    rand bit [8:0] d_in; //this represents the input vector
    bit [8:0] d_out; //this represents each serial bit of the output. each element is the subsequent bit output by the tx.

    //not using because d_in is set by calling randomize() on instance of obj
    // function new(bit [8:0] d_in, d_out); 
    //     d_in=d_in;
    //     d_out=d_out;
    // endfunction
 
    function void print(string tag="");
        $display ("T=%0t [Transaction] (Tag: %s) d_in=0x%0h d_out=0x%0h", $time, tag, d_in, d_out);
    endfunction
endclass