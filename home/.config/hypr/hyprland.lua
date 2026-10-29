-- Hyprland Lua configuration. The old hyprland.conf is kept as a rollback copy.

local mod = "SUPER"

hl.monitor({
    output = "eDP-1",
    mode = "1920x1200@60",
    position = "0x0",
    scale = 1,
})

hl.env("HYPRCURSOR_THEME", "ArcStarry-cursors")
hl.env("XCURSOR_THEME", "ArcStarry-cursors")
hl.env("HYPRCURSOR_SIZE", "35")
hl.env("XCURSOR_SIZE", "35")

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("systemctl --user start hyprland-session.target")
    hl.exec_cmd("bash -c 'wl-paste --watch cliphist store &'")
    hl.exec_cmd("/usr/bin/gnome-keyring-daemon --start --components=secrets")
end)

hl.config({
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        numlock_by_default = true,
        touchpad = { natural_scroll = true },
    },
    general = {
        gaps_in = 5,
        gaps_out = 5,
        border_size = 0,
        col = {
            active_border = "rgba(707070ff)",
            inactive_border = "rgba(d0d0d0ff)",
        },
        layout = "dwindle",
    },
    decoration = {
        rounding = 12,
        active_opacity = 1.0,
        inactive_opacity = 0.9,
        shadow = {
            enabled = true,
            range = 30,
            render_power = 5,
            offset = "0 5",
            color = "rgba(00000070)",
        },
        blur = {
            enabled = true,
            size = 6,
            passes = 2,
            ignore_opacity = true,
        },
    },
    animations = { enabled = true },
    dwindle = { preserve_split = true },
    master = { mfact = 0.5 },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        vrr = 1,
    },
    cursor = { hide_on_key_press = true },
})

hl.curve("myBezier", { type = "bezier", points = {{0.05, 0.9}, {0.1, 1.05}} })
hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "default" })

local function rule(name, match, effects)
    effects.name = name
    effects.match = match
    hl.window_rule(effects)
end

for _, class in ipairs({"gnome-calculator|galculator", "blueman-manager|nm-connection-editor", "org.gnome.Nautilus", "steam|lutris", "xdg-desktop-portal.*", "zoom", "org.quickshell"}) do
    rule("float-" .. class, { class = "^(" .. class .. ")$" }, { float = true })
end
rule("float-firefox-pip", { class = "^(firefox)$", title = "^(Picture-in-Picture)$" }, { float = true })
rule("tile-wezterm", { class = "^(org.wezfurlong.wezterm)$" }, { tile = true })
rule("tile-gnome-controls", { class = "^(gnome-control-center|pavucontrol)$" }, { tile = true })
rule("gnome-rounding", { class = "^(org.gnome.*)$" }, { rounding = 12, border_size = 0 })
rule("terminal-border", { class = "^(org.wezfurlong.wezterm|Alacritty|zen|kitty|com.mitchellh.ghostty)$" }, { border_size = 0 })
rule("thunar-opacity", { class = "^(thunar)$" }, { opacity = 0.85 })
rule("kitty-opacity", { class = "^(kitty)$" }, { opacity = 0.80 })
rule("code-opacity", { class = "^(code-oss|Code)$" }, { opacity = 0.80 })
rule("unfocused-opacity", { float = false, focus = false }, { opacity = 0.9 })

local function exec(command)
    return hl.dsp.exec_cmd(command)
end

hl.bind(mod .. " + T", exec("kitty"))
hl.bind(mod .. " + B", exec("brave"))
hl.bind(mod .. " + E", exec("thunar"))
hl.bind(mod .. " + C", exec("codium"))
hl.bind(mod .. " + SPACE", exec("dms ipc call spotlight toggle"))
hl.bind(mod .. " + SHIFT + SLASH", exec("~/.config/hypr/scripts/keyhint.sh"))
hl.bind(mod .. " + V", exec("dms ipc call clipboard toggle"))
hl.bind(mod .. " + M", exec("dms ipc call processlist focusOrToggle"))
hl.bind(mod .. " + S", exec("dms ipc call settings focusOrToggle"))
hl.bind(mod .. " + N", exec("dms ipc call notifications toggle"))
hl.bind(mod .. " + SHIFT + N", exec("dms ipc call notepad toggle"))
hl.bind(mod .. " + Y", exec("dms ipc call dankdash wallpaper"))
hl.bind(mod .. " + ALT + L", exec("dms ipc call lock lock"))
hl.bind(mod .. " + SHIFT + E", hl.dsp.exit())
hl.bind("CTRL + ALT + DELETE", exec("dms ipc call processlist focusOrToggle"))
hl.bind("F10", exec("~/.config/hypr/scripts/screenshot-dms.sh"))
hl.bind("ALT + F10", exec("dms screenshot window"))

hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = 1 }))
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = 0 }))
hl.bind(mod .. " + SHIFT + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + W", hl.dsp.group.toggle())
hl.bind(mod .. " + TAB", exec("dms ipc call hypr toggleOverview"))
hl.bind(mod .. " + R", hl.dsp.layout("togglesplit"))

for direction, key in pairs({left = "left", right = "right", up = "up", down = "down"}) do
    hl.bind(mod .. " + " .. key, hl.dsp.focus({ direction = direction }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))
end
for i = 1, 9 do
    hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

for key, direction in pairs({H = "left", L = "right", K = "up", J = "down"}) do
    hl.bind(mod .. " + " .. key, hl.dsp.focus({ direction = direction }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))
end
for key, delta in pairs({right = "40 0", left = "-40 0", up = "0 -40", down = "0 40"}) do
    hl.bind(mod .. " + CTRL + " .. key, exec("hyprctl dispatch resizeactive " .. delta))
end

hl.bind("XF86AudioRaiseVolume", exec("dms ipc call audio increment 3"), { repeating = true })
hl.bind("XF86AudioLowerVolume", exec("dms ipc call audio decrement 3"), { repeating = true })
hl.bind("XF86AudioMute", exec("dms ipc call audio mute"), { locked = true })
hl.bind("XF86AudioMicMute", exec("dms ipc call audio micmute"), { locked = true })
hl.bind("XF86MonBrightnessUp", exec("dms ipc call brightness increment 5"), { repeating = true })
hl.bind("XF86MonBrightnessDown", exec("dms ipc call brightness decrement 5"), { repeating = true })

hl.bind("SUPER + G", exec("notify-send -u critical 'Terjemahan Indo:' \"$(trans -b -t id \"$(wl-paste --primary)\")\""))
hl.bind("SUPER + SHIFT + G", exec("notify-send -u critical 'To English:' \"$(trans -b -t en \"$(wl-paste --primary)\")\""))

-- DMS Include Configs
require("dms.layout")
require("dms.outputs")
