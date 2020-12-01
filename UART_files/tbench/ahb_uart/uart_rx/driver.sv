import pkg::uart_rx_transaction;

class uart_rx_driver
#(parameter DATA_SIZE=9) //data size with parity
;
    mailbox drv_mbx;
    event drv_done;
    virtual uart_rx_if vif;

    task run();
        $display ("T=%0t [Driver] Driver is starting...", $time);        
        forever begin
            uart_rx_transaction t;
            $display ("T=%0t [Driver] Driver waiting for item...", $time);
            drv_mbx.get(t); //blocks until next item is present
            t.print("Driver");
            vif.rx <= 0; //start bit
            @(posedge vif.clk);

            for(int i = 0; i < 8; i++) @(posedge vif.b_tick); //might not need this

            for (int i = 0; i < DATA_SIZE; i++ ) begin
                vif.rx <= t.d_in[i];                
                for (int j = 0; j < 16; j++) @ (posedge vif.baud_tick); //wait for 16 baud ticks because it's oversampled
                @ (posedge vif.clk);
            end

            vif.rx <= 1; //stop bit
            while(!vif.tx_done) @(posedge vif.clk);

            ->drv_done; //now we know the transmitter is done, we can raise the drv_done event to signal for a new transaction to send over
            
        end
    endtask
endclass