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
- **Connections between sheets use global net labels.** Local labels are only for nets that stay inside one sheet. Power rails use power symbols (§1.5).

### 1.3 Components: PowerLabKiCadLibraries only

- **Every** symbol and footprint comes from https://github.com/odtu/PowerLabKiCadLibraries. Don't use KiCad's stock libraries or project-local libraries.
- If a part isn't in the repo, **stop and tell the user**. The part is added to PowerLabKiCadLibraries first (symbol + footprint + 3D model), then used. Never silently substitute a "similar" part or a stock-library part.

### 1.4 Wiring

- **Never connect a pin directly to another pin, or put a pin end directly on a junction.** Each pin gets its own wire segment to the junction. At a 4-way node, all four pins reach the junction dot through wires, like a plus sign of wires, not four legs touching.
- Put a junction dot on every T and cross connection. Wires only cross without a dot when they are not connected.
- Use the **2.54 mm (100 mil)** schematic grid. Every symbol, pin, wire, label and junction sits on it.
- Signal flow runs left to right, and power runs top to bottom (higher voltage at the top).

### 1.5 Net naming and power symbols

- **Never use bare `VCC` / `VDD`.** Name each rail by voltage *and* domain: `+5V_DDR`, `+3V3_RF`, `+3V3_MCU`, `+3V3_A`, `+12V_GD`, `+48V_DC` / `VBUS`.
- Grounds get separate names only when they really are separate domains: `GND`, `PGND`, `AGND`, `GND_ISO1`.
- Why: layout rules (net classes, widths, clearances) are assigned by net name, so the names must say what the net is.
- Signal nets are UPPER_SNAKE_CASE and describe the function: `PHASE_A`, `GATE_AH`, `ISENSE_A_P` / `ISENSE_A_N`, `PWM_AH`, `NFAULT` (active-low prefix `N`).
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

### 1.7 Layout notes on the schematic

- Write layout requirements **as text notes next to the parts they concern**, and start each one with `LAYOUT:` so it's easy to find. Examples:
  - `LAYOUT: Place C5 as close as possible to U1 pin 6`
  - `LAYOUT: 50 Ω impedance` (high-speed / RF traces)
  - `LAYOUT: Kelvin connection to R12 pads, route ISENSE_A_P/N as diff pair`
  - `LAYOUT: C20–C22 directly across Q1 drain / Q2 source (hot loop)`
  - `LAYOUT: Keep away from PHASE_A switch node`
- Before starting a PCB layout, collect every `LAYOUT:` note and treat them as requirements alongside §3.

### 1.8 Clean text

- Show only **Reference** and **Value**. Keep every other field (Footprint, MPN, Manufacturer, Datasheet, …) in the symbol but hidden.
- **Don't show extra value details** such as tolerance, voltage rating, power rating or package, *unless* they're what make the part specific. Show them for a 1 % / 2 W current shunt, a 100 V DC-link capacitor, or a 0.1 % divider resistor. A generic 10 k pull-up is just `10k`.
- No overlapping text. References and values never cross each other, wires or symbol bodies. Autoplace the fields, then check visually.
- All text reads horizontally. Keep reference and value on the same side of each symbol, consistently.

### 1.9 Schematic done-checklist

- [ ] A4 + PowerLab drawing sheet on every sheet; title block filled, no raw `${...}`
- [ ] Hierarchical structure, main page with info and images, global labels between sheets
- [ ] All parts come from PowerLabKiCadLibraries
- [ ] No pin-to-pin or pin-on-junction connections
- [ ] No bare VCC/VDD; every rail named by voltage and domain; GND symbols point down, supplies up
- [ ] GND and Power net classes set: GND nets blue and thick, supply nets red and thick
- [ ] `LAYOUT:` notes on every placement- or impedance-critical part
- [ ] Clean text: only Reference + Value, no unnecessary ratings, no overlaps
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
- Before asking for 2 oz copper, first try wider pours, parallel copper on both outer layers, and via arrays (§3.3, §3.4).
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

