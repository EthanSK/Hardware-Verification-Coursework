### personal notes:

# to compile all files in all folders under something, do

 vlog -work work +acc=blnr -noincr -timescale 1ns/1ps rtl/**/*.v

 for sv files this worked:
  `vlog -work work +acc=blnr -noincr -timescale 1ns/1ps tbench/ahb_uart/uart_tx/**`
  or for specific sv files:
  `vlog -work work +acc=blnr -noincr -timescale 1ns/1ps tbench/ahb_uart/uart_tx/*.sv`

  to do it with the pkg first:

  `vlog -work work +acc=blnr -noincr -timescale 1ns/1ps tbench/ahb_uart/uart_tx/pkg.sv  tbench/ahb_uart/uart_tx/*.sv`

# to set a clock input, right click on it in the wave window and click clock

https://people.ece.cornell.edu/land/courses/ece5760/ModelSim/Using_ModelSim.pdf

# to add the signals to the wave ting do dis

log –r /*
add wave *



restart -f after changing files https://stackoverflow.com/questions/5265807/how-to-restart-a-verilog-simulation-in-modelsim



-----------------------------
- make tests for the parity stuff
- use fault injection for it