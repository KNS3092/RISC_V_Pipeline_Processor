module mux (
    input  logic [31:0] a, b,
    input  logic        s,
    output logic [31:0] c
);

    assign c = s ? b : a;
    
endmodule

module mux_3_by_1 (
    input  logic [31:0] a, b, c,
    input  logic [1:0]  s,
    output logic [31:0] d
);
    assign d = (s == 2'b00) ? a : (s == 2'b01) ? b : (s == 2'b10) ? c : '0;
    
endmodule
    
