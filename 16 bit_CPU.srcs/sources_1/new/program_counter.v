`timescale 1ns / 1ps

module program_counter (
    input  wire        clk,        // Master clock pulse
    input  wire        rst,        // Reset pointer back to 0000
    input  wire        jump,       // Control signal: 1 if we want to jump to a new code line
    input  wire [15:0] jump_addr,  // The specific target line number we want to jump to
    output reg  [15:0] pc          // The current instruction address output
);

    // This block triggers exactly when the clock ticks upward
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 16'h0000;         // Start back at line 0
        end 
        else if (jump) begin
            pc <= jump_addr;        // Jump to the specific line of code
        end 
        else begin
            pc <= pc + 1'b1;        // Otherwise, move forward exactly 1 step
        end
    end

endmodule