//Ethan Sarif-Kattan & LH Lee

import ahb_uart_pkg::ahb_uart_transaction;



//this class monitors the output on the tx line of the uart
class ahb_uart_tx_monitor
#(parameter TX_OUT_SIZE=11) //number of bits in tx output including start and stop and parity
;
    virtual ahb_uart_if vif;
    mailbox scb_mbx;
    mailbox tx_tr_mbx;
    mailbox rx_tr_mbx;
 
 
    task run();
        $display ("T=%0t [Monitor] Monitor is starting...", $time);
        forever begin
            @ (posedge vif.clk);
            if (~vif.RsTx) begin //start bit is 0, stop bit is 1. when the tx start bit is 0 we know it has started transmitting,
                ahb_uart_transaction t; 
                 
                logic [TX_OUT_SIZE-3:0] d_out; //tx output with parity minus start and stop bits
                logic [TX_OUT_SIZE-1:0] tx_out; //includes the start and stop bits - so 11 bits
                tx_tr_mbx.get(t);
                $display ("T=%0t [Monitor] Monitor processing item...", $time);
                // @ (posedge vif.clk);
                for (int i = 0; i < TX_OUT_SIZE; i++) begin //includes start and stop state

                    for (int j = 0; j < 8; j++) @ (posedge vif.baud_tick);
                    tx_out[i] = vif.RsTx; //sample it right in the middle of the oversample cycle so that it is the most stable it can be...otherwise it don't work
                    for (int j = 0; j < 8; j++) @ (posedge vif.baud_tick); //wait for 16 baud ticks because it's oversampled
                    vif.RsRx = vif.RsTx; //send the tx output directly back into the rx input
                    
                    
                end //sample the output bits

                d_out = tx_out[TX_OUT_SIZE-2:1]; //remove the start and stop bits
                
                // $display ("id: %d Actual: %d RealExpected: %d", t.test_id, d_out[7:0], t.HWDATA[7:0]); 
                t.RsTx_data = d_out;
                scb_mbx.put(t);

                rx_tr_mbx.put(t); // put the transaction data in the rx mailbox so we can check against the inputs later

               end
        end
        
    endtask
endclass
