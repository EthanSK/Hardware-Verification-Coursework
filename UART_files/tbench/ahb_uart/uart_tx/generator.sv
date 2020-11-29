import pkg::transaction;

class generator;
    mailbox drv_mbx;
    event drv_done;
    int num_tests = 3;
    
    task run();
        for (int i = 0; i < num_tests; i++) begin
            transaction tr = new;
            tr.randomize();
            $display ("T=%0t [Generator] Created transaction at index %0d", $time, num_tests)
            drv_mbx.put(tr);
            @(drv_done)
        end
        $display ("T=%0t [Generator] Done generation of %0d transactions", $time, num_tests)
    endtask
endclass