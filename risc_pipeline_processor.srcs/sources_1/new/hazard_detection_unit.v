`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2026 11:14:48
// Design Name: 
// Module Name: hazard_detection_unit
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
// Hazard Detection Unit
// Detects load-use data hazards and initiates pipeline stalls
// ============================================================================

module hazard_detection_unit (
    input [4:0] id_ex_rt,           // Destination register in EX stage
    input id_ex_mem_read,           // Memory read signal in EX stage
    input [4:0] if_id_rs,           // Source register 1 in ID stage
    input [4:0] if_id_rt,           // Source register 2 in ID stage
    output reg stall                // Stall signal
);

    always @(*) begin
        // Detect load-use hazard
        // If instruction in EX is a load and its destination is a source for ID instruction
        if (id_ex_mem_read && 
            ((id_ex_rt == if_id_rs) || (id_ex_rt == if_id_rt))) begin
            stall = 1'b1;
        end else begin
            stall = 1'b0;
        end
    end

endmodule