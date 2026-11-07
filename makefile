# Makefile for LaTeX resumes -> pdf/
# Build defaults
SRC_DIR ?= src
OUT_DIR ?= pdf
RESUME  ?= base_resume          # .tex base name (without extension)
OUTPUT  ?= $(RESUME).pdf        # default pdf name matches tex base
PDF_PATH := $(OUT_DIR)/$(OUTPUT)

# Let \usepackage{resume-common} resolve to $(SRC_DIR)/resume-common.sty
export TEXINPUTS := $(SRC_DIR):$(TEXINPUTS)

.PHONY: all pdf check clean cleanall

# Build ALL .tex in src/ -> pdf/
all:
	@mkdir -p $(OUT_DIR)
	@for f in $(SRC_DIR)/*.tex; do \
	  b=$$(basename $$f .tex); \
	  $(MAKE) --no-print-directory pdf RESUME=$$b OUTPUT=$$b.pdf || exit 1; \
	done

# Fail if any PDF in OUT_DIR exceeds its page limit (default 1; override below)
check:
	@command -v pdfinfo >/dev/null || { echo "pdfinfo not found (install poppler)"; exit 1; }
	@fail=0; for f in $(OUT_DIR)/*.pdf; do \
	  b=$$(basename $$f .pdf); \
	  case $$b in front_end_resume|resume) max=2;; *) max=1;; esac; \
	  n=$$(pdfinfo $$f | awk '/^Pages:/{print $$2}'); \
	  if [ $$n -gt $$max ]; then echo "FAIL $$b: $$n pages (max $$max)"; fail=1; else echo "ok   $$b: $$n page(s)"; fi; \
	done; exit $$fail

# Build one resume (supports custom OUTPUT)
pdf:
	@mkdir -p $(OUT_DIR)
	pdflatex -interaction=nonstopmode -halt-on-error \
	  -output-directory=$(OUT_DIR) \
	  -jobname=$(basename $(OUTPUT)) \
	  $(SRC_DIR)/$(RESUME).tex

# Pattern: `make foo` -> builds src/foo.tex -> pdf/foo.pdf
%:
	@$(MAKE) pdf RESUME=$@ OUTPUT=$@.pdf

# Clean LaTeX aux/log files from OUT_DIR
clean:
	@rm -f $(OUT_DIR)/*.aux \
	       $(OUT_DIR)/*.log \
	       $(OUT_DIR)/*.out \
	       $(OUT_DIR)/*.toc \
	       $(OUT_DIR)/*.fls \
	       $(OUT_DIR)/*.fdb_latexmk \
	       $(OUT_DIR)/*.synctex.gz \
	       $(OUT_DIR)/*.bbl \
	       $(OUT_DIR)/*.blg

# Clean all (aux/log + PDFs)
cleanall: clean
	@rm -f $(OUT_DIR)/*.pdf