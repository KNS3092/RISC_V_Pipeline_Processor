module register_file (
    input  logic        clk, rst_n, WE3,
    input  logic [4:0]  A1, A2, A3,
    output logic [31:0] RD1, RD2,
    input  logic [31:0] WD3
);

    logic [31:0] registers [31:0];

    // Asynchronous Read Logic
    // In RISC-V, reading from x0 always returns 0
    assign RD1 = (~rst_n) ? '0 : registers[A1] ;
    assign RD2 = (~rst_n) ? '0 : registers[A2] ;

    // Synchronous Write Logic
    always_ff @(posedge clk) begin
        if (WE3 & (A3 != '0)) begin
            registers[A3] <= WD3; 
        end
    end

endmodule