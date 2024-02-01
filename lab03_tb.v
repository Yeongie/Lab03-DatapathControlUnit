//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: 
// Email: 
// 
// Assignment name: 
// Lab section: 
// TA: 
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
    reg [31:0] PC;
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
        .instr_op(PC[31:26]),
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
        .funct(PC[5:0]),
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
        input [31:0] PC_val,
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
        input        reg_write);
        begin
            totalTests = totalTests + 1;
            PC = PC_val;
            A = A_val;
            B = B_val;

            #100; // Wait 
            if (result_val !== result || zero_val !== zero) begin
                $write("failed\n");
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
        // More Control Unit tests jere
        // -------------------------------------------------------

        // -------------------------------------------------------
        // Test group 2: ALU Control Unit
        // -------------------------------------------------------
        $write("\tTest Case 1: R-type (add) ...");
        test_case(32'h00000024, 32'hFFFFFFFF, 32'h0001, 1'b0, 32'h0001, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0, 1'b0, 1'b1);

        // -------------------------------------------------------
        // More ALU Control Unit tests jere
        // -------------------------------------------------------

        // --------------------------------------------------------------
        // End testing
        // --------------------------------------------------------------
        $write("\n--------------------------------------------------------------");
        $write("\nTesting complete\nPassed %0d / %0d tests",totalTests-failedTests,totalTests);
        $write("\n--------------------------------------------------------------\n");
        $finish();
    end
endmodule

