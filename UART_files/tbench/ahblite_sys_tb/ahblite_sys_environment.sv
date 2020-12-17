//Ethan Sarif-Kattan & LH Lee

import ahblite_sys_pkg::*; //have to import * - importing each one manually gives errors about not being able to find it

class ahblite_sys_environment;
    ahblite_sys_generator gen;
    ahblite_sys_scoreboard scb;
    ahblite_sys_monitor mon;
    ahblite_sys_driver drv;
    

    mailbox scb_mbx;
    mailbox drv_mbx;
    mailbox tr_mbx; 
    mailbox num_outstanding_tests; //so we can finish after all tests have completed

    virtual ahblite_sys_if vif;
    event drv_done;

    function new();
        mon = new;
        drv = new;
        scb = new;
        gen = new;

        scb_mbx = new();
        drv_mbx = new();
        tr_mbx = new();
        num_outstanding_tests = new();


        mon.scb_mbx = scb_mbx;
        scb.scb_mbx = scb_mbx;

        drv.drv_mbx = drv_mbx;
        gen.drv_mbx = drv_mbx;

        drv.tr_mbx = tr_mbx;
        mon.tr_mbx = tr_mbx;

        drv.drv_done = drv_done;
        gen.drv_done = drv_done;

        scb.num_outstanding_tests = num_outstanding_tests;
        gen.num_outstanding_tests = num_outstanding_tests;

    endfunction

    virtual task run();
        drv.vif = vif;
        mon.vif = vif;
        scb.vif = vif;        

        fork
            gen.run(); 
            drv.run();
            mon.run();
            scb.run();
         join_any
        
        #40;

        //wait until all tests have complete
        while (num_outstanding_tests.num() !=0 ) 
            begin
                @ (posedge vif.clk); 
                #100;
                // $display ("num_outstanding_tests.num() %0d", num_outstanding_tests.num());
            end
         

        $display ("T=%0t Tx Num tests passed: %0d | Num tests failed: %0d", $time, scb.num_passed, scb.num_failed);

    endtask
endclass