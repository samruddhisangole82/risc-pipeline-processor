`timescale 1ns / 1ps

// ============================================================================
// Data Memory
// 256 words × 32 bits = 1 KB
// ============================================================================

module data_memory (

    input clk,
    input mem_read,
    input mem_write,

    input [31:0] address,
    input [31:0] write_data,

    output [31:0] read_data

);

    // ------------------------------------------------------------------------
    // Memory array
    // ------------------------------------------------------------------------

    reg [31:0] mem [0:255];

    wire [7:0] word_addr;

    assign word_addr = address[9:2];

    // ------------------------------------------------------------------------
    // Asynchronous read
    // ------------------------------------------------------------------------

    assign read_data = mem_read ?
                       mem[word_addr] :
                       32'd0;

    // ------------------------------------------------------------------------
    // Synchronous write
    // ------------------------------------------------------------------------

    always @(posedge clk) begin

        if (mem_write) begin
            mem[word_addr] <= write_data;
        end

    end

endmodule