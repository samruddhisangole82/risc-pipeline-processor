`timescale 1ns / 1ps

// ============================================================================
// Five-Stage MIPS/RISC Pipelined Processor
//
// Stages:
//     IF  -> Instruction Fetch
//     ID  -> Instruction Decode
//     EX  -> Execute
//     MEM -> Memory Access
//     WB  -> Write Back
//
// Features:
//     - 5-stage pipeline
//     - Data forwarding
//     - Load-use hazard detection
//     - Pipeline stall
//     - BEQ branch
//     - J jump
//     - Branch flushing
//     - Jump flushing
//     - Instruction memory
//     - Data memory
// ============================================================================

module risc_pipeline_processor (
    input clk,
    input reset
);

    // ========================================================================
    // IF STAGE
    // ========================================================================

    reg [31:0] pc;

    wire [31:0] pc_plus_4;
    wire [31:0] instruction_if;
    wire [31:0] pc_next;

    assign pc_plus_4 = pc + 32'd4;


    // ========================================================================
    // IF/ID PIPELINE REGISTER
    // ========================================================================

    wire [31:0] pc_id;
    wire [31:0] instruction_id;


    // ========================================================================
    // ID STAGE - Instruction Decode
    // ========================================================================

    wire [5:0] opcode;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;
    wire [5:0] funct;
    wire [15:0] immediate;

    assign opcode    = instruction_id[31:26];
    assign rs        = instruction_id[25:21];
    assign rt        = instruction_id[20:16];
    assign rd        = instruction_id[15:11];
    assign funct     = instruction_id[5:0];
    assign immediate = instruction_id[15:0];


    // Immediate extension
    wire [31:0] imm_extended;

    assign imm_extended = {{16{immediate[15]}}, immediate};


    // Register file outputs
    wire [31:0] read_data1_id;
    wire [31:0] read_data2_id;


    // ========================================================================
    // CONTROL SIGNALS
    // ========================================================================

    wire reg_dst_id;
    wire alu_src_id;
    wire mem_to_reg_id;
    wire reg_write_id;
    wire mem_read_id;
    wire mem_write_id;
    wire branch_id;
    wire jump_id;
    wire [3:0] alu_op_id;


    // ========================================================================
    // HAZARD DETECTION
    // ========================================================================

    wire stall;

    wire if_id_flush;
    wire id_ex_flush;
    wire ex_mem_flush;


    // ========================================================================
    // ID/EX PIPELINE REGISTER
    // ========================================================================

    wire reg_dst_ex;
    wire alu_src_ex;
    wire mem_to_reg_ex;
    wire reg_write_ex;
    wire mem_read_ex;
    wire mem_write_ex;
    wire branch_ex;

    wire [3:0] alu_op_ex;

    wire [31:0] pc_ex;
    wire [31:0] read_data1_ex;
    wire [31:0] read_data2_ex;
    wire [31:0] imm_extended_ex;

    wire [4:0] rs_ex;
    wire [4:0] rt_ex;
    wire [4:0] rd_ex;


    // ========================================================================
    // EX STAGE
    // ========================================================================

    wire [31:0] alu_operand_a;
    wire [31:0] alu_operand_b;

    wire [31:0] alu_input_b;

    wire [31:0] alu_result_ex;
    wire zero_flag_ex;

    wire [4:0] write_reg_ex;

    wire [31:0] branch_target_ex;

    wire [1:0] forward_a;
    wire [1:0] forward_b;


    // ========================================================================
    // EX/MEM PIPELINE REGISTER
    // ========================================================================

    wire mem_to_reg_mem;
    wire reg_write_mem;
    wire mem_read_mem;
    wire mem_write_mem;
    wire branch_mem;

    wire [31:0] branch_target_mem;
    wire zero_flag_mem;
    wire [31:0] alu_result_mem;
    wire [31:0] write_data_mem;

    wire [4:0] write_reg_mem;


    // ========================================================================
    // MEM STAGE
    // ========================================================================

    wire [31:0] mem_read_data_mem;

    wire branch_taken;


    // ========================================================================
    // MEM/WB PIPELINE REGISTER
    // ========================================================================

    wire mem_to_reg_wb;
    wire reg_write_wb;

    wire [31:0] mem_read_data_wb;
    wire [31:0] alu_result_wb;

    wire [4:0] write_reg_wb;


    // ========================================================================
    // WB STAGE
    // ========================================================================

    wire [31:0] write_data_wb;


    // ========================================================================
    // INSTRUCTION MEMORY
    // ========================================================================

    instruction_memory imem (
        .address(pc),
        .instruction(instruction_if)
    );


    // ========================================================================
    // BRANCH / JUMP LOGIC
    // ========================================================================

    // Branch is resolved in MEM stage.
    assign branch_taken = branch_mem & zero_flag_mem;


    // Jump target:
    //
    // {PC+4[31:28], instruction[25:0], 2'b00}
    //
    // pc_id already contains PC+4 because IF/ID stores pc_plus_4.
    //
    wire [31:0] jump_target_id;

    assign jump_target_id = {
        pc_id[31:28],
        instruction_id[25:0],
        2'b00
    };


    // Jump is resolved in ID.
    wire jump_taken;

    assign jump_taken = jump_id;


    // ========================================================================
    // NEXT PC
    // ========================================================================
    //
    // Priority:
    //
    //     1. Jump
    //     2. Taken branch
    //     3. Sequential PC
    //
    // ========================================================================

    assign pc_next = jump_taken   ? jump_target_id :
                     branch_taken ? branch_target_mem :
                     pc_plus_4;


    // ========================================================================
    // PROGRAM COUNTER
    // ========================================================================

    always @(posedge clk or posedge reset) begin

        if (reset) begin
            pc <= 32'd0;
        end

        else if (!stall) begin
            pc <= pc_next;
        end

    end


    // ========================================================================
    // PIPELINE FLUSH CONTROL
    // ========================================================================

    // Jump:
    //
    // The instruction immediately after J is already in IF.
    // Therefore IF/ID must be flushed.
    //
    // Branch:
    //
    // Branch is resolved in MEM.
    // Wrong-path instructions may be present in ID and EX.
    //

    assign if_id_flush = jump_taken | branch_taken;

    assign id_ex_flush = stall |
                         jump_taken |
                         branch_taken;


    // IMPORTANT:
    //
    // When a branch is resolved in MEM, an incorrect instruction can
    // already be in EX. Therefore EX/MEM must also be flushed.
    //
    assign ex_mem_flush = branch_taken;


    // ========================================================================
    // IF/ID PIPELINE REGISTER
    // ========================================================================

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
    // CONTROL UNIT
    // ========================================================================

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


    // ========================================================================
    // REGISTER FILE
    // ========================================================================

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


    // ========================================================================
    // HAZARD DETECTION UNIT
    // ========================================================================

    hazard_detection_unit hazard_unit (

        .id_ex_rt(rt_ex),
        .id_ex_mem_read(mem_read_ex),

        .if_id_rs(rs),
        .if_id_rt(rt),

        .opcode(opcode),

        .stall(stall)
    );


    // ========================================================================
    // ID/EX PIPELINE REGISTER
    // ========================================================================

    id_ex_register id_ex_reg (

        .clk(clk),
        .reset(reset),
        .flush(id_ex_flush),

        // Control
        .reg_dst_in(reg_dst_id),
        .alu_src_in(alu_src_id),
        .mem_to_reg_in(mem_to_reg_id),
        .reg_write_in(reg_write_id),
        .mem_read_in(mem_read_id),
        .mem_write_in(mem_write_id),
        .branch_in(branch_id),
        .alu_op_in(alu_op_id),

        // Data
        .pc_in(pc_id),
        .read_data1_in(read_data1_id),
        .read_data2_in(read_data2_id),
        .imm_extended_in(imm_extended),

        .rs_in(rs),
        .rt_in(rt),
        .rd_in(rd),

        // Outputs
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
    // FORWARDING UNIT
    // ========================================================================

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


    // ========================================================================
    // FORWARDING MUX - OPERAND A
    // ========================================================================

    assign alu_operand_a =
            (forward_a == 2'b01) ? alu_result_mem :
            (forward_a == 2'b10) ? write_data_wb :
                                   read_data1_ex;


    // ========================================================================
    // FORWARDING MUX - OPERAND B
    // ========================================================================

    assign alu_operand_b =
            (forward_b == 2'b01) ? alu_result_mem :
            (forward_b == 2'b10) ? write_data_wb :
                                   read_data2_ex;


    // ========================================================================
    // ALU SOURCE MUX
    // ========================================================================

    assign alu_input_b = alu_src_ex ?
                         imm_extended_ex :
                         alu_operand_b;


    // ========================================================================
    // ALU
    // ========================================================================

    alu main_alu (

        .operand_a(alu_operand_a),
        .operand_b(alu_input_b),

        .alu_control(alu_op_ex),

        .alu_result(alu_result_ex),
        .zero_flag(zero_flag_ex)
    );


    // ========================================================================
    // DESTINATION REGISTER
    // ========================================================================

    assign write_reg_ex = reg_dst_ex ?
                          rd_ex :
                          rt_ex;


    // ========================================================================
    // BRANCH TARGET
    // ========================================================================

    assign branch_target_ex =
            pc_ex + (imm_extended_ex << 2);


    // ========================================================================
    // EX/MEM PIPELINE REGISTER
    // ========================================================================

    ex_mem_register ex_mem_reg (
    .clk(clk),
    .reset(reset),
    .flush(ex_mem_flush),

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
    // DATA MEMORY
    // ========================================================================

    data_memory dmem (

        .clk(clk),

        .mem_read(mem_read_mem),
        .mem_write(mem_write_mem),

        .address(alu_result_mem),
        .write_data(write_data_mem),

        .read_data(mem_read_data_mem)
    );


    // ========================================================================
    // MEM/WB PIPELINE REGISTER
    // ========================================================================

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
    // WRITE BACK
    // ========================================================================

    assign write_data_wb =
            mem_to_reg_wb ?
            mem_read_data_wb :
            alu_result_wb;

endmodule