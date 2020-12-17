//Ethan Sarif-Kattan & LH Lee

import parity_check_pkg::parity_check_environment;

class parity_check_test;
    parity_check_environment env;

    function new();
        env = new;
     endfunction

    task run();
        env.run();
    endtask     
endclass