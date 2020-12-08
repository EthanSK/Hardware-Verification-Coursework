import parity_gen_pkg::*; //have to import * - importing each one manually gives errors about not being able to find it

class parity_gen_environment;
    parity_gen_scoreboard scb;
    parity_gen_runner runner;
    parity_gen_generator gen;

    mailbox scb_mbx;
    mailbox drv_mbx;
 
    virtual parity_gen_if vif;
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