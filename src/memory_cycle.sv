module memory_cycle(
    input  logic        clk, 
    input  logic        rst_n, 
    input  logic        RegWriteM, 
    input  logic        MemWriteM, 
    input  logic        ResultSrcM, 
    input  logic [4:0]  RD_M, 
    input  logic [31:0] PCPlus4M, 
    input  logic [31:0] WriteDataM, 
    input  logic [31:0] ALU_ResultM,
    
    output logic        RegWriteW, 
    output logic        ResultSrcW, 
    output logic [4:0]  RD_W, 
    output logic [31:0] PCPlus4W, 
    output logic [31:0] ALU_ResultW, 
    output logic [31:0] ReadDataW
);
    
    logic [31:0] ReadDataM;
    
    // Pipeline registers for the Memory/Writeback (M/W) boundary
    logic        RegWriteM_reg, ResultSrcM_reg;
    logic [4:0]  RD_M_reg;
    logic [31:0] PCPlus4M_reg, ALU_ResultM_reg, ReadDataM_reg;

    // Data Memory Instantiation
    data_memory dmem_inst (
        .clk   (clk),
        .rst_n (rst_n),
        .WE    (MemWriteM),
        .A     (ALU_ResultM),
        .WD    (WriteDataM),
        .RD    (ReadDataM)
    );
    
    

    // M/W Pipeline Register Logic
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            RegWriteM_reg   <= '0;
            ResultSrcM_reg  <= '0;
            RD_M_reg        <= '0;
            PCPlus4M_reg    <= '0; 
            ALU_ResultM_reg <= '0;
            ReadDataM_reg   <= '0;
        end
        else begin
            RegWriteM_reg   <= RegWriteM;
            ResultSrcM_reg  <= ResultSrcM;
            RD_M_reg        <= RD_M;
            PCPlus4M_reg    <= PCPlus4M; 
            ALU_ResultM_reg <= ALU_ResultM;
            ReadDataM_reg   <= ReadDataM;
        end
    end

    // Output assignments (Writeback stage inputs)
    assign RegWriteW   = RegWriteM_reg;
    assign ResultSrcW  = ResultSrcM_reg;
    assign RD_W        = RD_M_reg;
    assign PCPlus4W    = PCPlus4M_reg;
    assign ALU_ResultW = ALU_ResultM_reg;
    assign ReadDataW   = ReadDataM_reg;
    
endmodule