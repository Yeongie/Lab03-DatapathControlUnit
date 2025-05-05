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

# Lab 3 Report

**Name:** Isaac Lee
**Email:** ilee002@.cur.edu

## 1. Tested Instructions

Below is the list of each instruction exercised by our test bench (`lab03_tb.v`):

- **R-type AND** (`funct = 0x24`)
- **R-type OR** (`funct = 0x25`)
- **R-type ADD** (`funct = 0x20`)
- **R-type SUB** (`funct = 0x22`)
- **R-type SLT** (`funct = 0x2A`)
- **R-type NOR** (`funct = 0x27`)
- **ADDI** (opcode `0x08`)
- **LW** (opcode `0x23`)
- **SW** (opcode `0x2B`)
- **BEQ** (opcode `0x04`) :contentReference[oaicite:0]{index=0}:contentReference[oaicite:1]{index=1}

## 2. Difference between **ADD** and **ADDI** control signals

Most control signals for the **ADD** (R-type) and **ADDI** (I-type) instructions are the same—both write back to a register (`RegWrite = 1`), do not access data memory (`MemRead = MemWrite = 0`), and are not branches (`Branch = 0`). However:

- **RegDst**  
  - **ADD** uses `RegDst = 1` to select the **rd** field as the destination.  
  - **ADDI** uses `RegDst = 0` to select the **rt** field (since the immediate form writes to rt).

- **ALUSrc**  
  - **ADD** uses `ALUSrc = 0` to take its second operand from the register file.  
  - **ADDI** uses `ALUSrc = 1` to take its second operand from the sign-extended immediate value.

- **ALUOp**  
  - **ADD** asserts `ALUOp = 2'b10` to indicate an R-type function code should drive the ALU.  
  - **ADDI** asserts `ALUOp = 2'b00` to force the ALU into “add immediate” mode directly.

R-type operations route both operands through the register file and use the function field to choose the ALU operation, whereas I-type immediates bypass the second register read and hard-wire the ALU to perform addition. 
