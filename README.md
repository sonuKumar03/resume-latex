# Resume (LaTeX)

LaTeX sources for my resume and cover letters, with role-targeted variants and CI that builds the PDFs.

[![Build](https://github.com/sonuKumar03/resume-latex/actions/workflows/build-resume.yml/badge.svg)](https://github.com/sonuKumar03/resume-latex/actions/workflows/build-resume.yml)
[![Resume PDF](https://img.shields.io/badge/PDF-Download-brightgreen?style=flat&logo=adobeacrobatreader)](https://github.com/sonuKumar03/resume-latex/releases/latest)

## Layout

| File | Purpose |
|---|---|
| `src/base_resume.tex` | General-purpose 1-page resume |
| `src/front_end_resume.tex` | Frontend-focused resume (2 pages) |
| `src/full_stack_resume.tex` | Full-stack-focused resume |
| `src/resume.tex` | Alternate longer layout (2 pages) |
| `src/base_cover.tex`, `src/front_end_cover.tex` | Cover letter templates |
| `src/resume-common.sty` | Shared contact details (name, email, phone, links). Edit contact info here only |
| `src/workexperience.md` | Source-of-truth notes for achievements and metrics |
| `makefile` | Build automation |

Keep numbers in the `.tex` files consistent with `src/workexperience.md`.

## Build

Requires a TeX distribution with `pdflatex` (TeX Live / MacTeX).

```bash
make                    # build every src/*.tex into pdf/
make base_resume        # build one file: src/base_resume.tex -> pdf/base_resume.pdf
make check              # fail if a PDF exceeds its page limit (needs pdfinfo / poppler)
make clean              # remove aux/log files from pdf/
make cleanall           # also remove generated PDFs
```

The makefile sets `TEXINPUTS` so `\usepackage{resume-common}` resolves to `src/resume-common.sty`.

## CI

`.github/workflows/build-resume.yml` runs on changes to `src/`, `makefile`, or the workflow:

1. `make all` (fails if any file fails to compile)
2. `make check` (page limits)
3. Uploads PDFs as a workflow artifact
4. On `main`, publishes them to the [`latest` release](https://github.com/sonuKumar03/resume-latex/releases/latest)

Private files (`*.docx`, root-level PDFs, `src/*.pdf`) are git-ignored.
