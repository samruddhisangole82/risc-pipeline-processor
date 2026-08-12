\# 5-Stage Pipelined RISC-V Processor



A 32-bit RISC-V processor implemented in Verilog HDL using AMD Vivado. 

The processor uses a classic 5-stage instruction pipeline with dedicated 

pipeline registers, hazard detection, and data forwarding.



\---



\## 📌 Project Overview



This project implements a pipelined RISC-V processor capable of executing 

instructions through five pipeline stages:



\*\*IF → ID → EX → MEM → WB\*\*



The design was developed at RTL level using Verilog HDL and verified through 

behavioral simulation in AMD Vivado.



\---



\## 🏗️ Processor Architecture



The processor consists of the following five stages:



| Stage | Name | Description |

|-------|------|-------------|

| IF | Instruction Fetch | Fetches the instruction from instruction memory |

| ID | Instruction Decode | Decodes the instruction and reads registers |

| EX | Execute | Performs ALU operations and calculates addresses |

| MEM | Memory Access | Performs read/write operations on data memory |

| WB | Write Back | Writes the result back to the register file |



\### Pipeline



```text

&#x20;                ┌──────────────┐

&#x20;                │ Instruction  │

&#x20;                │    Memory    │

&#x20;                └──────┬───────┘

&#x20;                       │

&#x20;                       ▼

&#x20;                 ┌───────────┐

&#x20;                 │    IF     │

&#x20;                 └─────┬─────┘

&#x20;                       │

&#x20;                  IF/ID Register

&#x20;                       │

&#x20;                       ▼

&#x20;                 ┌───────────┐

&#x20;                 │    ID     │

&#x20;                 │  Decode   │

&#x20;                 └─────┬─────┘

&#x20;                       │

&#x20;                  ID/EX Register

&#x20;                       │

&#x20;                       ▼

&#x20;                 ┌───────────┐

&#x20;                 │    EX     │

&#x20;                 │    ALU    │

&#x20;                 └─────┬─────┘

&#x20;                       │

&#x20;                 EX/MEM Register

&#x20;                       │

&#x20;                       ▼

&#x20;                 ┌───────────┐

&#x20;                 │   MEM     │

&#x20;                 │   Data    │

&#x20;                 │  Memory   │

&#x20;                 └─────┬─────┘

&#x20;                       │

&#x20;                 MEM/WB Register

&#x20;                       │

&#x20;                       ▼

&#x20;                 ┌───────────┐

&#x20;                 │    WB     │

&#x20;                 │ Writeback │

&#x20;                 └───────────┘

