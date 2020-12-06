import ahb_uart_pkg::ahb_uart_test;

module ahb_uart_testbench;
    reg clk;
 
    ahb_uart_if _if(clk, baud_tick);

    always #10ns clk = ~clk; //50 mhz clock

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
        .parity_fault_injection(0),
        .PARITYERR(_if.PARITYERR),
        .baud_rate(19200)
        );

    initial begin
        automatic ahb_uart_test t = new;        

        $display ("T=%0t [Testbench] Testbench starting...", $time);

        clk <= 0;
        _if.HRESETn <= 0;
        _if.PARITYSEL <= 0; //even parity
         #40 _if.HRESETn <= 1;


        t.env.vif = _if;
        t.run();

        #10000ns;
        // $display ("T=%0t [Testbench] Testbench finishing...", $time);
        $stop;
    end
endmodule