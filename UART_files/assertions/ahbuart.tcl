clear -all
analyze -clear
analyze -v2k rtl/ahb_uart/fifo.v
analyze -v2k rtl/ahb_uart/uart_rx.v
analyze -v2k rtl/ahb_uart/uart_tx.v
analyze -v2k rtl/ahb_uart/baudgen.v
analyze -v2k rtl/ahb_uart/parity_gen.v
analyze -v2k rtl/ahb_uart/parity_check.v
analyze -v2k rtl/ahb_uart/AHBUART.v
elaborate -top AHBUART

clock HCLK
reset -expression !(HRESETn)

task -set <embedded>
set_proofgrid_max_jobs 4
set_proofgrid_max_local_jobs 4


cover -name uart_rd_high {
    @(posedge HCLK) disable iff (!HRESETn)
    (!HWRITE && HSEL && HTRANS[1] && (HADDR[7:0]==8'h00) |=> uart_rd)
}

cover -name uart_wr_high { 
    @(posedge HCLK) disable iff (!HRESETn)
    (HWRITE && HTRANS[1] && HSEL && (HADDR[7:0]==8'h00) |=> uart_wr)
}

