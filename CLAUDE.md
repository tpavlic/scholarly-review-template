# Working in this repository

This repository is a scaffold for drafting and archiving peer reviews of
academic manuscripts. A human reviewer writes and owns the review; the
assistant's role is to help organize and proof it and to run the build
and archive mechanitcs, not to form the evaluation.

## Confidentiality (read first)

- Manuscripts here are confidential, unpublished work.
- Never send manuscript or review content to external services without the
  user's explicit say-so, and only after confirming the venue allows AI
  assistance. Many publishers prohibit uploading manuscripts to third-party
  tools.
- Never commit confidential content to a public remote.

## Repository layout

- `round-N/manuscript/`: the manuscript (and supplement) under review.
- `round-N/review.md` (or `review.tex`): the review being written.
- `round-N/notes.md`: private reading notes, never submitted (see below).
- `round-N/submitted/`: the archived record of what was submitted (the raw
  review.md, or a built PDF; the version-controlled record).
- `templates/`: pristine templates; `make ROUND=N new` copies them.

For a re-review, read the prior round's `review.md` (or `review.tex`) and
check each point against the authors' response in the new round's
`manuscript/`.

### Using `notes.md`

`notes.md` is a shared scratchpad for both the human reviewer and any
assisting agent. Beyond the reviewer's own reading notes, the assistant may
record durable, reusable facts here so later work (finalizing the review or
a re-review) does not have to rediscover them: background on works the
manuscript cites, and candidate sources the authors may have missed. The
template seeds `Sources` subsections for these, but general facts and
developing ideas can go anywhere in the body.

Two limits apply. First, record what a source says (facts), not verdicts on
the manuscript; forming the evaluation remains the reviewer's job. Second,
`notes.md` is private working material -- it is never submitted, and,
because it may quote the confidential manuscript or hold others' PDFs, it
falls under the confidentiality rules above and is never committed to a
public remote.

## Conventions for review structure and style

When checking a review for quality, make sure the review abides by these
conventions:

- Review should open with a short, fair summary of the submission in the
  reviewer's own words.
- **Major** comments (validity, novelty, soundness, clarity of the
  contribution) should be separated from **minor** ones (wording, figures,
  references).
- Comments should be numbered so that authors can respond point by point.
- Comments should be specific and evidence based. Comments should cite
  sections, equations, figures, or line numbers and should quote the
  original manuscript where useful.
- Comments should be constructive and courteous. Critiques should be scoped
  to focus on the work, not the authors.
- Recommendations should be given with reasons, and the phrasing should be
  respectful to the editor as the ultimate decision maker for accepting
  or rejecting the manuscript.

When checking a review, also ensure it reads in plain, direct prose and
avoids formulaic phrasing, hedging, or inflated language.

## Building

- Each round of review is contained within a `round-N` folder.
- If a PDF is desired, `make` can build it (`review.pdf`), but Markdown-only
  reviews (`review.md`) are also acceptable.
- Rounds are Markdown by default; `make new TEX=1` scaffolds a LaTeX round
  (`review.tex`) instead, built with latexmk.
- `make submit` copies the review (PDF if exists, otherwise Markdown)
  into the `round-N/submitted` folder.
- See `README.md` for all `make` targets.
