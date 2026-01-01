module program_counter (
    input  logic        clk, rst_n,
    input  logic [31:0] PC_NEXT,
    output logic [31:0] PC
);

    // always_ff is used for clocked logic (flip-flops)
    always_ff @(posedge clk) begin
        if (~rst_n) begin
            PC <= '0;    // Reset the counter to 0
        end else begin
            PC <= PC_NEXT; // Update with the next address
        end
    end

endmodule