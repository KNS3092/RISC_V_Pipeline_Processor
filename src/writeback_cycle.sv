module writeback_cycle(
    input  logic        clk, 
    input  logic        rst_n, 
    input  logic        ResultSrcW,
    input  logic [31:0] PCPlus4W, 
    input  logic [31:0] ALU_ResultW, 
    input  logic [31:0] ReadDataW,
    
    output logic [31:0] ResultW
);

    // This mux selects the final data to be written to the Register File
    // s=0: ALU Result
    // s=1: Data Memory Output
    // s=1: Data Memory Output
    mux mux_result_inst (
        .a(ALU_ResultW),
        .b(ReadDataW),
        .s(ResultSrcW),
        .c(ResultW)
    );

endmodule