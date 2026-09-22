# HTL Leonding Diploma Thesis Template

Used by students to create their diploma thesis.

![HTBLA Leonding](titlepage/htlleondinglogo.png)

## LaTeX Tutorial

[freecodecamp](https://www.freecodecamp.org/news/learn-latex-full-course/) provides a full, free LaTeX course

## Building with Nix

This repository provides a Nix flake that pins a complete TeX Live environment, so you do not have to install a global LaTeX distribution.

```bash
# Build thesis.pdf (and the titlepage/coversheet.pdf if it is missing or stale)
nix run .#build

# Build the PDF as a Nix derivation (result becomes a symlink in ./result)
nix build .#thesis

# Continuously rebuild while you edit
nix run .#watch

# Remove all generated files and start fresh
nix run .#clean

# Enter a shell with latexmk, pdflatex, makeglossaries, etc.
nix develop
```

Inside the dev shell you can also use `latexmk` directly; the project `.latexmkrc` configures the PDF engine, BibTeX, and glossary handling.

```bash
nix develop
latexmk thesis.tex
```

If you hit a stale-auxiliary-file error (for example BibTeX complaining about a missing `\citation` because the previous `pdflatex` run failed), run `nix run .#clean` and then `nix run .#build` again.
