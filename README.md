# Lab 2 - The Datapath Control and ALU Control Units 

## Introduction

For this lab you will be building the control units for a MIPS processor. See the next figure.

![FIGURE 4.17  The simple datapath with the control unit.](./assets/fig-4.17.png)

There are two control units. The _main control unit_ manages the datapath. It receives an opcode
input from the currently executing instructions and based on this opcode it configures the
datapath accordingly. A truth table for the unit functionality (shown below) can be found in the
slides of CS161. The table (read vertically) shows the output for `R-format`, `lw`, `sw` and
`beq` instructions, additionally, you will need to implement the immediate type `addi`
instruction. To do this, you will trace through the datapath (shown above) to determine which
control lines will need to be set.

<table style="border-collapse: collapse; width: 98%; height: 496px;" border="1">
    <tbody>
        <tr style="height: 31px; background-color: #c2e0f4;">
            <td style="width: 14.2764%; height: 31px; text-align: center;"><strong>Control</strong></td>
            <td style="width: 14.2764%; height: 31px; text-align: center;"><strong>Signal name</strong></td>
            <td style="width: 14.2749%; height: 31px; text-align: center;"><strong>R-format</strong></td>
            <td style="width: 14.2764%; height: 31px; text-align: center;"><strong>lw</strong></td>
            <td style="width: 14.2749%; height: 31px; text-align: center;"><strong>sw</strong></td>
            <td style="width: 14.2764%; height: 31px; text-align: center;"><strong>beq</strong></td>
            <td style="width: 14.2749%; height: 31px; text-align: center;"><strong>addi</strong></td>
        </tr>
        <tr style="height: 31px;">
            <td style="width: 14.2764%; height: 186px; text-align: center;" rowspan="6"><strong>Inputs</strong></td>
            <td style="width: 14.2764%; height: 31px; text-align: right;">Op5</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">1</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">1</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">0</td>
        </tr>
        <tr style="height: 31px;">
            <td style="width: 14.2764%; height: 31px; text-align: right;">Op4</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">0</td>
        </tr>
        <tr style="height: 31px;">
            <td style="width: 14.2764%; height: 31px; text-align: right;">Op3</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">1</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">1</td>
        </tr>
        <tr style="height: 31px;">
            <td style="width: 14.2764%; height: 31px; text-align: right;">Op2</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">1</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">0</td>
        </tr>
        <tr style="height: 31px;">
            <td style="width: 14.2764%; height: 31px; text-align: right;">Op1</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">1</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">1</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">0</td>
        </tr>
        <tr style="height: 31px;">
            <td style="width: 14.2764%; height: 31px; text-align: right;">Op0</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">1</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">1</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">0</td>
        </tr>
        <tr style="height: 31px;">
            <td style="width: 14.2764%; height: 279px; text-align: center;" rowspan="9"><strong>Outputs</strong></td>
            <td style="width: 14.2764%; height: 31px; text-align: right;">RegDst</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">1</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">X</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">X</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">?</td>
        </tr>
        <tr style="height: 31px;">
            <td style="width: 14.2764%; height: 31px; text-align: right;">ALUSrc</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">1</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">1</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">?</td>
        </tr>
        <tr style="height: 31px;">
            <td style="width: 14.2764%; height: 31px; text-align: right;">MemtoReg</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">1</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">X</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">X</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">?</td>
        </tr>
        <tr style="height: 31px;">
            <td style="width: 14.2764%; height: 31px; text-align: right;">RegWrite</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">1</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">1</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">?</td>
        </tr>
        <tr style="height: 31px;">
            <td style="width: 14.2764%; height: 31px; text-align: right;">MemRead</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">1</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">?</td>
        </tr>
        <tr style="height: 31px;">
            <td style="width: 14.2764%; height: 31px; text-align: right;">MemWrite</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">1</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">?</td>
        </tr>
        <tr style="height: 31px;">
            <td style="width: 14.2764%; height: 31px; text-align: right;">Branch</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">1</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">?</td>
        </tr>
        <tr style="height: 31px;">
            <td style="width: 14.2764%; height: 31px; text-align: right;">ALUOp1</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">1</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">?</td>
        </tr>
        <tr style="height: 31px;">
            <td style="width: 14.2764%; height: 31px; text-align: right;">AluOp0</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">0</td>
            <td style="width: 14.2764%; height: 31px; text-align: center;">1</td>
            <td style="width: 14.2749%; height: 31px; text-align: center;">?</td>
        </tr>
    </tbody>
</table>

**Table 1.** The control function for the simple one-clock implementation. Read each column
vertically. I.e. if the `Op[5:0]` is `000000`, the `RegDst` would be ‘`1`’, `ALUSrc` would be ‘`0`’, etc.
You will need to fill in the `imm` column. Based on Figure D.2.4 from the book.

The second control unit manages the _ALU_. It receives an ALU opcode from the datapath
controller and the ‘`Funct Field`’ from the current instruction. With these, the ALU controller
decides what operation the ALU is to perform. The following figures from the CS161 slides give
an idea of the inputs and outputs of the ALU controller.

