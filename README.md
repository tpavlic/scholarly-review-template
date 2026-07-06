# Template for reviewing scholarly manuscripts

A small, self-contained scaffold for writing, building, and archiving peer
reviews of scholarly manuscripts, including re-reviews of revised submissions
across multiple rounds.

Reviews can be written in **Markdown** (built with pandoc) or **LaTeX** (built
with latexmk). A `Makefile` wraps both.

- [Structure](#structure)
- [Quick start](#quick-start)
  - [Submitting: PDF if available, Markdown otherwise](#submitting-pdf-if-available-markdown-otherwise)
- [Per-review workflow](#per-review-workflow)
- [Role of a coding assistant (`CLAUDE.md`)](#role-of-a-coding-assistant-claudemd)
- [Confidentiality](#confidentiality)
- [License](#license)

## Structure

```text
.
|-- Makefile             build / submit / scaffold helpers
|-- CLAUDE.md            scope notes for an LLM coding assistant (see below)
|-- templates/           pristine templates copied into each round
|   |-- review.md
|   |-- review.tex       LaTeX alternative (make new TEX=1)
|   |-- notes.md
|   |-- preamble.tex     shared PDF typography (used by both builds; not copied)
|   |-- .latexmkrc       latexmk config (-> PDF, aux in build/)
|   `-- round.mk         shim copied to each round as round-N/Makefile
|-- round-1/
|   |-- manuscript/      the manuscript (+ supplement) you were sent
|   |-- review.md        your review (source; or review.tex for LaTeX)
|   |-- notes.md         private reading notes (not submitted)
|   |-- .latexmkrc       per-round copy so in-folder builds make a PDF
|   |-- Makefile         forwards `make` here to the root Makefile
|   `-- submitted/       the archived record you submitted (.md or .pdf)
`-- round-2/ ...         one folder per re-review round, created on demand
```

(README.md, LICENSE, and the boilerplate `.gitignore` are omitted above.) Each
re-review gets its own `round-N/` folder, pairing the revision you received with
the review you wrote and submitted.

The `.latexmkrc` lives **inside each round**, not at the repository root.
latexmk reads `./.latexmkrc` from its working directory and does not search
parent folders, and so a per-round copy is what makes a LaTeX build produce a PDF
(rather than a DVI) whether you run `make`, invoke `latexmk` inside the round
folder, or let an editor extension build it. `make new` copies it from
`templates/`.

PDF typography (font, margins) lives in `templates/preamble.tex` and is shared
by both builds, and so the Markdown and LaTeX outputs match. Rounds do not carry
their own copy: the Markdown build points pandoc at the template, while a LaTeX
build finds it through the round's `.latexmkrc`. Drop a `preamble.tex` into a
round to override the typography for that round only.

## Quick start

Each of these `make` commands can be applied at the repository root or within a
`round-N` subfolder.

```sh
make              # build the latest round's review.pdf
make submit       # copy review PDF [otherwise Markdown] into round-N/submitted/
make new          # scaffold the next round for a re-review
make help         # all targets
```

The build always focuses on the **latest (highest) round**. Creating a round
shifts that focus automatically: after `make new` (which scaffolds the next
round), a bare `make` builds the new round. To act on an earlier round (or
any specific one), name it explicitly with `ROUND=`, which works backwards too:

```sh
make new          # create the next round (latest + 1)
make new TEX=1    # next round as LaTeX (review.tex, not review.md)
make ROUND=3 new  # or force a specific round number
make ROUND=1 pdf  # go back and rebuild an earlier round
```

Each `round-N` subfolder carries a small shim `Makefile` that forwards to the root
Makefile with `ROUND` set from the folder name. So, `make`, `make submit`, etc.
act on that round, and `make new` from inside a round still creates the next one.

By default builds use `pdflatex`. For richer Unicode or custom fonts, build
Markdown with `make PDF_ENGINE=xelatex`.

### Submitting: PDF if available, Markdown otherwise

The `submitted/` folder holds the git-tracked record of what you sent.
`make submit` copies the review into it:

- if you built a PDF (ran `make`), it copies `review-round-N.pdf`;
- otherwise it copies the raw `review.md` as `review-round-N.md`, and so a plain
  Markdown review you never built is archived as-is.

`make submit` does not build on its own, and so it works standalone for a Markdown
submission; run `make` first when you want the PDF archived. It overwrites the
existing copy, which is fine: the folder is version-controlled, and so you can
update the submitted record freely (and `git` keeps the history).

## Per-review workflow

Treat this repository as a *template*: clone it to keep your own local template
copy, then start a fresh **private** copy from that for each manuscript you
review, committing each round as the manuscript and your review evolve. Keep
those review copies private (see [Confidentiality](#confidentiality)) because
manuscripts and reviews are confidential. If you improve the template itself,
contributions back are welcome as pull requests.

## Role of a coding assistant (`CLAUDE.md`)

This repository includes a `CLAUDE.md` with guidance for LLM-based coding
assistants. Its scope is deliberately narrow.  The assistant is meant to
**maintain the structure of the repository and provide an initial scaffold**
on which a human reviewer builds. **It is not a co-reviewer.**

Every review must reflect the human reviewer's own reading and judgment, and its
substance must be the human reviewer's own comments. The assistant helps with
organization, formatting, and the mechanics of building and archiving the
review, not with forming the evaluation. See the confidentiality note below
before pointing any assistant or cloud tool at a manuscript.

## Confidentiality

Manuscripts under review are confidential, unpublished work.

- Do **not** push confidential manuscripts or reviews to a public repository.
  Keep working copies private.
- Before using any LLM or cloud tool to help draft a review, check the venue's
  or publisher's policy on AI assistance; many prohibit uploading manuscripts
  to third-party services.

## License

The template files (Makefile, configuration, templates) are released under the
MIT License (see `LICENSE`). That license covers the scaffold only, not any
manuscript or review content you add.

Copyright (c) 2026 Theodore P. Pavlic
