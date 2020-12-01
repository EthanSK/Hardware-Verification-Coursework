import pkg::uart_rx_environment;

class uart_rx_test;
    uart_rx_environment env;

    function new();
        env = new;
     endfunction

    task run();
        env.run();
    endtask     
endclass