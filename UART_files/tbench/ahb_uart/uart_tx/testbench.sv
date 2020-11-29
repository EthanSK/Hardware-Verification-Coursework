import pkg:test;

module testbench;
    reg clk;
    reg baud_tick;

    _if intf(clk, baud_tick);

    UART_TX DUT (
        .clk(clk),
        .resetn(intf.rst_n),
        .tx_start(intf.tx_start),
        .b_tick(baud_tick),
        .d_in(intf.d_in),
        .tx_done(intf.tx_done),
        .tx(intf.tx)
    );

    initial begin
        clk <= 0;
        intf.resetn <= 0;
        intf.tx_start <= 0;

        test t = new;        
        t.env.vif = intf;
        t.run();

        #1000 $finish;
    end
endmodule