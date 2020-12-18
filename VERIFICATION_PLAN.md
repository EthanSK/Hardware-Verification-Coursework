# Verification Plan

## UART TX
- Check that the 9 bit input data vector is correctly transformed to serial data at the correct baud rate.
- Ensure tx_start goes high before transmitting the data.
- Ensure tx_done goes high after the data is transmitted.
- For functional coverage, ensure input data is tested with both odd and even values, and test the distribution of values used is balanced enough by using low, medium-low, mediums-high, and high bins. Then test a cross combination of all of these.

## UART RX
- Read the serial Rx input data at the correct baud rate and check it matches the output vector
- Ensure rx_done is high after the receiving is done.
- For functional coverage, ensure input data is tested with both odd and even values, and test the distribution of values used is balanced enough by using low, medium-low, mediums-high, and high bins. Then test a cross combination of all of these.

## Parity Gen
- Check that the bottom 8 bits of the output data match the input data
- Confirm the parity bit is correct under both even and odd parity (randomly choose one) and with an occasional parity fault injection with a custom distribution.
- For functional coverage, ensure even and odd parity is tested, as well as parity fault injection. Also make sure input data is tested with both odd and even values. Then test a cross combination of all of these.


## Parity Check
- Check that PARITYERR is asserted when the parity bit is incorrect for both even and odd parity, and with an occasional parity fault injection with a custom distribution.
- For functional coverage, ensure even and odd parity is tested, as well as parity fault injection. Also make sure input data is tested with both odd and even values. Then test a cross combination of all of these.

## AHBUART
- Test overall transmission and receiving through the UART. Check the bottom 8 bits of HWDATA equate to the first 8 bits sent at the transmitter end. Then feed that output back into the Rx receiver terminal simultaneously and ensure HRDATA matches the original HWDATA.
- Push multiple data vectors through the UART at once to ensure the FIFO mechanism works as intended. When the HREADYOUT is low, stop sending data through until it becomes high again (at which point we know the FIFO has more space to hold more data).
- Check that parity is generated and received correctly for both even and odd parity, and with an occasional parity fault injection with a custom distribution.
- Ensure the AHBUART works at these baud rates: 110, 300, 600, 1200, 2400, 4800, 9600, 14400, 19200, 38400, 57600, 115200, 128000 and 256000
- For functional coverage, ensure even and odd parity is tested, as well as parity fault injection. Also make sure input data is tested with both odd and even values. Test the distribution of values used is balanced enough by using low, medium-low, mediums-high, and high bins. Then test a cross combination of all of these.


## AHBUART LITE SYS

- Drive transactions through the RsRx terminal of an AHBLITE SYS that is running an assembler program that waits for the receive buffer to have content, and sends the value back through the UART.
- Monitor the output of the RsTx terminal and check that it matches what was sent in.

