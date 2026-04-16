# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Embedded firmware for a motor drive software. Targets the TI TMS320F28379D (C2000 family, F2837xd Launchpad). Implements both sensored and sensorless motor control algorithms. 

## Default Interpretation

When the user asks about "the code", "the controller", "the board", or asks generic C questions in the context of this repository, assume they mean this specific target unless they explicitly say otherwise:

- **MCU:** `TMS320F28379D`
- **Board:** `LaunchXL-F28379D` / F2837xD LaunchPad
- **Toolchain:** TI C28xx compiler in Code Composer Studio
- **Code context:** embedded C firmware, register-level peripheral control, interrupt-driven real-time code

Prefer TI C2000 terminology and constraints over generic desktop C assumptions.

Do **not** default to `gcc`, `clang`, `cmake`, `make`, POSIX APIs, dynamic-allocation-heavy patterns, or OS-based threading unless the user explicitly asks for host-side code.

## Build System

**IDE:** TI Code Composer Studio (CCS) v20.2.0 — this is an Eclipse/GNU Make managed build.

There is no standalone Makefile or CLI build command. Build must be performed through CCS or `cl2000` compiler invocation matching these settings:
- **Compiler:** TI C28xx v22.6.1 LTS, target `TMS320F28379D`
- **Defines:** `CPU1`, `CLA_C`, `_LAUNCHXL_F28379D`, `DUAL_CORE`
- **FPU:** FPU32 enabled; large memory model; unified memory
- **Optimization:** `-O4` for `main.c`, `-O1` default for others
- **Linker script:** `2837x_RAM_lnk_cpu1.cmd`
- **Stack:** 0x200 bytes
- **Output:** `SensorlessCSI_NSPWM.out` (COFF format)

Project files live under `CCS Project/CCS Code/`.

## Working Assumptions

- Treat ISR execution time, determinism, and peripheral timing as first-order concerns.
- Assume `main()` is mostly initialization and background tasks; the control behavior is primarily interrupt-driven.
- Treat `ePWM`, `ADC`, `CMPSS`, `SCI`, `PIE`, GPIO muxing, and Xbar routing as TI-specific hardware topics, not portable C abstractions.
- When suggesting changes, consider sampling timing, PWM synchronization, protection trips, and shared global state between ISR and background code.
- If a request is ambiguous between generic C and embedded C2000 firmware, answer in the C2000/F28379D context first.

## Architecture



### Key Source Files

| File | Role |
|------|------|
| `main.c` | ePWM1 ISR, modulation, protection logic |
| `definitions.h` | All tunable parameters and feature flags |
| `variables.h/.c` | Global state (currents, power, control signals) |
| `init_peripherals.c` | ADC, ePWM1-3, CMPSS, Xbar hardware init |
| `functions.c` | Moving average, FIR filter, high-pass filter, PLL |
| `communications.c/.h` | UART serial protocol (send/receive) |

### Feature Flags in `definitions.h`

- `SENSORLESS` / `SENSORED` — control mode (sensored FOC is not yet implemented)
- `REACTIVE_POWER_CONTROL` — enable Q-based PI correction
- `STABILIZATION_LOOP_ACTIVE` — power-based frequency droop compensation
- `HRPWM_ENABLED` — high-resolution PWM
- `MOTOR_DEFAULT` / `MOTOR_100krpm` / `MOTOR_300krpm` — motor parameter sets

### Serial Protocol

Custom binary framing over SCIA at 115200 baud:
- **Receive (PC → MCU):** `[0xAA] [0xBB|0xCC|0xDD] [4B float] [0x55 0x55]`
  - 0xBB = frequency demand, 0xCC = acceleration rate, 0xDD = enable flag
- **Transmit (MCU → PC):** telemetry stream of `f_actual` and `Ia`

### PC Visualization

`CCS Project/plot_motor.py` — PyQt6 + matplotlib GUI for real-time plotting and CSV logging. Connect via COM port (default COM15).

### Protection

- **Hardware:** CMPSS comparators (CMPSS1, CMPSS3, CMPSS6) with trip-zone routing through InputXbar/EPWMXbar for per-phase overcurrent
- **Software:** Ia > 100 A → disable; Vdc < 90% nominal → fault

## How Claude Should Help

- Use hardware-aware reasoning for `main.c`, ISR logic, peripheral init, and protection code.
- Prefer concise, direct explanations grounded in this project's actual files and control flow.
- When proposing code, keep it compatible with CCS-managed embedded C for F28379D.
- Call out ASSUMPTIONS OR SIMPLIFICATIONS EXPLICITLY IN ALL CAPS when the hardware intent is not certain.
