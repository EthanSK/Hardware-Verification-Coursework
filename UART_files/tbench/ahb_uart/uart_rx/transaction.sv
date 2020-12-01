class uart_rx_transaction;

    rand bit [8:0] d_in; //serial data coming in
    bit [8:0] d_out;  //vector data going out
 
    function void print(string tag="");
        $display ("T=%0t [Transaction] (Tag: %s) d_in=0x%0h d_out=0x%0h", $time, tag, d_in, d_out);
    endfunction
endclass