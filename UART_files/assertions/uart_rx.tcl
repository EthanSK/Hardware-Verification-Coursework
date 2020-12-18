# Ethan Sarif-Kattan & LH Lee
clear -all
analyze -clear
analyze -v2k rtl/ahb_uart/uart_rx.v
elaborate -top UART_RX

clock clk
reset -expression !(resetn)

task -set <embedded>
set_proofgrid_max_jobs 4
set_proofgrid_max_local_jobs 4

cover -name rx_done_high {
  @(posedge clk) disable iff (!resetn)
    (b_reg == 15 &&  stop_st==current_state  |-> rx_done)
}    