import ahblite_sys_pkg::ahblite_sys_environment;

class ahblite_sys_test;
    ahblite_sys_environment env;

    function new();
        env = new;
     endfunction

    task run();
        env.run();
    endtask     
endclass