`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2026 11:12:02
// Design Name: 
// Module Name: control_unit
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
// Control Unit Module
// Generates control signals based on instruction opcode
// ============================================================================

module control_unit (
    input [5:0] opcode,          // 6-bit opcode from instruction
    input [5:0] funct,           // Function field for R-type instructions
    output reg reg_dst,          // Register destination selector
    output reg alu_src,          // ALU source selector
    output reg mem_to_reg,       // Memory to register selector
    output reg reg_write,        // Register write enable
    output reg mem_read,         // Memory read enable
    output reg mem_write,        // Memory write enable
    output reg branch,           // Branch instruction flag
    output reg jump,             // Jump instruction flag
    output reg [3:0] alu_op      // ALU operation code
);

    // Instruction Opcodes
    localparam R_TYPE = 6'b000000;
    localparam LW     = 6'b100011;  // Load Word
    localparam SW     = 6'b101011;  // Store Word
    localparam BEQ    = 6'b000100;  // Branch Equal
    localparam ADDI   = 6'b001000;  // Add Immediate
    localparam ANDI   = 6'b001100;  // And Immediate
    localparam ORI    = 6'b001101;  // Or Immediate
    localparam SLTI   = 6'b001010;  // Set Less Than Immediate
    localparam J      = 6'b000010;  // Jump

    // R-type function codes
    localparam FUNCT_ADD = 6'b100000;
    localparam FUNCT_SUB = 6'b100010;
    localparam FUNCT_AND = 6'b100100;
    localparam FUNCT_OR  = 6'b100101;
    localparam FUNCT_XOR = 6'b100110;
    localparam FUNCT_SLT = 6'b101010;
    localparam FUNCT_SLL = 6'b000000;
    localparam FUNCT_SRL = 6'b000010;
    localparam FUNCT_SRA = 6'b000011;
    localparam FUNCT_NOR = 6'b100111;

    always @(*) begin
        // Default values
        reg_dst = 0;
        alu_src = 0;
        mem_to_reg = 0;
        reg_write = 0;
        mem_read = 0;
        mem_write = 0;
        branch = 0;
        jump = 0;
        alu_op = 4'b0000;

        case (opcode)
            R_TYPE: begin
                reg_dst = 1;
                reg_write = 1;
                // Determine ALU operation from function field
                case (funct)
                    FUNCT_ADD: alu_op = 4'b0000;
                    FUNCT_SUB: alu_op = 4'b0001;
                    FUNCT_AND: alu_op = 4'b0010;
                    FUNCT_OR:  alu_op = 4'b0011;
                    FUNCT_XOR: alu_op = 4'b0100;
                    FUNCT_SLT: alu_op = 4'b0101;
                    FUNCT_SLL: alu_op = 4'b0110;
                    FUNCT_SRL: alu_op = 4'b0111;
                    FUNCT_SRA: alu_op = 4'b1000;
                    FUNCT_NOR: alu_op = 4'b1001;
                    default:   alu_op = 4'b0000;
                endcase
            end

            LW: begin
                alu_src = 1;
                mem_to_reg = 1;
                reg_write = 1;
                mem_read = 1;
                alu_op = 4'b0000; // ADD for address calculation
            end

            SW: begin
                alu_src = 1;
                mem_write = 1;
                alu_op = 4'b0000; // ADD for address calculation
            end

            BEQ: begin
                branch = 1;
                alu_op = 4'b0001; // SUB for comparison
            end

            ADDI: begin
                alu_src = 1;
                reg_write = 1;
                alu_op = 4'b0000; // ADD
            end

            ANDI: begin
                alu_src = 1;
                reg_write = 1;
                alu_op = 4'b0010; // AND
            end

            ORI: begin
                alu_src = 1;
                reg_write = 1;
                alu_op = 4'b0011; // OR
            end

            SLTI: begin
                alu_src = 1;
                reg_write = 1;
                alu_op = 4'b0101; // SLT
            end

            J: begin
                jump = 1;
            end

            default: begin
                // All signals remain at default values
            end
        endcase
    end

endmodule