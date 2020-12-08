import parity_gen_pkg::parity_gen_transaction;


class parity_gen_scoreboard;
    mailbox scb_mbx;
    int num_passed = 0;
    int num_failed = 0;

    task run();
        forever begin
            parity_gen_transaction t;
            scb_mbx.get(t);
            t.print("Scoreboard");
            if (t.d_in == t.d_out[7:0]) begin
                $display("PASS! Input vector %d is equal to output sequence of bits %d", t.d_in, t.d_out);
                num_passed = num_passed + 1;
            end else begin
                $display("FAIL! Input vector %d is NOT equal to output sequence of bits %d", t.d_in, t.d_out);
                num_failed = num_failed + 1;
            end
        end
    endtask
endclass