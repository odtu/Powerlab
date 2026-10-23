---
name: pcb-design-rules
description: METU PowerLab PCB design rules for KiCad work — PCBWay standard-price (no-surcharge) spec, fab limits and lab default DRC values, schematic rules, and common PCB layout rules. Use whenever designing, reviewing, or editing a schematic or PCB, setting up KiCad board/DRC constraints or net classes, sizing traces/vias/copper, or checking a layout for manufacturability and layout quality.
---

# PCB Design Rules — METU PowerLab

Target fab: **PCBWay Standard PCB, at standard (no-surcharge) spec**, IPC Class 2.
Sources: https://www.pcbway.com/capabilities.html and the quote form at https://www.pcbway.com/orderonline.aspx (both checked 2026-09-25).

## How to apply these rules

- **Cost comes first.** Every board must fit the standard-price spec in §2.0. Anything outside it adds a surcharge, so ask the user before using it and say which option costs extra.
- Every numeric rule has two columns: **PCBWay min** (the manufacturing limit, already capped at the standard-price spec) and **Lab default** (what to actually use). Design to the lab default. Go below it only locally, only when the part forces it (e.g. fine-pitch pads), and never below the PCBWay min.
- When two rules conflict, the stricter one wins. A project's own `CLAUDE.md` or README can override these; it wins over this file.
- If a design can't meet a rule, don't silently break it. Tell the user which rule, where, and why.
- **Placement distances are targets, not limits.** "Within 2.5 mm", "as close as the layout allows" and the like mean as close as you can. If meeting one would push other parts away from their own pins, go a little further (e.g. 3 mm instead of 2.5 mm) and keep the whole placement short. Fab and assembly limits (§2, "Room for assembly" in §3.2) and keep-out areas stay hard limits.
- Copper weight changes the limits. Always confirm the copper weight (outer and inner) before setting constraints.

---

## 1. Schematic rules

Follow these steps in order when starting a new schematic.

### 1.1 Page setup and title block

- Every sheet is **A4** (landscape).
- Every sheet uses the **METU PowerLab drawing sheet**. It carries the lab logo in the title block.
  - Template source: https://github.com/odtu/Powerlab/tree/master/KiCAD (`METUPowerLab_KiCadSchematicTemplate.kicad_wks`). Take the latest from there; the copy in this skill's `assets/` folder is an offline fallback.
  - Copy it into the project folder and set it with a relative path (Page Settings → Drawing sheet), so it travels with the project.
- The title block uses the text variables `${DESIGNER}`, `${PROJECTNUMBER}` and `${PROJECT_NAME}`. Define them in Schematic Setup → Project → Text Variables, or the title block prints the raw `${...}`. Fill in Title, Revision and Date on every sheet.

### 1.2 Sheet structure

- Always use **hierarchical sheets**, one per functional block. Examples: Power Supply, MCU Core, RF Section, Gate Drive, Power Stage, Current Sensing, Communication. Repeated blocks (e.g. three inverter phases) reuse the same sub-sheet.
- The **root sheet is the main page.** It holds general info and images:
  - project name, revision, and a short description of the board
  - key specs (input voltage range, output/phase current, power, switching frequency, MCU, interfaces)
  - images: a block diagram, board render or photo (placed as images in the schematic)
  - the hierarchical sheet symbols for all sub-sheets, arranged as a block diagram
  - revision history, if the project keeps one
- **Connections between sheets use global net labels.** Inside a sheet, connect with wires (§1.4); use a local label only where a wire would be too long. Power rails use power symbols (§1.5).

### 1.3 Components: PowerLabKiCadLibraries only

- **Every** symbol and footprint comes from https://github.com/odtu/PowerLabKiCadLibraries. Don't use KiCad's stock libraries or project-local libraries.
- **Exception: power symbols come from KiCad's built-in `power` library** (Place → Power Symbols): `power:GND`, `power:+3V3`, `power:+5V`, `power:VBUS`, `power:PWR_FLAG` and so on. They are net markers, not parts. Never make a lab or project library of power symbols.
- If a part isn't in the repo, **stop and tell the user**. The part is added to PowerLabKiCadLibraries first (symbol + footprint + 3D model), then used. Never silently substitute a "similar" part or a stock-library part.
- **Place the library part as it is.** Each lab symbol is one orderable part: its name says which one (`22 µF 100V`), its Value is the plain value (`22 µF`), and its ratings, MPN, manufacturer and distributor numbers are fields of their own. When placing it, don't pass a value or footprint: the part keeps the library's Value and every library field. Never type a rating, package or tolerance into the Value, and never make a project or new library symbol for a part the library already has. A different value or rating is a different lab symbol: pick that one, or replace the part with it.
- After placing, Symbol Properties must list the library's fields (Manufacturer Number, Voltage Rating, …). If a placed part shows only Reference, Value, Footprint, Datasheet and Description, update it from the library (KiCad: Tools → Update Symbols from Library; kicad MCP: `update_symbol_from_library`): that adds the missing fields and puts back the library's Value.
- **Large ICs are split into units.** A microcontroller, DSP, FPGA or any IC with more than about 40 pins is a multi-unit symbol, one unit per function, e.g. power and ground, clock and reset, debug, analog inputs, comparators/PGAs, and GPIO/peripheral banks. Place each unit next to the circuit it serves, on its sheet. If the library symbol is one big block, stop and tell the user: it is split into units in PowerLabKiCadLibraries first, then used. Smaller ICs such as a gate driver stay one unit.

### 1.4 Wiring

- **Never connect a pin directly to another pin, or put a pin end directly on a junction.** Each pin gets its own wire segment to the junction. At a 4-way node, all four pins reach the junction dot through wires, like a plus sign of wires, not four legs touching.
- **Never put a power symbol directly on a pin.** Draw a wire of at least one grid step (2.54 mm) from the pin to the GND or supply symbol, so the connection is visible and the wire takes its net-class colour and width (§1.6).
- **Draw it like a normal schematic: wires, not net labels, inside a sheet.** Place parts that connect next to each other and join them with wires, so the circuit can be read without searching for matching names. Decoupling capacitors, pull-ups, dividers, RC filters, gate resistors and bootstrap parts sit beside the pin they serve and are wired to it, with a short wire to their own GND or supply symbol. Never put a label at both ends of a connection that a short wire could make.
- **Use a net label only where a wire would hurt readability:**
  - the net goes to another sheet (global label, §1.2);
  - the wire would be long (more than about 10 grid steps, 25 mm) or would cross other wires or symbols;
  - the net goes to many places across the sheet, such as an I²C or SPI bus.
