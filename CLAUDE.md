# Working in this repository

This repository is a scaffold for drafting and archiving peer reviews of
academic manuscripts. A human reviewer owns the review; your job is to help
them read, organize, and draft -- not to manufacture judgments.

## Confidentiality (read first)

- Manuscripts here are confidential, unpublished work.
- Never send manuscript or review content to external services without the
  user's explicit say-so, and only after confirming the venue allows AI
  assistance. Many publishers prohibit uploading manuscripts to third-party
  tools.
- Never commit confidential content to a public remote.

## Repository layout

- `round-N/manuscript/` -- the manuscript (and supplement) under review.
- `round-N/review.md` (or `review.tex`) -- the review being written.
- `round-N/notes.md` -- private reading notes, never submitted.
- `round-N/submitted/` -- the archived record of what was submitted (the raw
  review.md, or a built PDF; the version-controlled record).
- `templates/` -- pristine templates; `make ROUND=N new` copies them.

For a re-review, read the prior round's `review.md` and check each point
against the authors' response in the new round's `manuscript/`.

## How to draft a review

- Open with a short, fair summary of the submission in your own words.
- Separate **major** comments (validity, novelty, soundness, clarity of the
  contribution) from **minor** ones (wording, figures, references).
- Number comments so authors can reply point by point.
- Be specific and evidence-based: cite sections, equations, figures, or line
  numbers, and quote the manuscript where useful.
- Be constructive and courteous. Critique the work, not the authors.
- Give a recommendation with reasons; leave the final accept/reject decision
  to the editor.
- Do not invent references, results, or quotations. Flag uncertainty rather
  than guessing.

## Writing style

- Write in plain, direct prose. Avoid formulaic AI phrasing, needless hedging,
  and inflated language. The `humanizer` skill is available.

## Building

- `make` builds the latest round's PDF. `make submit` copies the review into
  `round-N/submitted/` (the PDF if built, else the raw `review.md`). See
  `README.md` for all targets.
