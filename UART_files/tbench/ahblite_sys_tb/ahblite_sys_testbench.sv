import ahblite_sys_pkg::ahblite_sys_test;

module ahblite_sys_tb
#(parameter BAUD_RATE=18'd19200)
;

reg CLK;
reg slow_clk;
reg baud_tick;
wire [7:0] LED;

ahblite_sys_if _if(CLK, baud_tick);

always #10ns CLK = ~CLK; //50 mhz clock
always #20ns slow_clk = ~slow_clk; //slow clock for baudgen

AHBLITE_SYS dut(
    .CLK(CLK),
    .RESET(_if.RESETn), //its active low!!!
    .LED(_if.LED),
    .RsRx(_if.RsRx),
    .RsTx(_if.RsTx)
);

BAUDGEN 
#(.CLOCK_HZ(25_000_000))
uBAUDGEN(
    .clk(slow_clk),
    .resetn(_if.RESETn),
    .baud_rate(BAUD_RATE),
    .baudtick(baud_tick)
);

initial
    begin 
        automatic ahblite_sys_test t = new;        
        
        $display ("T=%0t [Testbench] Testbench starting...", $time);

        CLK <= 0;
        slow_clk <= 0;
        _if.baud_rate = BAUD_RATE;
        _if.RESETn=0;
        _if.RsRx <= 1'b1; //put on stop bit
         #60 _if.RESETn=1;

        t.env.vif = _if;
        fork
            t.run();            
        join
        
        $display ("T=%0t [Testbench] Testbench finishing...", $time);

        $stop;
    end

endmodule

