\# Five-Stage RISC Pipelined Processor



\## 📌 Project Overview



This project implements a 32-bit, five-stage RISC pipelined processor using Verilog HDL and verified through AMD Vivado XSim behavioral simulation.



The processor follows the classic five-stage pipeline:



IF → ID → EX → MEM → WB



The project demonstrates RTL design, pipelining, data forwarding, hazard detection, pipeline stalls, branch handling, jump handling, register operations, and memory operations.



\---



\## 🏗️ Processor Architecture



The processor consists of five pipeline stages:



1\. IF – Instruction Fetch

&#x20;  Fetches instructions from instruction memory.



2\. ID – Instruction Decode

&#x20;  Decodes instructions and reads source registers.



3\. EX – Execute

&#x20;  Performs ALU operations and address calculations.



4\. MEM – Memory Access

&#x20;  Performs data memory read and write operations.



5\. WB – Write Back

&#x20;  Writes results back to the register file.



Pipeline registers are used between the stages to allow multiple instructions to be processed simultaneously.



\---



\## ⚙️ Key Features



\- Five-stage pipelined architecture

\- Data forwarding for resolving data hazards

\- Load-use hazard detection

\- Pipeline stall and bubble insertion

\- Branch detection and pipeline flushing

\- Jump handling and pipeline flushing

\- 32-register register file

\- Instruction and data memory

\- Modular Verilog RTL design



\---



\## 🛠️ Tools \& Technologies



\- Language: Verilog HDL

\- EDA Tool: AMD Vivado 2024.2

\- Simulation: Vivado XSim

\- Design: RTL

\- Verification: Verilog Testbench

\- Version Control: Git and GitHub



\---



\## 📂 Repository Structure



risc-pipeline-processor/



├── risc\_pipeline\_processor.srcs/

├── risc\_pipeline\_processor.xpr

├── waveform.png

├── README.md

└── .gitignore



\---



\## 🧪 Verification



The processor was verified using AMD Vivado XSim behavioral simulation.



The testbench verifies:



\- ALU operations

\- Register operations

\- Data forwarding

\- Load-use hazard detection

\- Pipeline stalls

\- Branch handling

\- Jump handling

\- Memory read and write operations

\- Register write-back



\---



\## 📊 Simulation Results



The simulation produced the following final register values:



R1 = 5

R2 = 10

R3 = 15

R4 = 20

R5 = 20

R6 = 25

R7 = 30

R8 = 255

R10 = 42

R12 = 99



MEM\[0] = 20



The simulation also demonstrated:



FORWARD A = 10

FORWARD B = 01

LOAD-USE HAZARD: PIPELINE STALL

BRANCH TAKEN - FLUSHING PIPELINE

JUMP TAKEN - FLUSHING PIPELINE



\---



\## 🌊 Waveform Verification



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



!\[RISC Pipeline Processor Waveform](waveform.png)



\---



\## 🚀 How to Run



Open the risc\_pipeline\_processor.xpr project file in AMD Vivado.



Navigate to:



Flow Navigator → Simulation → Run Simulation → Run Behavioral Simulation



The processor execution can be observed using the Vivado waveform viewer and Tcl console.



\---



\## 👤 Author



Samruddhi Sangole



B.Tech Electronics and Telecommunication Engineering



FPGA / VLSI Enthusiast



\---



\## 📜 License



This project is intended for educational and academic purposes.

