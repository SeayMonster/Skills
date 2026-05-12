---
name: crisp-bc:sdd
description: >-
  Generate a Solution Design Document (SDD) from a completed Opportunity Log and Business Requirements Document (BRD). 
  This skill ensures all information flows correctly from the Opportunity Log through the BRD into a comprehensive, 
  client-facing SDD with Crisp branding. Use this skill when creating, updating, or reviewing SDDs for Professional 
  Services engagements. Triggers include: SDD, Solution Design Document, "create an SDD", "generate SDD from BRD", 
  "populate the SDD", or any request involving the Professional Services document workflow 
  (Opportunity Log -> BRD -> SDD).
---

# Professional Services SDD Generation Skill

## Overview

This skill governs the end-to-end document workflow for Crisp Professional Services engagements:

**Opportunity Log** -> **BRD** -> **SDD**

Each document builds on the previous one. The SDD is the final client-facing deliverable provided at project completion.

---

## Document Flow

### 1. Opportunity Log (Excel)
- **Purpose:** Serves as basis for the Solution deck and the SOW. Developed concurrently with the assessment. Captures each recommended solution.
- **Usage:** Can be distilled to create the Solutions Presentation deck and used by the client to prepare their business case.
- **Rules:**
  - Not necessary to fill every field if not applicable
  - Be granular on each line — don't combine opportunities that cross areas, applications, or consultants
- **File:** `OPPORTUNITY_LOG_Template.xlsx`
- **Sheets:** Template, Instructions, Sample, Dropdowns
- **Columns:** Consultant, Benefit, Opportunity, Area, Opportunity Details, Value Statement, Application, Potential Solution, Solution Details, Dependencies, Rank, Timing

### 2. BRD — Business Requirements Document (Excel)
- **Purpose:** Populated after the Opportunity Log is complete. Captures all business requirements.
- **File:** `BRD.xlsx`
- **Sheets:** BRD, Standard Dropdowns, If Then Dropdowns
- **Columns:** ID# (BRD ID), Requirement Topic (Epic), Requirement (Feature), Requirement Description, Rationale (Acceptance Criteria), Persona, MSCW, Business Importance, Base Solution Group, Base Solution, Custom Solution Group, Custom Solution Description, Trigger (Tag), Consolidated Comments/Notes
- **Key Formula:** Column H (Business Importance) auto-populates via VLOOKUP from the MSCW value in Standard Dropdowns

### 3. SDD — Solution Design Document (Word)
- **Purpose:** Recaps all information from the Opportunity Log and BRD. Client-facing document provided at end of project.
- **File:** `Master SDD Template Expansion.docx`
- **Sections:**
  1. Document Control & Strategic Parameters
  2. Functional Foundation (Global Core)
  3. Hierarchies & Data Structures
  4. Application Configuration: CKB & Database
  5. Application Configuration: Space & Floor Planning
  6. Application Configuration: Planogram Generator (PG)
  7. Application Configuration: Open Access (OA) & Security
  8. Custom Tooling (Extensions Layer)
  9. Integrations & Interfaces
  10. Testing & Validation (UAT Framework)
  - Appendices: Opportunity Log Summary, BRD Traceability, Glossary, Design Session Strategy

---

## Crisp Brand Styling (Applied to All Three Documents)

### Colors
| Name | Hex | Usage |
|------|-----|-------|
| Crisp Teal | #007672 | Primary header fills, H1/H2 text in SDD |
| Leaf | #00BB7E | Accent lines, dividers |
| Kale | #005257 | Dropdown sheet headers, H3 text, dark accents |
| Cypress | #003A3F | Body text color |
| Ice | #E6EDED | Alternating row shading |
| Mint | #D1F1E6 | Table borders/gridlines |
| Foam | #F0F5F2 | Section backgrounds, helper text rows |
| White | #FFFFFF | Header text on dark fills |

### Typography
- **Font:** Montserrat throughout (all three documents)
- **Headers (Excel):** Montserrat 10-11pt, Bold, White on Crisp Teal
- **Body (Excel):** Montserrat 10pt, Cypress color
- **SDD H1:** Montserrat 24pt, Bold, Crisp Teal, with Leaf underline
- **SDD H2:** Montserrat 16pt, Bold, Crisp Teal
- **SDD H3:** Montserrat 13pt, Bold, Kale
- **SDD Body:** Montserrat 11pt, Cypress
- **SDD Helper Text:** Montserrat 10pt, Italic, Kale

