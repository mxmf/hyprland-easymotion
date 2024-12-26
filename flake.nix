# Nix config informed by VirtCode's 'Dynamic Cursor'
# https://github.com/VirtCode/hypr-dynamic-cursors
{
  description = "Easymotion, for hyprland";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    forAllSystems = function:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
      ] (system: function nixpkgs.legacyPackages.${system});
  in {
    packages = forAllSystems (pkgs: {
      default = self.packages.${pkgs.system}.hyprland-easymotion;
      hyprland-easymotion = inputs.hyprland.packages.${pkgs.system}.hyprland.stdenv.mkDerivation rec {
        name = "hyprland-easymotion";
        pname = name;
        src = ./.;
        nativeBuildInputs = inputs.hyprland.packages.${pkgs.system}.hyprland.nativeBuildInputs ++ [inputs.hyprland.packages.${pkgs.system}.hyprland];
        buildInputs = inputs.hyprland.packages.${pkgs.system}.hyprland.buildInputs;

        dontUseCmakeConfigure = true;
        dontUseMesonConfigure = true;
        dontUseNinjaBuild = true;
        dontUseNinjaInstall = true;

        installPhase = ''
        runHook preInstall

        mkdir -p "$out/lib"
        cp -r ./hypreasymotion.so "$out/lib/libhyprland-easymotion.so"
        runHook postInstall
        '';
      };
    });
  };
}
