module instruction_memory (
    input  logic        rst_n,
    input  logic [31:0] A,
    output logic [31:0] RD
);

    // Declaring the memory array
    logic [31:0] mem [1023:0];

    // Word-aligned access: A[31:2]
    // A[1:0] are ignored because RISC-V instructions are 4-byte aligned
    assign RD = (~rst_n) ? '0 : mem[A[31:2]];
  
endmodule