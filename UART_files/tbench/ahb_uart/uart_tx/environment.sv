import pkg::*; //have to import * - importing each one manually gives errors about not being able to find it

class environment;
    scoreboard scb;
    monitor mon;
    driver drv;
    generator gen;

    mailbox scb_mbx;
    mailbox drv_mbx;

    virtual _if vif;
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
            gen.run();
            drv.run();
            mon.run();
            scb.run();
        join_any
    endtask
endclass