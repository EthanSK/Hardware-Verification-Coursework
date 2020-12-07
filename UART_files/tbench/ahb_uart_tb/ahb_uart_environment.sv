import ahb_uart_pkg::*; //have to import * - importing each one manually gives errors about not being able to find it

class ahb_uart_environment;
    ahb_uart_generator gen;

    ahb_uart_tx_scoreboard tx_scb;
    ahb_uart_tx_monitor tx_mon;
    ahb_uart_tx_driver tx_drv;
    

    mailbox scb_mbx;
    mailbox drv_mbx;

    mailbox tr_mbx; //outstanding transactions tht we can pull data from

    mailbox num_outstanding_tests; //so we can finish after all tests have completed

    virtual ahb_uart_if vif;
    event tx_drv_done;

    function new();
        tx_mon = new;
        tx_drv = new;
        tx_scb = new;
        gen = new;
        scb_mbx = new();
        drv_mbx = new();
        tr_mbx = new();
        num_outstanding_tests = new();

        gen.drv_mbx = drv_mbx;
        gen.drv_done = tx_drv_done;

        tx_mon.scb_mbx = scb_mbx;
        tx_scb.scb_mbx = scb_mbx;
        tx_drv.drv_mbx = drv_mbx;
        tx_drv.drv_done = tx_drv_done;
        tx_drv.tr_mbx = tr_mbx;
        tx_mon.tr_mbx = tr_mbx;

        tx_scb.num_outstanding_tests = num_outstanding_tests;
        gen.num_outstanding_tests = num_outstanding_tests;

    endfunction

    virtual task run();
        tx_drv.vif = vif;
        tx_mon.vif = vif;
        tx_scb.vif = vif;

        fork
            gen.run(); 
            tx_mon.run();
            tx_drv.run();
            tx_scb.run();
        join_any
        
        #40;

        //wait until all tests have complete
        while (num_outstanding_tests.num() !=0 ) 
            begin
                @ (posedge vif.clk); 
                #100;
                // $display ("num_outstanding_tests.num() %0d", num_outstanding_tests.num());
            end
        

        // #0.05s; //so it shows after all the tests are actually finished

        //TODO: - fork join any for rx AFTER the tx is done. theerofre we can reuse the vif and the gen...do it here as well after the artificial delay so we can guarantee it runs only after

        $display ("T=%0t Tx Num tests passed: %0d | Num tests failed: %0d", $time, tx_scb.num_passed, tx_scb.num_failed);

    endtask
endclass