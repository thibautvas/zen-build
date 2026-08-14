# zen-build

## Motivation

- Replace dependency introduced in nix-config by
[36b1d23](https://github.com/thibautvas/nix-config/commit/36b1d2331905e263c00b573d9e22d2e785ae0958)
with a proper repo and lockfile.

- zen-browser does not exist in nixpkgs yet.


## System config

Mine lives here: [zen.nix](https://github.com/thibautvas/nix-config/blob/main/modules/zen.nix).


## Standalone usage

```nix
{
  description = "zen browser overrides";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    zen-build = {
      url = "github:thibautvas/zen-build";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      zen-build,
    }:
    let
      inherit (nixpkgs) lib;

      defaultSearchEngine = "DuckDuckGo";

      extensions = {
        "uBlock0@raymondhill.net" = "ublock-origin";
        "addon@darkreader.org" = "darkreader";
      };

      prefs = {
        "browser.shell.checkDefaultBrowser" = false;
        "zen.welcome-screen.seen" = true;
      };

      extensionSettings = builtins.mapAttrs (name: value: {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/${value}/latest.xpi";
        installation_mode = "force_installed";
        default_area = "menupanel";
        private_browsing = "allow";
      }) extensions;

      extraPrefs = lib.concatMapAttrsStringSep "\n" (
        name: value: "lockPref(${builtins.toJSON name}, ${builtins.toJSON value});"
      ) prefs;

      mkOverride =
        system:
        let
          zen-browser = zen-build.packages.${system}.default;
        in
        zen-browser.override {
          extraPolicies = {
            ExtensionSettings = extensionSettings;
            SearchEngines.Default = defaultSearchEngine;
          };
          inherit extraPrefs;
        };
    in
    {
      packages = lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ] (system: {
        default = mkOverride system;
      });
    };
}
```