The board minimums are the **PCBWay standard-price floor** (§2.2), so DRC only rejects what can't be made without a surcharge. The **net classes** below carry the lab defaults, and that's what tracks are routed at. A track may go below the class width, down to 0.15 mm, only locally where a part forces it, e.g. escaping between fine-pitch pads (QFN, ESP32 module, USB-C).

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
| Default | 0.2 mm | 0.2 mm | 0.3 / 0.6 | Logic and low-current signals |
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
- **Place the mounting holes.** M3 = 3.2 mm hole, at least 4 mm from the board edge (hole centre), with a Ø 6–7 mm keepout with no parts or traces. Plated + GND or non-plated (NPTH) depends on the project: **ask the user** before placing them.
- **Place the critical parts, then lock their position and rotation.** This means connectors, switches, LEDs, displays, heatsinked parts: anything whose position the enclosure or the user defines. Connectors sit at the board edge, facing outward.

### 3.2 Placement

- **Separate the analog, digital and power sections physically** to avoid interference. Power enters near its connector and flows in one direction. Sensitive analog (references, ADC inputs, sensor front-ends) is placed furthest from switching parts and high-current paths.
- **Place similar components together**, block by block, matching the schematic sheets. For example, keep the whole power supply section together. KiCad can select all parts from one schematic sheet at once.
- **Decoupling capacitors go right next to the VCC/GND pins of every IC. This is an extremely important rule.**
  - One cap per supply pin. The smallest value goes closest to the pin.
  - Put the via to the plane at the cap pad, so current flows plane → via → cap → pin. Don't connect the cap through a long trace.
  - Keep the loop (cap → pin → GND pin → cap) as small as possible. Place decoupling before any other passives around the IC.
- **Crystals and oscillators** go right next to their MCU pins, with their load caps. Don't route traces under a crystal, and surround it with a GND pour.
- **Orient polarized components (diodes, LEDs, electrolytic/tantalum caps) the same way** wherever possible, to simplify assembly and inspection. Where possible, put pin 1 of ICs in the same corner.
- **Leave enough space for pick-and-place and hand soldering:**

| Item | Rule |
|---|---|
| Part to part | Never overlapping. Normal library parts have **no courtyard** (by design), so DRC won't catch this — check silkscreen outlines and the 3D view. Only RF/magnetic-sensitive parts (ESP32 antenna, magnetic encoders) carry a courtyard + keepout zone; never place anything inside it. |
| Pad to pad between neighbouring parts, hand soldering | ≥ 1.0 mm |
| Parts with Medium/Large footprints (larger hand-solder pads and a silkscreen outline) | Can sit closer than the pad-to-pad rule above: the pads and outline already leave room for the iron. Silkscreen outlines may nearly touch but never overlap. This depends on the user and the design, so ask. |
| Around QFN / QFP / fine-pitch ICs | ≥ 2 mm clear for iron and rework access |
| Tall parts (electrolytics, connectors, inductors) | Don't block access to small parts next to them |
| Smallest passive size | 0603 by default; 0402 only when space forces it |
| Part side | All SMD on **top** where possible (single-sided assembly is cheaper). THT parts all from one side. |
| Parts to board edge | ≥ 3.5 mm for PCBWay machine assembly. If that isn't possible, the board needs breakaway rails, which the user adds during panelization. Tell the user. |
| Small boards | PCBWay assembly needs a panel if the board is < 50 × 100 mm or not rectangular. **The user does panelization.** Don't panelize; just tell the user when it's needed. |

- **Fiducials** are optical marks that help assembly machines align the board. Add them to any board that will be machine-assembled:
  - 3 global fiducials on each side that has SMD parts, in corners, not in a straight line (non-collinear), and not placed symmetrically.
  - Each is a 1 mm copper dot with a 2 mm solder-mask opening and a 3 mm keepout (no silk, no copper).
  - Add a local pair diagonally across any part with pitch ≤ 0.5 mm.
- **Test points:** on every supply rail, GND, and key signals (clocks, resets, communication buses, sense signals). Give each a silkscreen label, and put a GND test point or probe hook near the groups.

