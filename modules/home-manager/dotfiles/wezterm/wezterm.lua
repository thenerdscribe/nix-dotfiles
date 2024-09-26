local wezterm = require("wezterm")

return {
	font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Light" }),
	window_close_confirmation = "NeverPrompt",
	freetype_load_flags = "NO_HINTING",
	visual_bell = {
		fade_in_duration_ms = 0,
		fade_out_duration_ms = 0,
	},
	hide_tab_bar_if_only_one_tab = true,
	font_size = 16.0,
	line_height = 1.8,
	color_scheme = "Catppuccin Mocha",
}
