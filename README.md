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

