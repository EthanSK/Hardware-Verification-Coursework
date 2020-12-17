//Ethan Sarif-Kattan & LH Lee

import ahblite_sys_pkg::ahblite_sys_transaction;

class ahblite_sys_driver
#(parameter DATA_SIZE=8) 
;
    mailbox drv_mbx;
    event drv_done;
    virtual ahblite_sys_if vif;
    mailbox tr_mbx;

    task run();
        $display ("T=%0t [Driver] Driver is starting...", $time);        
        forever begin
            ahblite_sys_transaction t;
            $display ("T=%0t [Driver] Driver waiting for item...", $time);
            drv_mbx.get(t); //blocks until next item is present
            t.print("Driver");
            vif.RsRx <= 0; //start bit
 
            for(int i = 0; i < 16; i++) @(posedge vif.baud_tick); //hold in start bit

            for (int i = 0; i < DATA_SIZE; i++ ) begin
                vif.RsRx <= t.d_in[i];                
                for (int j = 0; j < 16; j++) @ (posedge vif.baud_tick); //wait for 16 baud ticks because it's oversampled                
            end
            //send parity bit (hardcoded as odd parity in ahblite sys)
            
            vif.RsRx <= ~^t.d_in; //generate odd parity
            for(int i = 0; i < 16; i++) @(posedge vif.baud_tick); //hold parity for 16            

            vif.RsRx <= 1; //stop bit
            for(int i = 0; i < 16; i++) @(posedge vif.baud_tick); //hold stop for 16
            tr_mbx.put(t);
            ->drv_done;  
            
        end
    endtask
endclass