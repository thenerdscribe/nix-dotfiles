{
  pkgs ? import <nixpkgs> { },
  lib,
  unzip,
  libgbm,
  stdenv,
  libxkbcommon,
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
    libgbm
    libxcb
    libxkbcommon
  ];
  pname = "ZenNotes";
in
stdenv.mkDerivation {
  inherit pname;
  version = "2.3.0";
  src = fetchurl {
    url = "https://github.com/ZenNotes/zennotes/releases/download/v2.3.0/ZenNotes-2.3.0-linux-amd64.deb";
    hash = "sha256-DomY4JE8M4dXvd5M4Wt5myGmrS1pRhShIo7bxBJpMI8=";
  };

  dontBuild = true;

  nativeBuildInputs = [
    dpkg
    glib
    makeWrapper
  ];

  installPhase = ''
                runHook preInstall

                install_dir="$out/lib/${pname}"
                mkdir -p "$install_dir"
                cp -r . "$install_dir/"

    # The main executable is the Castlabs Electron binary named after the
    # product.  Common names: "kenku-fm", "Kenku FM", or "electron".
                local_bin=$(find "$install_dir" -maxdepth 3 \( -name "ZenNotes" -o -name "Kenku FM" -o -name "electron" \) -type f | head -1)

                mkdir -p "$out/bin"
                makeWrapper "$local_bin" "$out/bin/${pname}" \
                --set LD_LIBRARY_PATH "${runtimeLibs}" \
                --add-flags "--no-sandbox"

  '';
}
