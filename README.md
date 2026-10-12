# FPGA-Based Traffic Light Controller with Priority System

A four-way traffic light controller designed using **Verilog HDL, finite state machine (FSM) architecture, and FPGA implementation**. The project supports normal traffic sequencing and manual emergency vehicle priority, targeting the Digilent Basys 3 development board featuring the AMD/Xilinx Artix-7 FPGA.

## Project Overview

This project implements a traffic light controller for a four-way intersection consisting of North, South, East, and West directions. The controller manages traffic signals using an FSM, generates timing intervals from the FPGA clock, and handles emergency requests according to a fixed priority order.

The design includes Verilog RTL, a testbench, simulation waveforms, Vivado design-analysis screenshots, Basys 3 pin constraints, and a generated FPGA bitstream.

## Key Features

- Four-way traffic signal control.
- FSM-based RTL architecture.
- Internal one-second timing generation.
- Configurable green, yellow, all-red, and emergency timings.
- Manual emergency request inputs for all four directions.
- Emergency priority: **North > South > East > West**.
- ALL-RED transitions before emergency green.
- Handling of simultaneous emergency requests.
- Verilog testbench and simulation waveform.
- Vivado RTL, synthesis, and implementation analysis.
- Basys 3 XDC constraints and bitstream.
- Physical hardware implementation photographs.

## Hardware and Tools

| Component | Specification |
|---|---|
| FPGA board | Digilent Basys 3 |
| FPGA device | AMD/Xilinx Artix-7 XC7A35T-1CPG236C |
| System clock | 100 MHz |
| Hardware description language | Verilog HDL |
| FPGA design tool | AMD/Xilinx Vivado |
| Simulation | Icarus Verilog |
| Waveform viewer | GTKWave |
| Version control | Git and GitHub |

## System Architecture

The design consists of the following functional blocks:

1. **Timing logic:** Generates one-second timing events from the FPGA clock.
2. **Traffic controller FSM:** Controls normal traffic sequencing and emergency states.
3. **Emergency priority logic:** Selects the highest-priority active emergency request.
4. **Traffic signal outputs:** Drive the red, yellow, and green indicators for each direction.
5. **FPGA interface:** Connects the controller to the Basys 3 clock, reset, switches, and LEDs through the XDC constraints.

## Normal Traffic Sequence

The controller follows this repeating sequence:

1. North and South GREEN; East and West RED.
2. North and South YELLOW; East and West RED.
3. ALL RED.
4. East and West GREEN; North and South RED.
5. East and West YELLOW; North and South RED.
6. ALL RED.
7. Repeat.

The all-red intervals separate conflicting traffic movements.

## Emergency Priority System

The controller accepts four manual emergency request inputs:

| Input | Direction |
|---|---|
| `emergency_north` | North |
| `emergency_south` | South |
| `emergency_east` | East |
| `emergency_west` | West |

The priority order is:

**North > South > East > West**

When an emergency request is selected at a designated transition point, the controller enters the corresponding emergency sequence. If multiple requests are active, the highest-priority request is selected. All-red transitions are used before granting emergency green.

Emergency requests are represented by FPGA input signals. Physical emergency vehicle detection sensors are not included in this version.

## Timing Configuration

The intended default parameters are:

| Parameter | Value |
|---|---:|
| `CLK_FREQ` | 100,000,000 Hz |
| `GREEN_TIME` | 10 seconds |
| `YELLOW_TIME` | 3 seconds |
| `ALL_RED_TIME` | 1 second |
| `EMERGENCY_TIME` | 10 seconds |

These parameters are defined in the RTL design and can be adjusted for supported configurations.

## Hardware Implementation

The project targets the Digilent Basys 3 FPGA development board.

The intended board interface uses:

- The onboard 100 MHz clock.
- A push button for reset.
- Four slide switches for emergency requests.
- LEDs for traffic signal outputs.

The XDC file defines FPGA pin assignments and I/O standards. The generated bitstream can be used to configure the FPGA with the corresponding implemented design.

### Hardware Photographs

![Basys 3 hardware implementation](FPGA/hardware/hardware_implementation.jpeg)

![Basys 3 hardware implementation - photo 2](FPGA/hardware/hardware_implementation01.jpeg)

![Basys 3 hardware implementation - photo 3](FPGA/hardware/hardware_implementation02.jpeg)

