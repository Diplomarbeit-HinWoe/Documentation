# .latexmkrc — latexmk configuration for the HTL Leonding diploma thesis

# Always produce PDF.
$pdf_mode = 1;

# Run pdflatex non-interactively, stop on the first error, and enable shell-escape
# (used by some packages to run auxiliary tools).
$pdflatex = 'pdflatex -interaction=nonstopmode -halt-on-error -shell-escape %O %S';

# Let latexmk handle BibTeX automatically.
$bibtex_use = 2;

# Glossary / acronym support for the glossaries package.
# latexmk does not know about .glo -> .gls or .acn -> .acr by default, so we
# teach it to use the makeglossaries helper script.
add_cus_dep('glo', 'gls', 0, 'run_makeglossaries');
add_cus_dep('acn', 'acr', 0, 'run_makeglossaries');

sub run_makeglossaries {
    my $base = $_[0];
    $base =~ s/\.(glo|acn)$//;
    system("makeglossaries '$base'");
}
