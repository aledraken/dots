# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from libqtile import bar, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

# Keys

mod = "mod4"

# Programs

browser = "thorium-browser"
terminal = guess_terminal()
fm = "kitty -e yazi"
tm = "kitty -e htop"

# Scripts

kb = "/home/ale/.config/qtile/keyboard.bash"

keys = [
    
    # Move windows in front or back in stacking and move from previous to next
    
    Key(["mod1"], "up", lazy.window.move_up(), desc="Move in front"),
    Key(["mod1"], "down", lazy.window.move_down(), desc="Move back"), 

    Key(["mod1"], "left", lazy.group.prev_window(), desc="Move focus to previous"),
    Key(["mod1"], "right", lazy.group.next_window(), desc="Move focus to next"),

    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "left", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "right", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "down", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "up", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "left", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "right", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "down", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "up", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "left", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "right", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "down", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "up", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod, "shift"],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    # Programs & Scripts
    Key([mod], "f", lazy.spawn(browser), desc="Spawn browser"),
    Key([mod], "escape", lazy.spawn(tm), desc="Spawn task manager"),
    Key([mod], "r", lazy.spawn("rofi -show drun"), desc="Spawn rofi"),
    Key([mod], "m", lazy.spawn(fm), desc="Spawn file manager"),
    Key([mod], "l", lazy.spawn(kb), desc="Switch keyboard layout"),
    # Mouse emulation
    Key(["shift"], "KP_Up", lazy.spawn("xdotool mousemove_relative --sync 0 -150")),
    Key(["shift"], "KP_Down", lazy.spawn("xdotool mousemove_relative --sync 0 150")),
    Key(["shift"], "KP_Left", lazy.spawn("xdotool mousemove_relative --sync -- -150 0")),
    Key(["shift"], "KP_Right", lazy.spawn("xdotool mousemove_relative --sync 150 0")),
    Key(["shift"], "KP_Home", lazy.spawn("xdotool mousemove_relative --sync -- -100 -100")),
    Key(["shift"], "KP_Prior", lazy.spawn("xdotool mousemove_relative --sync 100 -100")),
    Key(["shift"], "KP_End", lazy.spawn("xdotool mousemove_relative --sync -- -100 100")),
    Key(["shift"], "KP_Next", lazy.spawn("xdotool mousemove_relative --sync 100 100")),

    Key(["mod1"], "KP_Up", lazy.spawn("xdotool mousemove_relative --sync 0 -50")),
    Key(["mod1"], "KP_Down", lazy.spawn("xdotool mousemove_relative --sync 0 50")),
    Key(["mod1"], "KP_Left", lazy.spawn("xdotool mousemove_relative --sync -- -50 0")),
    Key(["mod1"], "KP_Right", lazy.spawn("xdotool mousemove_relative --sync 50 0")),
    Key(["mod1"], "KP_Home", lazy.spawn("xdotool mousemove_relative --sync -- -50 -50")),
    Key(["mod1"], "KP_Prior", lazy.spawn("xdotool mousemove_relative --sync 50 -50")),
    Key(["mod1"], "KP_End", lazy.spawn("xdotool mousemove_relative --sync -- -50 50")),
    Key(["mod1"], "KP_Next", lazy.spawn("xdotool mousemove_relative --sync 50 50")),

    Key(["mod1"], "KP_Begin", lazy.spawn("xdotool click 1")),
    Key(["mod1"], "KP_Insert", lazy.spawn("xdotool click 3")),

    Key(["shift"], "KP_Begin", lazy.spawn("xdotool click 1")),
    Key(["shift"], "KP_Insert", lazy.spawn("xdotool click 3")),

    Key(["control"], "KP_Begin", lazy.spawn("xdotool click 1")),
    Key(["control"], "KP_Insert", lazy.spawn("xdotool click 3")),

    Key(["control"], "KP_Up", lazy.spawn("xdotool mousemove_relative --sync 0 -10")),
    Key(["control"], "KP_Down", lazy.spawn("xdotool mousemove_relative --sync 0 10")),
    Key(["control"], "KP_Left", lazy.spawn("xdotool mousemove_relative --sync -- -10 0")),
    Key(["control"], "KP_Right", lazy.spawn("xdotool mousemove_relative --sync 10 0")),
    Key(["control"], "KP_Home", lazy.spawn("xdotool mousemove_relative --sync -- -10 -10")),
    Key(["control"], "KP_Prior", lazy.spawn("xdotool mousemove_relative --sync 10 -10")),
    Key(["control"], "KP_End", lazy.spawn("xdotool mousemove_relative --sync -- -10 10")),
    Key(["control"], "KP_Next", lazy.spawn("xdotool mousemove_relative --sync 10 10")),
    # Audio (doesn't work in vm, need to try on metal)
    Key([], "XF86AudioMute", lazy.spawn("amixer -q set Master toggle")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -c 0 sset Master 5- unmute")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -c 0 sset Master 5+ unmute"))
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )


groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layouts = [
    layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], 
                   border_width=1, 
                   border_focus='#ffffff', 
                   border_normal='#000000', 
                   margin=5, 
                   margin_on_single=10, 
                   border_on_single=True
                   ),
    layout.Max(),
    layout.Floating(border_width=0
                    ),

    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="sans",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        wallpaper='~/.config/qtile/background.jpg',
        wallpaper_mode='stretch',
        top=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(disable_drag=True, hide_unused=True),
                widget.Prompt(),
                widget.WindowName(),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ), 
                widget.Volume(),
                widget.Systray(),
                widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
                widget.QuickExit(),
            ],
            24,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
        border_width=1,
        border_focus="#ffffff",
        border_normal="#000000",
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
