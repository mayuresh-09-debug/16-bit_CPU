# 16-Bit Low-Power Processor Architecture Core

A complete, working 16-bit processor execution core designed, simulated, and verified in Verilog using Xilinx Vivado.

## 🛠 Architecture Overview
This processor consists of four fully integrated hardware modules working in sync:
- **Control Unit (The Brain):** Decodes 16-bit binary machine instructions dynamically to drive internal datapath switches.
- **Arithmetic Logic Unit (The Calculator):** Implements high-speed mathematical operations, including 2's complement subtraction and live tracking via a status zero-flag sentinel.
- **Register File with Clock Gating (Storage):** Features an energy-efficient power architecture utilizing clock gating to wake up register units only during active write cycles.
- **Program Counter (The Navigator):** Manages instruction pointer flow sequentially and supports immediate branch control routing.

- ## 📊 Instruction Set Blueprint
Every instruction is exactly 16 bits wide, structured to maximize decoding efficiency:
* **Bits [15:14]** – Opcode (00 = R-Type Math, 01 = Load Immediate, 10 = Branch if Zero)
* **Bits [13:12]** – Destination Register Select (`reg_write_sel`)
* **Bits [11:10]** – Source Register A Select (`reg_read_selA`)
* **Bits [9:8]** – Source Register B Select (`reg_read_selB`)
* **Bits [7:0]** – Immediate Value / Target Jump Address

* ## 📈 Verification & Simulation
System validation was performed using behavioral testbench simulation scripts. Waveform analysis verified seamless data bus routing, pipeline synchronization with a 100MHz clock heartbeat, and successful control loop execution on both R-Type operations and hardware resets.
