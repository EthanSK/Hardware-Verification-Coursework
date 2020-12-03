import uart_tx_pkg::uart_tx_environment;

class uart_tx_test;
    uart_tx_environment env;

    function new();
        env = new;
     endfunction

    task run();
        env.run();
    endtask     
endclass