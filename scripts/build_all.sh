vlog -work work +acc=blnr -noincr -timescale 1ns/1ps rtl/**/*.v




vlog -work work +acc=blnr -noincr -timescale 1ns/1ps tbench/ahb_uart/uart_rx/uart_rx_pkg.sv tbench/ahb_uart/uart_tx/uart_tx_pkg.sv tbench/ahb_uart/uart_rx/*.sv tbench/ahb_uart/uart_tx/*.sv

 