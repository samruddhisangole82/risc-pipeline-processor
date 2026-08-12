`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2026 11:20:56
// Design Name: 
// Module Name: instruction_memory
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
// Instruction Memory Module
// Read-only memory for storing program instructions
// ============================================================================

// ============================================================================
// Instruction Memory Module
// Read-only memory for storing program instructions
// ============================================================================
// ============================================================================
// Instruction Memory Module
// Read-only memory for storing program instructions
// ============================================================================

module instruction_memory (
    input [31:0] address,           // Instruction address (PC)
    output [31:0] instruction       // Fetched instruction
);

    // Instruction memory: 256 words (1KB)
    reg [31:0] mem [0:255];

    // Word-aligned address (divide by 4)
    wire [7:0] word_addr = address[9:2];

    // Asynchronous read
    assign instruction = mem[word_addr];

    // Initialize with sample program
    // Using genvar and generate for loop (Vivado compatible)
    integer i;
    initial begin
        // First, initialize all locations to NOP
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 32'h00000000;
        end
        
        // Then load the actual program
        // Example program: Load some values and perform operations
        mem[0] = 32'h00000000;  // NOP
        mem[1] = 32'h00000000;  // NOP
        mem[2] = 32'h20010005;  // ADDI $1, $0, 5      : R1 = 5
        mem[3] = 32'h2002000A;  // ADDI $2, $0, 10     : R2 = 10
        mem[4] = 32'h00221820;  // ADD $3, $1, $2      : R3 = R1 + R2 = 15
        mem[5] = 32'h00412022;  // SUB $4, $2, $1      : R4 = R2 - R1 = 5
        mem[6] = 32'h00222824;  // AND $5, $1, $2      : R5 = R1 & R2
        mem[7] = 32'h00223025;  // OR $6, $1, $2       : R6 = R1 | R2
    end

endmodule