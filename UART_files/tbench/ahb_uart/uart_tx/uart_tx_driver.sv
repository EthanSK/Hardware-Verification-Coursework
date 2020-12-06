import uart_tx_pkg::uart_tx_transaction;

class uart_tx_driver;
    mailbox drv_mbx;
    mailbox tr_mbx;    
    event drv_done;
    virtual uart_tx_if vif;

    task run();
        $display ("T=%0t [Driver] Driver is starting...", $time);        
        forever begin
            uart_tx_transaction t;
            $display ("T=%0t [Driver] Driver waiting for item...", $time);
            drv_mbx.get(t); //blocks until next item is present
            tr_mbx.put(t);
            t.print("Driver");
            vif.d_in <= t.d_in;
            
            vif.tx_start <= 1;
            @(posedge vif.clk);
            while(!vif.tx_done) @(posedge vif.clk); //wait for transmitter to complete
            ->drv_done; //now we know the transmitter is done, we can raise the drv_done event to signal for a new transaction to send over
            vif.tx_start <= 0;
        end
    endtask
endclass