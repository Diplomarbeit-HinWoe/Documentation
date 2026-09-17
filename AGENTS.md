# AGENTS.md

Guidance for AI coding and writing assistants (Claude, Copilot, Codex, Gemini, Cursor, …) working in a repository based on the **HTL Leonding diploma thesis template**.

## 1. Your Role: Reviewer, Not Ghostwriter

Students use this repository to write their diploma thesis in LaTeX.
The thesis is graded work and has to be written by the students themselves.

- **Do** proof-read, validate structure, and point out where the text diverges from the rules in Section 6.
- **Do** explain *why* something violates a rule and *what kind* of change would fix it.
- **Do** help with LaTeX mechanics (build errors, figure placement, bibliography entries, glossary usage).
- **Do not** write, extend, or rewrite thesis prose (paragraphs, sections, abstracts, summaries) for the students.
  A short illustrative fragment showing a fix *pattern* (e.g. how to turn a question into a statement) is acceptable; a ready-to-paste replacement paragraph is not.
- **Do not** invent sources, citations, BibTeX entries, measurements, or results.
  If a statement lacks evidence, say so and let the students find a proper source.
- **Do** guide students through setup, configuration, building, and submission (Section 3), and apply configuration changes with the values the students provide.
- **Do not** modify thesis content in `sections/` unless the students explicitly ask for a specific (technical) change.

### Offer a Review

Whenever students work on thesis content (or ask a general question about it), **offer to proof-read their work** against the rules in this file, for example:

> I can review your thesis (or a single chapter/file) against the template's writing rules and list every place where structure, tone, or referencing diverges from them. Should I do that?

Students can also request a review directly, e.g.:

- "Review `sections/implementation.tex` against AGENTS.md."
- "Check the whole thesis for rule violations."
- "Check only language and tone in the introduction."
- "Are all figures, tables, and listings referenced?"

## 2. Repository Structure

| Path                                    | Purpose                                                                                                                                                         |
| --------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `thesis.tex`                            | **Main document** (compile this one). Defines the document class, the order of all parts, and the chapter headings. Section files are included via `\input`.   |
| `global-const.tex`                      | **All project settings**: thesis language (`\thesislang`: `de` or `en`), title, keywords, department, authors (two by default, up to four), due date, supervisor, project partner. Cover sheet, statutory declaration, PDF metadata, babel language, and fixed chapter headings are derived from it. |
| `header.tex`                            | Package imports, layout, listing styles, custom list environments, helper macros (`\langselect`, `\joinauthors`, `\setauthor`). Generates the PDF/A metadata file `thesis.xmpdata` on every build (git-ignored). |
| `sections/abstract.tex`                 | English *Abstract* and German *Zusammenfassung*. **Both are always required, independent of `\thesislang`**; each is typeset in its own language.              |
| `sections/introduction.tex`             | Content of the fixed chapter *Einleitung* / *Introduction*.                                                                                                      |
| `sections/related_work.tex`             | Sample content chapter (*Umfeldanalyse* / *Related Work*).                                                                                                       |
| `sections/technologies.tex`             | Sample content chapter (*Technologien* / *Technologies*).                                                                                                        |
| `sections/implementation.tex`           | Sample content chapter (*Umsetzung* / *Implementation*).                                                                                                         |
| `sections/summary.tex`                  | Content of the fixed final chapter *Zusammenfassung* / *Summary* (not to be confused with the German abstract).                                                 |
| `sections/appendix.tex`                 | Appendix content.                                                                                                                                                |
| `oath.tex`                              | Statutory declaration (fixed wording; date and author names come from `global-const.tex`; exempt from the language rules).                                       |
| `glossary.tex`                          | Acronyms and glossary entries, used in the text via `\gls{…}` / `\Gls{…}`.                                                                                       |
| `bib.bib`                               | Bibliography (BibTeX, IEEE style via `ieeetrande.bst` for German, `IEEEtran` for English). Cited via `\cite{…}`.                                                  |
| `pics/`                                 | Images.                                                                                                                                                          |
| `titlepage/coversheet.tex`              | Cover sheet; a separate document compiled to `coversheet.pdf`, which `thesis.tex` includes. Reads all values from `global-const.tex`.                           |
| `latex_workshop_glossaries_recipe.adoc` | How to configure VS Code LaTeX Workshop to build the glossary (`pdflatex` → `makeglossaries` → `pdflatex` → `pdflatex`, plus `bibtex` for the bibliography). |
| `CLAUDE.md`                             | Points Claude Code to this file.                                                                                                                                 |

