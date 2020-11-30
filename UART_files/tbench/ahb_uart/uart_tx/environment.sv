import pkg::*; //have to import * - importing each one manually gives errors about not being able to find it

class uart_tx_environment;
    uart_tx_scoreboard scb;
    uart_tx_monitor mon;
    uart_tx_driver drv;
    uart_tx_generator gen;

    mailbox scb_mbx;
    mailbox drv_mbx;

    virtual uart_tx_if vif;
    event drv_done;

    function new();
        mon = new;
        drv = new;
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
    endtask
endclass