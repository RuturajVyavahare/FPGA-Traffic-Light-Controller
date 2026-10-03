# FPGA-Based Traffic Light Controller with Priority System

A Verilog HDL-based FPGA traffic light controller for a four-way intersection, designed using a finite state machine (FSM) architecture with manual emergency vehicle priority handling.

> **Project Status:** RTL design, simulation, verification, and Vivado design analysis completed. Basys 3 hardware implementation and physical testing are pending.

---

## 📌 Overview

This project implements a four-way traffic light controller using **Verilog HDL** and a **Finite State Machine (FSM)** architecture.

The controller manages traffic signals for four directions:

- North
- South
- East
- West

During normal operation, North-South and East-West traffic are controlled alternately using configurable green, yellow, and all-red timing intervals.

The design also incorporates a **manual emergency vehicle priority mechanism**. Four FPGA switch inputs represent emergency vehicle requests for the corresponding directions.

When an emergency request is selected, the controller passes through a safe **ALL-RED state** before providing a GREEN signal to the selected emergency lane.

---

## 🎯 Objectives

- Design a four-way traffic light controller using Verilog HDL.
- Implement an FSM-based RTL architecture.
- Generate internal timing from the FPGA clock.
- Provide safe transitions between traffic states.
- Implement emergency vehicle priority handling.
- Support multiple simultaneous emergency requests.
- Implement a fixed priority scheme for emergency requests.
- Verify the design using RTL simulation.
- Analyze simulation waveforms using GTKWave and Vivado.
- Perform RTL, synthesis, and implementation analysis using Xilinx Vivado.
- Prepare the design for implementation on a Basys 3 FPGA board.

---

## 🚦 Key Features

- **4-way traffic signal control**
- **Verilog HDL implementation**
- **FSM-based RTL architecture**
- **North-South / East-West coordinated operation**
- **100 MHz FPGA clock support**
- **Internal one-second timing generation**
- **Manual emergency vehicle inputs**
- **Emergency priority encoder**
- **Fixed priority: North > South > East > West**
- **Safe ALL-RED transitions**
- **Configurable timing parameters**
- **Multiple simultaneous emergency request handling**
- **RTL simulation using Icarus Verilog**
- **Waveform analysis using GTKWave**
- **Vivado RTL and synthesis analysis**
- **Vivado implementation analysis**
- **Basys 3 FPGA target**

---

## 🧠 Emergency Priority System

Four manual emergency inputs are provided:

emergency_north
emergency_south
emergency_east
emergency_west