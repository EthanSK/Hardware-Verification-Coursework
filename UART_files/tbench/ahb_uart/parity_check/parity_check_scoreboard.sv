import parity_check_pkg::parity_check_transaction;


class parity_check_scoreboard;
    mailbox scb_mbx;
    int num_passed = 0;
    int num_failed = 0;

    covergroup cg with function sample(parity_check_transaction t);
        
        even_odd_parity: coverpoint t.is_even_parity {
            bins even_parity = {1};
            bins odd_parity = {0};
        }

    endgroup

    function new();
        cg = new();
    endfunction

    task run();
        forever begin
            parity_check_transaction t;
            scb_mbx.get(t);
            t.print("Scoreboard");
            cg.sample(t);
            if (
                 check_parity(t)
            )
            begin
                num_passed = num_passed + 1;
            end else begin
                num_failed = num_failed + 1;
            end
        end
    endtask

    function bit check_parity(parity_check_transaction t);
        if (
            (~^t.d_in) ~^ t.is_even_parity ^ t.parity_fault_injection ^ t.PARITYERR
        ) begin
            $display("PASS! PARITYERR %b is correct for data: %b, is_even_parity: %b, parity_fault_injection: %b", t.PARITYERR, t.d_in, t.is_even_parity, t.parity_fault_injection);
            return 1'b1;
        end else begin
            $display("FAIL! PARITYERR %b is incorrect for data: %b, is_even_parity: %b, parity_fault_injection: %b", t.PARITYERR, t.d_in, t.is_even_parity, t.parity_fault_injection);
            return 1'b0;
        end
    endfunction
endclass