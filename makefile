# Makefile for LaTeX resumes -> pdf/
# Build defaults
SRC_DIR ?= src
OUT_DIR ?= pdf
RESUME  ?= sonu_resume          # .tex base name (without extension)
OUTPUT  ?= $(RESUME).pdf        # default pdf name matches tex base
PDF_PATH := $(OUT_DIR)/$(OUTPUT)

.PHONY: all pdf clean cleanall

# Build ALL .tex in src/ -> pdf/
all:
	@mkdir -p $(OUT_DIR)
	@for f in $(SRC_DIR)/*.tex; do \
	  b=$$(basename $$f .tex); \
	  $(MAKE) --no-print-directory pdf RESUME=$$b OUTPUT=$$b.pdf; \
	done

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

clean:
	@rm -f $(OUT_DIR)/*.aux $(OUT_DIR)/*.log $(OUT_DIR)/*.out \
	       $(OUT_DIR)/*.toc $(OUT_DIR)/*.fls $(OUT_DIR)/*.fdb_latexmk \
	       $(OUT_DIR)/*.synctex.gz

cleanall: clean
	@rm -f $(OUT_DIR)/*.pdf