`timescale 1ns / 1ps

// ============================================================================
// Testbench
// Five-Stage RISC Pipeline Processor
// ============================================================================

module tb_risc_pipeline_processor;

    reg clk;
    reg reset;


    // ========================================================================
    // DUT
    // ========================================================================

    risc_pipeline_processor uut (

        .clk(clk),
        .reset(reset)

    );


    // ========================================================================
    // Clock
    // ========================================================================

    initial begin

        clk = 1'b0;

        forever #5 clk = ~clk;

    end


    // ========================================================================
    // VCD waveform
    // ========================================================================

    initial begin

        $dumpfile("risc_processor.vcd");

        $dumpvars(0, tb_risc_pipeline_processor);

    end


    // ========================================================================
    // Main test
    // ========================================================================

    initial begin

        reset = 1'b1;


        $display("");
        $display("====================================================");
        $display("       RISC PIPELINE PROCESSOR TEST");
        $display("====================================================");


        // Hold reset for 2 clock cycles

        #20;

        reset = 1'b0;


        // Run long enough for the complete program

        #400;


        // ================================================================
        // Display results
        // ================================================================

        $display("");
        $display("====================================================");
        $display("             FINAL REGISTER VALUES");
        $display("====================================================");

        display_registers();


        $display("");
        $display("MEM[0] = %0d", uut.dmem.mem[0]);


        // ================================================================
        // Automatic checks
        // ================================================================

        $display("");
        $display("====================================================");
        $display("                 CHECKING RESULTS");
        $display("====================================================");


        check_register(1, 5);
        check_register(2, 10);
        check_register(3, 15);
        check_register(4, 20);
        check_register(5, 20);
        check_register(6, 25);
        check_register(7, 30);


        // Branch wrong-path instructions

        check_register(8, 0);
        check_register(9, 0);


        // Branch target

        check_register(10, 42);


        // Jump wrong-path instruction

        check_register(11, 0);


        // Jump target

        check_register(12, 99);


        // Store

        if (uut.dmem.mem[0] === 32'd20) begin

            $display("PASS: MEM[0] = 20");

        end

        else begin

            $display("FAIL: MEM[0] expected 20, got %0d",
                     uut.dmem.mem[0]);

        end


        $display("");
        $display("====================================================");
        $display("              PIPELINE TEST COMPLETE");
        $display("====================================================");


        #20;

        $finish;

    end


    // ========================================================================
    // Display registers
    // ========================================================================

    task display_registers;

        integer i;

        begin

            for (i = 0; i < 32; i = i + 1) begin

                if (uut.reg_file.registers[i] != 32'd0) begin

                    $display(
                        "R%02d = %0d (0x%08h)",
                        i,
                        uut.reg_file.registers[i],
                        uut.reg_file.registers[i]
                    );

                end

            end

        end

    endtask


    // ========================================================================
    // Register checker
    // ========================================================================

    task check_register;

        input integer reg_num;
        input integer expected;

        begin

            if (uut.reg_file.registers[reg_num] === expected) begin

                $display(
                    "PASS: R%0d = %0d",
                    reg_num,
                    expected
                );

            end

            else begin

                $display(
                    "FAIL: R%0d expected %0d, got %0d",
                    reg_num,
                    expected,
                    uut.reg_file.registers[reg_num]
                );

            end

        end

    endtask


    // ========================================================================
    // Pipeline monitor
    // ========================================================================

    integer cycle;

    always @(posedge clk) begin

        if (!reset) begin

            cycle = $time / 10;

            $display("");
            $display("--------------- Cycle %0d ---------------", cycle);

            $display(
                "PC  = %h | IF Inst = %h",
                uut.pc,
                uut.instruction_if
            );

            $display(
                "ID  = %h",
                uut.instruction_id
            );

            $display(
                "EX  ALU = %h | Zero = %b",
                uut.alu_result_ex,
                uut.zero_flag_ex
            );

            $display(
                "MEM ALU = %h | Read=%b Write=%b",
                uut.alu_result_mem,
                uut.mem_read_mem,
                uut.mem_write_mem
            );

            $display(
                "WB  R%0d = %h | Write=%b",
                uut.write_reg_wb,
                uut.write_data_wb,
                uut.reg_write_wb
            );


            if (uut.stall) begin

                $display(
                    "*** LOAD-USE HAZARD: PIPELINE STALL ***"
                );

            end


            if (uut.forward_a != 2'b00) begin

                $display(
                    "*** FORWARD A = %b ***",
                    uut.forward_a
                );

            end


            if (uut.forward_b != 2'b00) begin

                $display(
                    "*** FORWARD B = %b ***",
                    uut.forward_b
                );

            end


            if (uut.branch_taken) begin

                $display(
                    "*** BRANCH TAKEN - FLUSHING PIPELINE ***"
                );

            end


            if (uut.jump_taken) begin

                $display(
                    "*** JUMP TAKEN - FLUSHING PIPELINE ***"
                );

            end

        end

    end


    // ========================================================================
    // Timeout watchdog
    // ========================================================================

    initial begin

        #1000;

        $display("");
        $display("ERROR: Simulation timeout!");

        $finish;

    end

endmodule