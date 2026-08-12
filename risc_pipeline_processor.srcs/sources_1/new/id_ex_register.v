`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2026 11:18:31
// Design Name: 
// Module Name: id_ex_register
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
// ID/EX Pipeline Register
// Pipeline register between Instruction Decode and Execute stages
// ============================================================================

module id_ex_register (
    input clk,
    input reset,
    input flush,                    // Flush signal for pipeline bubbles
    // Control signals
    input reg_dst_in,
    input alu_src_in,
    input mem_to_reg_in,
    input reg_write_in,
    input mem_read_in,
    input mem_write_in,
    input branch_in,
    input [3:0] alu_op_in,
    // Data signals
    input [31:0] pc_in,
    input [31:0] read_data1_in,
    input [31:0] read_data2_in,
    input [31:0] imm_extended_in,
    input [4:0] rs_in,
    input [4:0] rt_in,
    input [4:0] rd_in,
    // Outputs
    output reg reg_dst_out,
    output reg alu_src_out,
    output reg mem_to_reg_out,
    output reg reg_write_out,
    output reg mem_read_out,
    output reg mem_write_out,
    output reg branch_out,
    output reg [3:0] alu_op_out,
    output reg [31:0] pc_out,
    output reg [31:0] read_data1_out,
    output reg [31:0] read_data2_out,
    output reg [31:0] imm_extended_out,
    output reg [4:0] rs_out,
    output reg [4:0] rt_out,
    output reg [4:0] rd_out
);

    always @(posedge clk or posedge reset) begin
        if (reset || flush) begin
            // Clear all control and data signals
            reg_dst_out <= 1'b0;
            alu_src_out <= 1'b0;
            mem_to_reg_out <= 1'b0;
            reg_write_out <= 1'b0;
            mem_read_out <= 1'b0;
            mem_write_out <= 1'b0;
            branch_out <= 1'b0;
            alu_op_out <= 4'd0;
            pc_out <= 32'd0;
            read_data1_out <= 32'd0;
            read_data2_out <= 32'd0;
            imm_extended_out <= 32'd0;
            rs_out <= 5'd0;
            rt_out <= 5'd0;
            rd_out <= 5'd0;
        end else begin
            // Propagate signals
            reg_dst_out <= reg_dst_in;
            alu_src_out <= alu_src_in;
            mem_to_reg_out <= mem_to_reg_in;
            reg_write_out <= reg_write_in;
            mem_read_out <= mem_read_in;
            mem_write_out <= mem_write_in;
            branch_out <= branch_in;
            alu_op_out <= alu_op_in;
            pc_out <= pc_in;
            read_data1_out <= read_data1_in;
            read_data2_out <= read_data2_in;
            imm_extended_out <= imm_extended_in;
            rs_out <= rs_in;
            rt_out <= rt_in;
            rd_out <= rd_in;
        end
    end

endmodule