import parity_check_pkg::parity_check_test;

module parity_check_testbench;

    reg clk;
    reg baud_tick;

    parity_check_if _if(clk, baud_tick);

    always #10ns clk = ~clk; //50 mhz clock

    PARITY_CHECK
        #(.ORIG_DATA_IN_WIDTH(8))
    DUT
    (
        .is_even_parity(_if.is_even_parity),
        .data_in_parity(_if.d_in),
        .parity_fault_injection(_if.parity_fault_injection),
        .PARITYERR(_if.PARITYERR)
    );    

    initial begin
        automatic parity_check_test t = new;        
        $display ("T=%0t [Testbench] Testbench starting...", $time);

        clk <= 0;
        t.env.vif = _if;
        fork
            t.run();            
        join

        $display ("T=%0t [Testbench] Testbench finishing...", $time);
        $stop;        
    end

endmodule