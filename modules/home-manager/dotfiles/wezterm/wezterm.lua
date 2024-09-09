local wezterm = require("wezterm")

return {
    font = wezterm.font("NotoMono Nerd Font"),
    window_close_confirmation = "NeverPrompt",
    visual_bell = {
        fade_in_duration_ms = 0,
        fade_out_duration_ms = 0,
    },
    hide_tab_bar_if_only_one_tab = true,
    font_size = 16.0,
    line_height = 1.6,
    color_scheme = "Catppuccin Mocha",
}
