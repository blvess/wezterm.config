-- Config
local wezterm = require("wezterm")
local config = wezterm.config_builder()
-- local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local scheme = wezterm.get_builtin_color_schemes()["tokyonight"]

-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
	-- this is set by the plugin, and unset on ExitPre in Neovim
	return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "ALT" or "LEADER",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "ALT" or "CTRL" },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

config.color_scheme = "tokyonight"
config.audible_bell = "Disabled"
config.font = wezterm.font({
	harfbuzz_features = { "ss02=on" },
	family = "MonoLisa Variable",
})
config.font_size = 16
-- config.window_background_opacity = 0.95
config.hide_tab_bar_if_only_one_tab = true
config.native_macos_fullscreen_mode = false
config.disable_default_key_bindings = false
config.window_decorations = "RESIZE"
config.max_fps = 120
config.animation_fps = 120

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	split_nav("move", "h"),
	split_nav("move", "j"),
	split_nav("move", "k"),
	split_nav("move", "l"),
	-- resize panes
	split_nav("resize", "h"),
	split_nav("resize", "j"),
	split_nav("resize", "k"),
	split_nav("resize", "l"),
	{
		key = "|",
		mods = "LEADER|SHIFT",
		action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
	},
	{
		key = "-",
		mods = "LEADER",
		action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }),
	},
	{
		key = "a",
		mods = "LEADER|CTRL",
		action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }),
	},
	{
		key = "z",
		mods = "LEADER",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		key = "c",
		mods = "LEADER",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "[",
		mods = "LEADER",
		action = wezterm.action.ActivateCopyMode,
	},
	{
		key = "Enter",
		mods = "SUPER",
		action = wezterm.action.ToggleFullScreen,
	},
}

for i = 1, 8 do
	-- CTRL+a , number to activate that tab
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = wezterm.action.ActivateTab(i - 1),
	})
end

-- smart_splits.apply_to_config(config, {
-- 	direction_keys = { "h", "j", "k", "l" },
-- 	-- modifier keys to combine with direction_keys
-- 	modifiers = {
-- 		move = "LEADER", -- modifier to use for pane movement, e.g. CTRL+h to move left
-- 		resize = "ALT", -- modifier to use for pane resize, e.g. META+h to resize to the left
-- 	},
-- })

config.window_frame = {
	font_size = 16.0,
	active_titlebar_bg = scheme.background,
	inactive_titlebar_bg = scheme.background,
}

config.colors = {
	tab_bar = {
		background = "#11111b",
		active_tab = {
			bg_color = "#cba6f7",
			fg_color = "#11111b",
		},
		inactive_tab = {
			bg_color = "#181825",
			fg_color = "#cdd6f4",
		},
		inactive_tab_hover = {
			bg_color = "#1e1e2e",
			fg_color = "#cdd6f4",
		},
		new_tab = {
			bg_color = "#313244",
			fg_color = "#cdd6f4",
		},
		new_tab_hover = {
			bg_color = "#45475a",
			fg_color = "#cdd6f4",
		},
		-- fancy tab bar
		inactive_tab_edge = "#313244",
	},
}

return config
