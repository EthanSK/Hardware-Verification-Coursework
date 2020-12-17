import ahblite_sys_pkg::ahblite_sys_transaction;


class ahblite_sys_scoreboard;
    mailbox scb_mbx;
    mailbox num_outstanding_tests;
    virtual ahblite_sys_if vif;
    int num_passed = 0;
    int num_failed = 0;

    covergroup cg with function sample(ahblite_sys_transaction t);
        
        range_d_in_vals: coverpoint t.d_in {        
            bins lo = {[0:63]};
            bins med_lo = {[64:127]};
            bins med_hi = {[128:191]};
            bins hi = {[192:255]};
        }
        //to trigger different parity generation internally
        even_odd_d_in: coverpoint ^t.d_in {
            bins even = {0};
            bins odd = {1};
        }        
        all: cross range_d_in_vals, even_odd_d_in;
        
    endgroup

    function new();
        cg = new();
    endfunction

    task run();
        forever begin
            ahblite_sys_transaction t;
            int ignore;
            scb_mbx.get(t);
            t.print("Scoreboard");
            cg.sample(t);
            if (check_data(t))
            begin
                num_passed = num_passed + 1;
            end else begin
                num_failed = num_failed + 1;
            end
            num_outstanding_tests.get(ignore);         
        end
    endtask

    function bit check_data(ahblite_sys_transaction t);
        if (t.d_in == t.d_out) begin  
            $display("[Scoreboard] PASS! Input %d is equal to output %d", t.d_in, t.d_out);
            return 1'b1;
        end else begin
            $display("[Scoreboard] FAIL! Input %d is  NOT equal to output %d", t.d_in, t.d_out);
            return 1'b0;
        end
    endfunction
 
endclass