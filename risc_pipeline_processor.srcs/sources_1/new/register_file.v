`timescale 1ns / 1ps

module register_file (
    input clk,
    input reset,

    input        reg_write,

    input  [4:0] read_reg1,
    input  [4:0] read_reg2,

    input  [4:0] write_reg,
    input  [31:0] write_data,

    output [31:0] read_data1,
    output [31:0] read_data2
);

    // 32 registers × 32 bits
    reg [31:0] registers [0:31];

    integer i;

    // ------------------------------------------------------------
    // Read Port 1
    // ------------------------------------------------------------

    assign read_data1 =
        (read_reg1 == 5'd0) ? 32'd0 :
        (reg_write && (write_reg != 5'd0) &&
         (write_reg == read_reg1)) ? write_data :
        registers[read_reg1];

    // ------------------------------------------------------------
    // Read Port 2
    // ------------------------------------------------------------

    assign read_data2 =
        (read_reg2 == 5'd0) ? 32'd0 :
        (reg_write && (write_reg != 5'd0) &&
         (write_reg == read_reg2)) ? write_data :
        registers[read_reg2];

    // ------------------------------------------------------------
    // Synchronous write
    // ------------------------------------------------------------

    always @(posedge clk or posedge reset) begin

        if (reset) begin

            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'd0;

        end

        else if (reg_write && (write_reg != 5'd0)) begin

            registers[write_reg] <= write_data;

        end

    end

endmodule