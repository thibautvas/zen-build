{
  description = "zen browser build";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          zen = import ./build.nix {
            inherit pkgs;
          };

        in
        {
          packages = {
            default = zen.zen-browser;
            unwrapped = zen.zen-browser-unwrapped;
          };
        };

    in
    {
      packages = forAllSystems (system: (perSystem system).packages);
    };
}
