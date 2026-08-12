`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2026 11:08:52
// Design Name: 
// Module Name: risc_pipeline_processor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// ============================================================================
// Five-Stage RISC Pipelined Processor - Top Module
// Integrates all pipeline stages and components
// ============================================================================

module risc_pipeline_processor (
    input clk,
    input reset
);

    // ========================================================================
    // Wire Declarations
    // ========================================================================
    
    // IF Stage
    reg [31:0] pc;
    wire [31:0] pc_plus_4;
    wire [31:0] instruction_if;
    wire [31:0] pc_next;
    
    // IF/ID Pipeline Register
    wire [31:0] pc_id;
    wire [31:0] instruction_id;
    
    // ID Stage
    wire [5:0] opcode = instruction_id[31:26];
    wire [4:0] rs = instruction_id[25:21];
    wire [4:0] rt = instruction_id[20:16];
    wire [4:0] rd = instruction_id[15:11];
    wire [5:0] funct = instruction_id[5:0];
    wire [15:0] immediate = instruction_id[15:0];
    wire [31:0] imm_extended;
    wire [31:0] read_data1_id, read_data2_id;
    
    // Control signals from control unit
    wire reg_dst_id, alu_src_id, mem_to_reg_id, reg_write_id;
    wire mem_read_id, mem_write_id, branch_id, jump_id;
    wire [3:0] alu_op_id;
    
    // Hazard detection
    wire stall;
    wire if_id_flush;
    wire id_ex_flush;
    
    // ID/EX Pipeline Register
    wire reg_dst_ex, alu_src_ex, mem_to_reg_ex, reg_write_ex;
    wire mem_read_ex, mem_write_ex, branch_ex;
    wire [3:0] alu_op_ex;
    wire [31:0] pc_ex;
    wire [31:0] read_data1_ex, read_data2_ex;
    wire [31:0] imm_extended_ex;
    wire [4:0] rs_ex, rt_ex, rd_ex;
    
    // EX Stage
    wire [31:0] alu_operand_a, alu_operand_b;
    wire [31:0] alu_input_a, alu_input_b;
    wire [31:0] alu_result_ex;
    wire zero_flag_ex;
    wire [4:0] write_reg_ex;
    wire [31:0] branch_target_ex;
    wire [1:0] forward_a, forward_b;
    
    // EX/MEM Pipeline Register
    wire mem_to_reg_mem, reg_write_mem;
    wire mem_read_mem, mem_write_mem, branch_mem;
    wire [31:0] branch_target_mem;
    wire zero_flag_mem;
    wire [31:0] alu_result_mem;
    wire [31:0] write_data_mem;
    wire [4:0] write_reg_mem;
    
    // MEM Stage
    wire [31:0] mem_read_data_mem;
    wire pc_src;
    
    // MEM/WB Pipeline Register
    wire mem_to_reg_wb, reg_write_wb;
    wire [31:0] mem_read_data_wb;
    wire [31:0] alu_result_wb;
    wire [4:0] write_reg_wb;
    
    // WB Stage
    wire [31:0] write_data_wb;

    // ========================================================================
    // IF Stage - Instruction Fetch
    // ========================================================================
    
    assign pc_plus_4 = pc + 4;
    
    // PC Source selection (branch or sequential)
    assign pc_src = branch_mem & zero_flag_mem;
    assign pc_next = pc_src ? branch_target_mem : pc_plus_4;
    
    // Program Counter
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 32'd0;
        else if (!stall)
            pc <= pc_next;
    end
    
    // Instruction Memory
    instruction_memory imem (
        .address(pc),
        .instruction(instruction_if)
    );
    
    // IF/ID Pipeline Register
    assign if_id_flush = pc_src;  // Flush on branch taken
    
    if_id_register if_id_reg (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .flush(if_id_flush),
        .pc_in(pc_plus_4),
        .instruction_in(instruction_if),
        .pc_out(pc_id),
        .instruction_out(instruction_id)
    );

    // ========================================================================
    // ID Stage - Instruction Decode
    // ========================================================================
    
    // Sign-extend immediate value
    assign imm_extended = {{16{immediate[15]}}, immediate};
    
    // Control Unit
    control_unit ctrl_unit (
        .opcode(opcode),
        .funct(funct),
        .reg_dst(reg_dst_id),
        .alu_src(alu_src_id),
        .mem_to_reg(mem_to_reg_id),
        .reg_write(reg_write_id),
        .mem_read(mem_read_id),
        .mem_write(mem_write_id),
        .branch(branch_id),
        .jump(jump_id),
        .alu_op(alu_op_id)
    );
    
    // Register File
    register_file reg_file (
        .clk(clk),
        .reset(reset),
        .reg_write(reg_write_wb),
        .read_reg1(rs),
        .read_reg2(rt),
        .write_reg(write_reg_wb),
        .write_data(write_data_wb),
        .read_data1(read_data1_id),
        .read_data2(read_data2_id)
    );
    
    // Hazard Detection Unit
    hazard_detection_unit hazard_unit (
        .id_ex_rt(rt_ex),
        .id_ex_mem_read(mem_read_ex),
        .if_id_rs(rs),
        .if_id_rt(rt),
        .stall(stall)
    );
    
    // Insert bubble if stall is detected
    assign id_ex_flush = stall;
    
    // ID/EX Pipeline Register
    id_ex_register id_ex_reg (
        .clk(clk),
        .reset(reset),
        .flush(id_ex_flush),
        .reg_dst_in(reg_dst_id & ~stall),
        .alu_src_in(alu_src_id & ~stall),
        .mem_to_reg_in(mem_to_reg_id & ~stall),
        .reg_write_in(reg_write_id & ~stall),
        .mem_read_in(mem_read_id & ~stall),
        .mem_write_in(mem_write_id & ~stall),
        .branch_in(branch_id & ~stall),
        .alu_op_in(alu_op_id),
        .pc_in(pc_id),
        .read_data1_in(read_data1_id),
        .read_data2_in(read_data2_id),
        .imm_extended_in(imm_extended),
        .rs_in(rs),
        .rt_in(rt),
        .rd_in(rd),
        .reg_dst_out(reg_dst_ex),
        .alu_src_out(alu_src_ex),
        .mem_to_reg_out(mem_to_reg_ex),
        .reg_write_out(reg_write_ex),
        .mem_read_out(mem_read_ex),
        .mem_write_out(mem_write_ex),
        .branch_out(branch_ex),
        .alu_op_out(alu_op_ex),
        .pc_out(pc_ex),
        .read_data1_out(read_data1_ex),
        .read_data2_out(read_data2_ex),
        .imm_extended_out(imm_extended_ex),
        .rs_out(rs_ex),
        .rt_out(rt_ex),
        .rd_out(rd_ex)
    );

    // ========================================================================
    // EX Stage - Execute
    // ========================================================================
    
    // Forwarding Unit
    forwarding_unit fwd_unit (
        .ex_mem_rd(write_reg_mem),
        .mem_wb_rd(write_reg_wb),
        .ex_mem_reg_write(reg_write_mem),
        .mem_wb_reg_write(reg_write_wb),
        .id_ex_rs(rs_ex),
        .id_ex_rt(rt_ex),
        .forward_a(forward_a),
        .forward_b(forward_b)
    );
    
    // Forwarding MUX for operand A
    assign alu_operand_a = (forward_a == 2'b01) ? alu_result_mem :
                           (forward_a == 2'b10) ? write_data_wb :
                           read_data1_ex;
    
    // Forwarding MUX for operand B
    assign alu_operand_b = (forward_b == 2'b01) ? alu_result_mem :
                           (forward_b == 2'b10) ? write_data_wb :
                           read_data2_ex;
    
    // ALU Source MUX (register or immediate)
    assign alu_input_b = alu_src_ex ? imm_extended_ex : alu_operand_b;
    
    // ALU
    alu main_alu (
        .operand_a(alu_operand_a),
        .operand_b(alu_input_b),
        .alu_control(alu_op_ex),
        .alu_result(alu_result_ex),
        .zero_flag(zero_flag_ex)
    );
    
    // Write register MUX (rt or rd)
    assign write_reg_ex = reg_dst_ex ? rd_ex : rt_ex;
    
    // Branch target calculation
    assign branch_target_ex = pc_ex + (imm_extended_ex << 2);
    
    // EX/MEM Pipeline Register
    ex_mem_register ex_mem_reg (
        .clk(clk),
        .reset(reset),
        .mem_to_reg_in(mem_to_reg_ex),
        .reg_write_in(reg_write_ex),
        .mem_read_in(mem_read_ex),
        .mem_write_in(mem_write_ex),
        .branch_in(branch_ex),
        .branch_target_in(branch_target_ex),
        .zero_flag_in(zero_flag_ex),
        .alu_result_in(alu_result_ex),
        .write_data_in(alu_operand_b),
        .write_reg_in(write_reg_ex),
        .mem_to_reg_out(mem_to_reg_mem),
        .reg_write_out(reg_write_mem),
        .mem_read_out(mem_read_mem),
        .mem_write_out(mem_write_mem),
        .branch_out(branch_mem),
        .branch_target_out(branch_target_mem),
        .zero_flag_out(zero_flag_mem),
        .alu_result_out(alu_result_mem),
        .write_data_out(write_data_mem),
        .write_reg_out(write_reg_mem)
    );

    // ========================================================================
    // MEM Stage - Memory Access
    // ========================================================================
    
    // Data Memory
    data_memory dmem (
        .clk(clk),
        .mem_read(mem_read_mem),
        .mem_write(mem_write_mem),
        .address(alu_result_mem),
        .write_data(write_data_mem),
        .read_data(mem_read_data_mem)
    );
    
    // MEM/WB Pipeline Register
    mem_wb_register mem_wb_reg (
        .clk(clk),
        .reset(reset),
        .mem_to_reg_in(mem_to_reg_mem),
        .reg_write_in(reg_write_mem),
        .mem_read_data_in(mem_read_data_mem),
        .alu_result_in(alu_result_mem),
        .write_reg_in(write_reg_mem),
        .mem_to_reg_out(mem_to_reg_wb),
        .reg_write_out(reg_write_wb),
        .mem_read_data_out(mem_read_data_wb),
        .alu_result_out(alu_result_wb),
        .write_reg_out(write_reg_wb)
    );

    // ========================================================================
    // WB Stage - Write Back
    // ========================================================================
    
    // Write-back data MUX (memory data or ALU result)
    assign write_data_wb = mem_to_reg_wb ? mem_read_data_wb : alu_result_wb;

endmodule