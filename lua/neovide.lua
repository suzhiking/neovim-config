if vim.g.neovide then
-- Put anything you want to happen only in Neovide here
vim.o.guifont = "JetBrainsMono Nerd Font Mono:h14:#h-none" -- text below applies for VimScript
vim.g.neovide_window_blurred = false
-- vim.g.neovide_transparency = 0.96
vim.g.neovide_opacity = 1.0
vim.g.neovide_floating_shadow = true
vim.g.neovide_floating_z_height = 10
vim.g.neovide_light_angle_degrees = 45
vim.g.neovide_light_radius = 5
vim.g.neovide_position_animation_length = 0.2
vim.g.neovide_scroll_animation_length = 0.2
vim.g.neovide_theme = 'dark'
vim.g.neovide_refresh_rate = 240
vim.g.neovide_refresh_rate_idle = 5
vim.g.neovide_confirm_quit = true
vim.g.neovide_fullscreen = false
vim.g.neovide_remember_window_size = true
vim.g.neovide_profiler = false
vim.g.neovide_cursor_animation_length = 0.03
vim.g.neovide_cursor_trail_size = 0.8
vim.g.neovide_cursor_animate_command_line = true
-- vim.g.neovide_cursor_unfocused_outline_width = 0.125
vim.g.neovide_show_border = true
vim.g.neovide_input_macos_option_key_is_meta = 'only_left'
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0
vim.g.neovide_floating_shadow = true
vim.g.neovide_floating_z_height = 10
vim.g.neovide_light_angle_degrees = 45
vim.g.neovide_light_radius = 5
-- vim.g.neovide_show_border = true
-- vim.g.neovide_cursor_antialiasing = true

-- Cursor particles
-- vim.g.neovide_cursor_vfx_mode = "railgun" -- railgun|torpedo|pixiedust|sonicboom|ripple|wireframe
-- vim.g.neovide_cursor_vfx_opacity = 200.0
-- vim.g.neovide_cursor_vfx_particle_lifetime = 1.2
-- vim.g.neovide_cursor_vfx_particle_density = 7.0
-- vim.g.neovide_cursor_vfx_particle_speed = 10.0
-- vim.g.neovide_cursor_vfx_particle_phase = 1.5
-- vim.g.neovide_cursor_vfx_particle_curl = 1.0
--
vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
vim.keymap.set('v', '<D-c>', '"+y')    -- Copy
vim.keymap.set('n', '<D-v>', '"+P')    -- Paste normal mode
vim.keymap.set('v', '<D-v>', '"+P')    -- Paste visual mode
vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
vim.keymap.set('i', '<D-v>', '<C-R>+') -- Paste insert mode
vim.keymap.set("i", "<M-BS>", "<C-w>")
end
