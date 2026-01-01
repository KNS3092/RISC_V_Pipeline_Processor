module data_memory (
    input  logic        clk, rst_n, WE,
    input  logic [31:0] A, WD,
    output logic [31:0] RD
);

    // 1024 words of 32-bit memory (4KB total)
    logic [31:0] data_mem [1023:0];

    // Combinational Read Logic
    assign RD = (~rst_n) ? '0 : data_mem[A];

    // Synchronous Write Logic
    always_ff @(posedge clk) begin
        if (WE) begin
            data_mem[A] <= WD;
        end
    end

endmodule