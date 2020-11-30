import pkg::uart_tx_test;

module uart_tx_testbench;
    reg clk;
    reg baud_tick;

    uart_tx__if intf(clk, baud_tick);

    UART_TX DUT (
        .clk(clk),
        .resetn(intf.resetn),
        .tx_start(intf.tx_start),
        .b_tick(baud_tick),
        .d_in(intf.d_in),
        .tx_done(intf.tx_done),
        .tx(intf.tx)
    );

    initial begin
        automatic uart_tx_test t = new;        

        $display ("T=%0t [Testbench] Testbench starting...", $time);

        clk <= 0;
        intf.resetn <= 0;
        intf.tx_start <= 0;
        #40 intf.resetn <= 1;


        t.env.vif = intf;
        t.run();

        #1000ns;
        $display ("T=%0t [Testbench] Testbench finishing...", $time);
        $finish;
    end
endmodule