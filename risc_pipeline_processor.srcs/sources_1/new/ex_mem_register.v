`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2026 11:19:22
// Design Name: 
// Module Name: ex_mem_register
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
// EX/MEM Pipeline Register
// Pipeline register between Execute and Memory stages
// ============================================================================

module ex_mem_register (
    input clk,
    input reset,
    // Control signals
    input mem_to_reg_in,
    input reg_write_in,
    input mem_read_in,
    input mem_write_in,
    input branch_in,
    // Data signals
    input [31:0] branch_target_in,
    input zero_flag_in,
    input [31:0] alu_result_in,
    input [31:0] write_data_in,
    input [4:0] write_reg_in,
    // Outputs
    output reg mem_to_reg_out,
    output reg reg_write_out,
    output reg mem_read_out,
    output reg mem_write_out,
    output reg branch_out,
    output reg [31:0] branch_target_out,
    output reg zero_flag_out,
    output reg [31:0] alu_result_out,
    output reg [31:0] write_data_out,
    output reg [4:0] write_reg_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mem_to_reg_out <= 1'b0;
            reg_write_out <= 1'b0;
            mem_read_out <= 1'b0;
            mem_write_out <= 1'b0;
            branch_out <= 1'b0;
            branch_target_out <= 32'd0;
            zero_flag_out <= 1'b0;
            alu_result_out <= 32'd0;
            write_data_out <= 32'd0;
            write_reg_out <= 5'd0;
        end else begin
            mem_to_reg_out <= mem_to_reg_in;
            reg_write_out <= reg_write_in;
            mem_read_out <= mem_read_in;
            mem_write_out <= mem_write_in;
            branch_out <= branch_in;
            branch_target_out <= branch_target_in;
            zero_flag_out <= zero_flag_in;
            alu_result_out <= alu_result_in;
            write_data_out <= write_data_in;
            write_reg_out <= write_reg_in;
        end
    end

endmodule