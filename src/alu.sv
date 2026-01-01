module alu (
    input  logic [31:0] A, B,
    input  logic [2:0]  ALUControl,
    output logic [31:0] result,
    output logic        zero, negative, overflow, carry
);

    // Using internal logic types
    logic [31:0] a_and_b;
    logic [31:0] a_or_b;
    logic [31:0] mux_1_out;
    logic [31:0] sum;
    logic        cout;

    // Combinational Logic for operations
    assign a_and_b = A & B;
    assign a_or_b  = A | B;
    
    // Subtraction logic: if ALUcontrol[0] is 1, invert B and add 1 (via carry-in)
    assign mux_1_out = ALUControl[0] ? ~B : B;
    assign {cout, sum} = A + mux_1_out + ALUControl[0];

    // Main Output Multiplexer
    always_comb begin
        unique case (ALUControl)
            3'b000:  result = sum;           // Add
            3'b001:  result = sum;           // Subtract
            3'b010:  result = a_and_b;       // And
            3'b011:  result = a_or_b;        // Or
            3'b101:  result = {31'b0, sum[31] ^ overflow}; // SLT (Signed)
            default: result = '0;            // Default to 0
        endcase
    end
    
    // Flag Assignments
    assign zero = &(~result);   // Zero flag
    assign negative = result[31];       // Negative flag
    assign carry = ((~ALUControl[1]) & cout); // Carry flag
    
    // Overflow flag logic: 
    // Occurs if (pos + pos = neg) or (neg + neg = pos)
    assign OverFlow = ((sum[31] ^ A[31]) & 
                      (~(ALUControl[0] ^ B[31] ^ A[31])) &
                      (~ALUControl[1]));
endmodule