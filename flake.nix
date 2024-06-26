  {
    description = "Personal website using Hugo, and Blowfish";

    inputs = {
      nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
      flake-utils.url = "github:numtide/flake-utils";
    };

    outputs = { self, nixpkgs, flake-utils, }:
      flake-utils.lib.eachDefaultSystem (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
          {
            packages.website = pkgs.stdenv.mkDerivation rec {
              pname = "personal-website";
              version = "2024-05-15";
              src = ./.;
              nativeBuildInputs = [
                pkgs.hugo
              ];
              configurePhase = ''
              '';
              buildPhase = "${pkgs.hugo}/bin/hugo";
              installPhase = "cp -r public $out";
            };

            defaultPackage = self.packages.${system}.website;

            devShell = pkgs.mkShell {
              packages = [
                pkgs.hugo
              ];
              shellHook = ''
                cd ~/Projects/Personal-Blog
                hugo server -F &
                firefox --new-window localhost:1313
                cd ./content/posts
             '';
            };
          }
      );
  }
