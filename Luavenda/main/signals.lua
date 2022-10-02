-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Custom Local Library: Common Functional Decoration
require("deco.titlebar")

-- reading
-- https://awesomewm.org/apidoc/classes/signals.html

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup
    and not c.size_hints.user_position
    and not c.size_hints.program_position then
      -- Prevent clients from being unreachable after screen count changes.
      awful.placement.no_offscreen(c)
  end
--rounded corner
  c.shape = function(cr,w,h)
    gears.shape.rounded_rect(cr,w,h,10)
  end
end)

--Change title
-- client.connect_signal("property::name", function(c)
-- 	if not (c.class == "Chromium" or c.class == "firefox") then return end
-- 	local patterns = {}
-- 	patterns["- Chromium$"] = "" -- removes "- Chromium"
-- 	patterns["- (Mozilla Firefox)$"] = "hello" -- adds brackets - [Mozilla Firefox]

-- 	for p, r in pairs(patterns) do
-- 		if string.find(c.name, p) then
-- 			-- c.name = string.gsub(c.name, p, r)
-- 			c.name = patterns[p]
-- 			break
-- 		end
-- 	end
-- end)

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     c:emit_signal("request::activate", "mouse_enter", {raise = false})
-- end)
client.connect_signal("unmanage", function() focus_on_last_in_history(mouse.screen) end)

function focus_on_last_in_history( screen )
  local c = awful.client.focus.history.get(screen, 0)
  if not (c == nil) then
    client.focus = c
    c:raise()
  end
end

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

tag.connect_signal("property::selected", function() focus_on_last_in_history(mouse.screen) end)