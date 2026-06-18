# Build helper for academic peer reviews. Run these from the repository root.
#
# Reviews live in per-round folders (round-1/, round-2/, ...) and are written
# as Markdown (review.md, built with pandoc) or LaTeX (review.tex, built with
# latexmk).
#
#   make              build the latest round's review PDF (see ROUND below)
#   make new          scaffold the next round from templates/ (add TEX=1 for LaTeX)
#   make submit       copy the review into submitted/ (PDF if built, else the .md)
#   make clean        remove build artifacts (aux files and the built PDF)
#   make help         list targets
#
# You can also run `make` inside a round-N/ folder: a shim Makefile there
# forwards to this one with ROUND set from the folder name.

# ROUND selects which round-N/ folder to act on. With no ROUND given it defaults
# to the highest-numbered round that exists, and so a bare `make` follows you into
# round-2/ once you have created it. Override explicitly to revisit an earlier
# round (or jump ahead): make ROUND=1 pdf
LATEST := $(shell ls -d round-*/ 2>/dev/null | sed -E 's:round-([0-9]+)/:\1:' | sort -n | tail -1)
ROUND  ?= $(or $(LATEST),1)
DIR    := round-$(ROUND)
MD    := $(DIR)/review.md
TEX   := $(DIR)/review.tex
PDF   := $(DIR)/review.pdf
PREAMBLE := $(DIR)/preamble.tex

# `make new` creates the next round automatically (latest + 1). An explicit
# ROUND=N on the command line forces that specific round instead.
NEXT := $(shell echo $$(( $(or $(LATEST),0) + 1 )))
ifeq ($(origin ROUND),command line)
NEWDIR := round-$(ROUND)
else
NEWDIR := round-$(NEXT)
endif

# `make new` scaffolds a Markdown review by default; `make new TEX=1` scaffolds
# a LaTeX one (review.tex instead of review.md). Test the origin rather than
# `ifdef TEX`: make has a built-in default TEX = tex, and so ifdef would always
# be true and always pick LaTeX. Only an explicit command-line TEX counts.
ifeq ($(origin TEX),command line)
REVIEW := review.tex
else
REVIEW := review.md
endif

PANDOC     ?= pandoc
PDF_ENGINE ?= pdflatex      # xelatex / lualatex for richer Unicode + fonts
LATEXMK    ?= latexmk

# Pull the shared preamble (fonts, margins) into the Markdown build when present.
HEADER := $(if $(wildcard $(PREAMBLE)),--include-in-header=$(PREAMBLE),)

SUB := $(DIR)/submitted

.DEFAULT_GOAL := pdf
.PHONY: pdf submit new clean help

pdf:
	@if [ -f "$(MD)" ]; then \
	  echo "==> pandoc $(MD)"; \
	  $(PANDOC) "$(MD)" -o "$(PDF)" --pdf-engine=$(PDF_ENGINE) $(HEADER); \
	elif [ -f "$(TEX)" ]; then \
	  echo "==> latexmk $(TEX)"; \
	  ( cd "$(DIR)" && $(LATEXMK) review.tex ); \
	else \
	  echo "No $(MD) or $(TEX) found. Run: make ROUND=$(ROUND) new"; exit 1; \
	fi

# Copy the review into submitted/ as the record of what you sent: the built PDF
# if one exists (run `make` first), otherwise the raw review.md. Overwrites.
submit:
	@mkdir -p "$(SUB)"
	@if [ -f "$(PDF)" ]; then \
	  cp "$(PDF)" "$(SUB)/review-round-$(ROUND).pdf"; \
	  echo "==> submitted $(SUB)/review-round-$(ROUND).pdf"; \
	elif [ -f "$(MD)" ]; then \
	  cp "$(MD)" "$(SUB)/review-round-$(ROUND).md"; \
	  echo "==> submitted $(SUB)/review-round-$(ROUND).md"; \
	else \
	  echo "Nothing to submit in $(DIR) (no review.pdf or review.md)"; exit 1; \
	fi

new:
	@mkdir -p "$(NEWDIR)/manuscript" "$(NEWDIR)/submitted"
	@touch "$(NEWDIR)/manuscript/.gitkeep" "$(NEWDIR)/submitted/.gitkeep"
	@[ -f "$(NEWDIR)/$(REVIEW)" ]  || cp templates/$(REVIEW)  "$(NEWDIR)/$(REVIEW)"
	@[ -f "$(NEWDIR)/notes.md" ]   || cp templates/notes.md   "$(NEWDIR)/notes.md"
	@[ -f "$(NEWDIR)/.latexmkrc" ]   || cp templates/.latexmkrc   "$(NEWDIR)/.latexmkrc"
	@[ -f "$(NEWDIR)/preamble.tex" ] || cp templates/preamble.tex "$(NEWDIR)/preamble.tex"
	@[ -f "$(NEWDIR)/Makefile" ]     || cp templates/round.mk     "$(NEWDIR)/Makefile"
	@echo "==> scaffolded $(NEWDIR)/ (edit $(NEWDIR)/$(REVIEW))"
	@if [ -f "$(NEWDIR)/review.md" ] && [ -f "$(NEWDIR)/review.tex" ]; then \
	  echo "warning: $(NEWDIR) has both review.md and review.tex; make builds review.md and ignores review.tex. Remove the one you do not want." >&2; \
	fi

clean:
	@-( cd "$(DIR)" && $(LATEXMK) -c review.tex ) >/dev/null 2>&1 || true
	@rm -rf "$(DIR)/build" "$(PDF)"
	@echo "==> cleaned build artifacts in $(DIR)"

help:
	@echo "make [ROUND=n] pdf     build the round's review PDF"
	@echo "make           new     scaffold the next round (ROUND=n to force; TEX=1 for LaTeX)"
	@echo "make [ROUND=n] submit  copy review into submitted/ (PDF if built, else .md)"
	@echo "make [ROUND=n] clean   remove build artifacts"
