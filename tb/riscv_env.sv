class riscv_env;

    riscv_generator  gen;
    riscv_driver     driv;
    riscv_monitor    mon;
    riscv_scoreboard scb;

    mailbox gen2driv;
    mailbox mon2scb;
    mailbox gen2scb; 

    virtual riscv_if vif;

    function new(virtual riscv_if vif);
        this.vif = vif;
        
        gen2driv = new();
        mon2scb  = new();
        gen2scb  = new();

        gen  = new(gen2driv, gen2scb);
        driv = new(vif, gen2driv);
        mon  = new(vif, mon2scb);
        scb  = new(mon2scb, gen2scb);
    endfunction

    task run();

        fork
            gen.main();
            driv.main();
            mon.main();
            scb.main();
        join_any 
    endtask
endclass