- Keep wires short and direct. If a wire gets long, first move the part closer; only if that doesn't work, label both ends instead.
- A wired net that needs a name (for net classes, test points or simulation) gets **one** label on its wire, not a label at every pin.
- Put a junction dot on every T and cross connection. Wires only cross without a dot when they are not connected.
- Use the **2.54 mm (100 mil)** schematic grid. Every symbol, pin, wire, label and junction sits on it.
- Signal flow runs left to right, and power runs top to bottom (higher voltage at the top).

### 1.5 Net naming and power symbols

- **Never use bare `VCC` / `VDD`.** Name each rail by voltage *and* domain: `+5V_DDR`, `+3V3_RF`, `+3V3_MCU`, `+3V3_A`, `+12V_GD`, `+48V_DC` / `VBUS`.
- Grounds get separate names only when they really are separate domains: `GND`, `PGND`, `AGND`, `GND_ISO1`.
- Why: layout rules (net classes, widths, clearances) are assigned by net name, so the names must say what the net is.
- Signal nets are UPPER_SNAKE_CASE and describe the function: `PHASE_A`, `GATE_AH`, `ISENSE_A_P` / `ISENSE_A_N`, `PWM_AH`, `NFAULT` (active-low prefix `N`).
- **Place rails with KiCad's `power` symbols** (§1.3). A power symbol's Value is its net name, so for a rail with no stock symbol, place the closest one and change its Value: `power:+3V3` → `+3V3_MCU`, `power:+5V` → `+5V_SYS`, `power:GND` → `PGND`.
- **GND symbols always point down. VCC and other supply symbols always point up.** Never rotate them sideways.

### 1.6 Net classes and power-net styling

Set these up in Schematic Setup → Net Classes, so every wire picks up its style automatically from its net name. Don't style wires one by one.

- **GND nets are drawn thicker and blue. Supply nets are drawn thicker and red.**

| Net class | Pattern(s) | Schematic wire colour | Schematic wire width |
|---|---|---|---|
| GND | `*GND*` | Blue (0, 0, 255) | 0.3 mm (default wire is 0.15 mm) |
| Power | `+*`, `-*`, `VBUS*` | Red (255, 0, 0) | 0.3 mm |

- These are the same net classes as §2.6, so the PCB rules stay attached. Give the GND class the Power track/clearance values.
- The patterns rely on the net names in §1.5.
- **Set them up when the project is created, before drawing any wire.** With the kicad MCP, `create_netclass` with `projectPath` does it without a board: `name: "GND", patterns: ["*GND*"], schematicColor: "#0000FF", wireWidth: 0.3` and `name: "Power", patterns: ["+*", "-*", "VBUS*"], schematicColor: "#FF0000", wireWidth: 0.3`, plus the track and clearance values from §2.6; then reopen the schematic (File → Revert) so KiCad reads them. Check that a GND wire is blue and thick.

### 1.7 Layout notes on the schematic

- Write layout requirements **as text notes next to the parts they concern**, and start each one with `LAYOUT:` so it's easy to find. Examples:
  - `LAYOUT: Place C5 as close as possible to U1 pin 6`
  - `LAYOUT: 50 Ω impedance` (high-speed / RF traces)
  - `LAYOUT: Kelvin connection to R12 pads, route ISENSE_A_P/N as diff pair`
  - `LAYOUT: C20–C22 directly across Q1 drain / Q2 source (hot loop)`
  - `LAYOUT: Keep away from PHASE_A switch node`
- Before starting a PCB layout, collect every `LAYOUT:` note and treat them as requirements alongside §3.

### 1.8 Clean text

