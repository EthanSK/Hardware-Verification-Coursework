import ahb_uart_pkg::ahb_uart_transaction;


//this drives input to the ahb from the cpu so that it gets transmitted
class ahb_uart_tx_driver;
    mailbox drv_mbx;
    event drv_done;
    virtual ahb_uart_if vif;

    task run();
        $display ("T=%0t [Driver] Driver is starting...", $time);        
        forever begin
            ahb_uart_transaction t;
            $display ("T=%0t [Driver] Driver waiting for item...", $time);
            drv_mbx.get(t); //blocks until next item is present
            t.print("Driver");
            
            vif.HADDR <= t.HADDR;
            vif.HWDATA <= t.HWDATA;

            vif.HTRANS <= 2'b10
            vif.HWRITE <= 1'b1;
            vif.HREADY <= 1'b1;
            vif.HSEL <= 1'b1;
 
            @(posedge vif.clk);
            while(!vif.HREADYOUT) @(posedge vif.clk); //wait for fifo to have space so we can start sending more
            ->drv_done; //now we know the ahb transmission is done, we can raise the drv_done event to signal for a new transaction to send over
         end
    endtask
endclass