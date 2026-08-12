\# Five-Stage RISC Pipelined Processor



A 32-bit, five-stage RISC pipelined processor implemented in Verilog HDL and verified using AMD Vivado behavioral simulation.



The processor implements a classic five-stage pipeline:



\*\*IF → ID → EX → MEM → WB\*\*



The project demonstrates RTL design, pipelining, data forwarding, hazard detection, pipeline stalls, branch handling, jump handling, register operations, and memory operations.



\---



\## Project Overview



This project implements a 32-bit RISC processor using a five-stage instruction pipeline.



| Stage | Name | Function |

|---|---|---|

| IF | Instruction Fetch | Fetches instructions from instruction memory |

| ID | Instruction Decode | Decodes instructions and reads source registers |

| EX | Execute | Performs ALU operations and calculates addresses |

| MEM | Memory Access | Performs data memory read/write operations |

| WB | Write Back | Writes results back to the register file |



\---



\## Processor Architecture



```text

&#x20;            Instruction Memory

&#x20;                   |

&#x20;                   v

&#x20;             +-----------+

&#x20;             |    IF     |

&#x20;             |   Fetch   |

&#x20;             +-----+-----+

&#x20;                   |

&#x20;             +-----v-----+

&#x20;             |  IF / ID  |

&#x20;             |  Register |

&#x20;             +-----+-----+

&#x20;                   |

&#x20;                   v

&#x20;             +-----------+

&#x20;             |    ID     |

&#x20;             |  Decode   |

&#x20;             +-----+-----+

&#x20;                   |

&#x20;             +-----v-----+

&#x20;             |  ID / EX  |

&#x20;             |  Register |

&#x20;             +-----+-----+

&#x20;                   |

&#x20;                   v

&#x20;             +-----------+

&#x20;             |    EX     |

&#x20;             |    ALU    |

&#x20;             +-----+-----+

&#x20;                   |

&#x20;             +-----v-----+

&#x20;             | EX / MEM  |

&#x20;             |  Register |

&#x20;             +-----+-----+

&#x20;                   |

&#x20;                   v

&#x20;             +-----------+

&#x20;             |    MEM    |

&#x20;             |   Memory  |

&#x20;             +-----+-----+

&#x20;                   |

&#x20;             +-----v-----+

&#x20;             | MEM / WB  |

&#x20;             |  Register |

&#x20;             +-----+-----+

&#x20;                   |

&#x20;                   v

&#x20;             +-----------+

&#x20;             |    WB     |

&#x20;             | Write Back|

&#x20;             +-----------+

Key Features

1\. Five-Stage Pipeline



Instructions are processed through the following five stages:



IF → ID → EX → MEM → WB



Pipeline registers are used between stages, allowing multiple instructions to be processed simultaneously.



2\. Data Forwarding



A dedicated forwarding unit resolves data dependencies by forwarding results directly to the Execute stage instead of waiting for normal write-back.



Example:



ADD R3, R1, R2

ADD R4, R3, R5



The result produced for R3 can be forwarded to the ALU input of the following instruction.



The simulation demonstrates forwarding decisions such as:



FORWARD A = 10

FORWARD B = 01

3\. Load-Use Hazard Detection



A dedicated hazard detection unit identifies load-use dependencies that cannot be completely resolved using forwarding.



Example:



LW  R5, 0(R4)

ADD R6, R5, R1



The processor inserts a pipeline stall when required.



Simulation output:



\*\*\* LOAD-USE HAZARD: PIPELINE STALL \*\*\*



During the stall:



The PC is held.

The IF/ID pipeline register is held.

A bubble is inserted into the pipeline.

4\. Control Hazard Handling



When a branch is taken, instructions fetched from the incorrect path are flushed from the pipeline.



Simulation output:



\*\*\* BRANCH TAKEN - FLUSHING PIPELINE \*\*\*



This prevents instructions from the wrong execution path from modifying processor state.



5\. Jump Handling



Jump instructions update the program counter and cause incorrectly fetched instructions to be flushed.



Simulation output:



\*\*\* JUMP TAKEN - FLUSHING PIPELINE \*\*\*

6\. Register File



The processor contains a 32-register register file.



The verification testbench checks the final register values after program execution.



Example verified results:



R1  = 5

R2  = 10

R3  = 15

R4  = 20

R5  = 20

R6  = 25

R7  = 30

R10 = 42

R12 = 99

7\. Data Memory



The processor includes a dedicated data memory module supporting memory read and write operations.



The testbench verifies:



MEM\[0] = 20

RTL Modules

Module	Description

risc\_pipeline\_processor.v	Top-level processor

alu.v	Arithmetic and logical operations

control\_unit.v	Generates processor control signals

register\_file.v	32-register register file

instruction\_memory.v	Instruction memory

data\_memory.v	Data memory

forwarding\_unit.v	Handles data forwarding

hazard\_detection\_unit.v	Detects load-use hazards

if\_id\_register.v	IF/ID pipeline register

id\_ex\_register.v	ID/EX pipeline register

ex\_mem\_register.v	EX/MEM pipeline register

mem\_wb\_register.v	MEM/WB pipeline register

tb\_risc\_pipeline\_processor.v	Verification testbench

Hazard Handling

Data Hazards



Data dependencies between instructions are handled using the forwarding unit.



Previous Instruction

&#x20;       |

&#x20;       v

Pipeline Register

&#x20;       |

&#x20;       | Forwarding

&#x20;       v

&#x20;     ALU Input



Forwarding reduces the number of unnecessary pipeline stalls.



Load-Use Hazard



When a load instruction is immediately followed by an instruction that requires the loaded value, the data is not available early enough for normal forwarding.



The hazard detection unit therefore inserts a stall.



LW  R5, 0(R4)

ADD R6, R5, R1



&#x20;       ↓



Pipeline Stall

Control Hazards



Branches and jumps can change the program counter.



When a branch or jump is taken, incorrectly fetched instructions are flushed from the pipeline.



Branch / Jump Taken

&#x20;       |

&#x20;       v

Flush Pipeline

&#x20;       |

&#x20;       v

Fetch Correct Instruction

Verification



The processor was verified using a dedicated Verilog testbench in AMD Vivado XSim.



The testbench verifies:



Arithmetic operations

Register operations

Immediate operations

Store operations

Load operations

Data forwarding

Load-use hazard detection

Pipeline stalls

Branch execution

Branch flushing

Jump execution

Jump flushing

Final register values

Data memory contents

Simulation Results



The behavioral simulation completed successfully with all verification checks passing.



Register Verification

PASS: R1 = 5

PASS: R2 = 10

PASS: R3 = 15

PASS: R4 = 20

PASS: R5 = 20

PASS: R6 = 25

PASS: R7 = 30

PASS: R8 = 0

PASS: R9 = 0

PASS: R10 = 42

PASS: R11 = 0

PASS: R12 = 99

Memory Verification

PASS: MEM\[0] = 20

Hazard and Pipeline Events



The simulation also demonstrated:



FORWARD A = 10

FORWARD B = 01



\*\*\* LOAD-USE HAZARD: PIPELINE STALL \*\*\*



\*\*\* BRANCH TAKEN - FLUSHING PIPELINE \*\*\*



\*\*\* JUMP TAKEN - FLUSHING PIPELINE \*\*\*



These simulation messages confirm that the forwarding, hazard detection, pipeline stall, branch flush, and jump flush mechanisms were exercised during verification.



Waveform Verification



The processor was analyzed using the Vivado waveform viewer.



Important waveform signals include:



clk

reset

pc

if\_instruction

id\_instruction

alu\_result

zero

mem\_read

mem\_write

wb\_reg\_write

wb\_write\_reg

wb\_write\_data

forward\_a

forward\_b

stall



These signals demonstrate:



Instruction movement through the pipeline

Program counter updates

ALU execution

Memory operations

Register write-back

Data forwarding

Pipeline stalls

Branch flushing

Jump handling



**Tools Used**

Verilog HDL

AMD Vivado 2024.2

Vivado XSim

RTL Design

Computer Architecture

Digital Logic Design



**Project Structure**

risc\_pipeline\_processor/

│

├── risc\_pipeline\_processor.srcs/

│   └── sources\_1/

│       └── new/

│           ├── alu.v

│           ├── control\_unit.v

│           ├── data\_memory.v

│           ├── ex\_mem\_register.v

│           ├── forwarding\_unit.v

│           ├── hazard\_detection\_unit.v

│           ├── id\_ex\_register.v

│           ├── if\_id\_register.v

│           ├── instruction\_memory.v

│           ├── mem\_wb\_register.v

│           ├── register\_file.v

│           ├── risc\_pipeline\_processor.v

│           └── tb\_risc\_pipeline\_processor.v

│

├── README.md

└── risc\_pipeline\_processor.xpr

How to Run

1\. Open the Project



Open the following project file in AMD Vivado:



risc\_pipeline\_processor.xpr

2\. Run Behavioral Simulation



In Vivado, navigate to:



Flow Navigator

&#x20;   ↓

Simulation

&#x20;   ↓

Run Simulation

&#x20;   ↓

Run Behavioral Simulation

3\. Observe the Results



The processor execution can be observed through:



Vivado waveform viewer

Vivado Tcl console

Register verification output

Data memory verification output

Hazard and forwarding messages

Learning Objectives



This project demonstrates practical understanding of:



RTL design

RISC processor architecture

Five-stage pipelining

CPU datapath design

ALU design

Register-file design

Instruction memory

Data memory

Pipeline registers

Data hazards

Forwarding

Load-use hazards

Pipeline stalls

Control hazards

Branch flushing

Jump handling

Verilog HDL

RTL simulation and verification

Future Improvements



Possible future extensions include:



Support for additional RISC instructions

Larger instruction and data memories

Improved branch handling

Branch prediction

Automated regression testing

FPGA implementation

Synthesis and timing analysis

CPI measurement

Processor performance analysis

Author



Samruddhi Sangole



B.Tech Electronics \& Telecommunication Engineering



License



This project is intended for educational and academic purposes.

