`timescale 1ns / 1ps

module tb_alu();

    // Inputs to our ALU are registers (reg) in a testbench
    reg [15:0] A;
    reg [15:0] B;
    reg [1:0]  alu_op;

    // Outputs from our ALU are wires in a testbench
    wire [15:0] alu_out;
    wire        zero_flag;

    // Connect our testbench variables to the actual ALU module
    alu uut (
        .A(A),
        .B(B),
        .alu_op(alu_op),
        .alu_out(alu_out),
        .zero_flag(zero_flag)
    );

    initial begin
        // --- Test Case 1: ADD (5 + 3) ---
        A = 16'd5; B = 16'd3; alu_op = 2'b00;
        #10; // Wait 10 nanoseconds
        
        // --- Test Case 2: SUBTRACT (10 - 4) ---
        A = 16'd10; B = 16'd4; alu_op = 2'b01;
        #10; // Wait 10 nanoseconds
        
        // --- Test Case 3: SUBTRACT resulting in Zero (7 - 7) ---
        A = 16'd7; B = 16'd7; alu_op = 2'b01;
        #10; // Wait 10 nanoseconds

        // --- Test Case 4: Bitwise AND ---
        // This will compare the bits of both numbers and only keep matching 1s
        A = 16'b1111_1111_0000_0000; 
        B = 16'b1010_1010_1010_1010; 
        alu_op = 2'b10;
        #10; // Wait 10 nanoseconds
        
        $finish; // Stop the simulation
    end

endmodule