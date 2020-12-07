import ahb_uart_pkg::ahb_uart_transaction;

class ahb_uart_generator
#(parameter NUM_TESTS=4) 
;
    mailbox drv_mbx;
    event drv_done;
     
    task run();
        for (int i = 0; i < NUM_TESTS; i++) begin
            ahb_uart_transaction tr = new;
            void'(tr.randomize());
            $display ("T=%0t [Generator] Created transaction at index %0d", $time, i);
            drv_mbx.put(tr);
            @(drv_done);
        end
        $display ("T=%0t [Generator] Done generation of %0d transactions", $time, NUM_TESTS);
    endtask
endclass