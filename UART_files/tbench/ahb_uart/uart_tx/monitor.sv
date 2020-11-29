import pkg::transaction;

class monitor;
    virtual _if vif;
    mailbox scb_mbx;

    int tx_out_size = 9; //number of tx output bits

    task run();
        $display ("T=%0t [Monitor] Monitor is starting...", $time);
        forever begin
            @ (posedge vif.clk);
            if (vif.tx_start) begin
                logic [tx_out_size-1:0] d_out; //tx output with parity
                @ (posedge vif.clk);
                for (int i = 0 = i < tx_out_size; i++ ) begin
                    for (int j = 0; j < 16; j++) @ (posedge vif.baud_tick); //wait for 16 baud ticks because it's oversampled
                    d_out[i] = vif.tx;
                end //sample the output bits
                while (!vif.tx_done) @ (posedge vif.clk); //wait until done signal
                transaction t = new;
                t.d_in = vif.d_in;
                t.d_out = d_out;
                $display ("T=%0t [Monitor] Monitor processed item...", $time);
                scb_mbx.put(t);
            end
        end
        
    endtask