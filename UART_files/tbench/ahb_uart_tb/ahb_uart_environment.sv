import ahb_uart_pkg::*; //have to import * - importing each one manually gives errors about not being able to find it

class ahb_uart_environment;
    ahb_uart_scoreboard scb;
    ahb_uart_tx_monitor tx_mon;
    ahb_uart_tx_driver tx_drv;
    ahb_uart_generator gen;

    mailbox scb_mbx;
    mailbox drv_mbx;

    virtual ahb_uart_if vif;
    event drv_done;

    function new();
        tx_mon = new;
        tx_drv = new;
        scb = new;
        gen = new;
        scb_mbx = new();
        drv_mbx = new();

        mon.scb_mbx = scb_mbx;
        scb.scb_mbx = scb_mbx;

        drv.drv_mbx = drv_mbx;
        gen.drv_mbx = drv_mbx;

        drv.drv_done = drv_done;
        gen.drv_done = drv_done;
    endfunction

    virtual task run();
        drv.vif = vif;
        mon.vif = vif;

        fork
            drv.run();
            mon.run();
            scb.run();
            gen.run();
        join_any
        
        #200ns;
        $display ("T=%0t Num tests passed: %0d | Num tests failed: %0d", $time, scb.num_passed, scb.num_failed);

    endtask
endclass