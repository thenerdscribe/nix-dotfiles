{ pkgs, inputs, ... }:
{
  programs.niri.config = ''
    output "DP-1" {
        variable-refresh-rate
        mode "2560x1440@239.970"
    }
    output "DP-2" {
        variable-refresh-rate
        position x=2560 y=-250
        transform "90"
    }
    input {
        focus-follows-mouse max-scroll-amount="0%"
        keyboard {
            numlock
        }
        touchpad {
            // off
            tap
            // dwt
            // dwtp
            // drag false
            // drag-lock
            natural-scroll
              // accel-speed 0.2
            // accel-profile "flat"
            // scroll-method "two-finger"
            // disabled-on-external-mouse
        }
        mouse {
            // off
            // natural-scroll
            // accel-speed 0.2
            // accel-profile "flat"
            // scroll-method "no-scroll"

        }
    }
    layout {
        gaps 16
        background-color "transparent"
        center-focused-column "never"
        preset-column-widths {
            proportion 0.25
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
            proportion 0.75
            proportion 1.0
        }
        default-column-width {
            proportion 0.5
        }
        focus-ring {
            width 2
            inactive-color "#505050"
            active-gradient from="#80c8ff" to="#c7ff7f" angle=45
        }
        // You can also add a border. It's similar to the focus ring, but always visible.
        border {
            off
        }
    }
    hotkey-overlay {
        skip-at-startup
    }
    prefer-no-csd
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"
    animations {
    }
    window-rule {
        match app-id="^org\\.wezfurlong\\.wezterm$"
        default-column-width {

        }
    }
    // Open the Firefox picture-in-picture player as floating by default.
    window-rule {
        // This app-id regular expression will work for both:
        // - host Firefox (app-id is "firefox")
        // - Flatpak Firefox (app-id is "org.mozilla.firefox")
        match app-id="firefox$" title="^Picture-in-Picture$"
        open-floating true
    }
    window-rule {
        // This app-id regular expression will work for both:
        // - host Firefox (app-id is "firefox")
        // - Flatpak Firefox (app-id is "org.mozilla.firefox")
        match app-id="rofi$" title="Rofi"
        open-floating true
    }
    // Example: block out two password managers from screen capture.
    // (This example rule is commented out with a "/-" in front.)
    /-window-rule {
    match app-id=r#"^org\.keepassxc\.KeePassXC$"#
    match app-id=r#"^org\.gnome\.World\.Secrets$"#
    block-out-from "screen-capture"
    // Use this instead if you want them visible on third-party screenshot tools.
    // block-out-from "screencast"
    }
    // Example: enable rounded corners for all windows.
    // (This example rule is commented out with a "/-" in front.)
    window-rule {
        geometry-corner-radius 10
        clip-to-geometry true
    }
    binds {
        Mod+Shift+Slash {
            show-hotkey-overlay
        }
        Mod+E hotkey-overlay-title="Open file manager: pcmanfm" {
            spawn "pcmanfm"
        }
        Mod+T hotkey-overlay-title="Open a Terminal: ghostty" {
            spawn "ghostty"
        }
        Mod+Space repeat=false hotkey-overlay-title="Vicinae (Raycast)" {
            spawn "vicinae" "toggle"
        }
        Mod+Shift+Space repeat=false hotkey-overlay-title="DMS Spotlight" {
            spawn "dms" "ipc" "call" "spotlight" "toggle"
        }
        Super+Alt+Shift+Ctrl+C hotkey-overlay-title="Clipboard history" {
            spawn "vicinae" "vicinae://extensions/vicinae/clipboard/history"
        }
        XF86AudioRaiseVolume allow-when-locked=true {
            spawn-sh "playerctl --player=cmus,kew,spotify,mpd,Supersonic,audacious,firefox volume 0.05+"
        }
        XF86AudioLowerVolume allow-when-locked=true {
            spawn-sh "playerctl --player=cmus,kew,spotify,mpd,Supersonic,audacious,firefox volume 0.05-"
        }
        XF86AudioMute allow-when-locked=true {
            spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        }
        XF86AudioMicMute allow-when-locked=true {
            spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        }
        XF86AudioPlay allow-when-locked=true {
            spawn-sh "playerctl --player=cmus,kew,spotify,mpd,Supersonic,audacious,firefox play-pause"
        }
        XF86AudioStop allow-when-locked=true {
            spawn-sh "playerctl --player=cmus,kew,spotify,mpd,Supersonic,audacious,firefox stop"
        }
        XF86AudioPrev allow-when-locked=true {
            spawn-sh "playerctl --player=cmus,kew,spotify,mpd,Supersonic,audacious,firefox previous"
        }
        XF86AudioNext allow-when-locked=true {
            spawn-sh "playerctl --player=cmus,kew,spotify,mpd,Supersonic,audacious,firefox next"
        }

        Mod+Shift+M repeat=false hotkey-overlay-title="Open Rusty MPC" {
            spawn-sh "toggle-music"
        }

        Mod+O repeat=false {
            toggle-overview
        }
        Mod+Q repeat=false {
            close-window
        }
        Alt+H {
            focus-column-left
        }
        Alt+J {
            focus-window-down
        }
        Alt+K {
            focus-window-up
        }
        Alt+L {
            focus-column-right
        }
        Mod+Ctrl+Left {
            move-column-left
        }
        Mod+Ctrl+Down {
            move-window-down
        }
        Mod+Ctrl+Up {
            move-window-up
        }
        Mod+Ctrl+Right {
            move-column-right
        }
        Mod+Ctrl+H {
            move-column-left
        }
        Mod+Ctrl+J {
            move-window-down
        }
        Mod+Ctrl+K {
            move-window-up
        }
        Mod+Ctrl+L {
            move-column-right
        }
        Mod+Shift+H {
            focus-monitor-left
        }
        Mod+Shift+L {
            focus-monitor-right
        }
        Mod+Shift+Ctrl+H {
            move-window-to-monitor-left
        }
        Mod+Shift+Ctrl+L {
            move-window-to-monitor-right
        }
        Alt+U {
            focus-workspace-down
        }
        Alt+I {
            focus-workspace-up
        }
        Alt+Ctrl+U {
            move-column-to-workspace-down
        }
        Alt+Ctrl+I {
            move-column-to-workspace-up
        }
        Mod+Shift+U {
            move-workspace-down
        }
        Mod+Shift+I {
            move-workspace-up
        }
        Mod+WheelScrollDown cooldown-ms=150 {
            focus-workspace-down
        }
        Mod+WheelScrollUp cooldown-ms=150 {
            focus-workspace-up
        }
        Mod+Ctrl+WheelScrollDown cooldown-ms=150 {
            move-column-to-workspace-down
        }
        Mod+Ctrl+WheelScrollUp cooldown-ms=150 {
            move-column-to-workspace-up
        }
        Mod+WheelScrollRight {
            focus-column-right
        }
        Mod+WheelScrollLeft {
            focus-column-left
        }
        Mod+Ctrl+WheelScrollRight {
            move-column-right
        }
        Mod+Ctrl+WheelScrollLeft {
            move-column-left
        }
        Mod+Shift+WheelScrollDown {
            focus-column-right
        }
        Mod+Shift+WheelScrollUp {
            focus-column-left
        }
        Mod+Ctrl+Shift+WheelScrollDown {
            move-column-right
        }
        Mod+Ctrl+Shift+WheelScrollUp {
            move-column-left
        }

        Mod+1 {
           set-window-width "25%"
        }
        Mod+2 {
           set-window-width "33%"
        }
        Mod+3 {
           set-window-width "50%"
        }
        Mod+4 {
           set-window-width "66%"
        }
        Mod+5 {
           set-window-width "75%"
        }

        Mod+Ctrl+1 {
            move-column-to-workspace 1
        }
        Mod+Ctrl+2 {
            move-column-to-workspace 2
        }
        Mod+Ctrl+3 {
            move-column-to-workspace 3
        }
        Mod+Ctrl+4 {
            move-column-to-workspace 4
        }
        Mod+Ctrl+5 {
            move-column-to-workspace 5
        }
        Mod+Ctrl+6 {
            move-column-to-workspace 6
        }
        Mod+Ctrl+7 {
            move-column-to-workspace 7
        }
        Mod+Ctrl+8 {
            move-column-to-workspace 8
        }
        Mod+Ctrl+9 {
            move-column-to-workspace 9
        }
        Mod+BracketLeft {
            consume-or-expel-window-left
        }
        Mod+BracketRight {
            consume-or-expel-window-right
        }
        Mod+Comma {
            consume-window-into-column
        }
        Mod+Period {
            expel-window-from-column
        }
        Mod+R {
            switch-preset-column-width
        }
        Mod+Shift+R {
            switch-preset-window-height
        }
        Mod+Ctrl+R {
            reset-window-height
        }
        Mod+F {
            maximize-column
        }
        Mod+Shift+F {
            fullscreen-window
        }
        Mod+Ctrl+F {
            expand-column-to-available-width
        }
        Mod+C {
            center-column
        }
        Mod+Ctrl+C {
            center-visible-columns
        }

        Mod+Minus {
            set-column-width "-10%"
        }
        Mod+Equal {
            set-column-width "+10%"
        }

        // Finer height adjustments when in column with other windows.
        Mod+Shift+Minus {
            set-window-height "-10%"
        }
        Mod+Shift+Equal {
            set-window-height "+10%"
        }
        // Move the focused window between the floating and the tiling layout.
        Mod+V {
            toggle-window-floating
        }
        Mod+Shift+V {
            switch-focus-between-floating-and-tiling
        }
        Mod+W {
            toggle-column-tabbed-display
        }
        Mod+Shift+2 {
            screenshot
        }
        Mod+Shift+3 {
            screenshot-screen
        }
        Mod+Shift+4 {
            screenshot-window
        }
        // Applications such as remote-desktop clients and software KVM switches may
        // request that niri stops processing the keyboard shortcuts defined here
        // so they may, for example, forward the key presses as-is to a remote machine.
        // It's a good idea to bind an escape hatch to toggle the inhibitor,
        // so a buggy application can't hold your session hostage.
        //
        // The allow-inhibiting=false property can be applied to other binds as well,
        // which ensures niri always processes them, even when an inhibitor is active.
        Mod+Escape allow-inhibiting=false {
            toggle-keyboard-shortcuts-inhibit
        }
        // The quit action will show a confirmation dialog to avoid accidental exits.
        Mod+Shift+E {
            quit
        }
        Ctrl+Alt+Delete {
            quit
        }
        // Powers off the monitors. To turn them back on, do any input like
        // moving the mouse or pressing any other key.
        Mod+Shift+P {
            power-off-monitors
        }
    }
    workspace "Main" {
        open-on-output "DP-1"
    }
    workspace "Code" {
        open-on-output "DP-2"
    }
    workspace "Messaging" {
        open-on-output "DP-2"
    }
    workspace "Music" {
        open-on-output "DP-2"
    }
    spawn-sh-at-startup "streamdeck -n"
    spawn-sh-at-startup "dms run"
    spawn-sh-at-startup "syncthing"
    spawn-at-startup "ghostty"
    spawn-at-startup "spotify"
    spawn-at-startup "obsidian"
    spawn-at-startup "discord"
    spawn-at-startup "signal-desktop"
    spawn-at-startup "slack"
    spawn-sh-at-startup "vicinae server"
    spawn-sh-at-startup "/home/ryanm/Applications/pcpaneld/target/debug/pcpaneld daemon"
    window-rule {
        match title="Ghostty"
        open-maximized true
    }
    window-rule {
        match at-startup=true title="Ghostty"
        open-on-workspace "Code"
    }
    window-rule {
        match at-startup=true title="Spotify"
        open-maximized true
        open-on-workspace "Music"
    }
    window-rule {
        match at-startup=true title="Obsidian"
        open-on-workspace "Main"
        default-column-width {
            proportion 0.33333
        }
    }
    window-rule {
        match at-startup=true title="Zen Twilight"
        open-on-workspace "Main"
        default-column-width {
            proportion 0.66667
        }
    }
    window-rule {
        match at-startup=true title="Slack"
        open-on-workspace "Messaging"
    }
    window-rule {
        match at-startup=true title="Discord"
        open-on-workspace "Messaging"
    }
    window-rule {
        match at-startup=true title="Signal"
        open-on-workspace "Messaging"
    }
    window-rule {
        match title="Friends List"
        default-column-width {
            proportion 0.33333
        }
    }
    window-rule {
        match title="Soulframe"
        open-fullscreen true
    }
    window-rule {
        match is-focused=false
        opacity 0.85
    }
    window-rule {
            match title="RMPC Music"
            open-floating true
            open-focused true
            default-window-height { proportion 0.75; }
            default-column-width { proportion 0.75; }
        }
  '';
}