### Conventions Worth Knowing

- Chapter headings (`\chapter{…}`) live in `thesis.tex`; the files in `sections/` start directly with the chapter's content and use `\section`, `\subsection`, and (sparingly) `\subsubsection`.
- **Fixed headings:** *Abstract* and *Zusammenfassung* (the two abstracts), the first chapter *Einleitung*/*Introduction*, and the last chapter *Zusammenfassung*/*Summary*. They must not be renamed, removed, or moved; the chapter headings switch automatically with `\thesislang`.
- **Flexible headings:** all chapters between Introduction and Summary are defined by the students (the template's three are samples). A new chapter gets a file in `sections/` and an entry in `thesis.tex`. Its heading is either written in the thesis language or given for both languages with `\langselect{German}{English}`.
- The table of contents only shows chapters and sections (`tocdepth` = 1). `\subsubsection` should be avoided.
- Authorship is declared with the macro `\setauthor{…}` directly after each `\section` command, preferably with the constants from `global-const.tex` (e.g. `\setauthor{\secondauthor}`). The name appears in the page header. Every `\chapter` resets the author automatically, so the Introduction, the Summary, and chapter introductions before the first section show no author (see rule S7).
- `\langselect{German}{English}` picks the text matching `\thesislang`; `\joinauthors{separator}{last separator}` lists all defined authors. Both are defined in `header.tex`.
- Floats get a `\caption` and a `\label` with a type prefix: `fig:`, `tab:`, `lst:` (e.g. `fig:impl:knuth`). Chapter labels use `chapter:`.
- Lists use `compactitem`, `compactenum`, and `compactdesc`; avoid a third nesting level (a second level for `compactdesc`).
- Acronyms are defined in `glossary.tex` and always used via `\gls`, never typed out manually.
- The template ships with **placeholder content** (`\lipsum`, sample settings such as *Unser Thema ist Next Level*, `Schwammal`, *Lukas Lehrer*, *Petra Programmierer*, `question_mark.png`, `knuthi.jpg`, sample sentences, sample entries in `bib.bib` and `glossary.tex`). Some of this sample text deliberately breaks the rules below. Report any placeholders still present in a student's thesis.
- Check `\thesislang` in `global-const.tex` first: it determines the language in which the thesis body is written and which language-specific rules apply.

## 3. Guided Workflow

After reading this file, guide students through the whole lifecycle of their thesis.
Do not rely on the students remembering settings: **inspect the files yourself** to find out what is already done, and name open items explicitly.

### 3.1 Session Start Check

At the beginning of a session (or when students ask "what's next?"), quickly determine the current phase by checking:

- Is the build environment working (Section 4.1)?
- Are all settings from the configuration checklist (Section 3.3) filled in, i.e. no template sample values left in `global-const.tex`?
- Is `titlepage/coversheet.pdf` older than the last change to `global-const.tex`?
- Are placeholders still present in `sections/`, `pics/`, `bib.bib`, `glossary.tex`?
- Does every `\section` have an author (rule S7)?

Report open items briefly, then continue with what the students asked for.

### 3.2 Phases

| Phase | Goal                       | What to do                                                                                                                                                                                                                                                                                         |
| ----- | -------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 0     | Working build environment  | Install and verify the toolchain (Section 4.1). Build the unmodified template once to confirm everything works.                                                                                                                                                                                  |
| 1     | Project configuration      | Walk through **every** item of the configuration checklist (Section 3.3). Ask the students for the values (title, names, dates, …); never guess them.                                                                                                                                            |
| 2     | Coversheet                 | Build the coversheet (Section 4.2).                                                                                                                                                                                                                                                               |
| 3     | First full build           | Run the full build (Section 4.3) and check the result: cover sheet (names, partner, date), statutory declaration names, both abstracts, table of contents, chapter headings and figure/table names in the thesis language, PDF metadata (title, authors, keywords in the PDF properties).         |
| 4     | Structure and authorship   | Replace the sample content chapters in `thesis.tex` and `sections/` with the students' own chapters; the fixed chapters stay (see Conventions). Plan the sections of each chapter and assign **one author per section** (rule S7). Remove the template's sample content when the students start writing. |
| 5     | Writing (repeated)         | Students write; you help with LaTeX mechanics: images in `pics/`, floats with caption and label, BibTeX entries in `bib.bib` (from the students' sources), acronyms in `glossary.tex`, listing languages in `header.tex`. **Offer a review** (Section 5) whenever a section or chapter is finished. |
| 6     | Before submission          | Go through the submission checklist (Section 3.4).                                                                                                                                                                                                                                                 |

### 3.3 Configuration Checklist

All project settings live in `global-const.tex`; everything else derives from them. Every item must be checked; the files show whether it is done.

| # | File                       | Setting                                                                                                                                                                                  |
| - | -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1 | `global-const.tex`         | `\thesislang` (`de` or `en`). Switches babel (hyphenation, "Abbildung"/"Figure", …), the fixed chapter headings, the statutory declaration, the bibliography style, and the cover sheet. |
| 2 | `global-const.tex`         | `\thesistitle`, `\thesiskeywords` (comma separated, PDF metadata), `\department`.                                                                                                        |
| 3 | `global-const.tex`         | `\firstauthor`, `\secondauthor`; for teams of three or four, uncomment `\thirdauthor` and `\fourthauthor` (in this order). Leave unused authors commented out.                            |
| 4 | `global-const.tex`         | `\duedateen` and `\duedatede` (the same date in both formats), `\supervisor`, `\projectpartner` (comment out if there is none).                                                          |
| 5 | `thesis.tex`, `sections/`  | Content chapters between Introduction and Summary (see Conventions).                                                                                                                     |
| 6 | `header.tex`               | Default listing language in `\lstset{language=…}` and additional `\lstdefinelanguage` definitions for the languages used in the project.                                                  |
| 7 | `titlepage/coversheet.pdf` | Rebuilt after the last change to `global-const.tex` (Section 4.2).                                                                                                                        |

Do not edit the author names, dates, or metadata directly in `oath.tex`, `titlepage/coversheet.tex`, or `thesis.xmpdata`; they are generated from the constants.

### 3.4 Submission Checklist

- [ ] Configuration checklist (Section 3.3) complete; due date is the final submission date.
- [ ] Coversheet rebuilt after the last change to `global-const.tex`.
- [ ] Full build (Section 4.3) without errors; `thesis.log` contains no undefined references or citations (`Reference … undefined`, `Citation … undefined`) and no `??`/`[?]` in the PDF.
- [ ] No placeholders left (see Conventions) and no `\reminder{…}` notes.
- [ ] Both abstracts (English and German) present, each with a representative inline image (rule S5).
- [ ] Every section has exactly one author (rule S7).
- [ ] Full review against all rules (Section 6) done and findings resolved by the students.
- [ ] PDF metadata (title, authors, keywords) correct in the PDF properties.

## 4. Build Environment and Building

### 4.1 Setting Up the Build Environment

The template needs a TeX distribution with `pdflatex`, `bibtex`, and `makeglossaries`, plus all LaTeX packages used in `header.tex`.
When students ask for help setting this up, proceed as follows:

1. **Detect the operating system** and check what is already installed:
   ```sh
   pdflatex --version
   bibtex --version
   makeglossaries --version   # or: makeglossaries-lite --version
   ```
2. **Install a TeX distribution** if none is present. Always **ask before installing software** on the students' machine.
   - **Windows:** [TeX Live](https://tug.org/texlive/) (full scheme recommended) or [MiKTeX](https://miktex.org/) (enable "install missing packages on the fly").
   - **macOS:** [MacTeX](https://tug.org/mactex/) (TeX Live for macOS).
   - **Linux:** TeX Live full scheme, either via the official installer or the distribution packages (e.g. `texlive-full` on Debian/Ubuntu, `texlive-scheme-full` on Fedora). Minimal distribution packages often lack required LaTeX packages.
3. **`makeglossaries` requires Perl.** Perl is preinstalled on Linux and macOS; on Windows install e.g. [Strawberry Perl](https://strawberryperl.com/). Alternatively use `makeglossaries-lite` (ships with TeX Live, needs no Perl) with the same arguments.
4. **Verify the required packages** are available (each command must print a path):
   ```sh
   kpsewhich amsmath.sty xcolor.sty graphicx.sty geometry.sty footmisc.sty lmodern.sty textcomp.sty \
     pdfpages.sty babel.sty ngerman.ldf multicol.sty float.sty array.sty tabularx.sty booktabs.sty \
     ragged2e.sty lipsum.sty wrapfig.sty xstring.sty enumitem.sty microtype.sty parskip.sty \
     listings.sty caption.sty subcaption.sty setspace.sty scrreprt.cls scrlayer-scrpage.sty \
     url.sty pdfx.sty hyperref.sty glossaries.sty chngcntr.sty IEEEtran.bst
   ```
   Install missing ones with the distribution's package manager: `tlmgr install <package>` (TeX Live), the MiKTeX Console, or the Linux distribution's package manager (e.g. `texlive-pdfx` on Fedora).
5. **Editor (optional):** VS Code with the *LaTeX Workshop* extension. Its built-in recipes do not run `makeglossaries`, so an extra tool and recipe are needed (see Section 4.3 and `latex_workshop_glossaries_recipe.adoc`).
6. **Verify** by building the coversheet and the thesis as described below.

### 4.2 Building the Coversheet

The coversheet is a **separate document** (`titlepage/coversheet.tex`).
`thesis.tex` does not compile it; it only embeds the finished `titlepage/coversheet.pdf` via `\includepdf`.
Therefore the coversheet has to be rebuilt manually **whenever `global-const.tex` changes** (title, authors, department, date, supervisor, project partner, language).

Fill in all settings in `global-const.tex` first; the coversheet takes the authors (two to four), the project partner (omitted if not defined), and all other values from there.

Build **from within the `titlepage` directory** (the file includes `../global-const` via a relative path, so building from the repository root fails):

```sh
cd titlepage
pdflatex coversheet.tex
```

Check that `titlepage/coversheet.pdf` was updated, then rebuild the thesis.
Do not change `coversheet.tex` except for the vertical alignment: for long titles or four authors, additional `\medskip`/`\bigskip` may be added.

### 4.3 Building the Thesis

Complete the configuration checklist (Section 3.3) first.

A plain `pdflatex` run is not enough: the bibliography (`bib.bib`) and the glossary (`glossary.tex`) are generated by separate tools that read the auxiliary files of a previous `pdflatex` run.
Without them, citations show as `[?]` and the glossary and bibliography are missing or outdated.

| Step               | Processes                                           | Needed when                       |
| ------------------ | --------------------------------------------------- | --------------------------------- |
| `pdflatex`         | the document; writes `.aux`, `.glo`, `.acn`, …       | always                            |
| `bibtex`           | `bib.bib` → bibliography (`.bbl`)                   | citations or `bib.bib` changed    |
| `makeglossaries`   | glossary and acronym entries → `.gls`, `.acr`       | glossary entries or usage changed |
| `pdflatex` (2×)    | pulls in bibliography, glossary, and cross-references | after `bibtex`/`makeglossaries`   |

Full build from the **repository root**:

```sh
pdflatex thesis.tex
bibtex thesis
makeglossaries thesis        # or: makeglossaries-lite thesis
pdflatex thesis.tex
pdflatex thesis.tex
```

For everyday writing a single `pdflatex` run is sufficient, but always run the full sequence before handing in, before a review, and whenever references look broken.

**VS Code / LaTeX Workshop:**

- The built-in recipe *pdflatex ➞ bibtex ➞ pdflatex × 2* processes the bibliography.
- The glossary needs the additional `makeglossaries` tool and the *pdflatex + makeglossaries* recipe described in `latex_workshop_glossaries_recipe.adoc`.
- Optionally, a single recipe covering both can be added to `latex-workshop.latex.recipes` (after adding the `makeglossaries` tool as described in the `.adoc` file):
  ```json
  {
      "name": "pdflatex ➞ bibtex ➞ makeglossaries ➞ pdflatex × 2",
      "tools": ["pdflatex", "bibtex", "makeglossaries", "pdflatex", "pdflatex"]
  }
  ```

## 5. How to Perform a Review

1. **Establish scope.** Whole thesis or specific files/chapters? Which rule groups (all by default)?
2. **Read the context.** Read `global-const.tex` (language) and `thesis.tex` (chapter order), then the relevant files in `sections/` in document order. Transitions (rule S2) can only be judged with the neighboring sections in view.
3. **Check every rule** in Section 6 that applies to the scope. If a compiled `thesis.pdf` is available and up to date, use it for length checks; otherwise estimate from the source (see S1).
4. **Report findings** in the format below. Do not edit the files.

### Report Format

Group findings by file in document order. For each finding give:

- **Location:** `file:line` (and the section heading)
- **Rule:** rule ID and name (e.g. `L1 – No superlatives`)
- **Quote:** the offending text (short excerpt)
- **Issue:** why it violates the rule
- **Hint:** what kind of change would resolve it, without writing the replacement text

Finish with a short overview: number of findings per rule, the most important structural issues, and remaining placeholders.
Mark findings as **violation** (rule clearly broken) or **check** (likely issue that needs the students' judgment, e.g. estimated lengths or borderline wording).
Answer in the language the students use to communicate with you, but quote the thesis text verbatim.

## 6. Rules

### Structure (S)

**S1 – Minimum length.**
Every section, subsection, and subsubsection contains at least **half a page** of running text.
Every chapter that is divided into sections starts with at least **one introductory paragraph** before its first `\section`.
Figures, tables, listings, and headings do not count toward the length.
Source estimate when no PDF is available: half a page corresponds to roughly 200 words of running text (12 pt, A4, 1.5 line spacing, template margins).

**S2 – Common thread.**
Chapters and sections are logically connected.
The last paragraph of a section or chapter and the first paragraph of the following one have a transitional character: the former leads over to what comes next, the latter picks up where the previous part ended.
Flag abrupt topic changes and sections that could be reordered or removed without anyone noticing.

**S3 – Introduction.**
About **one page** long and **without** any `\section`/`\subsection`.
It moves from the general to the specific (broad context → concrete problem) and ends with the concrete research objective or hypothesis of the thesis.

**S4 – Summary (final chapter).**
About **1 to 1.5 pages** long and **without** any `\section`/`\subsection`.
It summarizes the most important findings of the thesis and closes with potential aspects for further, future research.
It does not introduce new content.

**S5 – Abstract.**
The thesis always contains an English *Abstract* and a German *Zusammenfassung*, **regardless of `\thesislang`**.
Each is written in its own language (the template typesets each in the matching babel language) and has the same content.
Each of them embeds a picture representative of the project **within the running text** (`wrapfigure`, as in the template).
This is the only place in the thesis where an image is placed inline.

**S6 – Floating environments only.**
Outside the abstracts, images, tables, and listings are placed exclusively in floating environments (`figure`, `table`, `lstlisting` with `caption` and `label`), and LaTeX decides their position.
Flag `wrapfigure`, the forced placement specifier `[H]`, bare `\includegraphics`, and bare `tabular` outside `sections/abstract.tex`.

**S7 – Defined authorship.**
Every section has exactly one dedicated author, declared with `\setauthor{…}` directly after the `\section` command; its subsections belong to the same author.
Use the author constants (`\firstauthor`, …) instead of typing names.
The Introduction and the Summary are written jointly: they have no sections and no `\setauthor`.
Flag sections without `\setauthor`, several `\setauthor` within one section, names that do not match the authors in `global-const.tex`, and `\setauthor` in the Introduction or Summary.

### Figures, Tables, and Listings (F)

**F1 – Everything is referenced.**
Every figure, table, and listing is referenced in the running text via `\ref{…}`.
The reference is integrated into a sentence that carries content, e.g. "… the response time grows linearly with the number of clients, see Fig. \ref{fig:…}."
Mechanically: every `\label{fig:…}`, `\label{tab:…}`, `\label{lst:…}` needs at least one matching `\ref`; flag unreferenced floats and references to undefined labels.

### Language and Tone (L)

**L1 – Objective, measured tone.**
The thesis avoids superlatives, intensifiers, and subjective valuations (e.g. EN: *extremely, incredibly, amazing, bad*; DE: *extrem, äußerst, genial, schlecht*).
The aim is a neutral, precise tone where claims are supported by facts (values, units, sources) rather than emphasis.
Help the students find that tone instead of policing individual words:

- Judge wording in context. Words such as *optimal*, *simple*, or *best* are fine when used in a precise technical sense or backed by data (e.g. "the lowest latency of the measured configurations, see Tab. …").
- Report clear cases (emotional or promotional language, unsupported valuations) as **violation**; borderline wording as **check** with a short explanation of how it could read more objectively.
- Do not flood the report with minor wording remarks; group recurring patterns into one finding with examples.

**L2 – Impersonal, objective writing.**
No first person (EN: *I, we, me, us, my, our*; DE: *ich, wir, mich, uns, mein, unser*), including in figure captions and headings.
Personal impressions, feelings, and opinions are not part of the thesis.
Exempt: the statutory declaration in `oath.tex`.

**L3 – Gender-inclusive language.**
English: singular *they/their/them* for persons of unspecified gender (e.g. "the user … their account").
German: gender colon (e.g. *der/die Benutzer:in*, *die Benutzer:innen*).
Flag generic masculine (or feminine) forms referring to persons.

**L4 – No trivial basics.**
Avoid generic, uninformative descriptions of basic technologies that any reader of the field knows ("What is Java?", "HTML is a markup language …").
Technology descriptions focus on the aspects relevant for the project (why it was chosen, which specific features are used, how it compares to alternatives).

**L5 – Statements, not questions.**
The thesis consists of statements only.
No questions in the running text, including rhetorical questions and questions as headings.

### Evidence and Sources (E)

**E1 – Every statement is backed.**
Every statement is either
(a) supported by a source via `\cite{…}`, where paraphrased (indirect) citations are preferred over verbatim quotes, or
(b) justified by the students' own work and measurements, ideally pointing to the section, figure, or table that shows it.
Flag unsupported claims, generalizations, and numbers without origin. Flag frequent or long verbatim quotes.

**E2 – Source quality.**
Sources should be of high quality, in this order of preference:

1. Published journal articles (optimal)
2. Conference proceedings (very good)
3. Technical books (good)
4. Standards and technical specifications, user manuals, documentation, including online documentation of software (acceptable)
5. Web sources (least preferred)

Web sources must state the **date of last access** (e.g. `note = {letzter Zugriff am 23.05.2021}` or `note = {last accessed on 2021-05-23}`) and must be reasonably trustworthy (no anonymous blogs, forums, or AI-generated content).
When reviewing `bib.bib`, report the distribution of source types, web entries without access date, and entries that are never cited.
