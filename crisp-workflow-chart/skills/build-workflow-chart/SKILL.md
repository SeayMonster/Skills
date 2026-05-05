---
name: build-workflow-chart
description: This skill should be used when the user asks to "rebuild the workflow chart", "regenerate the PPTX", "update the workflow chart", "build the Crisp workflow", or mentions changes to "Workflow_Chart_v2" or "Workflow_Chart_v3". It rebuilds the Crisp AI Workflow PowerPoint slide from the build_slide.py script.
allowed-tools: [Read, Edit, Bash, PowerShell, Glob]
---

# Build Workflow Chart

Rebuild the **Claude & AI Workflow — Standard Engagement** PowerPoint slide.

## Key Files

| File | Purpose |
|---|---|
| `Claude Output/build_slide.py` | Master build script — edit this to make changes |
| `Claude Output/Workflow_Chart_v3.pptx` | Current output file |
| `docs/superpowers/specs/2026-05-01-workflow-chart-design.md` | Design spec (colors, layout, section details) |

All paths are relative to:
`C:\Users\MSacia\OneDrive - cantactix.com\Desktop\AI\Professional Services Opportunity Log-BRD-SDD\`

## How to Run

```powershell
cd "C:\Users\MSacia\OneDrive - cantactix.com\Desktop\AI\Professional Services Opportunity Log-BRD-SDD\Claude Output"
py build_slide.py
```

Expected output:
```
Legend bottom: 5.310 inches (slide height: 7.5 inches)
Saved: Workflow_Chart_v3.pptx
File size: 33492 bytes
```

If you get `PermissionError`, the file is open in PowerPoint — close it first, then re-run.

## Making Changes

### Text replacements (tool name, role name, AI callout text)
1. Read `build_slide.py`
2. Find the relevant string using Grep
3. Edit with the Edit tool
4. Re-run the script

### Phase card content
The `phases` list (around line 115) controls each card:
```python
{
    "num": "[4]", "name": "Implementation",
    "role": "Tech Architect",
    "detail": "Scripts, UAT Scenarios\nCode Review",
    "ai": "AI: PowerShell scripts,\nUAT creation (Arcade)",
},
```

### Artifact callout cards
The `artifacts` list (around line 261) controls the three NEW artifact cards under the phase row.

### Document river nodes
- `row1_nodes` — Phase 0 through Phase 3 / SDD versions
- `row2_nodes` — Phase 4 through SDD Final

### Colors
All colors are defined as named constants at the top of `build_slide.py`:

| Constant | Hex | Used for |
|---|---|---|
| `BRAND_TEAL` | `#007672` | Headers, badges, arrows |
| `DEEP_TEAL` | `#003A3F` | Phase card backgrounds |
| `DARK_TEAL` | `#005f5b` | Final deliverable node |
| `MINT` | `#40C1AC` | Phase numbers, river border |
| `ICE_TINT` | `#D1F1E6` | Detail text, review strip |
| `AMBER` | `#B45309` | NEW badge, artifact nodes, v4 |
| `AMBER_BG` | `#FFF8F0` | Callout backgrounds |

## Slide Layout (top to bottom)

```
Title bar (brand teal, 16pt bold)
────────────────────────────────────────
Phase Card Row  [0]→[1]→[2]→[3]→[4]→[5]→[6]
  Each card: phase number (mint) / name (white) / role badge (teal) /
             detail text (ice tint) / AI callout (amber bg, phases 1-5)
────────────────────────────────────────
NEW Artifacts Callout Box (amber border)
  Environment Inventory | Security Mapping Sheet | Tech Discovery Notes
────────────────────────────────────────
Document & Artifact Flow  (two-row river, mint border)
  Row 1: Phase 0 → Executive Brief → … → Phase 3 → SDD v1→v2→v3→v4
  Row 2: Phase 4 → Scripts & UAT Scenarios → … → Phase 6 → SDD Final ✓
────────────────────────────────────────
SDD Review Path (Phase 3)  (ice tint strip, teal left border)
  v1 (teal) → v2 (teal) → v3 (teal) → v4 (amber / Stage Gate ✓)
────────────────────────────────────────
Weekly Project Management bar (brand teal)
Legend row
```

## Slide Dimensions

- Width: 13.33" — Height: 7.5" (widescreen 16:9)
- Margin: 0.25" on each side
- All content ends before 5.5" (plenty of bottom margin)
- Font: Arial throughout
