import pkg::transaction;
import pkg::environment;

class test;
    environment env;
    mailbox drv_mbx;

    function new();
        env = new;
        drv_mbx = new();
    endfunction

    virtual task run();
        env.driver.drv_mbx = drv_mbx;        
        apply_stim();
        fork
            env.run();
        join_none        
    endtask

    virtual task apply_stim();
        transaction tr;
        for(int i = 0; i < 3; i++) begin
            tr = new;
            tr.randomize();
            drv_mbx.put(tr);
        end
    endtask
endclass
        