{
  pkgs,
  ...
}:

let
  inherit (pkgs.stdenv.hostPlatform) system;

  variant = (builtins.fromJSON (builtins.readFile ./sources.json)).beta.${system};
  version = variant.version;
  src = pkgs.fetchurl variant;

  zenBuilds = {
    x86_64-linux = {
      nativeBuildInputs = [ pkgs.autoPatchelfHook ];

      buildInputs = with pkgs; [
        gtk3
        alsa-lib
      ];

      installPhase = ''
        mkdir -p "$out/lib/zen-${version}"
        cp -r ./* "$out/lib/zen-${version}/"
        mkdir -p "$out/bin"
        ln -s "$out/lib/zen-${version}/zen" "$out/bin/zen"
      '';
    };

    aarch64-darwin = {
      nativeBuildInputs = [ pkgs.undmg ];

      buildInputs = [ ];

      unpackPhase = "undmg $src";

      installPhase = ''
        mkdir -p "$out/Applications"
        cp -R "Zen.app" "$out/Applications/Zen Browser.app"
        mkdir -p "$out/bin"
        ln -s "$out/Applications/Zen Browser.app/Contents/MacOS/zen" "$out/bin/zen"
      '';
    };
  };

  zenUnwrapped = pkgs.stdenv.mkDerivation (
    {
      pname = "zen-browser-unwrapped";
      inherit version src;

      passthru = {
        applicationName = "Zen Browser";
        libName = "zen-${version}";
        binaryName = "zen";
        inherit (pkgs) gtk3;
        gssSupport = true;
        ffmpegSupport = true;
      };

      meta = {
        description = "Zen Browser";
        homepage = "https://zen-browser.app/";
        license = pkgs.lib.licenses.mpl20;
        mainProgram = "zen";
        platforms = builtins.attrNames zenBuilds;
      };
    }
    // zenBuilds.${system}
  );

in
{
  zen-browser-unwrapped = zenUnwrapped;
  zen-browser = pkgs.wrapFirefox zenUnwrapped {
    pname = "zen-browser";
  };
}
