terminal = "kitty"
browser = "mercury-browser"
fm = "kitty -e yazi"
tm = "kitty -e htop"

kb = "/home/ale/.config/qtile/keyboard.bash"

keys = [
  
    Key([mod], "left", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "right", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "down", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "up", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
   
    Key([mod, "shift"], "left", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "right", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "down", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "up", lazy.layout.shuffle_up(), desc="Move window up"),
   
    Key([mod, "control"], "left", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "right", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "down", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "up", lazy.layout.grow_up(), desc="Grow window up"),
   
    Key([mod], "f", lazy.spawn(browser), desc="Launch browser"),

    Key(
        [mod, "shift"],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),

    Key([mod], "r", lazy.spawn("rofi -show drun"), desc="Spawn rofi"),
   
    Key([mod], "m", lazy.spawn(fm), desc="Spawn file-manager"),
    Key([mod], "escape", lazy.spawn(tm), desc="Spawn task-manager"),
    Key(["mod1"], "l", lazy.spawn(kb), desc="Switch keyboard layout"),

    Key([], "XF86AudioMute", lazy.spawn("amixer -q set Master toggle")),
    Key([], "XF86LowerVolume", lazy.spawn("amixer -c 0 sset Master 1- unmute")),
    Key([], "XF86RaiseVolume", lazy.spawn("amixer -c 0 sset Master 1+ unmute")),

layouts = [
    layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"],
                   border_focus='#ffffff',
                   border_normal='#000000',
                   border_width=2,
                   margin=10,
                   margin_on_single=30,
                   border_on_single=True

screens = [
    Screen(
        wallpaper='~/.config/qtile/background.jpg',
        wallpaper_mode='stretch',
        top=bar.Bar( 
            [
                widget.Volume(),