- Show **Reference**, **Value** and the key ratings the library symbol already shows (a capacitor's voltage rating, a resistor's power and tolerance, an inductor's current…). Keep every other field (Footprint, MPN, Manufacturer, Datasheet, …) in the symbol but hidden. Visibility comes from the library: don't hide its ratings and don't show other fields.
- **Ratings are fields, never part of the Value.** A 100 V DC-link capacitor reads `22 µF` with `100V` under it from its Voltage Rating field, not `22 µF 100V`. A generic 10 k pull-up is just `10 kOhm`.
- No overlapping text. References and values never cross each other, wires or symbol bodies. Autoplace the fields, then check visually.
- All text reads horizontally. Keep reference and value on the same side of each symbol, consistently.

### 1.9 Schematic done-checklist

- [ ] A4 + PowerLab drawing sheet on every sheet; title block filled, no raw `${...}`
- [ ] Hierarchical structure, main page with info and images, global labels between sheets
- [ ] Inside each sheet, parts are wired to each other (decoupling caps, pull-ups, dividers beside their pins); labels only between sheets, on buses, or where a wire would be long
- [ ] All parts come from PowerLabKiCadLibraries, placed with all their library fields and the library's Value (no ratings typed into the Value)
- [ ] MCUs and other large ICs (> ~40 pins) placed as multi-unit symbols, each unit beside the circuit it serves
- [ ] No pin-to-pin, pin-on-junction or pin-on-power-symbol connections
- [ ] Power symbols from KiCad's `power` library; no bare VCC/VDD; every rail named by voltage and domain; GND symbols point down, supplies up
- [ ] GND and Power net classes set with their patterns: GND wires blue and 0.3 mm, supply wires red and 0.3 mm (look at a rendered sheet)
- [ ] `LAYOUT:` notes on every placement- or impedance-critical part
- [ ] Clean text: Reference, Value and the library's visible ratings only, no overlaps
- [ ] Every unused pin has `no_connect`, PWR_FLAGs placed, annotation complete, **ERC 0 errors**

---

## 2. Fab limits and DRC values (PCBWay)

### 2.0 Standard-price spec (default for every board)

These are the PCBWay quote-form defaults. Staying inside them avoids surcharges.

| Quote option | Standard (use this) | Costs extra — ask first |
|---|---|---|
| Layers | **2** | 4+ (use 4 only when routing, EMI or the power stage really needs it) |
| Material | FR-4, TG 150–160 | High-TG, Rogers, aluminium, HDI |
| Thickness | **1.6 mm** | Anything else |
| Min track/spacing | **6/6 mil (0.15 mm) or larger** | 5/5, 4/4, 3/3 mil |
| Min hole size | **0.3 mm or larger** | 0.25, 0.2, 0.15 mm |
| Solder mask | **Green** (red, yellow, blue are also free) | Other colours |
| Silkscreen | **White** (black also free) | — |
| Surface finish | **HASL lead-free** | ENIG, ENEPIG, hard gold, etc. |
| Via process | **Tented vias** | Plugged vias |
| Finished copper | **1 oz** outer, 1 oz inner | 2 oz and up |
| Extras | none | Castellated holes, edge plating, impedance control, blind/buried vias, gold fingers, removing the product number |

Cost-driven design habits:
- Keep boards compact. Price scales with area.
- Before asking for 2 oz copper, first try wider pours, parallel copper on both outer layers, and via arrays (§3.3, §3.5).
- Lead-free HASL handles 0.5 mm pitch QFNs and exposed pads fine for prototypes. Propose ENIG only for BGA, pitch below 0.5 mm, or very large exposed pads that must be flat, and ask first.

### 2.1 Board

| Item | PCBWay limit | Lab default |
|---|---|---|
| Layers | 1–14 | **2** (4 if justified and approved) |
| Thickness | 0.2–3.2 mm | **1.6 mm** |
| Thickness tolerance | ±10 % (t ≥ 1.0 mm), ±0.1 mm (t < 1.0 mm) | — |
| Outline tolerance | ±0.2 mm CNC routed, ±0.5 mm V-score | Keep mechanical fits ≥ 0.3 mm loose |
| Min board size | 3 × 3 mm (≥ 20 mm is "normal process") | ≥ 20 mm per side |
| Outer copper | 1–8 oz (surcharge above 1 oz) | **1 oz**; 2 oz only when the current requires it (§3.3) and the user approves |
| Inner copper | 1 / 1.5 / 2 / 3 / 4 oz | 1 oz |
| Surface finish | HASL, LF-HASL, ENIG, OSP, ENEPIG, … | **HASL lead-free** |

### 2.2 Tracks and spacing (per copper weight, "normal process")

| Copper | Width/space min (standard price) | **Lab default width/space** |
|---|---|---|
| 1 oz (35 µm) | 6 / 6 mil (0.15 / 0.15 mm) | **0.20 / 0.20 mm** |
| 2 oz (70 µm) | outer 7 / 8 mil (0.18 / 0.20 mm), inner 6 / 8 mil | **0.25 / 0.25 mm** |
| 3 oz (105 µm) | outer 10 / 12 mil (0.25 / 0.30 mm), inner 8 / 11 mil | **0.30 / 0.35 mm** |

**Hard floor: 0.15 mm / 0.15 mm (6/6 mil).** Anything finer puts the order into a surcharge tier. PCBWay can technically make 4/4 mil, but don't use it.
Hatched/grid copper needs larger values (1 oz: 9/11 mil). Prefer solid pours.

### 2.3 Drills, vias, annular ring

| Item | PCBWay limit | Lab default |
|---|---|---|
| Min drill | **0.3 mm** at standard price (0.15–0.25 mm costs extra) | 0.3 mm |
| Max drill | 6.0 mm (larger is milled) | — |
| Aspect ratio (thickness : drill) | ≤ 8 normal | ≤ 6 (1.6 mm board → drill ≥ 0.3 mm) |
| Annular ring, via (1 oz / 2 oz / 3 oz outer) | 5 / 7 / 8 mil (0.13 / 0.18 / 0.20 mm) | **0.15 mm** (1 oz), 0.2 mm (2–3 oz) |
| Annular ring, component hole (1 / 2 / 3 oz) | 10 / 12 / 14 mil (0.25 / 0.30 / 0.36 mm) | 0.3 mm (1 oz), 0.36 mm (2–3 oz) |
| Hole-to-hole, vias (≤ 0.45 mm) | 11 mil (0.28 mm) | 0.4 mm |
| Hole-to-hole, component holes | 16 mil (0.41 mm) | 0.5 mm |
| Inner-layer hole-to-copper (4 L / 6 L) | 7 / 8 mil (0.18 / 0.20 mm) | 0.25 mm |
| PTH finished-hole tolerance | ±0.08 mm | Size holes for lead + 0.2–0.3 mm |
| NPTH tolerance | ±0.05 mm | — |
| Plated slot width | ≥ 0.5 mm | ≥ 0.6 mm |
| Non-plated slot width | ≥ 0.8 mm | ≥ 1.0 mm |
| Castellated holes | Ø ≥ 0.5 mm, edge-to-edge ≥ 0.3 mm | Ø 0.6 mm |
| Via plugging (for via-in-pad) | Ø 0.2–0.4 mm, board 0.4–2.4 mm, **costs extra** | Don't use; tented vias are standard |

**Standard lab vias:**
- Signal: **0.3 mm drill / 0.6 mm pad**
- Power / thermal: **0.4 mm drill / 0.8 mm pad** (2 oz: 0.4 / 0.85 mm)

### 2.4 Solder mask and silkscreen

| Item | PCBWay limit | Lab default |
|---|---|---|
| Mask expansion (opening beyond pad) | ≥ 2 mil (0.05 mm) | 0.05 mm |
| Mask bridge (web), < 2 oz, green | 4 mil (0.10 mm) | 0.10 mm |
| Mask bridge, < 2 oz, black/other colours | 4.5 mil (0.115 mm) | 0.12 mm |
| Mask bridge, ≥ 2 oz | 5 mil (0.13 mm) | 0.13 mm |
| Silkscreen line width | 0.15 mm | 0.15 mm |
| Silkscreen text height | 0.8 mm | **1.0 mm** (1.2 mm for connector/polarity labels) |
| Width : height ratio | 1 : 5 recommended | 0.15–0.2 mm stroke for 1.0 mm text |
| Silk over pads / exposed copper | not allowed | keep ≥ 0.1 mm clear |

Green, red, yellow and blue mask, and white or black silk, cost nothing extra.

### 2.5 Board edge and panelization

| Item | PCBWay limit | Lab default |
|---|---|---|
| Copper to CNC-routed edge | 0.25 mm (0.20 mm "medium") | **0.5 mm** |
| Copper to V-score line | — | 1.0 mm |
| Board-to-board gap, tab routing | 1.6 mm | 2.0 mm |
| Board-to-board gap, V-score | 0 mm | 0 mm |
| V-score board thickness | 0.6–2.4 mm | — |

### 2.6 KiCad setup (Board Setup → Design Rules → Constraints)

Defaults for a **1 oz** board. For 2 oz or 3 oz, take the values from the tables above.

The board minimums are the **PCBWay standard-price floor** (§2.2), so DRC only rejects what can't be made without a surcharge. The **net classes** below carry the lab defaults, and that's what tracks are routed at. Signal tracks are 0.15 mm (the Default class); give a signal more only where it carries current or there's room and a reason. Power and GND tracks are sized for their current.

Put these values in **Board Setup** itself (File → Board Setup → Design Rules → Constraints and Net Classes), not only in a `.kicad_dru` rule, and check them there before routing. With the kicad MCP, `set_design_rules` with `preset: "powerlab"` sets them, `create_netclass` the Power and GND classes, and `get_design_rules` shows what the board holds. A board whose Board Setup still shows KiCad's defaults (minimum clearance 0, track 0.2, annular ring 0.1, via 0.5 mm) isn't set up.

| KiCad constraint | Value |
|---|---|
| Minimum clearance | 0.15 mm |
| Minimum track width | 0.15 mm |
| Minimum connection width | 0.15 mm |
| Minimum annular width | 0.15 mm |
| Minimum via diameter | 0.6 mm |
| Copper to hole clearance | 0.25 mm |
| Copper to edge clearance | 0.5 mm |
| Minimum through hole | 0.3 mm |
| Hole to hole clearance | 0.4 mm |
| Minimum uvia / blind vias | not allowed |
| Solder mask expansion | 0.05 mm |
| Solder mask min web width | 0.1 mm |
| Minimum silk text height | 1.0 mm |
| Minimum silk thickness | 0.15 mm |

**Default net classes:**

| Net class | Track | Clearance | Via (drill/pad) | Use for |
|---|---|---|---|---|
| Default | 0.15 mm | 0.2 mm | 0.3 / 0.6 | Logic and low-current signals |
| Power | sized for current (≥ 0.5 mm) | 0.3 mm | 0.4 / 0.8 | Supply rails, DC bus, phase outputs (schematic: red, thick — §1.6) |
| GND | sized for current (≥ 0.5 mm) | 0.3 mm | 0.4 / 0.8 | All ground nets (schematic: blue, thick — §1.6) |
| HV | sized for current | per voltage (§3.3) | 0.4 / 0.8 | Any net > 50 V |

Run DRC with zones refilled before calling any layout done. Zero unexplained errors. Waivers are documented in the project.

---

## 3. PCB layout rules

Follow these steps in order when laying out a board. Before starting, collect every `LAYOUT:` note from the schematic (§1.7). They are requirements too.

### 3.1 Board setup, outline and fixed parts

- Set up the stackup, DRC constraints and net classes from §2 before placing anything.
  - **2 layers** (default): route mostly on top. Keep the bottom as an unbroken GND pour as far as possible.
  - **4 layers** (only when justified, §2.0): L1 signals + parts / **L2 solid GND** / L3 power / L4 signals.
- **Draw the board outline first** on Edge.Cuts, as one closed shape, with dimensions from the enclosure or mechanical drawing. A 1 mm corner radius is recommended.
- **Place the mounting holes.** M3 = 3.2 mm hole, at least 4 mm from the board edge (hole centre), with a **Ø 8 mm keepout** (an M3 washer is 7 mm across) with no parts or tracks, on every layer. Use a 3.4 mm hole when the hole positions aren't precise. Plated + GND or non-plated (NPTH) depends on the project: **ask the user** before placing them.
- **Place the critical parts, then lock their position and rotation.** This means connectors, switches, LEDs, displays, heatsinked parts: anything whose position the enclosure or the user defines. Connectors sit at the board edge, facing outward.

### 3.2 Placement

Place block by block, in this order: fixed parts (§3.1) → power stage and hot loops → each IC with its decoupling caps first, then its other pin passives → everything else. Finish each block, connections and ratsnest included (below), before starting the next. Silkscreen and labels come last, after the whole placement (§3.6).

**Short connections come first.** Put each part where its connections are shortest, and pack the parts as tightly as assembly allows ("Room for assembly", below). Short connections need short tracks and few vias, and leave room for the rest of the routing. A block that looks uneven but has short airwires is better than a tidy grid with long ones.
- **Use both sides** when the board has parts on both. A passive may go on the other side, right under the pin it serves, when that's shorter than any place on the IC's own side. That includes decoupling caps when the IC's side has no room at that pin. Where a rule allows no via between a part and its pin (bootstrap caps, hot-loop caps), keep that part on the pin's side.
- **Stack blocks that talk to each other** on the two sides: e.g. the gate driver under the MCU or under the half bridge, the MOSFETs under their power pours. Their connections are then a via long.
- **Rotations follow the board.** On a rectangular board, turn parts to 0°, 90°, 180° or 270°. On a round board, parts may follow the circle (along its radius or its tangent where they sit); don't force them into 45° steps there.

- **Separate the analog, digital and power sections physically** to avoid interference. Power enters near its connector and flows in one direction. Sensitive analog (references, ADC inputs, sensor front-ends) is placed furthest from switching parts and high-current paths.
- **Place similar components together**, block by block, matching the schematic sheets. For example, keep the whole power supply section together. KiCad can select all parts from one schematic sheet at once. Inside a block, each part goes where its connections are, not into a neat grid.
- **Decoupling capacitors go right next to the VCC/GND pins of every IC. This is an extremely important rule.**
  - One cap per supply pin. The smallest value goes closest to the pin.
  - Distance: each 100 nF cap as close to its pin as you can, about 2.5 mm as the target (3 mm is fine when closer would push other parts out of place); bulk caps (µF) within about 25 mm of the IC. A layout recommendation in the IC's datasheet wins.
  - Put the via to the plane at the cap pad, so current flows plane → via → cap → pin. Don't connect the cap through a long trace.
  - Keep the loop (cap → pin → GND pin → cap) as small as possible. Place decoupling before any other passives around the IC.
- **Crystals and oscillators** go right next to their MCU pins (within about 10 mm, on the same side), with their load caps beside the crystal, placed symmetrically. Don't route any track under a crystal or its load caps, on any layer, and surround it with a GND pour.
- **Switching converters and half bridges: place the hot loop first.** The input ceramic capacitor is the first part placed after the switches:
  - right at a regulator's VIN and PGND pins, or bridging the high-side drain and low-side source of each half-bridge leg (one cap per pin pair or per leg);
  - capacitor, switches and diode on the same side and connected on the same layer, with no via inside the loop; the layer under the loop is solid GND;
  - keep the switch-node copper only as large as its current needs, and put the feedback divider right at the IC's FB pin, away from the switch node and the inductor.
- **Gate drivers and magnetics**: place each gate driver as close to its MOSFETs as the layout allows, so its gate and return tracks are short and reach the switch without crossing the high-current copper. Its bootstrap and supply caps sit right at the driver's pins, with no via between cap and pin. Plan the routes so no track has to pass under an inductor or transformer (§3.4).
- **Power input protection sits at the input connector, in order:** connector → reverse-polarity protection → fuse or eFuse → TVS → bulk capacitor → the rest of the board. Nothing branches off before the chain.
- **TVS and ESD diodes go at the connector, not at the IC.** The line runs connector → TVS pad → protected IC: through the TVS pad without a stub, and with no via between the connector and the TVS. The TVS GND pad goes straight into the GND pour with a via right at the pad (two or more for surge parts). Keep unprotected tracks away from the protected ones.
- **Radio modules (ESP32, Bluetooth, Wi-Fi) and antennas:** put the antenna end at the board edge, overhanging it where the module datasheet shows that. No copper on any layer under the antenna or inside its keepout. Keep metal parts, screws, batteries, tall connectors and cables at least 10 mm from the antenna (Espressif asks for 15 mm inside the enclosure), and keep switching converters, inductors and crystals away from it. Modules with a u.FL or SMA antenna connector don't need the keepout.
- **Orient polarized components (diodes, LEDs, electrolytic/tantalum caps) the same way** wherever possible, to simplify assembly and inspection. Where possible, put pin 1 of ICs in the same corner.

**Place passives by their connections.** A layout that looks tidy from a distance can still have half its passives turned the wrong way or in each other's places. Placement isn't done until every part passes these:
- **On the right side of its IC, in pin order.** A passive serving an IC pin sits on the side of the IC where that pin is, next to it. A row of such parts follows the order of the pins it serves, so their tracks run side by side and never cross.
- **Pads face their connections.** Turn every 2-pad part so the pad on the IC pin's net faces that pin, and the other pad faces where it goes (the GND via or pour, the supply, the next part of a chain). If turning it 180° makes its airwires shorter or uncrossed, turn it.
- **Chains in signal order.** A divider, RC filter, LED + resistor, gate resistor + pull-down or snubber is laid out in the order the signal flows: source → R → node → C/R → GND. The node that goes to the IC pin is the pad nearest that pin; the GND end is the far end, at its via.
- **Decoupling caps:** the supply pad faces the VDD pin; the GND pad faces that pin's GND (the GND pin next to it or the exposed pad), with its via at the GND pad.
- **Rows of like parts** (decaps, divider banks, pull-ups) share one orientation, aligned, with the same net on the same side, e.g. all GND pads in one line, so the GND pour or a via row serves them all.
- **Swap parts that are in each other's place.** If two parts' airwires cross, or one part's airwire runs past another part to reach its pin, swap them. Two caps on one rail can take either place; a part's net decides its place, not its reference.
- **Check the ratsnest after each block,** before going on: no airwire crossings inside the block, no airwire jumping over another part of the block, every airwire short. Measure with `get_ratsnest` / `estimate_airwire_lengths`, and look at a close-up (`powerlab-visual-review`). Then try a 180° turn or a swap for each passive, and keep what shortens the airwires.

**Room for assembly** (`check_part_spacing` measures it; library parts have no courtyard, so DRC can't):

| Item | Rule |
|---|---|
| Part to part | Never overlapping, bodies included. Only RF/magnetic-sensitive parts (ESP32 antenna, magnetic encoders) carry a courtyard + keepout zone. Nothing goes inside an antenna keepout. For a magnetic encoder, the requirements say what may go inside (often small passives, never switching parts, magnetics, shunts or power copper). |
| Pad to pad between neighbouring parts | **Machine assembly: ≥ 0.5 mm** (PCBWay handles 0.25 mm; 0.5 mm leaves room for rework). **Hand soldering: ≥ 1.0 mm.** `design-requirements.md` says which. |
| Around QFN / QFP / fine-pitch ICs | Parts not connected to the IC: about 2 mm from its pins, closer where the escape lanes of its pins stay free. Its own decoupling caps and pin passives sit right at their pins (≥ 0.5 mm), leaving the escape lanes of the other pins free (§3.4). |
| Keep-out areas | Apply to **both sides** unless the requirement says one side only; ask if it's unclear. |
| Through pads of a part on the other side | Thermal vias in a MOSFET or regulator pad and THT pins are copper on both sides: no pad of another net on them, and nothing within the pad-to-pad rule. |
| Tall parts (electrolytics, connectors, inductors) | Don't block access to small parts next to them |
| Smallest passive size | 0603 by default; 0402 only when space forces it |
| Part side | All SMD on **top** where possible (single-sided assembly is cheaper). THT parts all from one side. |
| Parts to board edge | ≥ 3.5 mm for PCBWay machine assembly. If that isn't possible, the board needs breakaway rails, which the user adds during panelization. Tell the user. |
| Small boards | PCBWay assembly needs a panel if the board is < 50 × 100 mm or not rectangular. **The user does panelization.** Don't panelize; just tell the user when it's needed. |

- **Fiducials** are optical marks that help assembly machines align the board. Add them to any board that will be machine-assembled:
  - 3 global fiducials on each side that has SMD parts, in corners, not in a straight line (non-collinear), and not placed symmetrically.
  - Each is a 1 mm copper dot with a 2 mm solder-mask opening and a 3 mm keepout (no silk, no copper).
  - Add a local pair diagonally across any part with pitch ≤ 0.5 mm.
- **Test points:** on every supply rail, GND, and key signals (clocks, resets, communication buses, sense signals). Give each a silkscreen label, and put a GND test point or probe hook near the groups. The programming/debug connector (SWD, JTAG, UART boot) stays reachable with the board in its enclosure.
  - Keep them small: SMD `METUPowerLab_TestPoints_SurfaceMounts:Pad_D1.0mm` by default; through-hole `METUPowerLab_TestPoints_ThroughHoles:Pad_D1.5mm_Drill0.8mm` for a probe tip, `Pad_D2.0mm_Drill1.0mm` for a probe hook or test loop. `Pad_D1.5mm` (SMD) only where a pogo-pin fixture asks for it. `Pad_D3.0mm_Drill1.3mm` is a wire pad (AWG18), not a test point.

### 3.3 Copper pours and high-current copper

Lay the copper before routing any signal, in this order:
1. **Power pads:** give every pad that carries power its copper area.
2. **Pour nets:** GND (and any other plane net) as pours. **No fan-out vias at this stage:** the pads connect through the pour. The only via placed now is at each decoupling cap's GND pad (§3.2).
3. Then route the tracks (§3.4).

**Power pads get their copper first**
- Every pad in a power path sits in a copper area sized for its current. This covers MOSFET drain/source and diode pads, inductor and transformer pads, shunts, bulk and DC-link caps, regulator input/output pads, and the power pins of connectors.
- Draw these areas before any signal track, so the power path gets the room it needs and the signals route around it.
- Don't leave a power pad to the router, and don't connect it with a thin track. After the fill, check every power pad: it must sit in its area, solidly connected (high-current SMD pads on power pours have no thermal relief, see below; GND pads always do).

**Pour nets and power rails**
- **Never route a pour net between pads.** This covers GND, or any net that has a plane or pour.
  - A pad on a layer with a pour connects through that pour. **Never fan out GND pads with vias up front, and never give every GND pad its own via:** it only clutters the board and blocks routing.
  - Before routing, the only GND vias are at **decoupling caps:** a via at the cap's GND pad (§3.2: plane → via → cap → pin).
  - A fine-pitch IC GND pin next to a GND exposed pad joins the exposed pad straight across the gap, without a via.
  - **After all routing**, fill the pours and run DRC. A pad the pour still can't reach shows up as unconnected: a pad boxed in by tracks, or a fine-pitch GND pin the pour can't get between its neighbours to. Give only that pad a via, with a short stub.
  - The only tracks a pour net has are the short stubs from these pads to their vias.
- **Power rails are copper areas, not traces, even at low current.**
  - Where it fits, run every supply rail as a polygon or pour:
    - on the parts layer, between the regulator, its caps and the loads;
    - or on the power layer (L3) of a 4-layer board.
  - A pour has the lowest impedance and decouples best. Power pins that sit close together (a regulator with its caps, a cap row) always share one area.
  - The pour flows around the pads of other nets (e.g. a switch node between them). Check that it stays in one piece.
  - Where no pour fits, use a track at the Power class width (≥ 0.5 mm) from end to end. Neck down only right at a pin that forces it (a fine-pitch IC pin), and widen again right after it.
  - Check every power track's width after routing.

**High current**
- **Use polygons/power planes for high-current paths if you can. Otherwise, use a wide trace.** Size width for the current using IPC-2221:

```
I = k · ΔT^0.44 · A^0.725       A = cross-section in mil², ΔT = temperature rise in °C
k = 0.048 (outer layer), 0.024 (inner layer);  width [mil] = A / (1.378 · oz)
```

  Lab default is **ΔT = 10 °C** on **1 oz** copper (standard price, §2.0):

| Current | Outer layer width | Inner layer width |
|---|---|---|
| 1 A | 0.3 mm | 0.8 mm |
| 2 A | 0.8 mm | 2.1 mm |
| 3 A | 1.4 mm | 3.6 mm |
| 5 A | 2.8 mm | 7.3 mm |
| 10 A | 7.3 mm | use a pour |

  - Above ~3 A, use pours. Stay on 1 oz: share the current between top and bottom copper joined by via arrays (§3.5) before asking for 2 oz.

**Voltage clearance** (IPC-2221B minimum conductor spacing; used by the HV net class, §2.6)

| Voltage between nets (DC or AC peak) | Outer layer, uncoated (B2) | Inner layer (B1) |
|---|---|---|
| 0–30 V | 0.10 mm (fab minimum §2.2 applies) | 0.05 mm (fab minimum applies) |
| 31–100 V | 0.60 mm | 0.10 mm |
| 101–150 V | 0.60 mm | 0.20 mm |
| 151–300 V | 1.25 mm | 0.20 mm |
| 301–500 V | 2.50 mm | 0.25 mm |
| > 500 V | 0.005 mm/V | 0.0025 mm/V |

- Mains-connected or isolated designs follow IEC 62368-1 / IEC 60664-1 instead, which need much larger distances. Ask the user for the standard and insulation class before laying these out.

**Pour quality**
- Pads connected to pours use **thermal relief** so they can be soldered.
  - **GND pours and planes always use thermal reliefs, never solid**, also for high-current GND pads: give those wider spokes (up to the pad's width) or more of them instead.
  - The exception is high-current SMD pads on power pours (e.g. a MOSFET drain on its DC-bus copper, a switch node, a phase output), which connect solid.
- Remove isolated copper islands, or stitch them to GND with vias. No floating copper. Minimum pour width ≥ 0.25 mm.
- Look at the pour around every pad connection after the fill. A sliver or island between a track and a pad's clearance ring means the track doesn't enter the pad straight at its centre: reroute that end (§3.4).
- Keep copper roughly balanced between top and bottom (pour both sides) to prevent board warp.
- Refill all zones (B) before DRC and before generating outputs.

### 3.4 Routing

Copper comes first (§3.3): power pads, power rails and pour nets (no GND fan-out vias; only decoupling-cap vias). Then route in this order: switching and gate-drive loops → clocks and high-speed signals → differential pairs → sensitive analog → everything else.

**General**
- **Keep traces short and direct. Use 45° corners; never use 90°.** No acute angles (they trap etchant), no stubs, and no dangling traces.
- **Only three directions: 0°, 45° and 90°.** No track runs at any other angle, not even a short one: a run between two points that aren't in line goes straight, bends 45° and goes straight again (into the pad along its axis), never as one slanted line.
- **Same-net pads next to each other connect directly**, with the shortest straight track between them (a decoupling cap's pad to its IC pin, two parallel caps, a filter bead to its cap). Never run that connection round a part, out and back, or through a via when a direct track on the pads' layer is free.
- **Parallel runs stay parallel.** Lines that run together (a bus, SPI, JTAG) keep one pitch and bend together at the same 45° steps; one line doesn't take a kink or a different angle where its neighbours go straight.
- After routing, check the tracks for these (angles, corners, kinks, detours, pad entries, solid GND pads) and fix them before DRC and the review: DRC passes them. With the kicad MCP, `check_routing` lists them.
- Don't route traces between fine-pitch pads. Leave pads straight out, then turn.
- Enable teardrops on pad and via connections (KiCad: Edit → Edit Teardrops). They're free and make the joints stronger.

**Pad connections**
- **Enter a pad straight and end at its centre.**
  - The last segment runs straight into the pad and ends at the pad's centre: along its axis, square to the edge it crosses, or at 45° straight to the centre where the pad isn't fine pitch. Don't add a bend just before the pad only to come in square.
  - A track that only touches the pad's edge, or clips its corner at an angle, is electrically connected but still wrong. It leaves odd copper shapes and pour slivers.
  - Use the pad as the junction. Several tracks of one net can meet at the pad centre, or a track can continue from that pad to the next pad of the net. Don't build a T-junction right beside a pad.
  - **No duplicate tracks.** Never run a second track of a net beside or on top of one it already has: join the existing track (a T-junction away from the pads) or the pad. Two tracks of a net leave a pad in different directions.
- **No copper islands or slivers next to pads.** A track end, round cap or jog beside a pad leaves a pour sliver or island between it and the pad's clearance ring; entering straight at the centre avoids it (check after the fill, §3.3).
- **Shortest path, fewest corners.**
  - No detours and no staircases. Approach a pad from the side facing the route, then finish straight into its centre.
  - A track bends only where something forces it: no wiggles round pads, no loops or U-turns round a via or pad.
  - Every corner is 45° or an arc. Never 90° or sharper, also where two track widths meet.
  - No stubs: remove unused neck-downs and dangling ends.
- **Keep escape room at fine-pitch parts.**
  - Keep about 1.5 mm in front of every fine-pitch pin free of other nets' tracks, on every layer, and keep that lane free of vias.
  - Don't route other nets under a fine-pitch IC until its pins have escaped.
  - Don't place test points or passives within about 2 mm of a pin row that still has to escape.
  - Give a fine-pitch part its room from the board edge and from holes, e.g. a QFN row facing a shaft hole.

**Switching signals and magnetics**
- **No tracks under inductors, transformers, chokes or other coils**, on any layer. Their magnetic field couples into a track that passes under the body. Route around the part's outline; only the part's own pads connect to it. A solid GND pour may stay under the part; signal and power tracks may not.
- **Switching signals don't share a layer with high-current copper.** Gate drive (driver → gate → source/Kelvin return), PWM, bootstrap and switch-node sense tracks run on a layer where that area has no high-current pour. The switching edges couple into the power copper next to them, and the power copper's noise couples back into the gate.
  - Plan it at placement (§3.2): put the gate driver where its tracks reach the switches without crossing the power copper.
  - Where a switching track must leave the power layer, run its return beside it and use a signal + return via pair side by side. This rule wins over avoiding vias on fast signals.
  - If the two can't be separated by layer, tell the user where, and keep the switching track short, never running alongside the high-current copper.
- **Gate return is Kelvin.** Use the MOSFET's Kelvin-source pin if it has one; otherwise take the return from the foot of the source pin with its own track, never through the power copper. Run gate and return side by side, or stacked on the next layer.
- **Current-sense shunts use Kelvin connections.** The two sense tracks leave from the inner edge of the shunt pads, carry no load current, run together as a pair to the amplifier, and keep away from the switch node and inductors.

**High-frequency and clock traces**
- **Keep high-frequency traces (clocks, SPI clock, switching gate signals, etc.) short, and minimise their current loop (trace + return path).**
- **Avoid vias on high-speed signals if you can**: route each one on a single layer from driver to load. A via adds inductance and breaks the return path.
- Every high-speed trace has a solid reference plane directly underneath. When it must change layer, put a GND via right next to the signal via so the return current can follow.
- Keep other traces ≥ 3× the trace width away from clocks (3W rule). Don't run clocks along the board edge.
- Put series termination resistors (if used) right at the driver pin.

**Differential pairs** (USB, CAN, RS-485, Ethernet)
- Route the two lines together at a constant gap, length-matched, on the same layer and without splitting around obstacles. No vias if you can; if they must change layer, both lines change together at the same spot.
- `LAYOUT: 50 Ω` / `90 Ω diff` notes need calculated widths. **Controlled impedance costs extra at PCBWay** (§2.0), so ask before ordering with it. USB full-speed and CAN work fine without it on short runs.

**Ground plane**
- **On a 4+ layer board, the ground plane is a solid, continuous sheet. Never route a high-speed trace over a split or gap in the ground plane.** It forces the return current into a big loop, causing EMI and signal-integrity failure.
- On 2-layer boards, keep bottom-side traces short and don't cut the GND pour into islands. If a bottom trace would block the return path of a top-side signal, jump it with vias instead.

### 3.5 Vias

- **Never use blind or buried vias.** Through-hole vias only (they're also outside the standard-price spec).
- **Use tented vias** (solder mask covers the via). This is also the PCBWay standard option.
  - The one exception is thermal vias inside an exposed pad. There the pad's mask opening leaves them open on the pad side; tent them on the other side.
- Don't put vias in SMD pads (except exposed/thermal pads). Keep at least 0.25 mm from the pad edge to the via's ring, with a solder-mask web between them, so solder can't wick away.
- No vias on high-speed signals if you can avoid them (§3.4). Where one is needed, a GND via goes right next to it.
- **Use vias for high-current areas, and copy that copper to the bottom/top layer for heat problems.** The copper on both layers shares current and spreads heat. Via current budget:
  - Plan **0.5 A per 0.3 mm via** and **0.7 A per 0.4 mm via**: vias needed ≥ current ÷ current per via. In hot or critical paths, plan 0.2–0.3 A per via. Published values range from 0.2 A to about 1 A per via; these sit on the safe side.
  - Use at least 2 vias on any power layer change. Place them across the current flow, not in a line along it.
- **Thermal vias** under hot parts and exposed pads: 0.3 mm drill at 1.0–1.2 mm pitch, connected to the planes solid (no thermal spokes). Use a windowpane paste pattern on large exposed pads.
- **Stitching vias:** tie GND pours on all layers together with vias about every 5 mm, and densely along board edges and around noisy sections. Around a radio module and along an RF feed line, every 3 mm or closer.

### 3.6 Silkscreen and board information

Do the silkscreen after the placement is finished. Don't move parts for their labels while placing; place for the connections, then fit the labels.

- Reference designators: readable, in at most two orientations (0° and 90°), never on pads, other outlines or under parts, and unmistakably next to their own part (in a row, all above or all below). Use the minimum sizes from §2.4; lab footprints print the label as a `${REFERENCE}` silkscreen text, not the Reference field. Where a dense block has no room, a short group label (e.g. `R14–R21`) or the fab layer is better than labels on top of each other.
- Polarity marks, pin-1 markers and diode bands must stay visible after assembly (outside the part body).
- Label connector pins and signals. Show voltage and polarity at every power input (e.g. `+24V  GND`, `+  −`).
- **Put the board information on every board:**
  - project name, version, date
  - design team members' names
  - organization logos (METU PowerLab)
  - website: `power.eee.odtu.edu.tr` / `github.com/odtu`, or a QR code
  - Use text variables in the PCB text (`${PROJECT_NAME}`, `${REVISION}`, `${ISSUE_DATE}`) so the board info stays in sync with the schematic title block.
  - Make the logo and QR code into footprints with KiCad's Image Converter. The lab QR code image is `PowerLabQrCode.png` at https://github.com/odtu/Powerlab/tree/master/KiCAD. Make the QR code at least ~12 mm wide and check that it scans in the 3D viewer render.

### 3.7 Final checks and outputs

- [ ] All zones refilled; **DRC 0 errors**, including schematic parity (no missing or extra parts or nets)
- [ ] Every `LAYOUT:` note from the schematic is satisfied
- [ ] Decoupling caps right at their IC pins; crystals right at the MCU
- [ ] Hot loops small with the input caps at the switches; gate drivers and their bootstrap caps close; gate returns and shunt sense tracks Kelvin (§3.2, §3.4)
- [ ] Input protection at the connector in order; TVS diodes at their connectors; antenna at the edge with its keepout clear on every layer (§3.2)
- [ ] No high-speed trace crosses a plane gap; clocks short, with return vias at layer changes
- [ ] High-current paths sized per §3.3; via counts per §3.5
- [ ] Every power pad sits in its copper area, laid before the signal routing (§3.3)
- [ ] No tracks under inductors or transformers; switching tracks not on the same layer as high-current copper; high-speed signals without vias where possible (§3.4)
- [ ] GND pads reach the pours (vias only at decoupling caps, plus pads still unconnected after routing); power rails as pours, or tracks at class width; every track enters its pad straight at the centre; no slivers or islands next to pads (§3.3, §3.4)
- [ ] Only through-hole vias, all tented (except thermal pads)
- [ ] Tracks only at 0°, 45° and 90°, no 90° corners or kinks, same-net neighbours joined directly, parallel runs parallel; GND pads with thermal reliefs (`check_routing` clean, §3.3, §3.4)
- [ ] Board Setup shows the lab constraints and net classes (§2.6), not KiCad's defaults; signal tracks 0.15 mm; test points small (§3.2)
- [ ] Parts placed for short connections, on both sides where that's shorter; passives with pads facing their pins, rows in pin order, chains in signal order, no crossing airwires inside a block (§3.2)
- [ ] Polarized parts aligned; assembly spacing, keep-outs (both sides) and fiducials per §3.2 (`check_part_spacing` clean)
- [ ] Silkscreen clean; board info, logo and website/QR present
- [ ] 3D viewer: no part collisions, connectors facing out, polarities right
- [ ] For the user before ordering: print the layout 1:1 on paper and check footprints against the real parts; check the Gerbers in a Gerber viewer
- [ ] Outputs for PCBWay:
  - fabrication: Gerber RS-274X + Excellon drill files, zipped
  - assembly: BOM (`.xlsx`/`.csv` with reference, quantity, MPN, manufacturer, package, SMD/THT) and a position (centroid) file with SMD parts, X/Y, rotation and side, plus an assembly drawing if anything is unusual
