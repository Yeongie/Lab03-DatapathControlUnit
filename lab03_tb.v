//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: Isaac Lee  
// Email: ilee002@ucr.edu
// 
// Assignment name: Lab03-DatapathControlUnit
// Lab section: 21
// TA: Sakshar Chakravarty
// 
// I hereby certify that I have not received assistance on this assignment,
// or used code, from ANY outside source other than the instruction team
// (apart from what was provided in the starter file).
//
//=========================================================================

`timescale 1ns / 1ps

module datapath_tb;
    // Inputs
    reg clk; 
    reg [31:0] instruction;
    reg [31:0] A;
    reg [31:0] B;

    wire reg_dst;
    wire branch;
    wire mem_read;
    wire mem_to_reg;
    wire [1:0] alu_op;
    wire mem_write;
    wire alu_src;
    wire reg_write;

    wire zero;
    wire [31:0] result;
    wire [3:0] alu_ctrl;

    // -------------------------------------------------------
    // Setup output file for possible debugging uses
    // -------------------------------------------------------
    initial
    begin
        $dumpfile("lab03.vcd");
        $dumpvars(0);
    end
    
    // ---------------------------------------------------
    // Instantiate the Units Under Test (UUT)
    // --------------------------------------------------- 
    
    control control_uut (
        .instr_op(instruction[31:26]),
        .reg_dst(reg_dst),
        .branch(branch),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write)
    );

    alu_control alu_control_uut (
        .alu_op(alu_op),
        .funct(instruction[5:0]),
        .alu_control(alu_ctrl)
    );

    alu alu_uut (
        .alu_control(alu_ctrl),
        .A(A),
        .B(B),
        .zero(zero),
        .result(result)
    );

    initial begin 
        clk = 0; #50
        clk = 1; #50
        clk = 0; #50
        clk = 1; #50
        
        forever begin 
            clk = ~clk; #50; 
        end 
    end

    task test_case(
        input [31:0] instruction_val,
        input [31:0] A_val,
        input [31:0] B_val,
        input        zero_val,
        input [31:0] result_val,
        input        reg_dst_val,
        input        branch_val,
        input        mem_read_val,
        input        mem_to_reg_val,
        input [1:0]  alu_op_val,
        input        mem_write_val,
        input        alu_src_val,
        input        reg_write_val);
        begin
            totalTests = totalTests + 1;
            instruction = instruction_val;
            A = A_val;
            B = B_val;

            #100; // Wait 
            if (result_val     !== result       || 
                zero_val       !== zero         || 
                reg_dst_val    !== reg_dst      || 
                branch_val     !== branch       || 
                mem_read_val   !== mem_read     || 
                mem_to_reg_val !== mem_to_reg   || 
                alu_op_val     !== alu_op       || 
                mem_write_val  !== mem_write    || 
                alu_src_val    !== alu_src      || 
                reg_write_val  !== reg_write) 
            begin
                $write("\nfailed - expected: zero = %b, result = %h, reg_dst = %b, branch = %b, mem_read = %b, mem_to_reg = %b, alu_op = %b, mem_write = %b, alu_src = %b, reg_write = %b", 
                       zero_val, result_val, reg_dst_val, branch_val, mem_read_val, mem_to_reg_val, alu_op_val, mem_write_val, alu_src_val, reg_write_val);
                $write("\n       - actual  : zero = %b, result = %h, reg_dst = %b, branch = %b, mem_read = %b, mem_to_reg = %b, alu_op = %b, mem_write = %b, alu_src = %b, reg_write = %b\n", 
                       zero, result, reg_dst, branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write);
                failedTests = failedTests + 1;
            end else begin
                $write("passed\n");
            end
            #10; // Wait 
        end
    endtask


    integer failedTests = 0;
    integer totalTests = 0;
    initial begin
        // Reset
        @(posedge clk); // Wait for first clock out of reset 
        #10; // Wait 

        // -------------------------------------------------------
        // Control-unit tests
        // -------------------------------------------------------

        // R-type AND
        test_case(32'h00000024, 32'hFFFFFFFF, 32'h00000001,
                  1'b0, 32'h00000001, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0, 1'b0, 1'b1);

        // R-type AND zero
        test_case(32'h00000025, 32'hFFFFFFFF, 32'h00000001,
                  1'b0, 32'hFFFFFFFF, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0, 1'b0, 1'b1);

        // R-type ADD
        test_case(32'h00000020, 32'hFFFFFFFF, 32'h00000001,
                  1'b1, 32'h00000000, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0, 1'b0, 1'b1);

        // R-type SUB
        test_case(32'h00000022, 32'hFFFFFFFF, 32'h00000001,
                  1'b0, 32'hFFFFFFFE, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0, 1'b0, 1'b1);

        // R-type SLT (equal)
        test_case(32'h0000002A, 32'hFFFFFFFF, 32'h00000001,
                  1'b0, 32'h00000001, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0, 1'b0, 1'b1);

        // R-type NOR
        test_case(32'h00000027, 32'h0000FFFF, 32'hFFFF0000,
                  1'b1, 32'h00000000, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0, 1'b0, 1'b1);

        // addi
        test_case(32'h20000004, 32'hFFFFFFFB, 32'h00000004,
                  1'b0, 32'hFFFFFFFF, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00, 1'b0, 1'b1, 1'b1);

        // lw
        test_case(32'h8C000020, 32'h000000FF, 32'h00000020,
                  1'b0, 32'h0000011F, 1'b0, 1'b0, 1'b1, 1'b1, 2'b00, 1'b0, 1'b1, 1'b1);

        // sw
        test_case(32'hAC000064, 32'h000000FF, 32'h00000064,
                  1'b0, 32'h00000163, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00, 1'b1, 1'b1, 1'b0);

        // beq
        test_case(32'h10000025, 32'h000000FF, 32'h00000025,
                  1'b0, 32'h000000DA, 1'b0, 1'b1, 1'b0, 1'b0, 2'b01, 1'b0, 1'b0, 1'b0);

        // -------------------------------------------------------
        // Test group 2: ALU Control Unit
        // -------------------------------------------------------
        $write("\tTest Case 1: R-type (add) ...");
        test_case(32'h00000024, 32'hFFFFFFFF, 32'h0001, 1'b0, 32'h0001, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0, 1'b0, 1'b1);

        // -------------------------------------------------------
        // More ALU Control Unit tests jere
        // -------------------------------------------------------
 // R-type OR  (funct=0x25)
        test_case(32'h00000025, 32'h00000011, 32'h0000FF00,
                  1'b0, 32'h0000FF11, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0, 1'b0, 1'b1);

        // R-type ADD (funct=0x20)
        test_case(32'h00000020, 32'h00000001, 32'h00000002,
                  1'b0, 32'h00000003, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0, 1'b0, 1'b1);

        // R-type SUB (funct=0x22)
        test_case(32'h00000022, 32'h00000005, 32'h00000003,
                  1'b0, 32'h00000002, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0, 1'b0, 1'b1);

        // R-type SLT (funct=0x2A)
        test_case(32'h0000002A, 32'h00000002, 32'h00000005,
                  1'b0, 32'h00000001, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0, 1'b0, 1'b1);

        // R-type NOR (funct=0x27)
        test_case(32'h00000027, 32'hAAAA5555, 32'h12345678,
                  1'b0, ~(32'hAAAA5555 | 32'h12345678), 1'b1, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0, 1'b0, 1'b1);

        // --------------------------------------------------------------
        // End testing
        // --------------------------------------------------------------
        $write("\n--------------------------------------------------------------");
        $write("\nTesting complete\nPassed %0d / %0d tests",totalTests-failedTests,totalTests);
        $write("\n--------------------------------------------------------------\n");
        $finish();
    end
endmodule

