module control_unit_top (
    input  logic [6:0] op,
    input  logic [6:0] funct7,
    input  logic [2:0] funct3,
    output logic       RegWrite, ALUSrc, MemWrite, ResultSrc, Branch,
    output logic [1:0] ImmSrc,
    output logic [2:0] ALUControl
);

    // Internal signal to connect Main Decoder to ALU Decoder
    logic [1:0] ALUOp;

    // --- Main Decoder Instantiation ---
    main_decoder main_decoder (
        .op        (op),
        .RegWrite  (RegWrite),
        .ImmSrc    (ImmSrc),
        .MemWrite  (MemWrite),
        .ResultSrc (ResultSrc),
        .Branch    (Branch),
        .ALUSrc    (ALUSrc),
        .ALUOp     (ALUOp)
    );

    // --- ALU Decoder Instantiation ---
    alu_decoder alu_decoder (
        .ALUOp      (ALUOp),
        .funct3     (funct3),
        .funct7     (funct7), 
        .op         (op),     
        .ALUControl (ALUControl)
    );

endmodule