## Simulation and Verification

The repository includes a Verilog testbench and simulation waveform for examining controller behavior.

The test scenarios cover:

- Normal traffic sequencing.
- North emergency request.
- South emergency request.
- East emergency request.
- West emergency request.
- North-versus-East priority.
- South-versus-East-versus-West priority.

The testbench and waveform provide evidence for examining FSM transitions, signal outputs, and emergency priority behavior.

## Vivado Design Analysis

The repository includes diagrams, simulation waveforms, and Vivado design-analysis screenshots.

### FSM Diagram

![FSM Diagram](Documentation/FSM_Diagram.png)

### Block Diagram

![Block Diagram](Documentation/Block_Diagram.png)

### Simulation Waveform

![Simulation Waveform](Documentation/simulation_waveform.png)

### Vivado Simulation

![Vivado Simulation Waveform](Documentation/vivado_simulation_waveform.png)

### RTL Schematic

![RTL Schematic](Documentation/vivado_rtl_schematic.png)

### Synthesis Schematic

![Synthesis Schematic](Documentation/vivado_synthesis_schematic.png)

### Implementation Schematic

![Implementation Schematic](Documentation/vivado_implementation_schematic.png)

## Project Structure

```text
FPGA-Traffic-Light-Controller/
├── README.md
├── LICENSE
├── .gitignore
│
├── RTL/
│   ├── priority_encoder.v
│   ├── timer.v
│   ├── top_module.v
│   └── traffic_controller.v
│
├── Testbench/
│   └── traffic_controller_tb.v
│
├── Simulation/
│   └── final_traffic_controller.vcd
│
├── FPGA/
│   ├── constraints/
│   │   └── Basys3_Traffic.xdc
│   ├── bitstream/
│   │   └── traffic_controller.bit
│   └── hardware/
│       ├── hardware_implementation.jpeg
│       ├── hardware_implementation01.jpeg
│       └── hardware_implementation02.jpeg
│
└── Documentation/
    ├── Block_Diagram.png
    ├── FSM_Diagram.png
    ├── simulation_waveform.png
    ├── vivado_simulation_waveform.png
    ├── vivado_rtl_schematic.png
    ├── vivado_synthesis_schematic.png
    └── vivado_implementation_schematic.png
```

## Running the RTL Simulation

Install Icarus Verilog and GTKWave, then open a terminal in the repository root.

Compile the testbench:

```bash
iverilog -g2012 -s traffic_controller_tb \
-o Simulation/final_sim \
RTL/traffic_controller.v \
Testbench/traffic_controller_tb.v
```

Run the simulation:

```bash
vvp Simulation/final_sim
```

Open the existing waveform:

```bash
gtkwave Simulation/final_traffic_controller.vcd
```

If your testbench or RTL depends on additional modules, include those source files in the compile command.

## FPGA Build and Programming

To reproduce the FPGA build:

1. Open the project in AMD/Xilinx Vivado.
2. Add the required Verilog source files.
3. Set `top_module` as the top module.
4. Add `FPGA/constraints/Basys3_Traffic.xdc`.
5. Run RTL elaboration and synthesis.
6. Run implementation and review timing and design-rule reports.
7. Generate the bitstream.
8. Program the Basys 3 and test normal sequencing and emergency priority.

The committed bitstream should correspond to the committed RTL and XDC files.

## Project Status

| Deliverable | Status |
|---|---|
| Verilog RTL design | Completed |
| Testbench and simulation | Completed |
| Simulation waveform | Included |
| Vivado design analysis | Documented |
| Basys 3 constraints | Included |
| Generated bitstream | Included |
| Hardware implementation photographs | Included |
| Project documentation | Updated |

## Future Improvements

- Integrate physical emergency vehicle detection sensors.
- Add pedestrian crossing control.
- Introduce configurable timings through switches or serial communication.
- Explore adaptive traffic control based on traffic density.
- Evaluate further area, timing, and power optimizations.

## Author

**Ruturaj Vyavahare**

Electronics and Telecommunication Engineering
VLSI and FPGA Design

- GitHub: [RuturajVyavahare](https://github.com/RuturajVyavahare)
- Project Repository: [FPGA-Based Traffic Light Controller](https://github.com/RuturajVyavahare/FPGA-Traffic-Light-Controller)

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.