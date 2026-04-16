---
name: ti-f2837xd-ccs-firmware
description: Work with TI C2000 embedded firmware for the TMS320F28379D / LaunchXL-F28379D in Code Composer Studio. Use when the user asks about CCS project structure, C firmware, interrupts, ePWM, ADC, CMPSS, SCI, linker settings, motor control, ISR timing, or F2837xD hardware behavior.
---

# TI F2837xD CCS Firmware

## Purpose

This repository is embedded C firmware for the TI `TMS320F28379D` on the `LaunchXL-F28379D` / F2837xD LaunchPad, developed in Code Composer Studio.

## Assume These Defaults

- Target MCU is `TMS320F28379D`
- Board is `LaunchXL-F28379D`
- Toolchain is TI C28xx in CCS, not `gcc` or `clang`
- Main firmware code lives under `CCS Project/CCS Code/`
- Real-time behavior is interrupt-driven
- Peripheral names and registers are TI C2000-specific

## Working Rules

- Interpret ambiguous C questions in this repository as TI C2000 embedded-firmware questions first.
- Prefer explanations in terms of `ePWM`, `ADC`, `CMPSS`, `PIE`, `SCI`, `Xbar`, GPIO muxing, and ISR timing.
- Treat ISR cost, determinism, ADC/PWM synchronization, and protection logic as high priority.
- Do not suggest generic desktop build steps such as `cmake`, `make`, `gcc`, or POSIX-based runtime behavior unless the user explicitly asks for host-side tooling.
- Keep code suggestions compatible with CCS-managed embedded C firmware for F28379D.
- If the hardware intent is uncertain, call out ASSUMPTIONS OR SIMPLIFICATIONS IN ALL CAPS.

## Project Context

- The project implements motor-drive control (both sensored and sensorless).
- The main control loop runs in the `ePWM1` ISR.
- `main()` mostly performs initialization plus background serial handling.
- Key files include `main.c`, `definitions.h`, `variables.c`, `variables.h`, `init_peripherals.c`, `functions.c`, `communications.c`, and `communications.h`.

## Code Placement Rules

Follow these rules strictly when writing or suggesting new code:

- **`init_peripherals.c`** — All peripheral initialization belongs here. This includes eQEP, ePWM, ADC, CMPSS, Xbar, SCI, GPIO muxing, and any other TI hardware peripheral setup. Even if a peripheral is new (e.g. eQEP for a sensored encoder), its `Init*()` function goes in this file.
- **`definitions.h`** — All tunable parameters, feature flags, and compile-time macros (e.g. sensor type selection, motor parameters, thresholds).
- **`variables.h` / `variables.c`** — All global state variables shared between ISR and background code.
- **`main.c`** — ISR control logic only. Call `Init*()` functions from `main()`. Do not put peripheral register configuration inline in `main.c`.
- **`functions.c`** — Reusable math/signal-processing functions (filters, transforms, etc.).
- **`communications.c`** — Serial protocol send/receive logic only.
- Do **not** create new `.c`/`.h` files unless the user explicitly asks for a new module. Prefer extending existing files.

## Commands

### `/optimize-function` — Reduce Clock Cycles for a C Function

**Trigger:** The user provides a C function and asks to optimize it, make it faster, reduce cycles, or invokes `/optimize-function`.

**Input:** A C function (pasted inline or referenced by name/file location).

**Output:** A rewritten version of the function optimized for minimum clock-cycle count on the TMS320F28379D (C28x core), with an explanation of every change.

**Procedure:**

1. **Read the input function.** If the user gives a function name or file path instead of inline code, read it from the project files first.
2. **Profile the bottlenecks.** Identify cycle-expensive patterns specific to the C28x pipeline:
   - Divisions (use reciprocal multiply or shift instead)
   - Float-to-int / int-to-float conversions
   - Branch-heavy control flow (prefer branchless arithmetic, conditional moves, `__min`/`__max` intrinsics)
   - Repeated memory loads of the same global (cache in a local)
   - Unaligned or non-contiguous memory access patterns
   - Function-call overhead inside tight loops (inline or macro)
   - Modulo by non-power-of-2 (replace with masking or lookup)
   - Generic `math.h` calls where TI `IQmath`, `TMU` (trigonometric math unit), or `FPU` intrinsics exist (e.g. `__sin`, `__cos`, `__sqrt`, `__einvf32`, `__eisqrtf32`, `__divf32`)
3. **Apply C28x-specific optimizations**, in order of impact:
   - Replace `sin()`, `cos()`, `sqrt()`, `1.0f/x` with TMU/FPU intrinsics when available.
   - Replace integer division/modulo with bit shifts, masks, or multiply-by-reciprocal.
   - Hoist loop-invariant loads and computations out of the loop body.
   - Convert branch-heavy `if/else` chains to arithmetic or lookup tables.
   - Use `volatile` only where hardware-mandated; remove unnecessary `volatile` on locals.
   - Prefer `float` over `double` — the C28x FPU is single-precision; `double` falls back to software emulation.
   - Use `#pragma FUNC_ALWAYS_INLINE` or `static inline` for small helpers called from the ISR.
   - Align data to 32-bit boundaries where DMA or burst access benefits.
   - Minimize global-variable reads inside loops — copy to a local, compute, write back once.
   - Consider loop unrolling for small, fixed-iteration loops (manual or `#pragma UNROLL`).
4. **Preserve correctness.** The optimized function must produce identical results for all valid inputs. If an optimization changes numerical precision (e.g. reciprocal multiply vs. true divide), state the trade-off explicitly.
5. **Present the result** as:
   - The full rewritten function, ready to drop in.
   - A bullet-point list of each optimization applied and the estimated cycle saving (qualitative: "eliminates ~20-cycle SW div" or quantitative if known from TI docs).
   - Any ASSUMPTIONS called out in ALL CAPS (e.g. input range constraints required by a fast-math replacement).
   - If the function is already near-optimal, say so and explain why.

**Constraints:**
- All output code must compile under the TI C28xx compiler (cl2000) with the project's existing flags.
- Do not introduce dynamic memory allocation (`malloc`, `calloc`).
- Do not add external library dependencies beyond what the project already links (TI driverlib, FPU/TMU libs).
- If a TMU intrinsic is used, note that it requires `--tmu_support=tmu0` compiler flag.
- Respect the project's code-placement rules (e.g. math helpers go in `functions.c`).

## Preferred Response Style

- Be direct.
- Ground explanations in the actual project structure and TI hardware context.
- Mention when advice depends on CCS, the TI compiler, or F28379D peripheral behavior.