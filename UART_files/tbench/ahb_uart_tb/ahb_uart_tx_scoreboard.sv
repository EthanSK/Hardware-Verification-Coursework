import ahb_uart_pkg::ahb_uart_transaction;


class ahb_uart_tx_scoreboard;
    mailbox scb_mbx;
    mailbox num_outstanding_tests;
    virtual ahb_uart_if vif;
    int num_passed = 0;
    int num_failed = 0;

    task run();
        forever begin
            ahb_uart_transaction t;
            int ignore;
            scb_mbx.get(t);
            t.print("Tx Scoreboard");
            if (check_data(t) && check_parity(t))
            begin
                num_passed = num_passed + 1;
            end else begin
                num_failed = num_failed + 1;
            end
            num_outstanding_tests.get(ignore);
            
        end
    endtask

    function bit check_data(ahb_uart_transaction t);
        if (t.RsTx_data[7:0] == t.HWDATA[7:0]) begin  
            $display("PASS! Input vector %d is equal to output data bits %d", t.HWDATA[7:0], t.RsTx_data[7:0]);
            return 1'b1;
        end else begin
            $display("FAIL! Input vector %d is NOT equal to output data bits %d", t.HWDATA[7:0], t.RsTx_data[7:0]);
            return 1'b0;
        end
    endfunction

    function bit check_parity(ahb_uart_transaction t);
        // return 1'b1; //TODO: remove
        //we check for even parity (set in tb top initial block)
        //there should be an even number of 1s for even parity, hence xoring them would give 0
        if (vif.PARITYSEL ? ^t.RsTx_data[8:0] : ~^t.RsTx_data[8:0]) begin  
            $display("PASS! Parity bit %d is correct for data %d", t.RsTx_data[8], t.RsTx_data[7:0]);
            return 1'b1;
        end else begin
            $display("FAIL! Parity bit %d is not correct for data %d", t.RsTx_data[8], t.RsTx_data[7:0]);
            return 1'b0;
        end
    endfunction
endclass