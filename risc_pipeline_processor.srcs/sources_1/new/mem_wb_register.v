`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2026 11:20:06
// Design Name: 
// Module Name: mem_wb_register
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
// MEM/WB Pipeline Register
// Pipeline register between Memory and Write-Back stages
// ============================================================================

module mem_wb_register (
    input clk,
    input reset,
    // Control signals
    input mem_to_reg_in,
    input reg_write_in,
    // Data signals
    input [31:0] mem_read_data_in,
    input [31:0] alu_result_in,
    input [4:0] write_reg_in,
    // Outputs
    output reg mem_to_reg_out,
    output reg reg_write_out,
    output reg [31:0] mem_read_data_out,
    output reg [31:0] alu_result_out,
    output reg [4:0] write_reg_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mem_to_reg_out <= 1'b0;
            reg_write_out <= 1'b0;
            mem_read_data_out <= 32'd0;
            alu_result_out <= 32'd0;
            write_reg_out <= 5'd0;
        end else begin
            mem_to_reg_out <= mem_to_reg_in;
            reg_write_out <= reg_write_in;
            mem_read_data_out <= mem_read_data_in;
            alu_result_out <= alu_result_in;
            write_reg_out <= write_reg_in;
        end
    end

endmodule
