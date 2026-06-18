# latexmk configuration for a review round.
#
# A copy lives in each round-N/ folder so that running latexmk inside the round
# (from the command line or an editor such as VS Code's LaTeX Workshop) finds it.
# latexmk reads ./.latexmkrc from its working directory and does NOT search
# parent folders, and so a single config at the repository root would be missed when
# you build from within a round. `make` builds the round using this same file.

# Build a PDF with pdflatex (not DVI/PS).
$pdf_mode = 1;

# Tuck auxiliary files into build/; keep the final PDF beside the source.
# $emulate_aux lets latexmk manage the aux directory itself, which is needed
# because TeX Live's pdflatex does not support the -aux-directory option.
$out_dir = '.';
$aux_dir = 'build';
$emulate_aux = 1;

# Find the shared review preamble (templates/preamble.tex) one level up, while
# letting a round-local preamble.tex override it: the round's own folder (.) is
# searched first, then ../templates, then the default TeX paths. This is read on
# every in-folder latexmk run (command line or editor), and so a round needs no
# preamble.tex of its own.
$ENV{'TEXINPUTS'} = '.:../templates:' . ($ENV{'TEXINPUTS'} // '');
