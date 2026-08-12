\# Five-Stage RISC Pipelined Processor



A 32-bit, five-stage RISC pipelined processor implemented in Verilog HDL and verified using AMD Vivado behavioral simulation.



The processor implements the classic five-stage pipeline:



\*\*IF → ID → EX → MEM → WB\*\*



The project demonstrates RTL design, pipelining, data forwarding, hazard detection, pipeline stalls, branch handling, jump handling, register operations, and memory operations.



\---



\## Project Overview



The processor consists of five pipeline stages:



| Stage | Name | Description |

|---|---|---|

| IF | Instruction Fetch | Fetches instructions from instruction memory |

| ID | Instruction Decode | Decodes instructions and reads source registers |

| EX | Execute | Performs ALU operations and address calculations |

| MEM | Memory Access | Performs data memory read and write operations |

| WB | Write Back | Writes results back to the register file |



Pipeline registers are placed between the stages to allow multiple instructions to be processed at the same time.



\---



\## Key Features



\### Five-Stage Pipeline



The processor uses the following pipeline:



\*\*IF → ID → EX → MEM → WB\*\*



The pipeline registers are:



\- IF/ID

\- ID/EX

\- EX/MEM

\- MEM/WB



\### Data Forwarding



A dedicated forwarding unit handles data dependencies between instructions.



Instead of waiting for an instruction to complete the write-back stage, the required result can be forwarded directly to the Execute stage.



For example:



```text

ADD R3, R1, R2

ADD R4, R3, R5

The result of the first instruction can be forwarded to the second instruction.



Load-Use Hazard Detection



A load-use hazard occurs when an instruction immediately uses a value loaded by the previous instruction.



Example:



LW  R5, 0(R4)

ADD R6, R5, R1



The forwarding unit alone cannot completely resolve this dependency.



The hazard detection unit therefore inserts a pipeline stall.



Control Hazard Handling



Branches can change the normal flow of instructions.



When a branch is taken, incorrectly fetched instructions are flushed from the pipeline.



Jump Handling



Jump instructions modify the program counter.



Incorrectly fetched instructions are flushed so that execution continues from the correct target address.



Register File



The processor contains 32 registers.



The register file is used to store operands and results during instruction execution.



Data Memory



A dedicated data memory module supports memory read and write operations.

Hazard Handling

Data Hazards



Data hazards occur when one instruction depends on the result of another instruction.



The forwarding unit reduces unnecessary pipeline stalls by forwarding the required data directly to the ALU.



Load-Use Hazards



When a load instruction is immediately followed by an instruction that uses the loaded value, the processor inserts a stall.



Example:



LW  R5, 0(R4)

ADD R6, R5, R1

Control Hazards



Branches and jumps can change the program counter.



When a branch or jump is taken, incorrectly fetched instructions are flushed from the pipeline.

