# zen-build

## Motivation

- Replace dependency introduced in nix-config by
[36b1d23](https://github.com/thibautvas/nix-config/commit/36b1d2331905e263c00b573d9e22d2e785ae0958)
with a proper repo and lockfile.

- zen-browser does not exist in nixpkgs yet.


## Example usage

- Add zen-build to flake inputs:

```nix
zen-build = {
  url = "github:thibautvas/zen-build";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

- Override defaults:

```nix
let
  zen-browser = zen-build.packages.x86_64-linux.default;

  defaultSearchEngine = "DuckDuckGo";

  extensionSettings = {
    "uBlock0@raymondhill.net" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      installation_mode = "force_installed";
      default_area = "menupanel";
      private_browsing = true;
    };
  };

  extraPrefs = ''
    lockPref("browser.ctrlTab.sortByRecentlyUsed", true);
    lockPref("browser.shell.checkDefaultBrowser", false);
    lockPref("zen.welcome-screen.seen", true);
  '';

  zen = zen-browser.override {
    extraPolicies = {
      ExtensionSettings = extensionSettings;
      SearchEngines.Default = defaultSearchEngine;
    };
    inherit extraPrefs;
  };

in
{
  environment.systemPackages = [ zen ]; # add to system packages
  # home.packages = [ zen ]; # add to home-manager packages
  # packages.x86_64-linux.default = zen; # expose package
}
```

- System config example:
[zen.nix](https://github.com/thibautvas/nix-config/blob/0591122521d81706fd3501ed334040cd4e373846/modules/zen.nix)

- Standalone flake example:
[flake.nix](./example/flake.nix)


## License

- Zen Browser itself is [MPL-2.0](https://github.com/zen-browser/desktop/blob/dev/LICENSE)
and is not redistributed here, [sources.json](./sources.json) only pins upstream release
URLs, which `fetchurl` retrieves at build time.

- Full credit for the browser obviously goes to the [Zen Browser team](https://github.com/zen-browser)
and its contributors, this repo is only a small unofficial Nix packaging layer around their releases.

- The build expressions in this repo are [MIT](./LICENSE) licensed, feel free to reuse any or all of them.
