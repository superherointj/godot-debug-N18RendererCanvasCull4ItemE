{ lib
, copyDesktopItems
, fetchFromGitHub
, fetchzip
, makeDesktopItem
, stdenv
, unzip
, alsa-lib
, expect
, gcc-unwrapped
, gnused
, git
, godot_4
, godot_4-export-templates
, libGLU
, libX11
, libXcursor
, libXext
, libXfixes
, libXi
, libXinerama
, libXrandr
, libXrender
, libglvnd
, libpulseaudio
, zlib
}:


stdenv.mkDerivation rec {
  pname = "godot-empty";
  version = "1.0.0";

  src = ./.;

  nativeBuildInputs = [
    copyDesktopItems
    godot_4
    unzip
  ];

  buildInputs = [
    alsa-lib
    gcc-unwrapped.lib
    git
    libGLU
    libX11
    libXcursor
    libXext
    libXfixes
    libXi
    libXinerama
    libXrandr
    libXrender
    libglvnd
    libpulseaudio
    zlib
  ];

  buildPhase = ''
    runHook preBuild

    # Cannot create file '/homeless-shelter/.config/godot/projects/...'
    export HOME=$TMPDIR

    mkdir -p $HOME/.local/share/godot/export_templates

    export EXPORT_TEMPLATES_VERSION=$(echo "${godot_4.version}" | ${gnused}/bin/sed "s/-/./g")
    echo "EXPORT_TEMPLATES_VERSION: $EXPORT_TEMPLATES_VERSION"

    ln -s ${godot_4-export-templates} $HOME/.local/share/godot/export_templates/$EXPORT_TEMPLATES_VERSION

    mkdir -p $out/bin

    # 'command' is required to forward stderr to stdin.
    # 'unbuffer' is required to keep colors in logs.
    command 2>&1 ${expect}/bin/unbuffer godot4 --path . --headless --verbose --export-release "Linux/X11" $out/bin/empty | tee $TMPDIR/godot.logs

    # Manually check for errors
    [ `grep "ERROR:" $TMPDIR/godot.logs | wc -l` -eq 0 ]

    runHook postBuild
  '';

  dontFixup = true;
  dontStrip = true;
  dontInstall = true;

  meta = {
    homepage = "https://github.com/superherointj/godot-debug-N18RendererCanvasCull4ItemE";
    description = "A demo for debugging N18RendererCanvasCull4ItemE in Godot 4";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
