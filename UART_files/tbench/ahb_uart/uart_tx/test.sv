import pkg::environment;

class test;
    environment env;

    function new();
        env = new;
     endfunction

    task run();
        env.run();      
    endtask     
endclass