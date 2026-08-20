# zen-build

## Motivation

- Replace dependency introduced in nix-config by
[36b1d23](https://github.com/thibautvas/nix-config/commit/36b1d2331905e263c00b573d9e22d2e785ae0958)
with a proper repo and lockfile.

- zen-browser does not exist in nixpkgs yet.


## Example usage

- Part of my nix-config: [zen.nix](https://github.com/thibautvas/nix-config/blob/main/modules/zen.nix).

- Standalone flake: [flake.nix](./example/flake.nix).


## License

- Zen Browser itself is [MPL-2.0](https://github.com/zen-browser/desktop/blob/dev/LICENSE)
and is not redistributed here, [sources.json](./sources.json) only pins upstream release
URLs, which `fetchurl` retrieves at build time.

- Full credit for the browser obviously goes to the [Zen Browser team](https://github.com/zen-browser)
and its contributors, this repo is only a small unofficial Nix packaging layer around their releases.

- The build expressions in this repo are [MIT](./LICENSE) licensed, feel free to reuse any or all of them.
