import ahb_uart_pkg::ahb_uart_test;

module ahb_uart_testbench
#(parameter BAUD_RATE=18'd19200)
;
    reg clk;
    reg baud_tick;

    ahb_uart_if _if(clk, baud_tick);

    always #10ns clk = ~clk; //50 mhz clock

    BAUDGEN 
    #(.CLOCK_HZ(50_000_000))
    uBAUDGEN(
        .clk(clk),
        .resetn(_if.HRESETn),
        .baud_rate(BAUD_RATE),
        .baudtick(baud_tick)
    ); //used just so we can read the data at the correct rate in the tx monitor for eg

    AHBUART DUT(
        .HCLK(clk),
        .HRESETn(_if.HRESETn),
        .HADDR(_if.HADDR),
        .HTRANS(_if.HTRANS),
        .HWDATA(_if.HWDATA),
        .HWRITE(_if.HWRITE),
        .HREADY(_if.HREADY),
        .HREADYOUT(_if.HREADYOUT),
        .HRDATA(_if.HRDATA),
        .HSEL(_if.HSEL),
        .RsRx(_if.RsRx),
        .RsTx(_if.RsTx),
        .uart_irq(_if.uart_irq),

        .PARITYSEL(_if.PARITYSEL),
        .parity_fault_injection(1'b0),
        .PARITYERR(_if.PARITYERR),
        .baud_rate(BAUD_RATE)
        );

    initial begin
        automatic ahb_uart_test t = new;        

        $display ("T=%0t [Testbench] Testbench starting...", $time);

        clk <= 0;
        _if.HRESETn <= 0;
        _if.PARITYSEL <= 1'b0; //even parity        
        _if.RsRx <= 1'b1; //put on stop bit
         #40 _if.HRESETn <= 1;
        
        t.env.vif = _if;
        fork
            t.run();            
        join


        $display ("T=%0t [Testbench] Testbench finishing...", $time);
        $stop;
    end
endmodule