`timescale 1ns / 1ps

// ============================================================================
// Forwarding Unit
//
// Resolves data hazards by forwarding results directly to the EX-stage ALU.
//
// Encoding:
//
//     00 -> No forwarding
//           Use ID/EX register value
//
//     01 -> Forward from EX/MEM
//           Use ALU result from previous instruction
//
//     10 -> Forward from MEM/WB
//           Use write-back value
//
// EX/MEM forwarding has priority over MEM/WB forwarding.
// ============================================================================

module forwarding_unit (

    input  [4:0] ex_mem_rd,
    input  [4:0] mem_wb_rd,

    input        ex_mem_reg_write,
    input        mem_wb_reg_write,

    input  [4:0] id_ex_rs,
    input  [4:0] id_ex_rt,

    output reg [1:0] forward_a,
    output reg [1:0] forward_b
);


    always @(*) begin

        // ====================================================================
        // Default
        // ====================================================================

        forward_a = 2'b00;
        forward_b = 2'b00;


        // ====================================================================
        // OPERAND A
        //
        // Check EX/MEM first.
        // ====================================================================

        if (
            ex_mem_reg_write &&
            (ex_mem_rd != 5'd0) &&
            (ex_mem_rd == id_ex_rs)
           ) begin

            forward_a = 2'b01;

        end

        else if (
            mem_wb_reg_write &&
            (mem_wb_rd != 5'd0) &&
            (mem_wb_rd == id_ex_rs)
                ) begin

            forward_a = 2'b10;

        end


        // ====================================================================
        // OPERAND B
        //
        // Check EX/MEM first.
        // ====================================================================

        if (
            ex_mem_reg_write &&
            (ex_mem_rd != 5'd0) &&
            (ex_mem_rd == id_ex_rt)
           ) begin

            forward_b = 2'b01;

        end

        else if (
            mem_wb_reg_write &&
            (mem_wb_rd != 5'd0) &&
            (mem_wb_rd == id_ex_rt)
                ) begin

            forward_b = 2'b10;

        end

    end

endmodule