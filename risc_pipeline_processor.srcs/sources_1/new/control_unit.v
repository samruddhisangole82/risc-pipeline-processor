`timescale 1ns / 1ps

// ============================================================================
// Control Unit
//
// Generates control signals for the pipelined processor.
// ============================================================================

module control_unit (

    input  [5:0] opcode,
    input  [5:0] funct,

    output reg reg_dst,
    output reg alu_src,

    output reg mem_to_reg,
    output reg reg_write,

    output reg mem_read,
    output reg mem_write,

    output reg branch,
    output reg jump,

    output reg [3:0] alu_op
);


    // ========================================================================
    // OPCODES
    // ========================================================================

    localparam R_TYPE = 6'b000000;

    localparam LW     = 6'b100011;
    localparam SW     = 6'b101011;

    localparam BEQ    = 6'b000100;

    localparam ADDI   = 6'b001000;
    localparam ANDI   = 6'b001100;
    localparam ORI    = 6'b001101;
    localparam SLTI   = 6'b001010;

    localparam J      = 6'b000010;


    // ========================================================================
    // R-TYPE FUNCTION CODES
    // ========================================================================

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


    // ========================================================================
    // ALU OPERATION CODES
    //
    // These must match the ALU module.
    // ========================================================================

    localparam ALU_ADD = 4'b0000;
    localparam ALU_SUB = 4'b0001;

    localparam ALU_AND = 4'b0010;
    localparam ALU_OR  = 4'b0011;

    localparam ALU_XOR = 4'b0100;
    localparam ALU_SLT = 4'b0101;

    localparam ALU_SLL = 4'b0110;
    localparam ALU_SRL = 4'b0111;

    localparam ALU_SRA = 4'b1000;
    localparam ALU_NOR = 4'b1001;


    // ========================================================================
    // CONTROL LOGIC
    // ========================================================================

    always @(*) begin

        // --------------------------------------------------------------------
        // Safe defaults
        //
        // These defaults make an unknown/unsupported instruction behave
        // like a NOP.
        // --------------------------------------------------------------------

        reg_dst    = 1'b0;
        alu_src    = 1'b0;

        mem_to_reg = 1'b0;
        reg_write  = 1'b0;

        mem_read   = 1'b0;
        mem_write  = 1'b0;

        branch     = 1'b0;
        jump       = 1'b0;

        alu_op     = ALU_ADD;


        // ====================================================================
        // Decode opcode
        // ====================================================================

        case (opcode)

            // =================================================================
            // R-TYPE
            // =================================================================

            R_TYPE: begin

                reg_dst   = 1'b1;
                reg_write = 1'b1;

                case (funct)

                    FUNCT_ADD:
                        alu_op = ALU_ADD;

                    FUNCT_SUB:
                        alu_op = ALU_SUB;

                    FUNCT_AND:
                        alu_op = ALU_AND;

                    FUNCT_OR:
                        alu_op = ALU_OR;

                    FUNCT_XOR:
                        alu_op = ALU_XOR;

                    FUNCT_SLT:
                        alu_op = ALU_SLT;

                    FUNCT_SLL:
                        alu_op = ALU_SLL;

                    FUNCT_SRL:
                        alu_op = ALU_SRL;

                    FUNCT_SRA:
                        alu_op = ALU_SRA;

                    FUNCT_NOR:
                        alu_op = ALU_NOR;

                    default: begin
                        reg_write = 1'b0;
                        alu_op = ALU_ADD;
                    end

                endcase

            end


            // =================================================================
            // LOAD WORD
            // =================================================================

            LW: begin

                alu_src    = 1'b1;

                mem_to_reg = 1'b1;

                reg_write  = 1'b1;

                mem_read   = 1'b1;

                alu_op     = ALU_ADD;

            end


            // =================================================================
            // STORE WORD
            // =================================================================

            SW: begin

                alu_src   = 1'b1;

                mem_write = 1'b1;

                alu_op    = ALU_ADD;

            end


            // =================================================================
            // BRANCH EQUAL
            // =================================================================

            BEQ: begin

                branch = 1'b1;

                alu_op = ALU_SUB;

            end


            // =================================================================
            // ADD IMMEDIATE
            // =================================================================

            ADDI: begin

                alu_src   = 1'b1;

                reg_write = 1'b1;

                alu_op    = ALU_ADD;

            end


            // =================================================================
            // AND IMMEDIATE
            // =================================================================

            ANDI: begin

                alu_src   = 1'b1;

                reg_write = 1'b1;

                alu_op    = ALU_AND;

            end


            // =================================================================
            // OR IMMEDIATE
            // =================================================================

            ORI: begin

                alu_src   = 1'b1;

                reg_write = 1'b1;

                alu_op    = ALU_OR;

            end


            // =================================================================
            // SET LESS THAN IMMEDIATE
            // =================================================================

            SLTI: begin

                alu_src   = 1'b1;

                reg_write = 1'b1;

                alu_op    = ALU_SLT;

            end


            // =================================================================
            // JUMP
            // =================================================================

            J: begin

                jump = 1'b1;

            end


            // =================================================================
            // Unsupported instruction
            // =================================================================

            default: begin

                reg_dst    = 1'b0;
                alu_src    = 1'b0;

                mem_to_reg = 1'b0;
                reg_write  = 1'b0;

                mem_read   = 1'b0;
                mem_write  = 1'b0;

                branch     = 1'b0;
                jump       = 1'b0;

                alu_op     = ALU_ADD;

            end

        endcase

    end

endmodule