<table style="border-collapse: collapse; width: 98%;" border="1">
    <tbody>
        <tr>
            <td style="width: 66.6202%; text-align: center; background-color: #c2e0f4;" colspan="4"><strong>Input</strong></td>
            <td style="width: 33.3101%; text-align: center; background-color: #c2e0f4;" colspan="2"><strong>Output</strong></td>
        </tr>
        <tr>
            <td style="width: 16.6558%; text-align: center; background-color: #c2e0f4;"><strong>Instruction Code</strong></td>
            <td style="width: 16.6543%; text-align: center; background-color: #c2e0f4;"><strong>ALUOp</strong></td>
            <td style="width: 16.6558%; text-align: center; background-color: #c2e0f4;"><strong>Instruction operation</strong></td>
            <td style="width: 16.6543%; text-align: center; background-color: #c2e0f4;"><strong>Funct field</strong></td>
            <td style="width: 16.6558%; text-align: center; background-color: #c2e0f4;"><strong>Desired ALU action</strong></td>
            <td style="width: 16.6543%; text-align: center; background-color: #c2e0f4;"><strong>ALU select input</strong></td>
        </tr>
        <tr>
            <td style="width: 16.6558%; text-align: right;">addi</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">??</span></td>
            <td style="width: 16.6558%;">Add Immediate</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">XXXXXX</span></td>
            <td style="width: 16.6558%;">add</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">0010</span></td>
        </tr>
        <tr>
            <td style="width: 16.6558%; text-align: right;">lw</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">00</span></td>
            <td style="width: 16.6558%;">Load word</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">XXXXXX</span></td>
            <td style="width: 16.6558%;">add</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">0010</span></td>
        </tr>
        <tr>
            <td style="width: 16.6558%; text-align: right;">sw</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">00</span></td>
            <td style="width: 16.6558%;">Store word</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">XXXXXX</span></td>
            <td style="width: 16.6558%;">add</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">0010</span></td>
        </tr>
        <tr>
            <td style="width: 16.6558%; text-align: right;">beq</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">01</span></td>
            <td style="width: 16.6558%;">Branch equal</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">XXXXXX</span></td>
            <td style="width: 16.6558%;">subtract</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">0110</span></td>
        </tr>
        <tr>
            <td style="width: 16.6558%; text-align: right;">R-type</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">10</span></td>
            <td style="width: 16.6558%;">add</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">100000</span></td>
            <td style="width: 16.6558%;">add</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">0010</span></td>
        </tr>
        <tr>
            <td style="width: 16.6558%; text-align: right;">R-type</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">10</span></td>
            <td style="width: 16.6558%;">subtract</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">100010</span></td>
            <td style="width: 16.6558%;">subtract</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">0110</span></td>
        </tr>
        <tr>
            <td style="width: 16.6558%; text-align: right;">R-type</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">10</span></td>
            <td style="width: 16.6558%;">AND</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">100100</span></td>
            <td style="width: 16.6558%;">and</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">0000</span></td>
        </tr>
        <tr>
            <td style="width: 16.6558%; text-align: right;">R-type</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">10</span></td>
            <td style="width: 16.6558%;">OR</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">100101</span></td>
            <td style="width: 16.6558%;">or</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">0001</span></td>
        </tr>
        <tr>
            <td style="width: 16.6558%; text-align: right;">R-type</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">10</span></td>
            <td style="width: 16.6558%;">NOR</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">100111</span></td>
            <td style="width: 16.6558%;">nor</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">1100</span></td>
        </tr>
        <tr>
            <td style="width: 16.6558%; text-align: right;">R-type</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">10</span></td>
            <td style="width: 16.6558%;">Set on less than</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">101010</span></td>
            <td style="width: 16.6558%;">Set on less than</td>
            <td style="width: 16.6543%; text-align: center;"><span style="font-family: 'andale mono', times;">0111</span></td>
        </tr>
    </tbody>
</table>

<center><b>ALU select bits based on ALUop, and Funct field</b></center>

