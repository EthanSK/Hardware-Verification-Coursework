import parity_gen_pkg::parity_gen_test;

module parity_gen_testbench;

    reg clk;
    reg baud_tick;

    parity_gen_if _if(clk, baud_tick);

    always #10ns clk = ~clk; //50 mhz clock

    PARITY_GEN
        #(.DATA_IN_WIDTH(8))
    DUT
    (
        .is_even_parity(_if.is_even_parity),
        .data_in(_if.d_in),
        .data_out(_if.d_out),
        .parity_fault_injection(_if.parity_fault_injection)
    );    

    initial begin
        automatic parity_gen_test t = new;        
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