### 3.3 Routing

Route in this order: critical high-current paths → clocks and high-speed signals → differential pairs → sensitive analog → everything else. Pour-net fan-out vias come before all of these, and the power rails (pours) before the signals.

**General**
- **Keep traces short and direct. Use 45° corners; never use 90°.** No acute angles (they trap etchant), no stubs, and no dangling traces.
- Don't route traces between fine-pitch pads. Leave pads straight out, then turn.
- Enable teardrops on pad and via connections (KiCad: Edit → Edit Teardrops). They're free and make the joints stronger.

**Pour nets, power rails and pad connections**
- **Never route a pour net between pads.** This covers GND, or any net that has a plane or pour.
  - A pad on a layer with a pour connects through that pour. Don't give every GND pad its own via: it only clutters the board and blocks routing.
  - Add a via at the pad only in these cases:
    - **Decoupling caps:** a via at the cap's GND pad (§3.2: plane → via → cap → pin).
    - **Fine-pitch IC GND pins:** when the pour can't get between the neighbouring pins.
    - **Boxed-in pads:** a pad the pour can't reach because tracks surround it. Check after the pours are filled: DRC lists these as unconnected.
  - The only tracks a pour net has are the short stubs from these pads to their vias.
- **Power rails are copper areas, not traces, even at low current.**
  - Where it fits, run every supply rail as a polygon or pour:
    - on the parts layer, between the regulator, its caps and the loads;
    - or on the power layer (L3) of a 4-layer board.
  - A pour has the lowest impedance and decouples best. Power pins that sit close together (a regulator with its caps, a cap row) always share one area.
  - The pour flows around the pads of other nets (e.g. a switch node between them). Check that it stays in one piece.
  - Where no pour fits, use a track at the Power class width (≥ 0.5 mm) from end to end. Neck down only right at a pin that forces it (a fine-pitch IC pin), and widen again right after it.
  - Autorouters may ignore net-class widths; Freerouting 2.4.1 does. Check every power track after autorouting.
- **Enter a pad straight and end at its centre.**
  - The last segment runs straight into the pad along its axis, square to the edge it crosses, and ends at the pad's centre.
  - A track that only touches the pad's edge, or clips its corner at an angle, is electrically connected but still wrong. It leaves odd copper shapes and pour slivers.
  - Use the pad as the junction. Several tracks of one net can meet at the pad centre, or a track can continue from that pad to the next pad of the net. Don't build a T-junction right beside a pad.
- **No copper islands or slivers next to pads.**
  - Where a track end, its round cap or a short jog sits beside a pad, the pour fills the gap between the track and the pad's clearance ring. That gap becomes a sliver or an island.
  - Route the track into the pad centre so it meets the pad cleanly.
  - Then refill and look at every pad connection.
  - Pours: remove islands, minimum width ≥ 0.25 mm (§3.5).
- **Shortest path, fewest corners.**
  - No detours and no staircases. Approach a pad from the side facing the route, then finish straight into its centre.
  - Every corner is 45° or an arc. Never 90° or sharper, also where two track widths meet.
  - No stubs: remove unused neck-downs and dangling ends.
- **Keep escape room at fine-pitch parts.**
  - Keep about 1.5 mm in front of every fine-pitch pin free of other nets' tracks, on every layer, and keep that lane free of fan-out vias.
  - Don't route other nets under a fine-pitch IC until its pins have escaped.
  - Don't place test points or passives within about 2 mm of a pin row that still has to escape.
  - Give a fine-pitch part its room from the board edge and from holes, e.g. a QFN row facing a shaft hole.

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

  - Above ~3 A, use pours. Stay on 1 oz: share the current between top and bottom copper joined by via arrays (§3.4) before asking for 2 oz.

