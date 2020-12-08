import parity_gen_pkg::parity_gen_environment;

class parity_gen_test;
    parity_gen_environment env;

    function new();
        env = new;
     endfunction

    task run();
        env.run();
    endtask     
endclass