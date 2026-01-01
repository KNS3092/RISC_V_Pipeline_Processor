# RISC_V_Pipeline_Processor
This repository contains a RTL implementation of a 5-Stage Pipelined RISC-V Processor and a  SystemVerilog Verification Environment.
The design supports the base RV32I integer instruction set (R-type and Memory types) and features RAW (Read After Write) hazard handling.

# Hardware Architecture (Design) The processor implements a classic RISC pipeline:
Instruction Fetch (IF): Program Counter logic and Instruction Memory interface.  
Instruction Decode (ID): 32-bit Register File, Control Unit for opcode decoding, and Sign Extension logic.  
Execute (EX): ALU for arithmetic/logic operations and branch calculation.  
Memory (MEM): Synchronous byte-addressable Data Memory interface.  
Write Back (WB): Result selection and register file update logic.  

# Verification Environment (Testbench) The verification suite is built using SystemVerilog OOP principles, following an architecture similar to UVM:
Generator: Uses Constrained Randomization to create diverse instruction mixes (ADD, SUB, AND, OR, LW, SW).  
Driver: Interfaces with the RTL via a virtual interface to inject machine code into Instruction Memory.  
Monitor: A cycle-accurate observer that captures instruction retirement at the Writeback stage.  
Scoreboard: Implements a reference ISA model to predict the expected state after every instruction.  
