`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2026 11:21:53
// Design Name: 
// Module Name: data_memory
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
// Data Memory Module
// Read/Write memory for load and store operations
// ============================================================================

// ============================================================================
// Data Memory Module
// Read/Write memory for load and store operations
// ============================================================================

// ============================================================================
// Data Memory Module
// Read/Write memory for load and store operations
// ============================================================================

// ============================================================================
// Data Memory Module
// Read/Write memory for load and store operations
// ============================================================================

module data_memory (
    input clk,
    input mem_read,                 // Memory read enable
    input mem_write,                // Memory write enable
    input [31:0] address,           // Memory address
    input [31:0] write_data,        // Data to write
    output [31:0] read_data         // Data read from memory
);

    // Data memory: 256 words (1KB)
    reg [31:0] mem [0:255];

    // Word-aligned address
    wire [7:0] word_addr = address[9:2];

    // Asynchronous read
    assign read_data = (mem_read) ? mem[word_addr] : 32'd0;

    // Synchronous write
    always @(posedge clk) begin
        if (mem_write) begin
            mem[word_addr] <= write_data;
        end
    end

    // Note: Memory is automatically initialized to X in simulation
    // and to 0 in synthesis. This is acceptable for data memory.

endmodule