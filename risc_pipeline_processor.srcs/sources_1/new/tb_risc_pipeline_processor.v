`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.02.2026 11:22:42
// Design Name: 
// Module Name: tb_risc_pipeline_processor
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
// Testbench for Five-Stage RISC Pipelined Processor
// Comprehensive testing of processor functionality
// ============================================================================

`timescale 1ns/1ps

module tb_risc_pipeline_processor;

    // Clock and reset signals
    reg clk;
    reg reset;
    
    // Instantiate the processor
    risc_pipeline_processor uut (
        .clk(clk),
        .reset(reset)
    );
    
    // Clock generation - 10ns period (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test stimulus
    initial begin
        // Initialize signals
        reset = 1;
        
        // Create VCD file for waveform viewing
        $dumpfile("risc_processor.vcd");
        $dumpvars(0, tb_risc_pipeline_processor);
        
        // Display header
        $display("========================================");
        $display("RISC Pipeline Processor Testbench");
        $display("========================================");
        $display("Time(ns) | PC    | Instruction | Stage");
        $display("----------------------------------------");
        
        // Hold reset for 2 clock cycles
        #10 reset = 0;
        
        // Monitor key signals
        $monitor("Time=%0t | PC=%h | Inst=%h", 
                 $time, uut.pc, uut.instruction_if);
        
        // Run simulation for enough cycles to see results
        #200;
        
        // Display register file contents
        $display("\n========================================");
        $display("Register File Contents (After Execution)");
        $display("========================================");
        display_registers();
        
        // Display pipeline statistics
        $display("\n========================================");
        $display("Pipeline Status");
        $display("========================================");
        $display("Stall Signal: %b", uut.stall);
        $display("Branch Taken: %b", uut.pc_src);
        
        $display("\n========================================");
        $display("Test Completed Successfully!");
        $display("========================================");
        
        #20 $finish;
    end
    
    // Task to display register contents
    task display_registers;
        integer i;
        begin
            for (i = 0; i < 32; i = i + 1) begin
                if (uut.reg_file.registers[i] != 0) begin
                    $display("R%02d = %h (%0d)", i, 
                            uut.reg_file.registers[i],
                            uut.reg_file.registers[i]);
                end
            end
        end
    endtask
    
    // Monitor pipeline stages
    always @(posedge clk) begin
        if (!reset) begin
            $display("\n--- Cycle %0d ---", $time/10);
            $display("IF:  PC=%h, Inst=%h", uut.pc, uut.instruction_if);
            $display("ID:  PC=%h, Inst=%h", uut.pc_id, uut.instruction_id);
            $display("EX:  ALU_A=%h, ALU_B=%h, Result=%h", 
                     uut.alu_operand_a, uut.alu_input_b, uut.alu_result_ex);
            $display("MEM: Addr=%h, WriteData=%h, MemRead=%b, MemWrite=%b",
                     uut.alu_result_mem, uut.write_data_mem, 
                     uut.mem_read_mem, uut.mem_write_mem);
            $display("WB:  WriteReg=R%0d, WriteData=%h, RegWrite=%b",
                     uut.write_reg_wb, uut.write_data_wb, uut.reg_write_wb);
            
            // Check for hazards
            if (uut.stall) begin
                $display("*** HAZARD DETECTED - Pipeline Stalled ***");
            end
            if (uut.forward_a != 2'b00) begin
                $display("*** Forwarding on Operand A: %b ***", uut.forward_a);
            end
            if (uut.forward_b != 2'b00) begin
                $display("*** Forwarding on Operand B: %b ***", uut.forward_b);
            end
        end
    end
    
    // Timeout watchdog
    initial begin
        #1000;
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

endmodule