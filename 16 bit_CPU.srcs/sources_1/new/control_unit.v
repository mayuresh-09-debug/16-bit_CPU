`timescale 1ns / 1ps

module control_unit (
    input  wire [15:0] instruction,   // The 16-bit instruction fetch from memory
    input  wire        alu_zero_flag, // Listens to the ALU to decide on branches
    
    // Outputs connected directly to our CPU pipeline switches
    output reg         reg_write_en,
    output wire [1:0]  reg_read_selA,
    output wire [1:0]  reg_read_selB,
    output wire [1:0]  reg_write_sel,
    output reg  [1:0]  alu_opcode,
    output reg         pc_jump,
    output wire [15:0] pc_jump_addr
);

    // Extract fields instantly using wire slicing
    wire [1:0] opcode = instruction[15:14];
    
    assign reg_write_sel = instruction[13:12];
    assign reg_read_selA = instruction[11:10];
    assign reg_read_selB = instruction[9:8];
    
    // Convert 8-bit immediate address to full 16-bit address for the PC
    assign pc_jump_addr = {8'h00, instruction[7:0]};

    // Combinational Decoding Logic
    always @(*) begin
        // Default values to prevent dangerous latches
        reg_write_en = 1'b0;
        alu_opcode   = 2'b00;
        pc_jump      = 1'b0;
        
        case (opcode)
            2'b00: begin // R-TYPE (Arithmetic: ADD, SUB, AND, OR)
                reg_write_en = 1'b1;         // Enable clock gating to save result
                alu_opcode   = instruction[1:0]; // The specific math operation is at the end
            end
            
            2'b01: begin // LOAD IMMEDIATE (Put a number directly into a register)
                // For simplicity in our basic pipeline, we'll configure the ALU 
                // to pass the value through, or route it straight to storage.
                reg_write_en = 1'b1;
                alu_opcode   = 2'b00; 
            end
            
            2'b10: begin // BRANCH IF ZERO (Jump if previous operation hit exactly 0)
                if (alu_zero_flag == 1'b1) begin
                    pc_jump = 1'b1;          // Fire the jump wire!
                end
            end
            
            default: begin
                reg_write_en = 1'b0;
                alu_opcode   = 2'b00;
                pc_jump      = 1'b0;
            end
        endcase
    end

endmodule