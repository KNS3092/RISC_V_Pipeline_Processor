module execute_cycle(
    input  logic        clk, 
    input  logic        rst_n, 
    input  logic        RegWriteE, 
    input  logic        ALUSrcE, 
    input  logic        MemWriteE, 
    input  logic        ResultSrcE, 
    input  logic        BranchE,
    input  logic [1:0]  ForwardA_E, ForwardB_E,
    input  logic [2:0]  ALUControlE, 
    input  logic [4:0]  RD_E, 
    input  logic [31:0] RD1_E, 
    input  logic [31:0] RD2_E, 
    input  logic [31:0] Imm_Ext_E, 
    input  logic [31:0] PCE, 
    input  logic [31:0] PCPlus4E, 
    input  logic [31:0] ResultW,
    
    output logic        PCSrcE, 
    output logic        RegWriteM, 
    output logic        MemWriteM, 
    output logic        ResultSrcM, 
    output logic [4:0]  RD_M, 
    output logic [31:0] PCTargetE, 
    output logic [31:0] PCPlus4M, 
    output logic [31:0] WriteDataM, 
    output logic [31:0] ALU_ResultM 
);
    
    logic        ZeroE;
    logic [31:0] Src_A, Src_B_interim, Src_B;
    logic [31:0] ResultE;
    
    
    logic        RegWriteE_reg, MemWriteE_reg, ResultSrcE_reg;
    logic [4:0]  RD_E_reg;
    logic [31:0] PCPlus4E_reg, RD2_E_reg, ResultE_reg;
    
    mux_3_by_1 mux_srca_inst (
                        .a(RD1_E),
                        .b(ResultW),
                        .c(ALU_ResultM),
                        .s(ForwardA_E),
                        .d(Src_A)
                        );

    mux_3_by_1 mux_srcb_inst (
                        .a(RD2_E),
                        .b(ResultW),
                        .c(ALU_ResultM),
                        .s(ForwardB_E),
                        .d(Src_B_interim)
                        ); 
    
    mux mux_alu_src_inst(
        .a(Src_B_interim),
        .b(Imm_Ext_E),
        .s(ALUSrcE),
        .c(Src_B)
    );
    
    alu alu_inst (
        .A          (Src_A),
        .B          (Src_B),
        .ALUControl (ALUControlE),
        .result     (ResultE),
        .zero       (ZeroE),
        .negative   (), 
        .overflow   (), 
        .carry      ()  
    );
    
    program_counter_adder branch_add_inst (
        .a (PCE),
        .b (Imm_Ext_E),
        .c (PCTargetE)
    );
    
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            RegWriteE_reg  <= '0;
            MemWriteE_reg  <= '0;
            ResultSrcE_reg <= '0;
            RD_E_reg       <= '0;
            PCPlus4E_reg   <= '0;
            RD2_E_reg      <= '0;
            ResultE_reg    <= '0;
        end
        else begin
            RegWriteE_reg  <= RegWriteE;
            MemWriteE_reg  <= MemWriteE;
            ResultSrcE_reg <= ResultSrcE;
            RD_E_reg       <= RD_E;
            PCPlus4E_reg   <= PCPlus4E;
            RD2_E_reg      <= Src_B_interim;
            ResultE_reg    <= ResultE;           
        end 
    end 
        
    assign PCSrcE      = ZeroE & BranchE;
    assign RegWriteM   = RegWriteE_reg;
    assign MemWriteM   = MemWriteE_reg;
    assign ResultSrcM  = ResultSrcE_reg;
    assign RD_M        = RD_E_reg;
    assign PCPlus4M    = PCPlus4E_reg;
    assign WriteDataM  = RD2_E_reg;
    assign ALU_ResultM = ResultE_reg;
    
endmodule