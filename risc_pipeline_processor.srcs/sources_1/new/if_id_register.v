`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2026 11:17:40
// Design Name: 
// Module Name: if_id_register
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
// IF/ID Pipeline Register
// Pipeline register between Instruction Fetch and Instruction Decode stages
// ============================================================================

module if_id_register (
    input clk,
    input reset,
    input stall,                    // Stall signal from hazard detection
    input flush,                    // Flush signal for branch misprediction
    input [31:0] pc_in,             // PC from IF stage
    input [31:0] instruction_in,    // Instruction from IF stage
    output reg [31:0] pc_out,       // PC to ID stage
    output reg [31:0] instruction_out // Instruction to ID stage
);

    always @(posedge clk or posedge reset) begin
        if (reset || flush) begin
            pc_out <= 32'd0;
            instruction_out <= 32'd0;
        end else if (!stall) begin
            pc_out <= pc_in;
            instruction_out <= instruction_in;
        end
        // If stall is asserted, hold current values
    end

endmodule