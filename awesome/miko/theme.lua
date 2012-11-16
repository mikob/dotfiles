-------------------------------
--    "Miko" awesome theme    --
--  By Miko Borys             --
-------------------------------

-- BASICS
theme = {}
theme.font          = "ubuntu 8.5"

theme.bg_normal     = "#7D8C7C"
theme.bg_focus      = "#BCBDA5"
theme.bg_urgent     = "#DACEB1"
theme.bg_minimize   = "#81654F"

theme.fg_normal     = "#54534B"
theme.fg_focus      = "#54534B"
theme.fg_urgent     = "#562630"
theme.fg_minimize   = "#000000"

theme.border_width  = "1"
theme.border_normal = "#7D8C7C"
theme.border_focus  = "#BCBDA5"
theme.border_marked = "#562630"

-- IMAGES
theme.layout_fairh           = "/usr/share/awesome/themes/miko/layouts/fairh.png"
theme.layout_fairv           = "/usr/share/awesome/themes/miko/layouts/fairv.png"
theme.layout_floating        = "/usr/share/awesome/themes/miko/layouts/floating.png"
theme.layout_magnifier       = "/usr/share/awesome/themes/miko/layouts/magnifier.png"
theme.layout_max             = "/usr/share/awesome/themes/miko/layouts/max.png"
theme.layout_fullscreen      = "/usr/share/awesome/themes/miko/layouts/fullscreen.png"
theme.layout_tilebottom      = "/usr/share/awesome/themes/miko/layouts/tilebottom.png"
theme.layout_tileleft        = "/usr/share/awesome/themes/miko/layouts/tileleft.png"
theme.layout_tile            = "/usr/share/awesome/themes/miko/layouts/tile.png"
theme.layout_tiletop         = "/usr/share/awesome/themes/miko/layouts/tiletop.png"

theme.awesome_icon           = "/usr/share/awesome/themes/miko/awesome-icon.png"
theme.tasklist_floating_icon = "/usr/share/awesome/themes/miko/layouts/floating.png"

-- from default for now...
theme.menu_submenu_icon     = "/usr/share/awesome/themes/default/submenu.png"
theme.taglist_squares_sel   = "/usr/share/awesome/themes/default/taglist/squarefw.png"
theme.taglist_squares_unsel = "/usr/share/awesome/themes/default/taglist/squarew.png"

-- MISC
theme.wallpaper_cmd         = { "awsetbg /usr/share/awesome/themes/miko/background.jpg" }
theme.taglist_squares       = "true"
theme.titlebar_close_button = "true"
theme.menu_height           = "15"
theme.menu_width            = "100"

-- Define the image to load
theme.titlebar_close_button_normal = "/usr/share/awesome/themes/default/titlebar/close_normal.png"
theme.titlebar_close_button_focus = "/usr/share/awesome/themes/default/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive = "/usr/share/awesome/themes/default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = "/usr/share/awesome/themes/default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active = "/usr/share/awesome/themes/default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive = "/usr/share/awesome/themes/default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = "/usr/share/awesome/themes/default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active = "/usr/share/awesome/themes/default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive = "/usr/share/awesome/themes/default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = "/usr/share/awesome/themes/default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active = "/usr/share/awesome/themes/default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = "/usr/share/awesome/themes/default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive = "/usr/share/awesome/themes/default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = "/usr/share/awesome/themes/default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active = "/usr/share/awesome/themes/default/titlebar/maximized_focus_active.png"

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
