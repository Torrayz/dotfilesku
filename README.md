# dotfiles — Hyprland

Personal Hyprland desktop configuration, managed with [GNU Stow](https://www.gnu.org/software/stow/).

> ⚠️ **Base framework:** this configuration is built on top of **ML4W Dotfiles
> (dots-hyprland)** — https://github.com/mylinuxforwork/dotfiles. The `~/.config/hypr`,
> `~/.config/waybar`, `~/.config/ml4w`, etc. files depend on that framework and on the
> packages it installs. See *Prerequisites* below before using this on a new machine.

## What's inside

```
dotfiles/
├── home/            # everything that gets symlinked into $HOME (stow package)
│   ├── .bashrc
│   ├── .zshrc
│   ├── .gtkrc-2.0
│   ├── .Xresources
│   └── .config/
│       ├── hypr/          # Hyprland (hyprland.lua based)
│       ├── waybar/        # status bar
│       ├── rofi/          # app launcher
│       ├── kitty/         # terminal
│       ├── ml4w/          # ML4W framework (settings + scripts, no wallpapers)
│       ├── swaync/ walker/ wlogout/ waypaper/ nwg-dock-hyprland/
│       ├── matugen/ fastfetch/ ohmyposh/
│       ├── bashrc/ zshrc/ fish/         # modular shell config
│       ├── gtk-3.0/ gtk-4.0/ qt6ct/ xsettingsd/
│       └── nvim/ vim/ sidepad/
├── install.sh        # stow-based installer
├── .gitignore
└── README.md
```

Excluded on purpose (for safety / size): wallpapers, backup files (`*.bak`, `*.backup*`,
`.dms-backups`), and any secrets.

## Prerequisites

The files assume an **Arch-based** distro with Hyprland and the ML4W dependency set.
Recommended path on a fresh machine:

1. Install the base setup — either run the official **ML4W installer**
   (see https://mylinuxforwork.github.io/dotfiles/ → Getting Started), or manually install
   the equivalent packages.
2. Install `stow`: `sudo pacman -S stow`.

## Install

```bash
git clone <this-repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh            # or ./install.sh --dry-run to preview
```

This symlinks `home/…` into your `$HOME`. Paths that were specific to the original
machine are stored as `@HOME@` and replaced with *your* home directory at install time.

## Uninstall

```bash
cd ~/dotfiles && stow -D --target="$HOME" home
```

## Customizing / adding your own secrets

- Shell customization that is machine-specific belongs in `~/.bashrc_custom` /
  `~/.zshrc_custom` (git-ignored, never committed).
- Put your own wallpapers in `~/.config/ml4w/wallpapers/`.

## Notes

- A few absolute paths (fastfetch logo, qt6ct color scheme, waypaper stylesheet,
  `.gtkrc-2.0`) use `@HOME@` and are auto-adapted on install. Review those if something
  references a file you don't have.
- `git status` will show those files as modified right after install — that's expected
  (your home path got baked in for your machine).