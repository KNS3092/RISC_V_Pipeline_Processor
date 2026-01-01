class riscv_generator;

    riscv_transaction trans;
    mailbox gen2driv;           
    mailbox gen2scb;            
    int num_transactions;           
    event ended;                

    function new(mailbox gen2driv, mailbox gen2scb);
        this.gen2driv = gen2driv;
        this.gen2scb  = gen2scb;
    endfunction

    task main();
        repeat(num_transactions) begin
            trans = new();
            if (!trans.randomize()) $fatal("Gen: Randomization Failed");
            
            gen2driv.put(trans); 
            gen2scb.put(trans);  
        end
        -> ended;
    endtask
endclass