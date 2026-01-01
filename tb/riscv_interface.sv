interface riscv_if (input logic clk);
    logic rst_n;
    task reset_dut();
        rst_n = 0;
        repeat(5) @(posedge clk);
        rst_n = 1;
    endtask
endinterface