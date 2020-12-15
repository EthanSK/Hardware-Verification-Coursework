vlog -work work +acc=blnr +cover -noincr -timescale 1ns/1ps rtl/**/*.v

vlog -work work +acc=blnr +cover -noincr -timescale 1ns/1ps tbench/ahb_uart/uart_rx/uart_rx_pkg.sv tbench/ahb_uart/uart_tx/uart_tx_pkg.sv tbench/ahb_uart/uart_rx/*.sv tbench/ahb_uart/uart_tx/*.sv

vlog -work work +acc=blnr +cover -noincr -timescale 1ns/1ps tbench/ahb_uart_tb/ahb_uart_pkg.sv tbench/ahb_uart_tb/*.sv

vlog -work work +acc=blnr +cover -noincr -timescale 1ns/1ps tbench/ahb_uart/parity_gen/parity_gen_pkg.sv tbench/ahb_uart/parity_gen/*.sv 

vlog -work work +acc=blnr +cover -noincr -timescale 1ns/1ps tbench/ahb_uart/parity_check/parity_check_pkg.sv tbench/ahb_uart/parity_check/*.sv 

 