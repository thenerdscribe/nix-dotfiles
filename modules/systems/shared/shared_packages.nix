{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    alacritty
    delta
    dig
    fastfetch
    gh
    imagemagick
    pandoc
    prettyping
    (python313.withPackages (
      p: with p; [
        pandas
        requests
        matplotlib
      ]
    ))
    ripgrep-all
    tasksh
    taskwarrior3
    taskwarrior-tui
    unzip
    wget
    yazi-unwrapped
    yt-dlp
    zellij
  ];
}
