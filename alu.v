//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: Isaac Lee      
// Email: ilee002@ucr.edu
// 
// Assignment name: Lab02ALU
// Lab section: 21
// TA: Sakshar Chakravarty
// 
// I hereby certify that I have not received assistance on this assignment,
// or used code, from ANY outside source other than the instruction team
// (apart from what was provided in the starter file).
//
//=========================================================================

`timescale 1ns / 1ps

// --------------------------------------
// MIPS ALU Control & Funct constants
// --------------------------------------

`define ALU_AND         4'b0000
`define ALU_OR          4'b0001
`define ALU_ADD         4'b0010
`define ALU_SUBTRACT    4'b0110
`define ALU_LESS_THAN   4'b0111
`define ALU_NOR         4'b1100
  
`define FUNCT_AND       6'b100100
`define FUNCT_OR        6'b100101
`define FUNCT_ADD       6'b100000
`define FUNCT_SUBTRACT 	6'b100010
`define FUNCT_LESS_THAN 6'b101010
`define FUNCT_NOR 		6'b100111


`define WORD_SIZE 32 

module alu (
    input  [3:0] alu_control,  // ALU control from alu_control.v
    input  [31:0] A,           // Operand A
    input  [31:0] B,           // Operand B
    output reg [31:0] result,  // Result
    output reg        zero     // Zero flag
);

// ---------------------------------------------------------
// Implementation of MIPS ALU 
// --------------------------------------------------------- 


    always @(*) begin
        case (alu_control)
            4'b0000: result = A & B;                   // AND
            4'b0001: result = A | B;                   // OR
            4'b0010: result = A + B;                   // ADD
            4'b0110: result = A - B;                   // SUB
            4'b0111: result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0; //signed SLT
            4'b1100: result = ~(A | B);                // NOR
            default: result = 32'b0;                   // shouldn't happen
        endcase
        zero = (result == 32'b0);
    end

endmodule
