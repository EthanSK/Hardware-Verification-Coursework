import pkg::transaction;

class driver;
    mailbox drv_mbx;
    event drv_done;
    virtual _if vif;

    task run();
        $display ("T=%0t [Driver] Driver is starting...", $time);

        forever begin
            transaction t;
            $display ("T=%0t [Driver] Driver waiting for item...", $time);
            drv_mbx.get(t);
            t.print("Driver");
            vif.d_in <= t.d_in;
            vif.tx_start <= 1;
            @(posedge vif.clk);
            ->drv_done;
    endtask
endclass