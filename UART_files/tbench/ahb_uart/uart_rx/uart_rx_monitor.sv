import uart_rx_pkg::uart_rx_transaction;

class uart_rx_monitor
 ;
    virtual uart_rx_if vif;
    mailbox scb_mbx;

 
    task run();
        $display ("T=%0t [Monitor] Monitor is starting...", $time);
        forever begin
            @ (posedge vif.clk);
            if (vif.rx_done) begin
                uart_rx_transaction t = new; 
                logic [8:0] dout; 
                $display ("T=%0t [Monitor] Monitor processing item...", $time);
                @ (posedge vif.clk);

                t.d_in = vif.d_in;
                t.d_out = vif.dout;
                scb_mbx.put(t);
            end
        end
        
    endtask
endclass