module program_counter_adder (
    input  logic [31:0] a, b,
    output logic [31:0] c
);

    // Simple combinational addition
    assign c = a + b;

endmodule