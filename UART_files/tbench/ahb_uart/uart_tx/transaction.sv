class transaction;

    rand bit [8:0] d_in;
    bit [8:0] d_out;
 
    function void print(string tag="");
        $display ("T=%0t %s d_in=0x%0h d_out=0x%0h", $time, tag, d_in, d_out);
    endfunction
endclass