import ahb_uart_pkg::ahb_uart_transaction;


//this drives input to the ahb from the cpu so that it gets transmitted
class ahb_uart_tx_driver;
    mailbox drv_mbx;
    mailbox tr_mbx;
    event drv_done;
    virtual ahb_uart_if vif;

    task run();
        $display ("T=%0t [Driver] Driver is starting...", $time);        
        forever begin
            ahb_uart_transaction t;
            @(posedge vif.clk);
            $display ("T=%0t [Driver] Driver waiting for item...", $time);
            drv_mbx.get(t); //blocks until next item is present
            tr_mbx.put(t);
            t.print("Driver");
            $display ("Expected: %d (%b)", t.HWDATA[7:0], t.HWDATA[7:0]); //TODO: - remove
            vif.HADDR <= t.HADDR;
            vif.HTRANS <= 2'b10;
            vif.HWRITE <= 1'b1;
            vif.HREADY <= 1'b1;
            vif.HSEL <= 1'b1;
            vif.PARITYSEL <= t.PARITYSEL;
            vif.parity_fault_injection <= t.parity_fault_injection;
            @(posedge vif.clk);
            vif.HWDATA <= t.HWDATA;
            // vif.HWRITE <= 1'b0;
            vif.HSEL <= 1'b0;
            // vif.HTRANS <= 2'b00;            
  
            @(posedge vif.clk);
            @(posedge vif.clk); //this posedge clock saved my life. without it everything breaks.
            while(~vif.HREADYOUT) @(posedge vif.clk); //wait for fifo to have space so we can start sending more
            ->drv_done; //now we know the ahb transmission is done, we can raise the drv_done event to signal for a new transaction to send over

          end
    endtask
endclass