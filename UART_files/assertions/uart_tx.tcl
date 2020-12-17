clear -all
analyze -clear
analyze -v2k rtl/ahb_uart/uart_tx.v
elaborate -top UART_TX

clock clk
reset -expression !(resetn)

task -set <embedded>
set_proofgrid_max_jobs 4
set_proofgrid_max_local_jobs 4


cover -name tx_start_bit {
  @(posedge clk) disable iff (!resetn)
    (start_st == current_state |=> ~tx)
}

cover -name tx_stop_bit {
  @(posedge clk) disable iff (!resetn)
    (stop_st == current_state |=> tx)
}

cover -name tx_done_high {
  @(posedge clk) disable iff (!resetn)
    (b_reg == 15 && current_state == stop_st |-> tx_done)
}    