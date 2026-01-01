module main_decoder (
    input  logic [6:0] op,
    output logic       RegWrite,
    output logic       ALUSrc,
    output logic       MemWrite,
    output logic       ResultSrc,
    output logic       Branch,
    output logic [1:0] ImmSrc,
    output logic [1:0] ALUOp
);

    // --- Opcode Parameters ---
    localparam logic [6:0] OP_LW     = 7'b0000011; 
    localparam logic [6:0] OP_SW     = 7'b0100011; 
    localparam logic [6:0] OP_R_TYPE = 7'b0110011; 
    localparam logic [6:0] OP_I_TYPE = 7'b0010011; 
    localparam logic [6:0] OP_BEQ    = 7'b1100011; 

    always_comb begin
        // --- Default Values ---
        RegWrite  = 1'b0;
        ALUSrc    = 1'b0;
        MemWrite  = 1'b0;
        ResultSrc = 1'b0;
        Branch    = 1'b0;
        ImmSrc    = 2'b00;
        ALUOp     = 2'b00;

        case (op)
            OP_LW: begin
                RegWrite  = 1'b1;
                ALUSrc    = 1'b1;
                ResultSrc = 1'b1;
                ImmSrc    = 2'b00;
                ALUOp     = 2'b00;
            end

            OP_SW: begin
                ALUSrc    = 1'b1;
                MemWrite  = 1'b1;
                ImmSrc    = 2'b01;
                ALUOp     = 2'b00;
            end

            OP_R_TYPE: begin
                RegWrite  = 1'b1;
                ALUOp     = 2'b10;
            end

            OP_I_TYPE: begin
                RegWrite  = 1'b1;
                ALUSrc    = 1'b1;
                ImmSrc    = 2'b00;
                ALUOp     = 2'b00;
            end

            OP_BEQ: begin
                Branch    = 1'b1;
                ImmSrc    = 2'b10;
                ALUOp     = 2'b01;
            end

            default: begin
                // Default values already set to 0
            end
        endcase
    end

endmodule