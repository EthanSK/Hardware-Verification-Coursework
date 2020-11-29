import pkg::transaction;


class scoreboard;
    mailbox scb_mbx;
    int num_passed = 0;
    int num_failed = 0;

    task run();
        forever begin
            transaction t;
            scb_mbx.get(t);
            t.print("Scoreboard");
            if (t.d_in == t.d_out) begin
                $display("PASS! Input vector %d is equal to output sequence of bits %d", t.d_in, t.d_out);
                num_passed = num_passed + 1;
            else 
                $display("FAIL! Input vector %d is NOT equal to output sequence of bits %d", t.d_in, t.d_out);
                num_failed = num_failed + 1;
            end
        end
    endtask
endclass