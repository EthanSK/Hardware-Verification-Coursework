//Ethan Sarif-Kattan & LH Lee

import uart_rx_pkg::uart_rx_test;

module uart_rx_testbench;
    reg clk;
    reg baud_tick;

    uart_rx_if _if(clk, baud_tick);

    always #10ns clk = ~clk; //50 mhz clock

    BAUDGEN 
    #(.CLOCK_HZ(50_000_000))
    uBAUDGEN(
        .clk(clk),
        .resetn(_if.resetn),
        .baud_rate(18'd19200),
        .baudtick(baud_tick)
    );

    UART_RX DUT (
        .clk(clk),
        .resetn(_if.resetn),
        .rx(_if.rx),
        .b_tick(baud_tick),
        .dout(_if.dout),
        .rx_done(_if.rx_done)
     );

    initial begin
        automatic uart_rx_test t = new;        

        $display ("T=%0t [Testbench] Testbench starting...", $time);

        clk <= 0;
        _if.resetn <= 0;
        #40 _if.resetn <= 1;


        t.env.vif = _if;
        fork
            t.run();    
        join
        
        // $display ("T=%0t [Testbench] Testbench finishing...", $time);
        // $finish; //this quits questasim...
        $stop;
    end
endmodule