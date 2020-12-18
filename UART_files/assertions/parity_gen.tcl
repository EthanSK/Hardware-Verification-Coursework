# Ethan Sarif-Kattan & LH Lee
clear -all
analyze -clear
analyze -v2k rtl/ahb_uart/parity_gen.v
elaborate -top PARITY_GEN

# Setup global clocks and resets
clock -none
reset -none

# Setup task
task -set <embedded>
set_proofgrid_max_jobs 4
set_proofgrid_max_local_jobs 4


assert -name data_is_correct {
    data_in[7:0] == data_out[7:0]
}
