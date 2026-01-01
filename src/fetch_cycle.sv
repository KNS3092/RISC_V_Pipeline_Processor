module fetch_cycle(
    input  logic clk, 
    input  logic rst_n, 
    input  logic PCSrcE, 
    input  logic [31:0] PCTargetE,
     
    output logic [31:0] InstrD, 
    output logic [31:0] PCD, 
    output logic [31:0] PCPlus4D
);
    
    logic [31:0] PC_F, PCF, PCPlus4F;
    logic [31:0] InstrF;
    
    logic [31:0] InstrF_reg, PCF_reg, PCPlus4F_reg;
    
    mux pc_mux_inst (
        .a(PCPlus4F),
        .b(PCTargetE),
        .s(PCSrcE),
        .c(PC_F)
    );
    
    program_counter pc_inst (
        .clk(clk),
        .rst_n(rst_n),
        .PC_NEXT(PC_F),
        .PC(PCF)
    );
        
    instruction_memory imem_inst (
        .rst_n(rst_n),
        .A(PCF),
        .RD(InstrF)
    );
        
    program_counter_adder pc_adder_inst(
        .a(PCF),
        .b(32'h00000004),
        .c(PCPlus4F)
    );
        
    always_ff @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            InstrF_reg <= '0;
            PCF_reg <= '0;
            PCPlus4F_reg <= '0;
        end 
        else begin
            InstrF_reg <= InstrF;
            PCF_reg <= PCF;
            PCPlus4F_reg <= PCPlus4F;
        end
    end
           
    assign InstrD = (~rst_n) ? '0 : InstrF_reg;
    assign PCD = (~rst_n) ? '0 : PCF_reg;
    assign PCPlus4D = (~rst_n) ? '0 : PCPlus4F_reg;
            
endmodule