<p>&nbsp;</p>
<table style="border-collapse: collapse; width: 98%;" border="1">
    <tbody>
        <tr>
            <td style="width: 22.2078%; text-align: center; background-color: #c2e0f4;" colspan="2"><strong>ALUOp</strong></td>
            <td style="width: 66.6202%; text-align: center; background-color: #c2e0f4;" colspan="6"><strong>Funct field</strong></td>
            <td style="width: 11.1023%; background-color: #c2e0f4;" rowspan="2"><strong>Operation</strong></td>
        </tr>
        <tr>
            <td style="width: 11.1039%; background-color: #c2e0f4;"><strong>ALUOp1</strong></td>
            <td style="width: 11.1039%; background-color: #c2e0f4;"><strong>ALUOp2</strong></td>
            <td style="width: 11.1039%; background-color: #c2e0f4;"><strong>F5</strong></td>
            <td style="width: 11.1039%; background-color: #c2e0f4;"><strong>F4</strong></td>
            <td style="width: 11.1023%; background-color: #c2e0f4;"><strong>F3</strong></td>
            <td style="width: 11.1039%; background-color: #c2e0f4;"><strong>F2</strong></td>
            <td style="width: 11.1023%; background-color: #c2e0f4;"><strong>F1</strong></td>
            <td style="width: 11.1039%; background-color: #c2e0f4;"><strong>F0</strong></td>
        </tr>
        <tr>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">0</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">0</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1023%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1023%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1023%; text-align: center;"><span style="font-family: 'andale mono', times;">0010</span></td>
        </tr>
        <tr>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">1</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1023%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1023%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1023%; text-align: center;"><span style="font-family: 'andale mono', times;">0110</span></td>
        </tr>
        <tr>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">1</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1023%; text-align: center;"><span style="font-family: 'andale mono', times;">0</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">0</span></td>
            <td style="width: 11.1023%; text-align: center;"><span style="font-family: 'andale mono', times;">0</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">0</span></td>
            <td style="width: 11.1023%; text-align: center;"><span style="font-family: 'andale mono', times;">0010</span></td>
        </tr>
        <tr>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">1</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1023%; text-align: center;"><span style="font-family: 'andale mono', times;">0</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">0</span></td>
            <td style="width: 11.1023%; text-align: center;"><span style="font-family: 'andale mono', times;">1</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">0</span></td>
            <td style="width: 11.1023%; text-align: center;"><span style="font-family: 'andale mono', times;">0110</span></td>
        </tr>
        <tr>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">1</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1023%; text-align: center;"><span style="font-family: 'andale mono', times;">0</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">1</span></td>
            <td style="width: 11.1023%; text-align: center;"><span style="font-family: 'andale mono', times;">0</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">0</span></td>
            <td style="width: 11.1023%; text-align: center;"><span style="font-family: 'andale mono', times;">0000</span></td>
        </tr>
        <tr>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">1</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1023%; text-align: center;"><span style="font-family: 'andale mono', times;">0</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">1</span></td>
            <td style="width: 11.1023%; text-align: center;"><span style="font-family: 'andale mono', times;">0</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">1</span></td>
            <td style="width: 11.1023%; text-align: center;"><span style="font-family: 'andale mono', times;">0001</span></td>
        </tr>
        <tr>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">1</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1023%; text-align: center;"><span style="font-family: 'andale mono', times;">1</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">0</span></td>
            <td style="width: 11.1023%; text-align: center;"><span style="font-family: 'andale mono', times;">1</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">0</span></td>
            <td style="width: 11.1023%; text-align: center;"><span style="font-family: 'andale mono', times;">0111</span></td>
        </tr>
        <tr>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">1</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">X</span></td>
            <td style="width: 11.1023%; text-align: center;"><span style="font-family: 'andale mono', times;">0</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">1</span></td>
            <td style="width: 11.1023%; text-align: center;"><span style="font-family: 'andale mono', times;">1</span></td>
            <td style="width: 11.1039%; text-align: center;"><span style="font-family: 'andale mono', times;">1</span></td>
            <td style="width: 11.1023%; text-align: center;"><span style="font-family: 'andale mono', times;">1100</span></td>
        </tr>
    </tbody>
</table>
<center><b>Truth Table for ALU Control</b></center>

## Deliverables

For this lab, you are expected to build and test both the datapath using the template provided
([`control.v`](./control.v)) and ALU control ([`alu_control.v`](./alu_control.v), from Lab 02) 
units. The target processor architecture will only support a subset of the MIPS instructions, 
listed below. You only have to offer control for these instructions. Signal values can be 
found within your textbook (and in the images above).

- `add`, `addi`
- `sub`,
- `slt`
- `not`*, `nor`
- `or`
- `and`
- `lw`, `sw`
- `beq`


\* `not` is **not** an instruction, it is a _pseudo-op_, which means it can be implemented using other
operations. Think about how you would implement it using the other operations.

### Producing the Waveform

Once you've synthesized the code for the test-bench and the `alu_control` and `control` modules, you can run
the test-bench simulation script to make sure all the tests pass. This simluation run should
produce the code to make a waveform. Use techniques you learned in the first lab to produce a
waveform for this lab and save it as a PNG. 

You don't need to add a marker this time. Also, I've provided a .gtkw.

### The Lab Report

Finally, create a file called REPORT.md and use GitHub markdown to write your lab report. This lab
report will again be short, and comprised of two sections. The first section is a description of 
each test case. Use this section to discuss what changes you made in your tests from the prelab
until this final report. The second section should include your waveform. 

## Submission:

Each student **must** turn in their repository from GitHub to Gradescope. The contents of which should be:
- A REPORT.md file with your name and email address, and the content described above
- All Verilog file(s) used in this lab (implementation and test benches).

**If your file does not synthesize or simulate properly, you will receive a 0 on the lab.**
