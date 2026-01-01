class riscv_transaction;

    rand logic [6:0]  opcode;
    rand logic [2:0]  funct3;
    rand logic [6:0]  funct7;
    rand logic [4:0]  rs1, rs2, rd;
    rand logic [11:0] imm;
    
    logic [31:0] machine_code;
    string inst_name;
    
    logic [31:0] addr;   
    logic [31:0] wdata;  
    
    constraint suppported_ops {
    
        opcode inside{
            7'b0110011,
            7'b0000011,
            7'b0100011
         };
     }
     
     constraint valid_registers {
        rd  != 0;
     }
    
    constraint valid_funct {
        if (opcode == 7'b0110011) {
            funct3 inside {3'b000, 3'b110, 3'b111};
            if (funct3 == 3'b000) {
                funct7 inside {7'b0000000, 7'b0100000};
            }else {
                funct7 == 7'b0000000;
            }
        }
        
        if (opcode == 7'b0000011) {
            funct3 == 3'b010;
        }
        
        if (opcode == 7'b0100011) {
            funct3 == 3'b010;
        }
    }
      
     constraint rf_range {
        rs1 inside {[0:31]};
        rs2 inside {[0:31]};
        rd  inside {[1:31]}; 
      }

     constraint dmem_range {
        if (opcode == 7'b0000011 || opcode == 7'b0100011) {
            imm inside {[0:60]}; 
            rs1 == 0;            
        }
    }

    
    function void post_randomize();
        if (opcode == 7'b0110011) begin
            machine_code = {funct7, rs2, rs1, funct3, rd, opcode};
            case(funct3)
                3'b000:  inst_name = (funct7[5]) ? "SUB" : "ADD";
                3'b110:  inst_name = "OR";
                3'b111:  inst_name = "AND";
                default: inst_name = "UNKNOWN_R";
            endcase
        end
        else if (opcode == 7'b0000011) begin 
            machine_code = {imm, rs1, funct3, rd, opcode};
            inst_name = "LW";
        end
        else if (opcode == 7'b0100011) begin 
            machine_code = {imm[11:5], rs2, rs1, funct3, imm[4:0], opcode};
            inst_name = "SW";
        end
        else begin
            machine_code = 32'h00000013;
            inst_name = "NOP";
        end
    endfunction
         
     function void display (string tag = "");
        $display("[%s] %s | Hex: %h | rs1: x%d, rs2: x%0d, rd: x%0d",tag, inst_name, machine_code, rs1, rs2, rd);
     endfunction
      
endclass    
                                