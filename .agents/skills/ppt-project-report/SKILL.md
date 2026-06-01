---
name: ppt-project-report
description: Use this skill when creating or editing PowerPoint presentations, PPT slides, slide decks, course reports, frontend/backend project reports, architecture diagrams, ER diagrams, flowcharts, sequence diagrams, API flow diagrams, database design slides, or scientific/technical charts.
---

# PPT Project Report Skill

## Purpose

Create high-quality PowerPoint presentations for frontend/backend course projects, technical reports, academic reports, and software engineering assignments.

The final deliverable should be a real `.pptx` file whenever possible, not only Markdown, plain text, or an outline.

## When to use this skill

Use this skill when the user asks for:

- PPT
- PowerPoint
- slides
- slide deck
- presentation
- course report
- project report
- frontend/backend project presentation
- software engineering report
- architecture diagram
- ER diagram
- database design slides
- system flowchart
- API flow diagram
- sequence diagram
- scientific chart
- research-style figure

## Preferred tools

When available, use these tools:

- Use PptxGenJS to generate native `.pptx` files.
- Use Mermaid for:
  - flowcharts
  - ER diagrams
  - sequence diagrams
  - frontend routing diagrams
  - backend API flow diagrams
  - user operation flow diagrams
  - module relationship diagrams
- Use D2 for clean and modern system architecture diagrams when available.
- Use PlantUML for formal UML diagrams when available.
- Use Python matplotlib and SciencePlots for scientific charts, experiment plots, line charts, bar charts, scatter plots, and technical data visualization.
- Export diagrams as SVG or PNG before inserting them into PowerPoint.
- Keep source files for diagrams and charts so the user can audit or modify them later.

## Default slide structure for frontend/backend course projects

For a frontend/backend project report, use this structure by default:

1. Title page
2. Project background and problem
3. Requirements analysis
4. User roles and core features
5. System architecture diagram
6. Frontend page structure and routing design
7. Backend layered architecture
8. Database ER diagram
9. Core business flow
10. API design
11. Feature screenshots or demo pages
12. Testing and results
13. Technical highlights
14. Summary and future improvements

## Recommended diagram choices

Use the following diagram types by default:

- System architecture: D2 or Mermaid
- Frontend routing: Mermaid flowchart
- Backend layered architecture: Mermaid flowchart or PlantUML component diagram
- Database ER diagram: Mermaid ER diagram or PlantUML ER diagram
- Login/register flow: Mermaid sequence diagram
- Core business process: Mermaid flowchart
- API request flow: Mermaid sequence diagram
- Scientific chart: Python matplotlib + SciencePlots

## Design style

- Use a clean academic and technical style.
- Avoid crowded slides.
- Each slide should have one clear message.
- Use diagrams instead of long paragraphs when possible.
- Keep fonts, spacing, colors, and icon style consistent.
- Prefer simple professional colors.
- Avoid childish, noisy, or overly decorative designs unless the user explicitly asks.
- Use speaker notes if they help the presentation.
- Make titles specific, not generic.
- Use screenshots and visual evidence when available.

## Output requirements

When the user asks for a PPT:

1. Analyze the project content first.
2. Create a clear slide outline.
3. Generate diagrams if needed.
4. Generate chart images if needed.
5. Generate a real `.pptx` file.
6. Keep diagram source files in a `diagrams/` folder.
7. Keep exported diagram images in an `assets/` or `output/` folder.
8. Keep the final PowerPoint in an `output/` folder.
9. Clearly tell the user where the final `.pptx` file is.

## Quality check before finishing

Before finishing, check:

- Is there a real `.pptx` output?
- Are architecture diagrams readable?
- Is the ER diagram consistent with database tables?
- Are screenshots or demo images not distorted?
- Are slide titles meaningful?
- Is there too much text on any slide?
- Are fonts and spacing consistent?
- Are all generated diagrams saved together with the PPT?
- Is the presentation suitable for a university course report?
