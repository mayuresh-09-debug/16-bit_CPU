`timescale 1ns / 1ps

module alu (
    input  wire [15:0] A,          // 16-bit Input Data A
    input  wire [15:0] B,          // 16-bit Input Data B
    input  wire [1:0]  alu_op,     // 2-bit Operation Code (Opcode)
    output reg  [15:0] alu_out,    // 16-bit Output Result
    output reg         zero_flag   // Status flag: 1 if alu_out is exactly 0
);

    // This block automatically runs whenever A, B, or the alu_op changes
    always @(*) begin
        case (alu_op)
            2'b00: alu_out = A + B;       // ADD
            2'b01: alu_out = A - B;       // SUBTRACT
            2'b10: alu_out = A & B;       // Bitwise AND
            2'b11: alu_out = A | B;       // Bitwise OR
            default: alu_out = 16'h0000;
        endcase
        
        // Set the zero flag if the result of the calculation is zero
        if (alu_out == 16'h0000) begin
            zero_flag = 1'b1;
        end else begin
            zero_flag = 1'b0;
        end
    end

endmodule