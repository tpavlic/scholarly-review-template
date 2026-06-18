# Per-round Makefile shim (copied to round-N/Makefile by `make new`).
#
# Lets you run `make` from inside a round-N/ folder: it forwards the target to
# the repository-root Makefile with ROUND set from this folder's name, so
# `make`, `make submit`, `make clean`, etc. operate on THIS round. `make new` is
# forwarded without ROUND so the root Makefile picks the next round as usual.
ROUND := $(patsubst round-%,%,$(notdir $(CURDIR)))

.DEFAULT_GOAL := pdf
.PHONY: pdf submit clean help new

pdf submit clean help:
	@$(MAKE) --no-print-directory -C .. ROUND=$(ROUND) $@

new:
	@$(MAKE) --no-print-directory -C .. new
