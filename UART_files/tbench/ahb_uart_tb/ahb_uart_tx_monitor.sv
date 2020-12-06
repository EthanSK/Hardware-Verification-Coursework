import ahb_uart_pkg::ahb_uart_transaction;



//this class monitors the output on the tx line of the uart
class ahb_uart_tx_monitor
#(parameter TX_OUT_SIZE=11) //number of bits in tx output including start and stop and parity
;
    virtual ahb_uart_if vif;
    mailbox scb_mbx;
    mailbox cur_transactions;
 
 
    task run();
        $display ("T=%0t [Monitor] Monitor is starting...", $time);
        forever begin
            @ (posedge vif.clk);
            if (~vif.RsTx) begin //start bit is 0, stop bit is 1. when the tx start bit is 0 we know it has started transmitting,
                ahb_uart_transaction t = new; 
                ahb_uart_transaction cur_tr; // get the corresponding input now so we can pair it in the newly created transaction
                
                logic [TX_OUT_SIZE-3:0] d_out; //tx output with parity minus start and stop bits
                logic [TX_OUT_SIZE-1:0] tx_out; //includes the start and stop bits - so 11 bits
 
                $display ("T=%0t [Monitor] Monitor processing item...", $time);
                // @ (posedge vif.clk);
                for (int i = 0; i < TX_OUT_SIZE; i++) begin //includes start and stop state
                    @ (posedge vif.clk); // in data state
                    @ (posedge vif.clk); // in data state
                    @ (posedge vif.clk);
                    tx_out[i] = vif.RsTx;
                    for (int j = 0; j < 16; j++) @ (posedge vif.baud_tick); //wait for 16 baud ticks because it's oversampled
                end //sample the output bits

                d_out = tx_out[TX_OUT_SIZE-2:1]; //remove the start and stop bits
                cur_transactions.get(cur_tr);
                $display ("Actual: %d RealExpected: %d", d_out[7:0], cur_tr.HWDATA[7:0]); //TODO: - remove
                t.HWDATA = cur_tr.HWDATA;  
                t.RsTx_data = d_out;
                scb_mbx.put(t);
            end
        end
        
    endtask
endclass
