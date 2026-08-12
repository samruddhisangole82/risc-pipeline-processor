`timescale 1ns / 1ps

// ============================================================================
// Hazard Detection Unit
//
// Detects load-use hazards.
//
// If:
//
//     instruction in EX = LW
//
// and:
//
//     destination of LW == source of instruction in ID
//
// then:
//
//     - PC is stalled
//     - IF/ID is stalled
//     - ID/EX receives a bubble
//
// ============================================================================

module hazard_detection_unit (

    input [4:0] id_ex_rt,
    input       id_ex_mem_read,

    input [4:0] if_id_rs,
    input [4:0] if_id_rt,

    input [5:0] opcode,

    output reg stall
);

    // Opcodes
    localparam R_TYPE = 6'b000000;
    localparam LW     = 6'b100011;
    localparam SW     = 6'b101011;
    localparam BEQ    = 6'b000100;
    localparam ADDI   = 6'b001000;
    localparam ANDI   = 6'b001100;
    localparam ORI    = 6'b001101;
    localparam SLTI   = 6'b001010;
    localparam J      = 6'b000010;


    // Does the instruction in ID use rs?
    reg uses_rs;

    // Does the instruction in ID use rt as a source?
    reg uses_rt;


    always @(*) begin

        // Default
        uses_rs = 1'b0;
        uses_rt = 1'b0;


        // ================================================================
        // Determine source registers
        // ================================================================

        case (opcode)

            // R-type:
            // ADD rd, rs, rt
            R_TYPE: begin
                uses_rs = 1'b1;
                uses_rt = 1'b1;
            end


            // LW:
            // LW rt, immediate(rs)
            LW: begin
                uses_rs = 1'b1;
                uses_rt = 1'b0;
            end


            // SW:
            // SW rt, immediate(rs)
            //
            // Both rs and rt are source registers.
            SW: begin
                uses_rs = 1'b1;
                uses_rt = 1'b1;
            end


            // BEQ:
            // BEQ rs, rt, offset
            BEQ: begin
                uses_rs = 1'b1;
                uses_rt = 1'b1;
            end


            // Immediate instructions:
            // ADDI rt, rs, immediate
            // ANDI rt, rs, immediate
            // ORI  rt, rs, immediate
            // SLTI rt, rs, immediate
            ADDI,
            ANDI,
            ORI,
            SLTI: begin
                uses_rs = 1'b1;
                uses_rt = 1'b0;
            end


            // J:
            // J target
            J: begin
                uses_rs = 1'b0;
                uses_rt = 1'b0;
            end


            default: begin
                uses_rs = 1'b0;
                uses_rt = 1'b0;
            end

        endcase


        // ================================================================
        // Load-use hazard
        // ================================================================

        if (id_ex_mem_read &&
            (id_ex_rt != 5'd0) &&
            (
                (uses_rs && (id_ex_rt == if_id_rs)) ||
                (uses_rt && (id_ex_rt == if_id_rt))
            )
           ) begin

            stall = 1'b1;

        end

        else begin

            stall = 1'b0;

        end

    end

endmodule