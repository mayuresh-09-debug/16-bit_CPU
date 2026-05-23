`timescale 1ns / 1ps

module register_file (
    input  wire        clk,           // Master clock signal (the pulse)
    input  wire        rst,           // Reset signal to clear all data
    input  wire        write_enable,  // CLOCK GATING: Only updates if this is 1
    input  wire [1:0]  read_regA,     // 2-bit address for Register to read out of Port A
    input  wire [1:0]  read_regB,     // 2-bit address for Register to read out of Port B
    input  wire [1:0]  write_reg,     // 2-bit address for Register we want to save data into
    input  wire [15:0] write_data,    // 16-bit data we want to save
    output wire [15:0] reg_dataA,     // 16-bit output data from Port A
    output wire [15:0] reg_dataB      // 16-bit output data from Port B
);

    // Create our array of 4 registers, each 16 bits wide
    reg [15:0] registers [3:0];

    // Reading data from registers is "combinational" (instant, no clock needed)
    assign reg_dataA = registers[read_regA];
    assign reg_dataB = registers[read_regB];

    // Writing data ONLY happens on the rising edge of the clock signal
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Clear all registers to 0 when reset button is pushed
            registers[0] <= 16'h0000;
            registers[1] <= 16'h0000;
            registers[2] <= 16'h0000;
            registers[3] <= 16'h0000;
        end 
        else if (write_enable) begin
            // CLOCK GATING IN ACTION:
            // The circuit only spends energy updating if write_enable is active!
            registers[write_reg] <= write_data;
        end
        // If write_enable is 0, the registers do nothing, saving battery power.
    end

endmodule