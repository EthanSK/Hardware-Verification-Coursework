import pkg::transaction;
import pkg::monitor;
import pkg::scoreboard;
import pkg::driver;

class environment;
    scoreboard scb;
    monitor mon;
    driver drv;

    mailbox scb_mbx;
    // mailbox out_mbx; //change name...actually do we even need this
    virtual if vif;

    function new();
        mon = new;
        drv = new;
        scb = new;

        scb_mbx = new();
        // out_mbx = new();
    endfunction

    virtual task run();
        drv.vif = vif;
        mon.vif = vif;
        mon.scb_mbx = scb_mbx;
        scb.scb_mbx = scb_mbx;
        // mon.out_mbx = out_mbx;
        // scb.out_mbx = out_mbx;

        fork
            scb.run();
            drv.run();
            mon.run();
        join_any
    endtask
endclass