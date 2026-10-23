
{
  description = "Nix development environment for building an AOSP GSI";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      aospFhs = pkgs.buildFHSEnv {
        name = "aosp-fhs";

        targetPkgs = pkgs: with pkgs; [
          bashInteractive
          coreutils
          findutils
          gnugrep
          gnused
          gawk
          which

          git
          gitRepo
          gnupg
          curl
          wget
          rsync
          openssh

          procps
          psmisc
          util-linux
          nettools

          gnumake
          gcc
          binutils
          pkg-config

          python3
          perl
          bc
          bison
          flex
          gperf
          lzop
          m4

          zip
          unzip
          zlib
          libxml2
          libxslt
          fontconfig

          android-tools
          ccache
          file
          patch
          which
        ];

        multiPkgs = pkgs: with pkgs; [
          zlib
          ncurses
          libgcc
          stdenv.cc.cc.lib
        ];

        multiArch = true;

        runScript = "bash";

        profile = ''
          export ALLOW_NINJA_ENV=true
          export USE_CCACHE=1
          export CCACHE_EXEC="${pkgs.ccache}/bin/ccache"

          # Keep the compiler cache outside the Nix store.
          export CCACHE_DIR="$HOME/.cache/aosp-ccache"
        '';
      };
    in
    {
      packages.${system}.aosp-fhs = aospFhs;

      devShells.${system}.default = pkgs.mkShell {
        packages = [ aospFhs ];

        shellHook = ''
          echo "AOSP FHS environment available."
          echo "Run: aosp-fhs"
        '';
      };
    };
}
