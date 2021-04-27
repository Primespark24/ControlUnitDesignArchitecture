# CS401-1 Digital Design and Computer Architecture
## FP_3: Control Unit Design

# Introduction    
In this lab you will design the main *Control Unit* (CU) for your processor to tie your  verify that your control unit is interpreting your instructions correctly.  The control unit observes the **instruction opcode** and then outputs control signals that tell the each indvidual component of the Data Path Unit exactly what to do (and when to do it).  A CU implements the "Decode" and "Execute" phases of an instruction's life-cycle.  

# Single-cycle or Multi-cycle Machine?
Single-cycle machines have much simpler control units than do multi-cycle machines. A multi-cycle machine requires a finite state machine control unit, while in contrast, a single-cycle machine only requires a simple "decoder":

* In a *single-cycle machine*, the control unit is just a fancy *look-up ROM* that acts somewhat like a python dictionary or a C++ map.  The instruction op-code functions like the input "key" and the control unit then returns the "value" (i.e. the set of control signals, the control bus) that control each component in the DPU. The *control bus* consists of the set of wires that carry control signals to each component in the Data Path Unit (DPU). Each instruction's opcode will result in a specific set of control signals  that will cause the components in the DPU to behave in a manner appropriate to that instruction.

* In a *multi-cycle machine*, the control unit is built using a *finite state machine*.  In this case, each instruction op-code is the input to the machine which triggers a series of control signal states. All of the instruction share the "fetch" phase of the FSM, but, after decoding, each individual instruction will step through a specific set of states required for the execute phase of the instruction. Each individual state will then result in a specific set of control signals  that will cause the components in the DPU to behave in a manner appropriate to that *specific state*.


# 25 pts. Exercise 1: Control Unit Design
The controller is the portion of the CU that looks at the opcode and determines the output signals. i.e. it is a map that links instructions and activates the appropriate control signals.  Have your Assembly Language, ALU, and DPU designs easily accessible while you work on this design. 

#### SINGLE CYCLE CU DESIGN:  
Complete this section if you are doing a single cycle processor. Create the following table with one row for each of your instructions. You can see Table 7.3 on page 384 for an example of what this should look like for your processor.  Basically this is just a simply a list of opcodes followed by all the signals activated for those opcodes. Use as many columns as neccessary.

    *********************************************************************

    | Instruction     |                |                |                |                |
    |:---------------:|:---------------::---------------::---------------::---------------:
    |                 |                |                |                |                |
    |                 |                |                |                |                |

    Fig 1 Single Cycle CU Main Decoder Truth Table
    *********************************************************************

#### MULTI CYCLE CU DESIGN: 
Complete this section if you are making a multi-cycle CPU. Modify or make your own FSM design language similar to the FSM pseudo-code is shown below in Fig 1 Multi-Cycle. 

*********************************************************************

```
    FETCH:   
            IM_READ <= '1'                            # Read from instruction memory
            WAIT:  WHILE IM_READY != '1' GOTO WAIT:   # wait for memory ready signal
            INSTRUCTION_REG <= MEMORY_OUT_BUF         # Load instruction register
            GOTO DECODE:

    DECODE: 
            OPCODE <= INSTRUCTION_REG( ?? downto ?? ) # Get Opcode from INSTRUCTION_REG register
            NEXT_STATE <= CU[ OPCODE ]                # Lookup NEXT_STATE in the Control Unit
            GOTO NEXT_STATE:                          # Next State for each instruction

#  THE NEXT STATE FOR EACH INSTRUCTION

    LW :
            Do all the states for LW for your processor
            GOTO FETCH:
    
    SW :    
            Do all the states for SW for your processor
            GOTO FETCH:

    ADD:    
            Set signals for the ALU to ADD
            Take output from ALU and put it where it belongs
            GOTO FETCH:
```
Fig 1 Multi-cycle FSM Decode
*********************************************************************

## 25 pts. Exercise 2: Integrated VHDL for the Control Unit and the Data Path Unit

Using the design tools from Exercise 1, design the VHDL for the Control Unit and itegrate it's control signals into your DPU. 

### SINGLE CYCLE CONTROL UNIT DESIGN:  
For an example, look at the MIPS single cycle control unit. The VHDL is on pages 431, 432 of the textbook. However there are small differences so you will also want to look at your MIPS3 processor’s control unit code.

### MULTI-CYCLE CONTROL UNIT DESIGN:  
For this, you will want to refresh your memory on how to write code for a Finite State Machine. See pages 212 and 213 in your textbook.  The main idea here is that you can design a control unit Finite State Machine using the concept of "microcode".  Microcode is like a mini-assembly/finite state machine language that you can lay out like shown below. It's basically a textual description of the FSM bubbles like those shown on pages 212, 213 of your textbook.

## 25 pts. Exercise 3:  VHDL Testbench With Simple Adhoc Program Running Correctly
Design a very simple ad-hoc test program for your processor. This should use every instruction you intend for it to execute.  Remember, you will need to put the hex code into a data file that can be read by your VHDL code. 

