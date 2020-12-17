import ahb_uart_pkg::ahb_uart_transaction;

class ahb_uart_generator
#(parameter NUM_TESTS=1000) 
;
    mailbox drv_mbx;
    mailbox num_outstanding_tests;
    event drv_done;
     
    task run();
        for (int i = 0; i < NUM_TESTS; i++) begin
            ahb_uart_transaction tr = new;
            void'(tr.randomize());
            tr.test_id = i;
            $display ("T=%0t [Generator] Created transaction at index %0d", $time, i);
            drv_mbx.put(tr);
            num_outstanding_tests.put(1);
            @(drv_done);
        end
        $display ("T=%0t [Generator] Done generation of %0d transactions", $time, NUM_TESTS);
    endtask
endclass