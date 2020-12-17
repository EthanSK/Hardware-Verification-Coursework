//Ethan Sarif-Kattan & LH Lee

import parity_check_pkg::*; //have to import * - importing each one manually gives errors about not being able to find it

class parity_check_environment;
    parity_check_scoreboard scb;
    parity_check_runner runner;
    parity_check_generator gen;

    mailbox scb_mbx;
    mailbox drv_mbx;
 
    virtual parity_check_if vif;
    event drv_done;

    function new();
        scb = new;
        runner = new;
        gen = new;
        scb_mbx = new();
        drv_mbx = new();
 
        runner.scb_mbx = scb_mbx;    
        scb.scb_mbx = scb_mbx;
        
        runner.drv_mbx = drv_mbx;
        gen.drv_mbx = drv_mbx;

        runner.drv_done = drv_done;
        gen.drv_done = drv_done;
    endfunction

    virtual task run();
        runner.vif = vif;
        
        fork
            gen.run();
            runner.run();
            scb.run();
         join_any
        
        
        #200ns;
        $display ("T=%0t Num tests passed: %0d | Num tests failed: %0d", $time, scb.num_passed, scb.num_failed);

    endtask
endclass