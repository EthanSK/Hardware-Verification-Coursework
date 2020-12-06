import uart_tx_pkg::uart_tx_transaction;

class uart_tx_monitor
#(parameter TX_OUT_SIZE=11) //number of bits in tx output including start and stop and parity
;
    virtual uart_tx_if vif;
    mailbox scb_mbx;
    mailbox tr_mbx;

    task run();
        $display ("T=%0t [Monitor] Monitor is starting...", $time);
        forever begin
            @ (posedge vif.clk);
            if (vif.tx_start) begin
                uart_tx_transaction t; //needs to be declared here or weird error
                logic [TX_OUT_SIZE-3:0] d_out; //tx output with parity minus start and stop bits
                logic [TX_OUT_SIZE-1:0] tx_out; //includes the start and stop bits - so 11 bits
                tr_mbx.get(t); //get the corresponding input data (d_in)
                $display ("T=%0t [Monitor] Monitor processing item...", $time);
                for (int i = 0; i < TX_OUT_SIZE; i++) begin
                    for (int j = 0; j < 16; j++) @ (posedge vif.baud_tick);
                    tx_out[i] = vif.tx; //read in the middle of the 16 baud tick oversampled cycle
                    @ (posedge vif.clk);
                end //sample the output bits
                while (!vif.tx_done) @ (posedge vif.clk); //wait until done signal
                d_out = tx_out[TX_OUT_SIZE-2:1]; //remove the start and stop bits
                t.d_out = d_out;
                scb_mbx.put(t);
            end
        end
        
    endtask
endclass