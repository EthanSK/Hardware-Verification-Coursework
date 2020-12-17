import ahblite_sys_pkg::ahblite_sys_transaction;



//this class monitors the output on the tx line of the uart
class ahblite_sys_monitor
#(parameter TX_OUT_SIZE=11) //number of bits in tx output including start and stop and parity
;
    virtual ahblite_sys_if vif;
    mailbox scb_mbx;
    mailbox tr_mbx;
 
    task run();
        $display ("T=%0t [Monitor] Monitor is starting...", $time);
        forever begin
            @ (posedge vif.clk);
            if (~vif.RsTx) begin //start bit is 0, stop bit is 1. when the tx start bit is 0 we know it has started transmitting,
                ahblite_sys_transaction t; 
                 
                logic [TX_OUT_SIZE-3:0] d_out; //tx output with parity minus start and stop bits
                logic [TX_OUT_SIZE-1:0] tx_out; //includes the start and stop bits - so 11 bits
                tr_mbx.get(t);
                $display ("T=%0t [Monitor] Monitor processing item...", $time);
                // @ (posedge vif.clk);
                for (int i = 0; i < TX_OUT_SIZE; i++) begin //includes start and stop state

                    for (int j = 0; j < 8; j++) @ (posedge vif.baud_tick);
                    tx_out[i] = vif.RsTx; //sample it right in the middle of the oversample cycle so that it is the most stable it can be...otherwise it don't work
                    for (int j = 0; j < 8; j++) @ (posedge vif.baud_tick); //wait for 16 baud ticks because it's oversampled                    
                    
                end //sample the output bits

                d_out = tx_out[TX_OUT_SIZE-3:1]; //remove the start and stop bits and parity
                
                t.d_out = d_out;
                scb_mbx.put(t);

               end
        end
        
    endtask
endclass
