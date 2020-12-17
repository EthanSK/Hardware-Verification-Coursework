//Ethan Sarif-Kattan & LH Lee

import parity_gen_pkg::parity_gen_transaction;

class parity_gen_runner; //easier in this case to combine monitor and driver to sync correctly
    mailbox drv_mbx;
    mailbox scb_mbx;
    event drv_done;
    virtual parity_gen_if vif;

    task run();
        $display ("T=%0t [Runner] Driver is starting...", $time);        
        forever begin
            parity_gen_transaction t;
            $display ("T=%0t [Runner] Driver waiting for item...", $time);
            drv_mbx.get(t); //blocks until next item is present
            t.print("Driver");
            vif.d_in <= t.d_in;
            vif.is_even_parity <= t.is_even_parity;
            vif.parity_fault_injection <= t.parity_fault_injection;
            @(posedge vif.clk); 

            t.d_out = vif.d_out;
            scb_mbx.put(t);

            ->drv_done;             
        end
    endtask
endclass