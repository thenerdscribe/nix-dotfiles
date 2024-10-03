local wezterm = require("wezterm")

return {
	window_background_opacity = 0.6,
	macos_window_background_blur = 80,
	font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Light", stretch = "Normal", style = "Normal" }),
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
