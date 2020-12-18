# Ethan Sarif-Kattan & LH Lee
clear -all
analyze -clear
analyze -v2k rtl/ahb_uart/fifo.v
elaborate -top FIFO

clock clk
reset -expression !(resetn)

task -set <embedded>
set_proofgrid_max_jobs 4
set_proofgrid_max_local_jobs 4

assert -name not_full_and_empty_together {
    @(posedge clk) disable iff (!resetn)
    ~(full & empty)
}

assert -name not_empty_if_wr_and_not_rd {
    @(posedge clk) disable iff (!resetn)
    (~rd & wr) |=> !empty
}

assert -name _not_full_if_rd_and_not_wr {
    @(posedge clk) disable iff (!resetn)
    (~wr & rd) |=> !full
}
