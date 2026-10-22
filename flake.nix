{
  description = "LaTeX development environment for the HTL Leonding diploma thesis";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
      texFor = pkgs: pkgs.texliveMedium.withPackages (ps: [
        ps.latexmk
        ps.ieeetran
        ps."collection-latexextra"
        ps."collection-langgerman"
      ]);
    in
    {
      devShells = forAllSystems (pkgs:
        let
          tex = texFor pkgs;
        in
        {
          default = pkgs.mkShell {
            buildInputs = [ tex pkgs.perl pkgs.plantuml ];
            shellHook = ''
              echo "LaTeX thesis shell ready."
              echo "  nix run .#build     — build thesis.pdf"
              echo "  nix run .#watch     — auto-rebuild on changes"
              echo "  nix run .#clean     — remove generated files"
              echo "  nix run .#diagrams  — render diagrams/*.puml to PNG + SVG"
              echo "  latexmk thesis.tex  — use the project .latexmkrc"
            '';
          };
        });

      packages = forAllSystems (pkgs:
        let
          tex = texFor pkgs;
        in
        {
          thesis = pkgs.stdenvNoCC.mkDerivation {
            name = "thesis";
            src = ./.;
            nativeBuildInputs = [ tex pkgs.perl ];
            buildPhase = ''
              # Build the cover page first (required by the main document via \includepdf)
              latexmk -cd -pdf -pdflatex="pdflatex -interaction=nonstopmode -halt-on-error -shell-escape %O %S" titlepage/coversheet.tex

              # Build the main thesis
              latexmk -pdf thesis.tex
            '';
            installPhase = ''
              mkdir -p $out
              cp thesis.pdf $out/thesis.pdf
              cp titlepage/coversheet.pdf $out/coversheet.pdf || true
            '';
          };
          default = self.packages.${pkgs.system}.thesis;
        });

      apps = forAllSystems (pkgs:
        let
          tex = texFor pkgs;

          build = pkgs.writeShellScriptBin "build-thesis" ''
            export PATH="${pkgs.lib.makeBinPath [ tex pkgs.perl ]}:$PATH"
            set -e

            # Build the cover page if it is missing or stale.
            latexmk -cd -pdf -pdflatex="pdflatex -interaction=nonstopmode -halt-on-error -shell-escape %O %S" titlepage/coversheet.tex

            # Build the main thesis using the project's .latexmkrc
            latexmk -pdf thesis.tex
          '';

          clean = pkgs.writeShellScriptBin "clean-thesis" ''
            export PATH="${pkgs.lib.makeBinPath [ tex ]}:$PATH"
            set -e

            latexmk -C thesis.tex || true
            latexmk -C -cd titlepage/coversheet.tex || true

            rm -f thesis.{acn,acr,alg,aux,bbl,blg,glg,glo,gls,ist,lof,log,lol,lot,out,run.xml,sym,toc,xmpdata,xmpi}
            rm -f titlepage/coversheet.{aux,bbl,blg,fdb_latexmk,fls,log,out,run.xml,xmpdata,xmpi}
            rm -f sections/*.aux
          '';

          watch = pkgs.writeShellScriptBin "watch-thesis" ''
            export PATH="${pkgs.lib.makeBinPath [ tex pkgs.perl ]}:$PATH"
            latexmk -pvc -pdf thesis.tex
          '';

          diagrams = pkgs.writeShellScriptBin "render-diagrams" ''
            export PATH="${pkgs.lib.makeBinPath [ pkgs.plantuml ]}:$PATH"
            export PLANTUML_LIMIT_SIZE=16384
            set -e
            plantuml -tpng diagrams/*.puml
            plantuml -tsvg diagrams/*.puml
          '';
        in
        {
          default = {
            type = "app";
            program = "${build}/bin/build-thesis";
          };
          build = {
            type = "app";
            program = "${build}/bin/build-thesis";
          };
          clean = {
            type = "app";
            program = "${clean}/bin/clean-thesis";
          };
          watch = {
            type = "app";
            program = "${watch}/bin/watch-thesis";
          };
          diagrams = {
            type = "app";
            program = "${diagrams}/bin/render-diagrams";
          };
        });
    };
}
