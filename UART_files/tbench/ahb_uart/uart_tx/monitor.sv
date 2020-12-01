import pkg::uart_tx_transaction;

class uart_tx_monitor
#(parameter TX_OUT_SIZE=11) //number of bits in tx output including start and stop and parity
;
    virtual uart_tx_if vif;
    mailbox scb_mbx;

 
    task run();
        $display ("T=%0t [Monitor] Monitor is starting...", $time);
        forever begin
            @ (posedge vif.clk);
            if (vif.tx_start) begin
                uart_tx_transaction t = new; //needs to be declared here or weird error
                logic [TX_OUT_SIZE-3:0] d_out; //tx output with parity minus start and stop bits
                logic [TX_OUT_SIZE-1:0] tx_out; //includes the start and stop bits - so 11 bits
                $display ("T=%0t [Monitor] Monitor processing item...", $time);
                @ (posedge vif.clk);
                for (int i = 0; i < TX_OUT_SIZE; i++) begin
                    for (int j = 0; j < 16; j++) @ (posedge vif.baud_tick); //wait for 16 baud ticks because it's oversampled
                    tx_out[i] = vif.tx;
                end //sample the output bits
                while (!vif.tx_done) @ (posedge vif.clk); //wait until done signal
                d_out = tx_out[TX_OUT_SIZE-2:1]; //remove the start and stop bits
                t.d_in = vif.d_in;
                t.d_out = d_out;
                scb_mbx.put(t);
            end
        end
        
    endtask
endclass