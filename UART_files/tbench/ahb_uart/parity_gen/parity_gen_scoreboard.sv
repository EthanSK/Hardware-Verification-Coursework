//Ethan Sarif-Kattan & LH Lee

import parity_gen_pkg::parity_gen_transaction;


class parity_gen_scoreboard;
    mailbox scb_mbx;
    int num_passed = 0;
    int num_failed = 0;

     covergroup cg with function sample(parity_gen_transaction t);
        
        even_odd_parity: coverpoint t.is_even_parity {
            bins even_parity = {1};
            bins odd_parity = {0};
        }

        parity_fault_injection: coverpoint t.parity_fault_injection {
            bins no_fault_inj = {0};
            bins fault_inj = {1};
        }

        even_odd_d_in: coverpoint ^t.d_in {
            bins even = {0};
            bins odd = {1};
        }

        all: cross even_odd_parity, parity_fault_injection, even_odd_d_in;

    endgroup

    function new();
        cg = new();
    endfunction

    task run();
        forever begin
            parity_gen_transaction t;
            scb_mbx.get(t);
            t.print("Scoreboard");
            cg.sample(t);
            if (
                check_data(t) &&
                check_parity(t)
            )
            begin
                num_passed = num_passed + 1;
            end else begin
                num_failed = num_failed + 1;
            end
        end
    endtask

    function bit check_data(parity_gen_transaction t);
        if (t.d_in == t.d_out[7:0]) begin
            $display("PASS! Input %d is equal to output data %d", t.d_in, t.d_out[7:0]);
            return 1'b1;
        end else begin
            $display("FAIL! Input %d is NOT equal to output data %d", t.d_in, t.d_out[7:0]);
            return 1'b0;
        end
    endfunction

    function bit check_parity(parity_gen_transaction t);
        if (
            (~^t.d_out[8:0]) ~^ t.is_even_parity ^ t.parity_fault_injection
        ) begin
            $display("PASS! Parity %b is correct", t.d_out[8]);
            return 1'b1;
        end else begin
            $display("FAIL! Parity %b is incorrect", t.d_out[8]);
            return 1'b0;
        end
    endfunction
endclass