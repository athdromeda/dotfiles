-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

local beautiful = require("beautiful")
-- Wibox handling library
local wibox = require("wibox")

-- Custom Local Library: Common Functional Decoration
local deco = {
    wallpaper = require("deco.wallpaper"),
    taglist = require("deco.taglist"),
    tasklist = require("deco.tasklist")
}

local taglist_buttons = deco.taglist()
local tasklist_buttons = deco.tasklist()

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt {
        prompt = "Do "
    }

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(awful.button({}, 1, function()
        awful.layout.inc(1)
    end), awful.button({}, 3, function()
        awful.layout.inc(-1)
    end), awful.button({}, 4, function()
        awful.layout.inc(1)
    end), awful.button({}, 5, function()
        awful.layout.inc(-1)
    end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    -- local common = require("awful.widget.common")
    -- local function list_update(w, buttons, label, data, objects)
    --     common.list_update(w, buttons, label, data, objects)
    --     w:set_max_widget_size(500)
    -- end
    -- s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons, nil, list_update, wibox.layout.flex.horizontal())

    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        -- style = {
        --     border_width = 1,
        --     border_color = "#777777",
        --     shape = gears.shape.rounded_bar
        -- },
        layout = {
            spacing = 0,
            -- spacing_widget = {
            --     {
            --         forced_width = 5,
            --         shape = gears.shape.circle,
            --         widget = wibox.widget.separator
            --     },
            --     valign = "center",
            --     halign = "center",
            --     widget = wibox.container.place
            -- },
            layout = wibox.layout.flex.horizontal
        },
        -- Notice that there is *NO* wibox.wibox prefix, it is a template,
        -- not a widget instance.
        widget_template = {
            {
                {
                    -- {
                    --     {
                    --         id = "icon_role",
                    --         widget = wibox.widget.imagebox
                    --     },
                    --     margins = 2,
                    --     widget = wibox.container.margin
                    -- },
                    {
                        id = "text_role",
                        widget = wibox.widget.textbox
                    },
                    layout = wibox.layout.fixed.horizontal
                },
                left = 10,
                right = 10,
                widget = wibox.container.margin
            },
            id = "background_role",
            forced_width = 45,
            widget = wibox.container.background
        }
    }

    bookmark = wibox.widget {
        {
            markup = "+ ",
            align = "center",
            valign = "center",
            widget = wibox.widget.textbox
        },
        margins = 4,
        widget = wibox.container.margin
    }

    local menus = {{
        command = 'scrot -d 3',
        icon = '/home/ath/.config/awesome/icons/maximize.svg'
    }, {
        command = 'simplescreenrecorder',
        icon = '/home/ath/.config/awesome/icons/video.svg'
    }, {
        command = 'cmst',
        icon = '/home/ath/.config/awesome/icons/wifi.svg'
    }}

    local popuup = awful.popup {
        ontop = true,
        visible = false,
        bg = beautiful.bg_focus,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 4)
        end,
        placement = function(c)
            awful.placement.left(c, {
                margins = {
                    top = 30,
                    left = 30
                }
            })
        end,
        widget = {
            {{
                    image = os.getenv("HOME") .. "/.config/awesome/avatar.jpg",
                    fixed_width = 5,
                    resize = false,
                    halign = "center",
                    valign = "center",
                    widget = wibox.widget.imagebox
                },

                layout = wibox.layout.fixed.vertical
            },
            margins = 10,
            widget = wibox.container.margin
        }

    }
    local popup = awful.popup {
        ontop = true,
        visible = false,
        bg = beautiful.bg_normal,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 4)
        end,
        placement = function(c)
            awful.placement.right(c, {
                margins = {
                    top = 30,
                    right = 10
                }
            })
        end,
        widget = {
            -- {{
            --         image = os.getenv("HOME") .. "/.config/awesome/lamp.svg",
            --         fixed_width = 10,
            --         resize = false,
            --         halign = "center",
            --         valign = "center",
            --         widget = wibox.widget.imagebox
            --     },

            --     layout = wibox.layout.fixed.vertical
            -- },
            -- margins = 10,
            -- widget = wibox.container.margin
        }

    }
    local rows = {
        layout = wibox.layout.fixed.vertical
    }

    for _, item in ipairs(menus) do
        local row = wibox.widget {
            {

                {
                    image = item.icon,
                    resize = false,
                    halign = "center",
                    valign = "center",
                    fixed_width = 5,
                    fixed_height = 5,
                    widget = wibox.widget.imagebox
                },

                margins = 10,
                widget = wibox.container.margin
            },
            bg = beautiful.bg_normal,
            widget = wibox.container.background
        }
        row:connect_signal("mouse::enter", function(c)
            c:set_bg(beautiful.bg_focus)
        end)
        row:connect_signal("mouse::leave", function(c)
            c:set_bg(beautiful.bg_normal)
        end)
        row:buttons(
            awful.util.table.join(
                awful.button({}, 1, function()
                    awful.spawn.with_shell(item.command)
                    popup.visible = not popup.visible
                end)
            )
        )
        table.insert(rows, row)
    end
    popup:setup(rows)

    bookmark:buttons(awful.util.table.join(awful.button({}, 1, function()
        if popup.visible then
            popup.visible = not popup.visible
            popuup.visible = not popuup.visible
        else
            popup:move_next_to(mouse.current_widget_geometry)
            popuup:move_next_to(mouse.current_widget_geometry)
        end

         
    end)))

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "bottom",
        screen = s
    })

    -- Add widgets to the wibox
    s.mywibox:setup{
        layout = wibox.layout.stack,
        {
            layout = wibox.layout.align.horizontal,
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                -- mylauncher,
                -- s.mytaglist,
                -- s.mypromptbox,
                s.mytasklist
            },
            -- s.mytasklist,  Middle widget
            nil,
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                -- mykeyboardlayout,
                wibox.widget.systray(),
                s.mytaglist,
                mytextclock,
                bookmark,
                require("battery-widget") {
                    battery_prefix = "",
                    ac_prefix = "+"
                }
                -- s.mylayoutbox,
                -- bookmark_widget
            }
        },
        -- {
        --     s.mytaglist,
        --     valign = "center",
        --     halign = "center",
        --     layout = wibox.container.place
        -- },
        {
            s.mypromptbox,
            valign = "center",
            halign = "left",
            layout = wibox.container.place
        }
    }
end)
-- }}}