### Excel Formatting
- Header row: Crisp Teal fill, white bold Montserrat text, centered
- Alternating rows: Ice (#E6EDED) every other row
- Borders: Thin, Mint (#D1F1E6)
- Dropdown reference sheets: Kale (#005257) headers
- Frozen header rows for usability
- Column widths optimized for content readability

### SDD (Word) Formatting
- Cover page with centered title, client name, project name, date
- Header: "Solution Design Document | CONFIDENTIAL" with Teal underline
- Footer: "crisp. Professional Services | Page [#]" with Teal top border
- Table of Contents with hyperlinks
- Tables: Crisp Teal header rows, Mint borders, Ice alternating data rows
- Section helper text in italic Kale to guide population

---

## How to Generate an SDD from Opportunity Log & BRD

### Step 1: Read Source Documents
```
Read the Opportunity Log (OPPORTUNITY_LOG_Template.xlsx) — Template sheet
Read the BRD (BRD.xlsx) — BRD sheet
```

### Step 2: Map Opportunity Log to SDD
| Opportunity Log Column | SDD Location |
|----------------------|--------------|
| Opportunity | Appendix A — Opportunity Log Summary |
| Area | Appendix A — Area column |
| Application | Appendix A — Application column; determines which Section 4-8 to populate |
| Potential Solution | Appendix A — Solution column; populates relevant section tables |
| Solution Details | Populates the detail fields within the matching SDD section |
| Dependencies | Section 1.5 (System Dependencies) and relevant section tables |
| Rank | Appendix A — Rank column |
| Timing | Appendix A — Timing column |
| Value Statement | Section 1.4 (Success Criteria) context |

### Step 3: Map BRD to SDD
| BRD Column | SDD Location |
|-----------|--------------|
| ID# (BRD ID) | Appendix B — BRD ID column |
| Requirement Topic (Epic) | Determines which SDD section the requirement maps to |
| Requirement (Feature) | Appendix B — Requirement column |
| Requirement Description | Populates detail within the matching SDD section |
| Rationale | Supports the "Notes" columns in SDD section tables |
| MSCW | Appendix B — MSCW column; prioritizes what gets documented in detail |
| Base Solution Group / Base Solution | Maps to SDD section tables (Solution column) |
| Custom Solution Group / Description | Maps to SDD section tables for custom work |
| Trigger (Tag) | Informs automation and integration sections (Sections 8-9) |

### Step 4: Populate SDD Sections
For each SDD section (2-9), populate the configuration tables using:
1. The relevant Opportunity Log rows (matched by Application and Area)
2. The corresponding BRD requirements (matched by Requirement Topic/Feature)
3. Any additional technical details from Solution Details and Dependencies

### Step 5: Complete Appendices
- **Appendix A:** Copy Opportunity Log summary data into the table
- **Appendix B:** Create traceability matrix linking each BRD ID to its SDD section
- **Appendix C:** Glossary is pre-populated; add client-specific terms as needed
- **Appendix D:** Customize design session strategy based on project scope

### Step 6: Review
- Verify every Opportunity Log row has a corresponding entry in the SDD
- Verify every BRD requirement with MSCW of "Must Have" or "Should Have" is addressed
- Ensure consistent tone: concise, friendly, helpful, insightful (Crisp voice)
- Confirm all placeholder brackets [like this] have been replaced with actual content

---

## Field Definitions Reference

### Opportunity Log Fields
| Field | Definition |
|-------|-----------|
| Consultant | Which consulting group is responsible — Business or Technical |
| Benefit | Category — Analytics, Productivity, Quality, or Sustainability |
| Opportunity | Proposed solution in 4 words or fewer |
| Area | Primary area affected — People, Process, or Technology |
| Opportunity Details | Plain language description of the proposed solution |
| Value Statement | Solution tied to proposed ROI, worded for a business case |
| Application | Which application enables this solution |
| Potential Solution | Specific development needed to address the opportunity |
| Solution Details | Additional details on the solution as needed |
| Dependencies | Software, data, cross-functional, or other dependencies |
| Rank | Priority — High, Medium, or Low ROI or need state |
| Timing | Implementation timeline estimate |

### BRD Fields
| Field | Definition |
|-------|-----------|
| ID# (BRD ID) | Unique identifier for each requirement |
| Requirement Topic (Epic) | High-level grouping of the requirement |
| Requirement (Feature) | Specific feature or capability |
| Requirement Description | "Ability to..." statement describing the requirement |
| Rationale | "So that I can..." statement — the business reason |
| Persona | Who this requirement serves |
| MSCW | Must Have, Should Have, Could Have, Won't Have |
| Business Importance | 1-High, 2-Medium, 3-Low (auto-calculated from MSCW) |
| Base Solution Group | Standard solution category |
| Base Solution | Standard solution type |
| Custom Solution Group | Custom development category |
| Custom Solution Description | Custom development details |
| Trigger (Tag) | Automatic or Manual trigger |
| Consolidated Comments/Notes | Additional context and notes |

---

## Domain Terminology
| Abbreviation | Full Term |
|-------------|-----------|
| BRD | Business Requirements Document |
| BRV | Business Rule Validation |
| BY | Blue Yonder |
| CKB | Central Knowledge Base |
| CKS | Central Knowledge Server |
| LCM | Lifecycle Management |
| OA | Open Access |
| OLAR | Object Level Access Rules |
| OMD | Object Mapping Document |
| PG | Planogram Generator |
| POG | Planogram |
| RBAC | Role-Based Access Control |
| SA Pro | Space Automation Pro |
| SDD | Solution Design Document |
| TDD | Technical Design Document |
| UAT | User Acceptance Testing |
