import parity_check_pkg::parity_check_transaction;

class parity_check_generator
#(parameter NUM_TESTS=1000) 
;
    mailbox drv_mbx;
    event drv_done;
     
    task run();
        for (int i = 0; i < NUM_TESTS; i++) begin
            parity_check_transaction tr = new;
            void'(tr.randomize());
            $display ("T=%0t [Generator] Created transaction at index %0d", $time, i);
            drv_mbx.put(tr);
            @(drv_done);
        end
        $display ("T=%0t [Generator] Done generation of %0d transactions", $time, NUM_TESTS);
    endtask
endclass