**High-frequency and clock traces**
- **Keep high-frequency traces (clocks, SPI clock, switching gate signals, etc.) short, and minimise their current loop (trace + return path).**
- Every high-speed trace has a solid reference plane directly underneath. When it changes layer, put a GND via right next to the signal via so the return current can follow.
- Keep other traces ≥ 3× the trace width away from clocks (3W rule). Don't run clocks along the board edge.
- Put series termination resistors (if used) right at the driver pin.

**Differential pairs** (USB, CAN, RS-485, Ethernet)
- Route the two lines together at a constant gap, length-matched, on the same layer and without splitting around obstacles.
- `LAYOUT: 50 Ω` / `90 Ω diff` notes need calculated widths. **Controlled impedance costs extra at PCBWay** (§2.0), so ask before ordering with it. USB full-speed and CAN work fine without it on short runs.

**Ground plane**
- **On a 4+ layer board, the ground plane is a solid, continuous sheet. Never route a high-speed trace over a split or gap in the ground plane.** It forces the return current into a big loop, causing EMI and signal-integrity failure.
- On 2-layer boards, keep bottom-side traces short and don't cut the GND pour into islands. If a bottom trace would block the return path of a top-side signal, jump it with vias instead.

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

### 3.4 Vias

- **Never use blind or buried vias.** Through-hole vias only (they're also outside the standard-price spec).
- **Use tented vias** (solder mask covers the via). This is also the PCBWay standard option.
  - The one exception is thermal vias inside an exposed pad. There the pad's mask opening leaves them open on the pad side; tent them on the other side.
- Don't put vias in SMD pads (except exposed/thermal pads). Keep a solder-mask web between a via and a pad so solder can't wick away.
- **Use vias for high-current areas, and copy that copper to the bottom/top layer for heat problems.** The copper on both layers shares current and spreads heat. Via current budget:
  - 0.3 mm via ≈ 1 A, 0.4 mm via ≈ 1.5 A (conservative)
  - Use at least 2 vias on any power layer change. Place them across the current flow, not in a line along it.
- **Thermal vias** under hot parts and exposed pads: 0.3 mm drill at 1.0–1.2 mm pitch. Use a windowpane paste pattern on large exposed pads.
- **Stitching vias:** tie GND pours on all layers together with vias about every 5 mm, and densely along board edges and around noisy sections.

### 3.5 Copper pours

- Pads connected to pours use **thermal relief** so they can be soldered. The exception is high-current SMD pads, which connect solid.
- Remove isolated copper islands, or stitch them to GND with vias. No floating copper.
- Look at the pour around every pad connection after the fill. A sliver or island between a track and a pad's clearance ring means the track doesn't enter the pad straight at its centre: reroute that end (§3.3).
- Keep copper roughly balanced between top and bottom (pour both sides) to prevent board warp.
- Refill all zones (B) before DRC and before generating outputs.

### 3.6 Silkscreen and board information

- Reference designators: readable, in at most two orientations (0° and 90°), never on pads or under parts. Use the minimum sizes from §2.4.
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
- [ ] No high-speed trace crosses a plane gap; clocks short, with return vias at layer changes
- [ ] High-current paths sized per §3.3; via counts per §3.4
- [ ] GND pads reach the pours (vias only at decoupling caps, fine-pitch GND pins and boxed-in pads); power rails as pours, or tracks at class width; every track enters its pad straight at the centre; no slivers or islands next to pads (§3.3)
- [ ] Only through-hole vias, all tented (except thermal pads)
- [ ] Polarized parts aligned; assembly spacing and fiducials per §3.2
- [ ] Silkscreen clean; board info, logo and website/QR present
- [ ] 3D viewer: no part collisions, connectors facing out, polarities right
- [ ] Print the layout 1:1 on paper and check footprints against the real parts
- [ ] Gerbers checked in the Gerber viewer before ordering
- [ ] Outputs for PCBWay:
  - fabrication: Gerber RS-274X + Excellon drill files, zipped
  - assembly: BOM (`.xlsx`/`.csv` with reference, quantity, MPN, manufacturer, package, SMD/THT) and a position (centroid) file with SMD parts, X/Y, rotation and side, plus an assembly drawing if anything is unusual
