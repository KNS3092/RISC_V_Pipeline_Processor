class riscv_monitor;
    
    virtual riscv_if vif;
    mailbox mon2scb;
    
    function new (virtual riscv_if vif, mailbox mon2scb);
        this.vif = vif;
        this.mon2scb = mon2scb;
    endfunction
    
    task main();
        $display("[Monitor] Started");
        forever begin
            @(posedge vif.clk);
            
            if (pipeline_tb.dut.MemWriteM) begin
                riscv_transaction sw_trans;
                sw_trans = new();
            
                sw_trans.opcode = 7'b0100011;
                sw_trans.addr   = pipeline_tb.dut.ALU_ResultM; 
                sw_trans.wdata  = pipeline_tb.dut.WriteDataM;  
            
                $display("[Monitor] SW Detected: Addr=%h, Data=%h", sw_trans.addr, sw_trans.wdata);
                mon2scb.put(sw_trans);
            end
            if (pipeline_tb.dut.RegWriteW && (pipeline_tb.dut.RDW != 5'b0)) begin
                riscv_transaction wb_trans;
                wb_trans = new();
                wb_trans.rd           = pipeline_tb.dut.RDW;
                wb_trans.machine_code = pipeline_tb.dut.ResultW;             
                     
                $display("[Monitor] Reg Update: x%0d = %h", wb_trans.rd, wb_trans.machine_code);
                mon2scb.put(wb_trans);
            end
         end
      endtask
endclass
            
    
    