`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2026 11:10:20
// Design Name: 
// Module Name: alu
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
// ALU Module - Arithmetic Logic Unit
// 32-bit ALU supporting multiple operations
// ============================================================================

module alu (
    input [31:0] operand_a,      // First operand
    input [31:0] operand_b,      // Second operand
    input [3:0] alu_control,     // ALU operation selector
    output reg [31:0] alu_result, // Result of operation
    output zero_flag              // Zero flag for branch decisions
);

    // ALU Operation Codes
    localparam ALU_ADD  = 4'b0000;
    localparam ALU_SUB  = 4'b0001;
    localparam ALU_AND  = 4'b0010;
    localparam ALU_OR   = 4'b0011;
    localparam ALU_XOR  = 4'b0100;
    localparam ALU_SLT  = 4'b0101; // Set Less Than
    localparam ALU_SLL  = 4'b0110; // Shift Left Logical
    localparam ALU_SRL  = 4'b0111; // Shift Right Logical
    localparam ALU_SRA  = 4'b1000; // Shift Right Arithmetic
    localparam ALU_NOR  = 4'b1001;

    // Combinational ALU logic
    always @(*) begin
        case (alu_control)
            ALU_ADD:  alu_result = operand_a + operand_b;
            ALU_SUB:  alu_result = operand_a - operand_b;
            ALU_AND:  alu_result = operand_a & operand_b;
            ALU_OR:   alu_result = operand_a | operand_b;
            ALU_XOR:  alu_result = operand_a ^ operand_b;
            ALU_SLT:  alu_result = ($signed(operand_a) < $signed(operand_b)) ? 32'd1 : 32'd0;
            ALU_SLL:  alu_result = operand_a << operand_b[4:0];
            ALU_SRL:  alu_result = operand_a >> operand_b[4:0];
            ALU_SRA:  alu_result = $signed(operand_a) >>> operand_b[4:0];
            ALU_NOR:  alu_result = ~(operand_a | operand_b);
            default:  alu_result = 32'd0;
        endcase
    end

    // Zero flag assertion
    assign zero_flag = (alu_result == 32'd0);

endmodule
