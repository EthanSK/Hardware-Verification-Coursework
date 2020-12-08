import parity_check_pkg::parity_check_transaction;


class parity_check_scoreboard;
    mailbox scb_mbx;
    int num_passed = 0;
    int num_failed = 0;

    task run();
        forever begin
            parity_check_transaction t;
            scb_mbx.get(t);
            t.print("Scoreboard");
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
            $display("PASS! PARITYERR %b is correct for data %d", t.PARITYERR, t.d_in);
            return 1'b1;
        end else begin
            $display("FAIL! PARITYERR %b is incorrect for data %d", t.PARITYERR, t.d_in);
            return 1'b0;
        end
    endfunction
endclass