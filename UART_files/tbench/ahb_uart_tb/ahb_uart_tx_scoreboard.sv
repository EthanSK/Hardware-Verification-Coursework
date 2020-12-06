import ahb_uart_pkg::ahb_uart_transaction;


class ahb_uart_tx_scoreboard;
    mailbox scb_mbx;
    int num_passed = 0;
    int num_failed = 0;

    task run();
        forever begin
            ahb_uart_transaction t;
            scb_mbx.get(t);
            t.print("Tx Scoreboard");
            check_data(t);
            check_parity(t);
            
        end
    endtask

    function check_data(ahb_uart_transaction t);
        if (t.RsTx_data[7:0] == t.HWDATA[7:0]) begin  
                $display("PASS! Input vector %d is equal to output sequence of bits %d", t.RsTx_data, t.HWDATA);
                num_passed = num_passed + 1;
        end else begin
            $display("FAIL! Input vector %d is NOT equal to output sequence of bits %d", t.RsTx_data, t.HWDATA);
            num_failed = num_failed + 1;
        end
    endfunction

    function check_parity(ahb_uart_transaction t);
        //we check for even parity (set in tb top initial block)
        if (t.RsTx_data[8] == (^t.RsTx_data[7:0])) begin  
                $display("PASS! Parity bit %d is correct for data %d", t.RsTx_data[8], t.RsTx_data[7:0]);
                num_passed = num_passed + 1;
        end else begin
            $display("FAIL! Parity bit %d is not correct for data %d", t.RsTx_data[8], t.RsTx_data[7:0]);
            num_failed = num_failed + 1;
        end
    endfunction
endclass