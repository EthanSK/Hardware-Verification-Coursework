import ahb_uart_pkg::ahb_uart_transaction;

//this class monitors the output on the tx line of the uart
class ahb_uart_rx_monitor
#(parameter TX_OUT_SIZE=11) //number of bits in tx output including start and stop and parity
;
    virtual ahb_uart_if vif;
    mailbox scb_mbx;
    mailbox rx_tr_mbx;
 
 
    task run();
        $display ("T=%0t [Monitor] Monitor is starting...", $time);
        forever begin
            ahb_uart_transaction t;
            logic [7:0] d_out;
            @ (posedge vif.clk);
            
            //only try and read if we are not currently writing
            if (~vif.HWRITE && vif.HRDATA) begin                
                vif.HTRANS <= 2'b10;
                vif.HREADY <= 1'b1;
                vif.HSEL <= 1'b1;         
                d_out = vif.HRDATA;
                @(posedge vif.clk);
                vif.HSEL <= 1'b0;
                vif.HTRANS <= 2'b00; 
                rx_tr_mbx.get(t);   
                t.HRDATA = d_out;
                scb_mbx.put(t);
                @(posedge vif.clk);             
             end        
        end
        
    endtask
endclass
