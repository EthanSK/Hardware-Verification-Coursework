import uart_tx_pkg::uart_tx_transaction;


class uart_tx_scoreboard;
    mailbox scb_mbx;
    int num_passed = 0;
    int num_failed = 0;

     covergroup cg with function sample(uart_tx_transaction t);
        
        even_odd_d_in: coverpoint ^t.d_in {
            bins even = {0};
            bins odd = {1};
        }

        range_din_vals: coverpoint t.d_in {        
            bins lo = {[0:127]};
            bins med_lo = {[128:255]};
            bins med_hi = {[256:383]};
            bins hi = {[384:511]};
        }


        all: cross range_din_vals, even_odd_d_in;

    endgroup

    function new();
        cg = new();
    endfunction


    task run();
        forever begin
            uart_tx_transaction t;
            scb_mbx.get(t);
            t.print("Scoreboard");
            cg.sample(t);
            if (t.d_in == t.d_out) begin
                $display("PASS! Input vector %d is equal to output sequence of bits %d", t.d_in, t.d_out);
                num_passed = num_passed + 1;
            end else begin
                $display("FAIL! Input vector %d is NOT equal to output sequence of bits %d", t.d_in, t.d_out);
                num_failed = num_failed + 1;
            end
        end
    endtask
endclass