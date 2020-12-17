clear -all
analyze -clear
analyze -v2k rtl/ahb_uart/baudgen.v
elaborate -top BAUDGEN

clock clk
reset -expression !(resetn)

task -set <embedded>
set_proofgrid_max_jobs 4
set_proofgrid_max_local_jobs 4

assert -name tick_for_one_clk_cycle {
    @(posedge clk) disable iff (!resetn)
        baudtick |=> ~baudtick
}
