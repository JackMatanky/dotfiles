# Tmux Configuration

> A polished tmux configuration designed for Zellij-style UX, visual hints, persistent sessions, and a dual-status layout. Built with TPM and powered by modern plugins.

---

## 🔧 Features

- **Zellij-inspired UX**: `Ctrl-a` as prefix, modal-style navigation
- **Dual Status Bar**: Top bar with Catppuccin theming, bottom (fake) bar for hints
- **Dynamic Keybinding Help**: `which-key` style popups after pressing the prefix
- **Persistent Sessions**: Session auto-restore and snapshot support via `continuum` and `resurrect`
- **Floating Panes**: Via `tmux-floax`
- **Calendar Integration**: Meeting info shown directly via `cal.sh` + `icalBuddy`
- **Clipboard + Mouse Support**
- **TPM Plugin Manager**, installed via Homebrew

---

## ⌨️ Keybindings

| Keybinding      | Action                                   |
| --------------- | ---------------------------------------- |
| `Ctrl-a`        | Prefix (instead of `Ctrl-b`)             |
| `Ctrl-a r`      | Reload tmux config                       |
| `Ctrl-a ?`      | View cheatsheet popup                    |
| `Ctrl-h/j/k/l`  | Move between panes                       |
| `Ctrl + Arrows` | Resize panes                             |
| `F11`           | Toggle dual status bar                   |
| `F12`           | Hide secondary status line               |
| `Ctrl-a o`      | Launch fuzzy session switcher (SessionX) |
| `Ctrl-a p`      | Launch floating pane (Floax)             |

> Full list: see [`tmux.keybindings`](./tmux.keybindings)

---

## 📦 Plugins Used

Managed by [TPM](https://github.com/tmux-plugins/tpm). Install via `Ctrl-a I`.

| Plugin                               | Purpose                                          |
| ------------------------------------ | ------------------------------------------------ |
| `tmux-plugins/tpm`                   | Plugin manager                                   |
| `omerxx/catppuccin-tmux`             | Catppuccin theme + custom meeting/status modules |
| `tmux-plugins/tmux-sensible`         | Better tmux defaults                             |
| `tmux-plugins/tmux-yank`             | Clipboard integration                            |
| `tmux-plugins/tmux-prefix-highlight` | Shows when prefix is active                      |
| `tmux-plugins/tmux-resurrect`        | Manual session saving                            |
| `tmux-plugins/tmux-continuum`        | Auto-save and auto-restore                       |
| `omerxx/tmux-sessionx`               | Fuzzy interactive session manager (zoxide-based) |
| `omerxx/tmux-floax`                  | Floating, persistent popup panes                 |
| `alexwforsythe/tmux-which-key`       | Keybinding hints popup (Zellij-style)            |
| `charlietag/tmux-split-statusbar`    | Simulates a second status line                   |
| `fcsonline/tmux-thumbs`              | Visual mouse-less link selector                  |
| `sainnhe/tmux-fzf`                   | Fuzzy pane/window switcher                       |
| `wfxr/tmux-fzf-url`                  | Fuzzy URL opener from visible panes              |

---

## 📅 Calendar Integration

Meeting info is displayed in the status bar using `icalBuddy` via `cal.sh`.

```sh
brew install ical-buddy
chmod +x ~/.config/tmux/scripts/cal.sh
```

Update this line in tmux.conf if your calendar setup differs:

```sh
set -g @catppuccin_meetings_text '#($HOME/.config/tmux/scripts/cal.sh)'
```

## 🧪 Setup

```sh
# Install TPM (if not already)
brew install tpm

# Start a tmux session and install plugins
tmux
# Then inside tmux:
# Press prefix (Ctrl-a) then I (uppercase i)
```

To automatically restore sessions on startup:

```sh
set -g @continuum-restore 'on'
```

📁 Folder Structure

```txt
tmux/
├── tmux.conf                # Main config
├── tmux.keybindings         # Cheatsheet viewer (bash script)
└── scripts/
    └── cal.sh               # Calendar status script
```

## 🧠 Philosophy

This setup balances terminal-native UX (vi-style, modal flow) with Zellij-style usability:

- Prefix-based key discovery (which-key)
- Persistent and recoverable environment
- Visual clarity via Catppuccin
- Seamless pane + session control

---

## 📚 Resources

- [tmux wiki](https://github.com/tmux/tmux/wiki)
- [tmux-cheatsheet](https://github.com/omerxx/tmux-cheatsheet)
- [tmux-floax](https://github.com/omerxx/tmux-floax)
- [tmux-which-key](https://github.com/alexwforsythe/tmux-which-key)
- [tmux-split-statusbar](https://github.com/charlietag/tmux-split-statusbar)
- [tmux-thumbs](https://github.com/fcsonline/tmux-thumbs)
- [tmux-fzf](https://github.com/sainnhe/tmux-fzf)
- [tmux-fzf-url](https://github.com/wfxr/tmux-fzf-url)
