module alu_decoder (
    input  logic [1:0] ALUOp,
    input  logic [6:0] op, funct7,
    input  logic [2:0] funct3,
    output logic [2:0] ALUControl
);

    // Using enum for internal labels - better for waveforms and safety
    typedef enum logic [2:0] {
        ALU_ADD = 3'b000,
        ALU_SUB = 3'b001,
        ALU_AND = 3'b010,
        ALU_OR  = 3'b011,
        ALU_SLT = 3'b101
    } alu_ctrl_t;

    always_comb begin
        // Default assignment: prevents latches
        ALUControl = ALU_ADD;
        unique case (ALUOp)
            2'b00:   ALUControl = ALU_ADD; // Load / Store
            2'b01:   ALUControl = ALU_SUB; // Beq
            2'b10: begin // R-type
                unique case (funct3)
                    3'b000:  ALUControl = ({op[5], funct7[5]} == 2'b11) ? ALU_SUB : ALU_ADD;
                    3'b010:  ALUControl = ALU_SLT;
                    3'b110:  ALUControl = ALU_OR;
                    3'b111:  ALUControl = ALU_AND;
                    default: ALUControl = ALU_ADD;
                endcase
            end
            default: ALUControl = ALU_ADD;
        endcase
    end
endmodule

