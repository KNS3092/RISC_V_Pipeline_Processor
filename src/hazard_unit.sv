module hazard_unit(
    input  logic        rst_n, 
    input  logic        RegWriteM, 
    input  logic        RegWriteW,
    input  logic [4:0]  RD_M, 
    input  logic [4:0]  RD_W, 
    input  logic [4:0]  Rs1_E, 
    input  logic [4:0]  Rs2_E,
    
    output logic [1:0]  ForwardAE, 
    output logic [1:0]  ForwardBE
);

    // Forwarding Logic for Operand A
    always_comb begin
        if (!rst_n) begin
            ForwardAE = 2'b00;
        end
        // Priority 1: Forward from Memory Stage (most recent result)
        else if ((RegWriteM == 1'b1) && (RD_M != 5'b0) && (RD_M == Rs1_E)) begin
            ForwardAE = 2'b10;
        end
        // Priority 2: Forward from Writeback Stage
        else if ((RegWriteW == 1'b1) && (RD_W != 5'b0) && (RD_W == Rs1_E)) begin
            ForwardAE = 2'b01;
        end
        // Default: No forwarding
        else begin
            ForwardAE = 2'b00;
        end
    end

    // Forwarding Logic for Operand B
    always_comb begin
        if (!rst_n) begin
            ForwardBE = 2'b00;
        end
        // Priority 1: Forward from Memory Stage
        else if ((RegWriteM == 1'b1) && (RD_M != 5'b0) && (RD_M == Rs2_E)) begin
            ForwardBE = 2'b10;
        end
        // Priority 2: Forward from Writeback Stage
        else if ((RegWriteW == 1'b1) && (RD_W != 5'b0) && (RD_W == Rs2_E)) begin
            ForwardBE = 2'b01;
        end
        // Default: No forwarding
        else begin
            ForwardBE = 2'b00;
        end
    end

endmodule