import pkg::uart_tx_test;

module uart_tx_testbench;
    reg clk;
    reg baud_tick;

    uart_tx_if _if(clk, baud_tick);

    always #10ns clk = ~clk; //50 mhz clock

    BAUDGEN 
    #(.CLOCK_HZ(50_000_000))
    uBAUDGEN(
        .clk(clk),
        .resetn(_if.resetn),
        .baud_rate(18'd19200),
        .baudtick(baud_tick)
    );

    UART_TX DUT (
        .clk(clk),
        .resetn(_if.resetn),
        .tx_start(_if.tx_start),
        .b_tick(baud_tick),
        .d_in(_if.d_in),
        .tx_done(_if.tx_done),
        .tx(_if.tx)
    );

    initial begin
        automatic uart_tx_test t = new;        

        $display ("T=%0t [Testbench] Testbench starting...", $time);

        clk <= 0;
        _if.resetn <= 0;
        _if.tx_start <= 0;
        #40 _if.resetn <= 1;


        t.env.vif = _if;
        t.run();

        #1000ns;
        // $display ("T=%0t [Testbench] Testbench finishing...", $time);
        // $finish; //this quits questasim...
        $stop;
    end
endmodule