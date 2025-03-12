def mirror-display [] {
  # mirrors current workspace to other screens
  hyprctl keyword monitor ", preferred, auto, 1, mirror, eDP-1"
}

def extend-display [] {
  hyprctl keyword monitor ", preferred, auto, 1"
}
