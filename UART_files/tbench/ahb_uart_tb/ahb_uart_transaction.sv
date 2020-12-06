class ahb_uart_transaction;

    rand bit [31:0] HWDATA;
    
    rand bit [31:0] HADDR;
    constraint HADDR_bottom_byte {HADDR[7:0] == 8'h00;}

    bit [17:0] baud_rate;
    bit [31:0] HRDATA;
    bit  [1:0]  HTRANS;
    bit PARITYSEL;
    bit PARITYERR;

    bit [8:0] RsTx_data; //output data from tx wire after data has all gone through. includes parity


    function void print(string tag="");
        $display ("T=%0t [Transaction] (Tag: %s) baud_rate=0x%0h HWDATA=0x%0h HADDR=0x%0h HRDATA=0x%0h", $time, tag, baud_rate, HWDATA, HADDR, HRDATA);
    endfunction
endclass