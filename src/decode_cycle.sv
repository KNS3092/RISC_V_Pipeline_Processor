module decode_cycle(
    input  logic        clk, 
    input  logic        rst_n, 
    input  logic        RegWriteW,
    input  logic [4:0]  RDW,
    input  logic [31:0] InstrD, 
    input  logic [31:0] PCD, 
    input  logic [31:0] PCPlus4D, 
    input  logic [31:0] ResultW,
    
    output logic        RegWriteE, 
    output logic        ALUSrcE, 
    output logic        MemWriteE, 
    output logic        ResultSrcE, 
    output logic        BranchE,
    output logic [2:0]  ALUControlE,
    output logic [4:0]  RD_E, 
    output logic [4:0]  RS1_E, 
    output logic [4:0]  RS2_E,
    output logic [31:0] RD1_E, 
    output logic [31:0] RD2_E, 
    output logic [31:0] Imm_Ext_E,
    output logic [31:0] PCE, 
    output logic [31:0] PCPlus4E
);

    logic        RegWriteD, ALUSrcD, MemWriteD, ResultSrcD, BranchD;
    logic [1:0]  ImmSrcD;
    logic [2:0]  ALUControlD;
    logic [31:0] RD1_D, RD2_D, Imm_Ext_D;

    logic        RegWriteD_reg, ALUSrcD_reg, MemWriteD_reg, ResultSrcD_reg, BranchD_reg;
    logic [2:0]  ALUControlD_reg;
    logic [4:0]  RD_D_reg, RS1_D_reg, RS2_D_reg;
    logic [31:0] RD1_D_reg, RD2_D_reg, Imm_Ext_D_reg;
    logic [31:0] PCD_reg, PCPlus4D_reg;

    control_unit_top cu_top_inst (
        .op         (InstrD[6:0]),
        .funct3     (InstrD[14:12]),
        .funct7     (InstrD[31:25]),
        .RegWrite   (RegWriteD),
        .ImmSrc     (ImmSrcD),
        .ALUSrc     (ALUSrcD),
        .MemWrite   (MemWriteD),
        .ResultSrc  (ResultSrcD),
        .Branch     (BranchD),
        .ALUControl (ALUControlD)
    );

    register_file rf_inst (
        .clk   (clk),
        .rst_n (rst_n),
        .WE3   (RegWriteW),
        .A1    (InstrD[19:15]),
        .A2    (InstrD[24:20]),
        .A3    (RDW), 
        .WD3   (ResultW),
        .RD1   (RD1_D),
        .RD2   (RD2_D)
    );

    sign_extend se_inst (
        .In      (InstrD),
        .ImmSrc  (ImmSrcD),
        .Imm_Ext (Imm_Ext_D)
    );

    

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            RegWriteD_reg   <= '0;
            ALUSrcD_reg     <= '0;
            MemWriteD_reg   <= '0;
            ResultSrcD_reg  <= '0;
            BranchD_reg     <= '0;
            ALUControlD_reg <= '0;
            RD_D_reg        <= '0;
            RD1_D_reg       <= '0;
            RD2_D_reg       <= '0;
            Imm_Ext_D_reg   <= '0;
            PCD_reg         <= '0;
            PCPlus4D_reg    <= '0;
            RS1_D_reg       <= '0;
            RS2_D_reg       <= '0;
        end
        else begin
            RegWriteD_reg   <= RegWriteD;
            ALUSrcD_reg     <= ALUSrcD;
            MemWriteD_reg   <= MemWriteD;
            ResultSrcD_reg  <= ResultSrcD;
            BranchD_reg     <= BranchD;
            ALUControlD_reg <= ALUControlD;
            RD_D_reg        <= InstrD[11:7];
            RD1_D_reg       <= RD1_D;
            RD2_D_reg       <= RD2_D;
            Imm_Ext_D_reg   <= Imm_Ext_D;
            PCD_reg         <= PCD;
            PCPlus4D_reg    <= PCPlus4D;
            RS1_D_reg       <= InstrD[19:15];
            RS2_D_reg       <= InstrD[24:20];   
        end
    end

    assign RegWriteE   = RegWriteD_reg;
    assign ALUSrcE     = ALUSrcD_reg;
    assign MemWriteE   = MemWriteD_reg;
    assign ResultSrcE  = ResultSrcD_reg;
    assign BranchE     = BranchD_reg;
    assign ALUControlE = ALUControlD_reg;
    assign RD1_E       = RD1_D_reg;
    assign RD2_E       = RD2_D_reg;
    assign Imm_Ext_E   = Imm_Ext_D_reg;
    assign RD_E        = RD_D_reg;
    assign PCE         = PCD_reg;
    assign PCPlus4E    = PCPlus4D_reg;
    assign RS1_E       = RS1_D_reg;
    assign RS2_E       = RS2_D_reg;

endmodule