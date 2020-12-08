import ahb_uart_pkg::ahb_uart_transaction;

//this class monitors the output on the tx line of the uart
class ahb_uart_rx_monitor
#(parameter TX_OUT_SIZE=11) //number of bits in tx output including start and stop and parity
;
    virtual ahb_uart_if vif;
    mailbox scb_mbx;
    mailbox tr_mbx;
 
 
    task run();
        $display ("T=%0t [Monitor] Monitor is starting...", $time);
        forever begin
            @ (posedge vif.clk);

            //only try and read if we are not currently writing
            while(vif.HWRITE) @(posedge vif.clk);

            vif.HADDR <= t.HADDR;
            vif.HTRANS <= 2'b10;
            vif.HWRITE <= 1'b1;
            vif.HREADY <= 1'b1;
            vif.HSEL <= 1'b1;
            vif.PARITYSEL <= t.PARITYSEL;
            vif.parity_fault_injection <= t.parity_fault_injection;
            @(posedge vif.clk);
            vif.HWDATA <= t.HWDATA;
            vif.HWRITE <= 1'b0;
            vif.HSEL <= 1'b0;
            vif.HTRANS <= 2'b00;    
        end
        
    endtask
endclass
