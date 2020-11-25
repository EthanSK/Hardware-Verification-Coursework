`timescale 1ns/1ps
module ahblite_sys_tb(

);

reg RESET, CLK;
wire [7:0] LED;

AHBLITE_SYS dut(.CLK(CLK), .RESET(RESET), .LED(LED));

// Note: you should modify this to give a 50MHz clock (or whatever you assume for your baud rate generator)
//EDIT: updated clk from #5 each to #10 each so period is 20ns so clock is 50mhz

initial
begin
   CLK=0;
   forever
   begin
      #10 CLK=1;
      #10 CLK=0;
   end
end

initial
begin
   RESET=0;
   #60 RESET=1;
   #40 RESET=0;
end

endmodule

