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

