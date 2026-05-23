`timescale 1ns / 1ps

module tb_cpu_top();

    // Inputs to our motherboard
    reg         clk;
    reg         rst;
    reg  [15:0] external_instruction;

    // Outputs from our motherboard to observe on the waves
    wire [15:0] current_pc;
    wire [15:0] cpu_result;
    wire        cpu_zero_flag;

    // Connect the testbench to our completed CPU Top module
    cpu_top uut (
        .clk(clk),
        .rst(rst),
        .external_instruction(external_instruction),
        .current_pc(current_pc),
        .cpu_result(cpu_result),
        .cpu_zero_flag(cpu_zero_flag)
    );

    // --- Clock Generator (100MHz Engine) ---
    always begin
        #5 clk = ~clk;
    end

    initial begin
        // Initialize everything
        clk = 0;
        rst = 1;
        external_instruction = 16'h0000;

        // Release the system reset after 15ns
        #15 rst = 0;
        
        // =========================================================================
        // EXECUTE INSTRUCTION: Load Immediate value '10' into Register 1
        // Hex representation: 16'h500A
        // =========================================================================
        #10;
        external_instruction = 16'b00_00_00_00_000000_01; // Hex: 16'h0001 
        
        #60;
        $finish; // Stop the simulation
    end

endmodule