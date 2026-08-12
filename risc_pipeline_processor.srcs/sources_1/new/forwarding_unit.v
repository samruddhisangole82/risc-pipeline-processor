`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2026 11:16:24
// Design Name: 
// Module Name: forwarding_unit
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
// Forwarding Unit
// Handles data forwarding to resolve data hazards through forwarding
// ============================================================================

module forwarding_unit (
    input [4:0] ex_mem_rd,          // Destination register in MEM stage
    input [4:0] mem_wb_rd,          // Destination register in WB stage
    input ex_mem_reg_write,         // Register write signal in MEM stage
    input mem_wb_reg_write,         // Register write signal in WB stage
    input [4:0] id_ex_rs,           // Source register 1 in EX stage
    input [4:0] id_ex_rt,           // Source register 2 in EX stage
    output reg [1:0] forward_a,     // Forward control for operand A
    output reg [1:0] forward_b      // Forward control for operand B
);

    // Forward control encoding:
    // 00: No forwarding (use register file data)
    // 01: Forward from MEM stage (EX/MEM pipeline register)
    // 10: Forward from WB stage (MEM/WB pipeline register)

    always @(*) begin
        // Default: no forwarding
        forward_a = 2'b00;
        forward_b = 2'b00;

        // EX hazard (forward from MEM stage)
        if (ex_mem_reg_write && (ex_mem_rd != 5'd0) && (ex_mem_rd == id_ex_rs)) begin
            forward_a = 2'b01;
        end
        // MEM hazard (forward from WB stage)
        else if (mem_wb_reg_write && (mem_wb_rd != 5'd0) && (mem_wb_rd == id_ex_rs)) begin
            forward_a = 2'b10;
        end

        // EX hazard for operand B
        if (ex_mem_reg_write && (ex_mem_rd != 5'd0) && (ex_mem_rd == id_ex_rt)) begin
            forward_b = 2'b01;
        end
        // MEM hazard for operand B
        else if (mem_wb_reg_write && (mem_wb_rd != 5'd0) && (mem_wb_rd == id_ex_rt)) begin
            forward_b = 2'b10;
        end
    end

endmodule