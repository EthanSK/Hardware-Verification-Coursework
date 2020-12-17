//Ethan Sarif-Kattan & LH Lee

class ahb_uart_transaction;

    rand bit [31:0] HWDATA;
    
    rand bit [31:0] HADDR;
    constraint HADDR_bottom_byte {HADDR[7:0] == 8'h00;}
    
    bit [31:0] HRDATA;
    bit  [1:0]  HTRANS;
    rand bit PARITYSEL;
    bit PARITYERR;
    rand bit parity_fault_injection;
    constraint parity_fault_injection_dist {
        parity_fault_injection dist {
            0 :/ 90,
            1 :/ 10 };
    }
    
    bit [8:0] RsTx_data; //output data from tx wire after data has all gone through. includes parity

    bit[31:0] test_id;
    

    function void print(string tag="");
        $display ("T=%0t [Transaction] (Tag: %s) HWDATA=0x%0h HADDR=0x%0h HRDATA=0x%0h", $time, tag, HWDATA, HADDR, HRDATA);
    endfunction
endclass


//we can't have a different baud rate at different points in the same UART
    // rand bit [17:0] baud_rate;
    // constraint baud_rate_dist {
    //     baud_rate dist {
    //         110 :/ 7,
    //         300 :/ 7,
    //         600 :/ 7 
    //         1200 :/ 7 
    //         2400 :/ 7 
    //         4800 :/ 7 
    //         9600 :/ 7 
    //         14400 :/ 7 
    //         19200 :/ 7 
    //         38400 :/ 7 
    //         57600 :/ 7 
    //         115200 :/ 7 
    //         128000 :/ 8 
    //         256000 :/ 8
    //     };
    // }
