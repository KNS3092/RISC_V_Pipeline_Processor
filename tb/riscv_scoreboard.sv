class riscv_scoreboard;

    mailbox mon2scb; 
    mailbox gen2scb; 
    
    logic [31:0] shadow_rf [31:0];      
    logic [31:0] shadow_mem [1023:0];   
    
    int total_tests = 0;
    int pass_count  = 0;
    int fail_count  = 0;
    
    function new(mailbox mon2scb, mailbox gen2scb);
        this.mon2scb = mon2scb;
        this.gen2scb = gen2scb;
        
        for (int i = 0; i < 32; i++) 
            this.shadow_rf[i] = i; 
        this.shadow_rf[0] = 32'h0; 
        
        for (int i = 0; i < 1024; i++) begin
            this.shadow_mem[i] = (i < 64) ? (32'hDEADBEEF + i) : 32'h0;
        end
    endfunction
    
    function void update_reference_model(riscv_transaction trans);
        logic [31:0] addr;
        logic [31:0] sext_imm;
        logic [31:0] rs1_val, rs2_val;
        int mem_index;
        
        rs1_val = shadow_rf[trans.rs1];
        rs2_val = shadow_rf[trans.rs2];
        sext_imm = {{20{trans.imm[11]}}, trans.imm};
        
        case (trans.opcode)
            7'b0110011: begin // R-Type
                case(trans.funct3)
                    3'b000: begin
                        if (trans.funct7[5]) 
                            shadow_rf[trans.rd] = rs1_val - rs2_val;
                        else 
                            shadow_rf[trans.rd] = rs1_val + rs2_val;
                    end
                    3'b110: shadow_rf[trans.rd] = rs1_val | rs2_val;
                    3'b111: shadow_rf[trans.rd] = rs1_val & rs2_val;
                endcase
            end
            
            7'b0000011: begin
                addr = rs1_val + sext_imm;
                mem_index = addr % 1024;
                
                shadow_rf[trans.rd] = shadow_mem[mem_index];
                
                $display("[RefModel] LW: addr=0x%08h ? mem[%0d] = 0x%08h ? x%0d", 
                         addr, mem_index, shadow_mem[mem_index], trans.rd);
            end
            
            7'b0100011: begin 
                addr = rs1_val + sext_imm;
                mem_index = addr % 1024;
                
                shadow_mem[mem_index] = rs2_val;
                
                $display("[RefModel] SW: x%0d(0x%08h) ? addr=0x%08h [mem[%0d]]", 
                         trans.rs2, rs2_val, addr, mem_index);
            end
        endcase
        
        shadow_rf[0] = 32'h0;
    endfunction
    
    task main();
        riscv_transaction exp_trans, act_trans;
        forever begin
            gen2scb.get(exp_trans);
             
            mon2scb.get(act_trans);
            
            update_reference_model(exp_trans);
            
            total_tests++;
            
            if (act_trans.opcode == 7'b0100011) begin 
                int mem_idx = act_trans.addr % 1024;
                logic [31:0] expected = shadow_mem[mem_idx];
                
                if (act_trans.wdata === expected) begin
                    $display("[Scoreboard] MEM PASS | Addr: 0x%08h", act_trans.addr);
                    pass_count++;
                end else begin
                    $error("[Scoreboard] MEM FAIL | Addr: 0x%08h | Exp: 0x%08h, Got: 0x%08h", 
                           act_trans.addr, expected, act_trans.wdata);
                    fail_count++;
                end
            end 
            else begin
                logic [31:0] expected = shadow_rf[act_trans.rd];
                
                if (act_trans.machine_code === expected) begin
                    $display("[Scoreboard] REG PASS | x%02d = 0x%08h", 
                             act_trans.rd, act_trans.machine_code);
                    pass_count++;
                end else begin
                    $error("[Scoreboard] REG FAIL | x%02d | Exp: 0x%08h, Got: 0x%08h", 
                           act_trans.rd, expected, act_trans.machine_code);
                    fail_count++;
                end
            end
        end
    endtask
endclass