//Ethan Sarif-Kattan & LH Lee

import uart_rx_pkg::uart_rx_environment;

class uart_rx_test;
    uart_rx_environment env;

    function new();
        env = new;
     endfunction

    task run();
        env.run();
    endtask     
endclass