# What we have done and where to find it

The testbenches can be built using `scripts/build_all.sh`

## Verification Plan

We wrote a verification plan outlining the steps we plan on testing and verifying. This can be found in `VERIFICATION_PLAN.md`

## Modifications

- Modified `baudgen.v` to support any baud_rate.
- Created a PARITY_GEN module in `UART_files/rtl/ahb_uart/parity_gen.v` that supports even and odd parity, as well is artificial fault injection.
- Created a PARITY_CHECK module in `UART_files/rtl/ahb_uart/parity_check.v` that supports even and odd parity, as well as artificial fault injection.
- Modified `uart_rx` and `uart_tx` to support 9-bit data transfer (Note that we kept it modular and decoupled from parity which is in a separate module).
- Modified `AHBUART.v` to support even and odd parity, parity fault injection, and raising the PARITYERR signal on detection of a parity error. We also support input for a custom baud rate by using the bottom bits of HADDR not equaling 0 and setting HWRITE and HSEL to 1.
- The status register now includes a parity error counter.

## Unit Tests

We created unit level testbenches for the components we modified. These are:

- parity_check `UART_files/tbench/ahb_uart/parity_check`
- parity_gen `UART_files/tbench/ahb_uart/parity_gen`
- uart_rx `UART_files/tbench/ahb_uart/uart_rx`
- uart_tx `UART_files/tbench/ahb_uart/uart_tx`

TODO: add paths to logfiles of running these tests
TODO: coverage

## AHBUART E2E

We tested the entire AHBUART as a whole. We fed input through HWDATA, then once that data travels to the RsTx terminal, we feed it right back in through the RsRx terminal. The data then goes back through the AHBUART and we monitor the results of HRDATA.

Note that we test to see if overall transmission worked at the RsTx terminal as well as at HRDATA
The testbench can be found in `/UART_files/tbench/ahb_uart_tb`

Testbench log: 
Coverage: `coverage/ahb_uart_tb.txt`

TODO: logfiles & coverage

## AHBLITE SYS Integration test

We tested the functionality of the AHBUART as a peripheral of the whole AHBLITE SYS. In assembly, we wait until the receive buffer is not empty, and if so, read the next value and transmit it back out. We then monitor that transmitted output in our testbench and check it against the driven input to Rx terminal. We added some functional coverage to ensure all edge cases that would occur internally were triggered.

The testbench is in `UART_files/tbench/ahblite_sys_tb`, and the assembly being used is in `UART_files/src/cm0dsasm_UART.s`

Testbench log: `testbench_logs/ahblite_sys_tb.txt`
Coverage: `coverage/ahblite_sys_tb.txt`

## Coverage
We wrote covergroups for each testbench as outlined in the verification plan. The covergroups can be found in the scoreboard of each testbench mentioned above.



TODO: path to coverage reports (both functional and code)


## Assertions

