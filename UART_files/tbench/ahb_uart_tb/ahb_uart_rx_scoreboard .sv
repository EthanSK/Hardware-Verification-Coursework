import ahb_uart_pkg::ahb_uart_transaction;


class ahb_uart_rx_scoreboard;
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
            t.print("Rx Scoreboard");
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
        if (t.RsRx_data[7:0] == t.HRDATA[7:0]) begin  
            $display("[Rx scb] PASS! Input data bits %d is equal to output data vector %d", t.HRDATA[7:0], t.RsTx_data[7:0]);
            return 1'b1;
        end else begin
            $display("[Rx scb] FAIL! Input data bits %d is NOT equal to output data vector %d", t.HRDATA[7:0], t.RsTx_data[7:0]);
            return 1'b0;
        end
    endfunction

    function bit check_parity(ahb_uart_transaction t);
         //we check for even parity (set in tb top initial block)
        //there should be an even number of 1s for even parity, hence xoring them would give 0
        if (~t.PARITYERR) begin  
            $display("[Rx scb] PASS! Parity bit %b is correct for data: %b, PARITYSEL: %b, parity_fault_injection: %b", t.HRDATA[8], t.HRDATA[7:0], t.PARITYSEL, t.parity_fault_injection);
            return 1'b1;
        end else begin
            $display("[Rx scb] FAIL! Parity bit %b is not correct for data: %b, PARITYSEL: %b, parity_fault_injection: %b", t.HRDATA[8], t.HRDATA[7:0], t.PARITYSEL, t.parity_fault_injection);
            return 1'b0;
        end
    endfunction
endclass