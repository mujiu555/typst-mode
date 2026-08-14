{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "git+https://mirrors.nju.edu.cn/git/nixpkgs.git?ref=nixos-25.11&shallow=1";
    tytanic.url = "github:typst-community/tytanic/v0.4.1";
    utpm.url = "github:typst-community/utpm";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      tytanic,
      utpm,
      ...
    }:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = (import (inputs.nixpkgs) { inherit system; });
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            tytanic.packages.${system}.default
            utpm.packages.${system}.default
            typst
            tinymist
            nodejs
          ];
          shellHook = ''
            export PATH="$PWD/node_modules/.bin/:$PATH"
            export NPM_PACKAGES="$PWD/.npm-packages"
          '';
        };
      }
    );
}
