\# Five-Stage RISC Pipelined Processor



A 32-bit, five-stage RISC pipelined processor implemented in Verilog HDL and verified using AMD Vivado behavioral simulation.



The processor implements the classic five-stage pipeline:



IF → ID → EX → MEM → WB



The project demonstrates RTL design, pipelining, data forwarding, hazard detection, pipeline stalls, branch handling, jump handling, register operations, and memory operations.



\## Project Overview



The processor consists of five pipeline stages:



IF - Instruction Fetch

Fetches instructions from instruction memory.



ID - Instruction Decode

Decodes instructions and reads source registers.



EX - Execute

Performs ALU operations and address calculations.



MEM - Memory Access

Performs data memory read and write operations.



WB - Write Back

Writes results back to the register file.



Pipeline registers are used between the stages to allow multiple instructions to be processed simultaneously.



\## Key Features



\### Five-Stage Pipeline



The processor uses the following pipeline:



IF → ID → EX → MEM → WB



Pipeline registers:



\- IF/ID

\- ID/EX

\- EX/MEM

\- MEM/WB



\### Data Forwarding



A dedicated forwarding unit handles data dependencies between instructions.



Instead of waiting for an instruction to complete the write-back stage, the required result can be forwarded directly to the Execute stage.



Example:



ADD R3, R1, R2

ADD R4, R3, R5



The result of the first instruction can be forwarded to the second instruction.



\### Load-Use Hazard Detection



A load-use hazard occurs when an instruction immediately uses a value loaded by the previous instruction.



Example:



LW R5, 0(R4)

ADD R6, R5, R1



The forwarding unit alone cannot completely resolve this dependency.



The hazard detection unit therefore inserts a pipeline stall.



During the stall, the program counter and IF/ID pipeline register are held while a bubble is inserted into the pipeline.



\### Control Hazard Handling



Branches can change the normal flow of instructions.



When a branch is taken, incorrectly fetched instructions are flushed from the pipeline so that execution continues from the correct target.



\### Jump Handling



Jump instructions modify the program counter.



Incorrectly fetched instructions are flushed so that execution continues from the correct jump target.



\### Register File



The processor contains 32 registers.



The register file stores operands and results during instruction execution.



\### Data Memory



A dedicated data memory module supports memory read and write operations.



\## Hazard Handling



\### Data Hazards



Data hazards occur when one instruction depends on the result of another instruction.



The forwarding unit reduces unnecessary pipeline stalls by forwarding the required data directly to the ALU.



\### Load-Use Hazards



When a load instruction is immediately followed by an instruction that uses the loaded value, the processor inserts a pipeline stall.



Example:



LW R5, 0(R4)

ADD R6, R5, R1



\### Control Hazards



Branches and jumps can change the program counter.



When a branch or jump is taken, incorrectly fetched instructions are flushed from the pipeline.



\## Simulation Results



The processor was verified using AMD Vivado XSim behavioral simulation.



The simulation demonstrated:



\- Five-stage instruction pipeline

\- Data forwarding

\- Load-use hazard detection

\- Pipeline stall

\- Branch handling

\- Branch pipeline flushing

\- Jump handling

\- Jump pipeline flushing

\- Register write-back

\- Memory read and write operations



\## Final Register Values



R1  = 5

R2  = 10

R3  = 15

R4  = 20

R5  = 20

R6  = 25

R7  = 30

R8  = 255

R10 = 42

R12 = 99



\## Memory Result



MEM\[0] = 20



\## Verification Output



PASS: R1 = 5

PASS: R2 = 10

PASS: R3 = 15

PASS: R4 = 20

PASS: R5 = 20

PASS: R6 = 25

PASS: R7 = 30

PASS: R8 = 255

PASS: R9 = 0

PASS: R10 = 42

PASS: R11 = 0

PASS: R12 = 99

PASS: MEM\[0] = 20



\## Pipeline Events



The simulation demonstrated the following events:



FORWARD A = 10

FORWARD B = 01



LOAD-USE HAZARD: PIPELINE STALL



BRANCH TAKEN - FLUSHING PIPELINE



JUMP TAKEN - FLUSHING PIPELINE



\## Waveform Verification



The processor was analyzed using the Vivado waveform viewer.



The waveform demonstrates:



\- Program counter updates

\- Instruction movement through pipeline stages

\- ALU operations

\- Data forwarding

\- Load-use pipeline stall

\- Memory read and write operations

\- Register write-back

\- Branch flushing

\- Jump handling



\## Waveform



!\[RISC Pipeline Processor Waveform](waveform.png)



\## RTL Modules



risc\_pipeline\_processor.v - Top-level processor



alu.v - Arithmetic and logical operations



control\_unit.v - Generates processor control signals



register\_file.v - 32-register register file



instruction\_memory.v - Instruction memory



data\_memory.v - Data memory



forwarding\_unit.v - Handles data forwarding



hazard\_detection\_unit.v - Detects load-use hazards



if\_id\_register.v - IF/ID pipeline register



id\_ex\_register.v - ID/EX pipeline register



ex\_mem\_register.v - EX/MEM pipeline register



mem\_wb\_register.v - MEM/WB pipeline register



tb\_risc\_pipeline\_processor.v - Verification testbench



\## Project Structure



risc\_pipeline\_processor/



risc\_pipeline\_processor.srcs/



sources\_1/



new/



alu.v

control\_unit.v

data\_memory.v

ex\_mem\_register.v

forwarding\_unit.v

hazard\_detection\_unit.v

id\_ex\_register.v

if\_id\_register.v

instruction\_memory.v

mem\_wb\_register.v

register\_file.v

risc\_pipeline\_processor.v

tb\_risc\_pipeline\_processor.v



waveform.png



README.md



risc\_pipeline\_processor.xpr



\## How to Run



Open the project file:



risc\_pipeline\_processor.xpr



In AMD Vivado, navigate to:



Flow Navigator → Simulation → Run Simulation → Run Behavioral Simulation



The processor execution can be observed using the Vivado waveform viewer and Tcl console.



\## Tools Used



\- Verilog HDL

\- AMD Vivado 2024.2

\- Vivado XSim

\- RTL Design

\- Computer Architecture

\- Digital Logic Design



\## Learning Objectives



This project demonstrates practical understanding of:



\- RTL design

\- RISC processor architecture

\- Five-stage pipelining

\- CPU datapath design

\- ALU design

\- Register-file design

\- Instruction memory

\- Data memory

\- Pipeline registers

\- Data hazards

\- Forwarding

\- Load-use hazards

\- Pipeline stalls

\- Control hazards

\- Branch flushing

\- Jump handling

\- Verilog HDL

\- RTL simulation and verification



\## Future Improvements



Possible future extensions include:



\- Support for additional RISC instructions

\- Larger instruction and data memories

\- Improved branch handling

\- Branch prediction

\- Automated regression testing

\- FPGA implementation

\- Synthesis and timing analysis

\- CPI measurement

\- Processor performance analysis



\## Author



Samruddhi Sangole



B.Tech Electronics and Telecommunication Engineering



\## License



This project is intended for educational and academic purposes.

