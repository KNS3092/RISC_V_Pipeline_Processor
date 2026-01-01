`timescale 1ns / 1ps

module directed_tb();

    // --- Signal Declarations ---
    logic clk = 1'b0;
    logic rst_n;

    // --- Clock Generation (10MHz / 100ns period) ---
    always begin
        #50 clk = ~clk;
    end

// --- Stimulus Block ---
    initial begin
        dut.Fetch.imem_inst.mem[0] = 32'h00000000;
        dut.Fetch.imem_inst.mem[1] = 32'h00500293;
        dut.Fetch.imem_inst.mem[2] = 32'h00300313;
        dut.Fetch.imem_inst.mem[3] = 32'h006283B3;
        dut.Fetch.imem_inst.mem[4] = 32'h00002403;
        dut.Fetch.imem_inst.mem[5] = 32'h00100493;
        dut.Fetch.imem_inst.mem[6] = 32'h00940533;
     
        // Load Data Memory (Initial State) ---
        dut.Memory.dmem_inst.data_mem[0]  = 32'h00000000; 
       
        // Initialize Register x9 ---
        dut.Decode.rf_inst.registers[0] = 32'h00000000; 
        
        // Reset Sequence
        rst_n = 1'b0;
        #200;
        rst_n = 1'b1;
        
        // Run simulation
        #2000;
        $finish;    
    end
    // --- Device Under Test (DUT) Instantiation ---
    pipeline_top dut (
        .clk (clk), 
        .rst_n (rst_n)
    );


endmodule