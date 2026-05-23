`timescale 1ns / 1ps

module cpu_top (
    input  wire        clk,           // Master clock pulse for the entire CPU
    input  wire        rst,           // Master reset button
    
    // External instruction input (Simulating reading from a memory chip)
    input  wire [15:0] external_instruction, 
    
    // Outputs to observe what is happening inside our CPU
    output wire [15:0] current_pc,    // Shows what line of code we are on
    output wire [15:0] cpu_result,    // Shows the current output of the calculation
    output wire        cpu_zero_flag  // Shows if the calculation resulted in zero
);

    // Internal Wires connecting the modules together
    wire [15:0] wire_reg_dataA;
    wire [15:0] wire_reg_dataB;
    
    // Control lines driven automatically by the Control Unit
    wire        ctrl_reg_write_en;
    wire [1:0]  ctrl_reg_read_selA;
    wire [1:0]  ctrl_reg_read_selB;
    wire [1:0]  ctrl_reg_write_sel;
    wire [1:0]  ctrl_alu_opcode;
    wire        ctrl_pc_jump;
    wire [15:0] ctrl_pc_jump_addr;

    // =========================================================================
    // 1. PLUG IN THE BRAIN (The Control Unit)
    // =========================================================================
    control_unit BRAIN_MODULE (
        .instruction(external_instruction),
        .alu_zero_flag(cpu_zero_flag),
        .reg_write_en(ctrl_reg_write_en),
        .reg_read_selA(ctrl_reg_read_selA),
        .reg_read_selB(ctrl_reg_read_selB),
        .reg_write_sel(ctrl_reg_write_sel),
        .alu_opcode(ctrl_alu_opcode),
        .pc_jump(ctrl_pc_jump),
        .pc_jump_addr(ctrl_pc_jump_addr)
    );

    // =========================================================================
    // 2. PLUG IN THE PROGRAM COUNTER (The Navigator)
    // =========================================================================
    program_counter PC_MODULE (
        .clk(clk),
        .rst(rst),
        .jump(ctrl_pc_jump),
        .jump_addr(ctrl_pc_jump_addr),
        .pc(current_pc)
    );

    // =========================================================================
    // 3. PLUG IN THE REGISTER FILE (The Storage with Clock Gating)
    // =========================================================================
    register_file REG_FILE_MODULE (
        .clk(clk),
        .rst(rst),
        .write_enable(ctrl_reg_write_en), 
        .read_regA(ctrl_reg_read_selA),
        .read_regB(ctrl_reg_read_selB),
        .write_reg(ctrl_reg_write_sel),
        .write_data(cpu_result),     
        .reg_dataA(wire_reg_dataA),
        .reg_dataB(wire_reg_dataB)
    );

    // =========================================================================
    // 4. PLUG IN THE ALU (The Calculator)
    // =========================================================================
    alu ALU_MODULE (
        .A(wire_reg_dataA),          
        .B(wire_reg_dataB),          
        .alu_op(ctrl_alu_opcode),
        .alu_out(cpu_result),        
        .zero_flag(cpu_zero_flag)
    );

endmodule