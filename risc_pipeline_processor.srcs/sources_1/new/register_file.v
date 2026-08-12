`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2026 11:11:08
// Design Name: 
// Module Name: register_file
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
// Register File Module
// 32 general-purpose registers with dual read ports and one write port
// Register 0 is hardwired to zero
// ============================================================================
// ============================================================================
// Register File Module
// 32 general-purpose registers with dual read ports and one write port
// Register 0 is hardwired to zero
// ============================================================================

module register_file (
    input clk,
    input reset,
    input reg_write,                 // Write enable signal
    input [4:0] read_reg1,          // First read register address
    input [4:0] read_reg2,          // Second read register address
    input [4:0] write_reg,          // Write register address
    input [31:0] write_data,        // Data to write
    output [31:0] read_data1,       // First read data output
    output [31:0] read_data2        // Second read data output
);

    // 32 registers, each 32 bits wide
    reg [31:0] registers [0:31];
    
    integer i;

    // Asynchronous read operations with internal forwarding
    // If reading the same register being written, forward the write data
    assign read_data1 = (read_reg1 == 5'd0) ? 32'd0 :
                        (reg_write && (write_reg == read_reg1)) ? write_data :
                        registers[read_reg1];
    
    assign read_data2 = (read_reg2 == 5'd0) ? 32'd0 :
                        (reg_write && (write_reg == read_reg2)) ? write_data :
                        registers[read_reg2];

    // Synchronous write operation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize all registers to 0
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'd0;
            end
        end else if (reg_write && write_reg != 5'd0) begin
            // Write to register (except register 0)
            registers[write_reg] <= write_data;
        end
    end

endmodule