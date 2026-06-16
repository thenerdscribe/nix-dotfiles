# Claude: "Make me a NixOS derivation for kenku-fm (https://github.com/owlbear-rodeo/kenku-fm)"
# + Some tweaks so it's not a flake (easier sometimes)
{
  pkgs ? import <nixpkgs> { },
  lib,
  unzip,
  stdenv,
  fetchurl,
  appimageTools, # used to unpack the AppImage variant if preferred
  makeWrapper,
  autoPatchelfHook,
  dpkg, # only needed for the .deb unpack path
  electron, # fallback electron – NOT used at runtime (Castlabs
  # Electron is bundled inside the upstream zip)
  libGL,
  libdrm,
  mesa,
  alsa-lib,
  libudev-zero,
  at-spi2-atk,
  at-spi2-core,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libX11,
  libXScrnSaver,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXrender,
  libXtst,
  libxcb,
  nspr,
  nss,
  pango,
  systemd,
  xorg,
  udev,
}:
let
  pname = "kenku-fm";
  version = "1.5.5";

  # ── pre-built zip release ─────────────────────────────────────────────
  # Download the Linux x86_64 zip from the GitHub release page.
  # To update: grab the new URL from the Releases page and run
  #   nix-prefetch-url --type sha256 <url>
  # to obtain the correct hash.
  src = fetchurl {
    url = "https://github.com/owlbear-rodeo/kenku-fm/releases/download/v${version}/Kenku.FM-linux-x64-${version}.zip";
    # Replace this placeholder with the real sha256 after prefetching:
    # sha256 = lib.fakeSha256;
    sha256 = "0j9bp0ccmzglsc7k5zhxg2d6y9njbgxkf8rlg872qx0b8jrs88fj";
  };

  # Runtime libraries the bundled Electron/Chromium needs.
  runtimeLibs = lib.makeLibraryPath [
    libGL
    libdrm
    mesa
    alsa-lib
    libudev-zero
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libxcb
    nspr
    nss
    pango
    systemd
    udev
  ];

in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    unzip
  ];

  buildInputs = [
    libGL
    alsa-lib
    gtk3
    nss
    nspr
    dbus
    at-spi2-atk
    cups
    libdrm
    mesa
    libXdamage
    libXext
    libXfixes
    libXrandr
    libxcb
    libX11
    systemd
    udev
  ];

  # The zip extracts to a directory; autoPatchelf will fix the ELF RPATH.
  unpackPhase = ''
    runHook preUnpack
    unzip -q $src -d extracted
    sourceRoot=$(find extracted -maxdepth 1 -mindepth 1 -type d | head -1)
    if [ -z "$sourceRoot" ]; then
      # Flat zip – treat the extracted directory itself as the root.
      sourceRoot=extracted
    fi
    runHook postUnpack
  '';

  # Nothing to compile – the zip contains the fully-built application.
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install_dir="$out/lib/${pname}"
    mkdir -p "$install_dir"
    cp -r . "$install_dir/"

    # The main executable is the Castlabs Electron binary named after the
    # product.  Common names: "kenku-fm", "Kenku FM", or "electron".
    local_bin=$(find "$install_dir" -maxdepth 1 \( -name "kenku-fm" -o -name "Kenku FM" -o -name "electron" \) -type f | head -1)

    mkdir -p "$out/bin"
    makeWrapper "$local_bin" "$out/bin/${pname}" \
      --set LD_LIBRARY_PATH "${runtimeLibs}" \
      --add-flags "--no-sandbox"

    # Desktop entry
    mkdir -p "$out/share/applications"
    cat > "$out/share/applications/${pname}.desktop" <<EOF
    [Desktop Entry]
    Name=Kenku FM
    Comment=Online tabletop audio sharing for Discord
    Exec=${pname} %U
    Icon=${pname}
    Terminal=false
    Type=Application
    Categories=AudioVideo;Audio;Network;
    EOF

    # Icon – the zip may ship a .png; try common locations.
    for candidate in \
        "$install_dir/resources/app/src/icons/icon.png" \
        "$install_dir/resources/app.asar.unpacked/src/icons/icon.png" \
        "$install_dir/kenku-fm.png"; do
      if [ -f "$candidate" ]; then
        mkdir -p "$out/share/pixmaps"
        cp "$candidate" "$out/share/pixmaps/${pname}.png"
        break
      fi
    done

    runHook postInstall
  '';

  # autoPatchelfHook will try to satisfy ELF dependencies; some Chromium
  # shared objects are self-contained inside the zip so failures for those
  # can be ignored.
  autoPatchelfIgnoreMissingDeps = true;

  meta = with lib; {
    description = "Online tabletop audio sharing for Discord";
    longDescription = ''
      Kenku FM is a desktop application for Windows, macOS, and Linux designed
      to be the easiest way to share music in a Discord voice call.  It can
      share local music files, stream audio from websites such as YouTube and
      Spotify, and integrates with the Elgato Stream Deck.
    '';
    homepage = "https://www.kenku.fm";
    downloadPage = "https://github.com/owlbear-rodeo/kenku-fm/releases";
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
    # Kenku FM bundles the Castlabs Electron fork which includes Widevine CDM.
    # Widevine itself is proprietary; set unfreeRedistributable accordingly if
    # you want DRM-protected media playback.
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