* Make sure it is working in simulation before attempting to run in the FPGA
* IMPORTANT: Every time you change your hexcode file contents, you will need to run the gen.sh script in order to incorporate the hex file for the instructions into the memory of the machine.
* Verify that each instruction is working as intended. 

## 25 pts. Exercise 4: Mini Presentation FP_3
1. Show the class your control unit design. If you have a multi-cycle, you must show your bubble diagram state machine diagram. For a single-cycle machine you must show your decoder tables.
2. Demo your ad-hoc program running (either in simulation or on the FPGA)
3. What hardware bugs did you encounter in testing? How did you find them? How did you squash them?
4. Did you go above and beyond the assignment requirements in any way?


## What to Hand In
This document with the following items included. 
* VHDL code for your completed design the FP3 subfolder of your group's whitgit repository
* List of instructions and op-codes.
* SINGLE-CYCLE: Neatly drawn decoder tables.
* MULTI-CYCLE: Neatly drawn FSM bubble diagram and/or microcode table/spreadsheet for the multi-cycle design. 
* jpg/png files that demonstrate your microprocessor is running the ad-hoc program correctly.

### Summary of Observations
In this section, include your summary of the groups observations.  

| CATEGORY |  Beginning 0%-79% | Satisfactory 80%-89% | Excellent 90%-100% |
|:--------:|:-----------:|:------------:|:----------:|
| 25 pts. Control Unit Design | Rudimentary decoder tables. | Basic decoder tables and/or basic finite state machine bubble diagram for the control unit. | Neat, well commented, complete set of decoder tables (single cycle)  or neat, well commented complete finite state machine bubble diagram and tables  (multi-cycle). |
| 25 pts. Control Unit VHDL | VHDL code for the control unit. Few to no comments. | Some instructions working, satisfactory VHDL code for the control unit. Satisfactory comments. | Working VHDL code for all the instructions in the control unit. Excellent comments, code formatted neatly, etc. |
| 25 pts. Control Unit Test  | Simulation test bench created but not documented well or does not work properly |	Ad-hoc test code that tests every possible instruction and runs correctly in simulation. |	Ad-hoc program that runs correctly in simulation and also on the FPGA. |
| 25 pts. Mini Presentation | Little to no content, poor presentation. | Several of the required elements for Exercise 4 | All the required elements of Exercise 4 and a good presentation.

***
Machine Code Instruction Format: 64 bits: 

x means that the value depends on the runtime

0: F/I-Type: |2 Bit instruction type| 5 bits op | 13 Extra | 6 RS |6 RD | 32 Immediate/Float|

| Instruction| Instruction_Type | Opcode | Extra | RS  | RD | Immediate|
|:----:| :----:|:----:|:----:|:----:|:----:|:----:|
| Addfi      |    00            | 00000  |  13   |  x  | x  |   x      |

1: R-Type:   |2 Bit instruction type| 5 bits op| 39 bit extra| 6 RT | 6 RD | 6 RS |

| Instruction| Instruction_Type | Opcode | Extra | RT | RD | RS |
|:---:| :---:|:---:|:---:|:---:|:---:|:---:|
| Sub        |    01            | 00010  |  39   | x  | x  | x  |
| Add        |    01            | 00001  |  39   | x  | x  | x  |
| Mul        |    01            | 00011  |  39   | x  | x  | x  |
| Div        |    01            | 00100  |  39   | x  | x  | x  |
| Mod        |    01            | 00101  |  39   | x  | x  | x  |
| And        |    01            | 00110  |  39   | x  | x  | x  |
| Or         |    01            | 00111  |  39   | x  | x  | x  |

2: J-Type:   |2 Bit instruction type| 5 bits op| 6 RD | 32 Immediate/Float |Offset from current line 19 bits|
| Instruction| Instruction_Type | Opcode | RD    | Immediate | Jump Offset |
|:---:| :---:|:---:|:---:|:---:     |:---:   |
| beq        |   10              |  01010 |  x    |   x       |  calculate  |
| bne        |   10              |  01011 |  x    |   x       |  calculate  |
| jump       |   10             |  01100 |  x    |   x       |  calculate  |
| blt        |   10             |  01110 |  x    |   x       |  calculate  |
| bgt        |   10             |  01111 |  x    |   x       |  calculate  |

3:  M-Type:   |2 Bit instruction type| 5 bits op| 45 bits Extra | 6 RD | 6 mem_loc |

| Instruction | Instruction Type| Opcode | Extra | RD | Memory Location |
| :---: | :---: | :---: | :---: | :---:| :---: |
| lw         |    11                | 01000    |  45           | x    | x  |  x |
| sw         |    11                | 01001    |  45           | x    | x   | x |

Lw and sw are only to be called in the assembly program when using a defined variable. It is not defined to be able to load from one register to another, or store from one register to another. For that purpose, use add. 
***