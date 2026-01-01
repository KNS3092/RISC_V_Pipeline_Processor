class riscv_driver;

    virtual riscv_if vif; 
    mailbox gen2driv;     
    int addr = 0;         
    
    function new (virtual riscv_if vif, mailbox gen2driv);
        this.vif = vif;
        this.gen2driv = gen2driv;
    endfunction
    
    task main();
        forever begin
            riscv_transaction trans;
            gen2driv.get(trans);
            
            pipeline_tb.dut.Fetch.imem_inst.mem[addr] = trans.machine_code;
            $display("[Driver] Loaded Index %0d: %s (%h)", addr, trans.inst_name, trans.machine_code);
            addr++;
        end
     endtask 
endclass