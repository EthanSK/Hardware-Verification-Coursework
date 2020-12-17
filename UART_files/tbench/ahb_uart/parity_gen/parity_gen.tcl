clear -all
analyze -clear
analyze -v2k rtl/ahb_uart/parity_gen.v
elaborate -top PARITY_GEN

# Setup global clocks and resets
clock clk
reset -expression !(resetn)

# Setup task
task -set <embedded>
set_proofgrid_max_jobs 4
set_proofgrid_max_local_jobs 4


assert -name data_is_correct {
    @(posedge clk) disable iff (!resetn)
        data_in[7:0] == data_out[7:0]
}
