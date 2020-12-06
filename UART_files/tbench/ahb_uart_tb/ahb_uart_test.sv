import ahb_uart_pkg::ahb_uart_environment;

class ahb_uart_test;
    ahb_uart_environment env;

    function new();
        env = new;
     endfunction

    task run();
        env.run();
    endtask     
endclass