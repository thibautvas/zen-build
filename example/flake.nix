{
  description = "zen browser override";

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
      system = "x86_64-linux";

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

      zen =
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
      packages.${system}.default = zen;
    };
}
