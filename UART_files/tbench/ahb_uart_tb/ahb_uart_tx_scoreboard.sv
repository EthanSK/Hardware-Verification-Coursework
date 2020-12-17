//Ethan Sarif-Kattan & LH Lee

import ahb_uart_pkg::ahb_uart_transaction;


class ahb_uart_tx_scoreboard;
    mailbox scb_mbx;
    mailbox num_outstanding_tests;
    virtual ahb_uart_if vif;
    int num_passed = 0;
    int num_failed = 0;

    covergroup cg with function sample(ahb_uart_transaction t);
        
        even_odd_d_in: coverpoint ^t.HWDATA[7:0] {
            bins even = {0};
            bins odd = {1};
        }

        even_odd_parity: coverpoint t.PARITYSEL {
            bins odd_parity = {1};
            bins even_parity = {0};
        }

        parity_fault_injection: coverpoint t.parity_fault_injection {
            bins no_fault_inj = {0};
            bins fault_inj = {1};
        }
        
        range_HWDATA_vals: coverpoint t.HWDATA[7:0] {        
            bins lo = {[0:63]};
            bins med_lo = {[64:127]};
            bins med_hi = {[128:191]};
            bins hi = {[192:255]};
        }

        all: cross range_HWDATA_vals, even_odd_d_in, parity_fault_injection, even_odd_parity;
    endgroup

    function new();
        cg = new();
    endfunction

    task run();
        forever begin
            ahb_uart_transaction t;
            int ignore;
            scb_mbx.get(t);
            t.print("Tx Scoreboard");
            cg.sample(t);
            if (check_data(t) && check_parity(t))
            begin
                num_passed = num_passed + 1;
            end else begin
                num_failed = num_failed + 1;
            end
            // num_outstanding_tests.get(ignore); //done in rx
            
        end
    endtask

    function bit check_data(ahb_uart_transaction t);
        if (t.RsTx_data[7:0] == t.HWDATA[7:0]) begin  
            $display("[Tx scb] PASS! Input vector %d is equal to output data bits %d", t.HWDATA[7:0], t.RsTx_data[7:0]);
            return 1'b1;
        end else begin
            $display("[Tx scb] FAIL! Input vector %d is NOT equal to output data bits %d", t.HWDATA[7:0], t.RsTx_data[7:0]);
            return 1'b0;
        end
    endfunction

    function bit check_parity(ahb_uart_transaction t);
         //we check for even parity (set in tb top initial block)
        //there should be an even number of 1s for even parity, hence xoring them would give 0
        if ((~^t.RsTx_data[8:0]) ^ t.PARITYSEL ^ t.parity_fault_injection) begin  
            $display("[Tx scb] PASS! Parity bit %b is correct for data: %b, PARITYSEL: %b, parity_fault_injection: %b", t.RsTx_data[8], t.RsTx_data[7:0], t.PARITYSEL, t.parity_fault_injection);
            return 1'b1;
        end else begin
            $display("[Tx scb] FAIL! Parity bit %b is not correct for data: %b, PARITYSEL: %b, parity_fault_injection: %b", t.RsTx_data[8], t.RsTx_data[7:0], t.PARITYSEL, t.parity_fault_injection);
            return 1'b0;
        end
    endfunction
endclass