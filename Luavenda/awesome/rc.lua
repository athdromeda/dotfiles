-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Theme handling library
local beautiful = require("beautiful")

-- Miscellanous awesome library
-- local menubar = require("menubar")

RC = {} -- global namespace, on top before require any modules
RC.vars = require("main.user-variables")

-- {{{ Error handling -- }}}
require("main.error-handling")

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/ath/.config/awesome/themes/vio/theme.lua")
-- beautiful.wallpaper = RC.vars.wallpaper
-- }}}

modkey = RC.vars.modkey

-- Custom Local Library
local main = {
  layouts = require("main.layouts"),
  tags    = require("main.tags"),
  menu    = require("main.menu"),
  rules   = require("main.rules"),
}

-- Custom Local Library: Keys and Mouse Binding
local binding = {
  globalbuttons = require("binding.globalbuttons"),
  clientbuttons = require("binding.clientbuttons"),
  globalkeys    = require("binding.globalkeys"),
  bindtotags    = require("binding.bindtotags"),
  clientkeys    = require("binding.clientkeys")
}

-- {{{ Layouts
-- Table of layouts to cover with awful.layout.inc, order matters.
-- a variable needed in main.tags, and statusbar
-- awful.layout.layouts = { ... }
RC.layouts = main.layouts()
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
-- a variable needed in rules, tasklist, and globalkeys
RC.tags = main.tags()
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
RC.mainmenu = awful.menu({ items = main.menu() }) -- in globalkeys

-- a variable needed in statusbar (helper)
RC.launcher = awful.widget.launcher(
  { image = beautiful.awesome_icon, menu = RC.mainmenu }
)

-- Menubar configuration
-- Set the terminal for applications that require it
-- menubar.utils.terminal = RC.vars.terminal

-- }}}

-- {{{ Mouse and Key bindings
RC.globalkeys = binding.globalkeys()
RC.globalkeys = binding.bindtotags(RC.globalkeys)

-- Set root
root.buttons(binding.globalbuttons())
root.keys(RC.globalkeys)
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Statusbar: Wibar
require("deco.statusbar")
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = main.rules(
  binding.clientkeys(),
  binding.clientbuttons()
)
-- }}}

-- {{{ Signals
require("main.signals")
-- }}}
awful.util.spawn("lxpolkit")
awful.util.spawn("sh /home/ath/.config/changetitle.sh")
awful.util.spawn("sh /home/ath/.config/swapesc.sh")
awful.util.spawn("feh --bg-fill /home/ath/.config/wallpaper/bg-purple.png")
awful.util.spawn("conky -p10 -c ~/.config/conky/geddy.conkyrc")

-- local buttons_example =  wibox
--   opacity = 1,
--   bg = '#2E3440',
--   ontop = true,
--   height = 100,
--   width = 200,
--   shape = function(cr, width, height)
--     gears.shape.rounded_rect(cr, width, height, 3)
--   end
-- }

-- local button = {}
-- local button = wibox.widget{
--   text = "I'm a button!",
--   widget = wibox.widget.textbox
-- }

-- buttons_example:setup{
--  button,
--  valign = 'center',
--  layout = wibox.container.place
--}

-- awful.placement.top(buttons_example, {margins = {top = 40}, parent = awful.screen.focused()})
