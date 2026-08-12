\# Five-Stage RISC Pipelined Processor



A 32-bit, five-stage RISC pipelined processor implemented in Verilog HDL and verified using AMD Vivado behavioral simulation.



The processor follows the classic five-stage pipeline:



\*\*IF → ID → EX → MEM → WB\*\*



This project demonstrates RTL design, pipelining, data forwarding, hazard detection, pipeline stalls, branch handling, jump handling, register operations, and memory operations.



\---



\## Project Overview



The processor consists of five pipeline stages:



| Stage | Name | Description |

|---|---|---|

| IF | Instruction Fetch | Fetches instructions from instruction memory |

| ID | Instruction Decode | Decodes instructions and reads registers |

| EX | Execute | Performs ALU operations and address calculations |

| MEM | Memory Access | Performs data memory read/write operations |

| WB | Write Back | Writes results back to the register file |



Pipeline registers are used between stages so that multiple instructions can be processed simultaneously.



\---



\## Key Features



\### 1. Five-Stage Pipeline



The processor implements:



```text

IF → ID → EX → MEM → WB

