`include "riscv_transaction.sv"
`include "riscv_generator.sv"
`include "riscv_driver.sv"
`include "riscv_monitor.sv"
`include "riscv_scoreboard.sv"
`include "riscv_env.sv"

module pipeline_tb;
  
    logic clk;
    riscv_if if0(.clk(clk));
    int num_tests = 100;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        for (int i = 0; i < 32; i++)   dut.Decode.rf_inst.registers[i] = 32'h0;
        for (int i = 0; i < 1024; i++) dut.Memory.dmem_inst.data_mem[i] = 32'h0;
        for (int i = 0; i < 1024; i++) dut.Fetch.imem_inst.mem[i] = 32'h00000013;
        
        $display("[TB] Memory and Registers cleared.");

        for (int i = 0; i < 32; i++) begin
            dut.Decode.rf_inst.registers[i] = i; 
        end
        
        for (int i = 0; i < 64; i++) begin
            dut.Memory.dmem_inst.data_mem[i] = 32'hDEADBEEF + i;
        end
    end
     
    pipeline_top dut (
        .clk(clk),
        .rst_n(if0.rst_n)
    );

    riscv_env env;

    initial begin
        env = new(if0);
        env.gen.num_transactions = num_tests; 
        if0.reset_dut();

        $display("--- Launching Random Stimulus ---");
        
        fork
            env.run();
        join_none 

        wait(env.scb.total_tests == num_tests);

        repeat(2) @(posedge clk);

        $display("\n=======================================");
        $display("      FINAL VERIFICATION SUMMARY");
        $display("   Instructions Tested: %0d", env.scb.total_tests);
        $display("   Passed: %0d", env.scb.pass_count);
        $display("   Failed: %0d", env.scb.fail_count);
        $display("   Pass Percentage: %0.2f %%", (real'(env.scb.pass_count) / env.scb.total_tests) * 100);
        $display("=======================================");
        $finish;
    end

    initial begin
        #1000000000;
        $display("ERROR: Simulation Timed Out");
        $finish;
    end

endmodule