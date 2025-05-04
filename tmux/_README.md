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

| Plugin                                                                                        | Purpose                                          |
| --------------------------------------------------------------------------------------------- | ------------------------------------------------ |
| [`tmux-plugins/tpm`](https://github.com/tmux-plugins/tpm)                                     | Plugin manager                                   |
| [`omerxx/catppuccin-tmux`](https://github.com/omerxx/catppuccin-tmux)                         | Catppuccin theme + custom meeting/status modules |
| [`tmux-plugins/tmux-sensible`](https://github.com/tmux-plugins/tmux-sensible)                 | Better tmux defaults                             |
| [`tmux-plugins/tmux-yank`](https://github.com/tmux-plugins/tmux-yank)                         | Clipboard integration                            |
| [`tmux-plugins/tmux-prefix-highlight`](https://github.com/tmux-plugins/tmux-prefix-highlight) | Shows when prefix is active                      |
| [`tmux-plugins/tmux-resurrect`](https://github.com/tmux-plugins/tmux-resurrect)               | Manual session saving                            |
| [`tmux-plugins/tmux-continuum`](https://github.com/tmux-plugins/tmux-continuum)               | Auto-save and auto-restore                       |
| [`omerxx/tmux-sessionx`](https://github.com/omerxx/tmux-sessionx)                             | Fuzzy interactive session manager (zoxide-based) |
| [`omerxx/tmux-floax`](https://github.com/omerxx/tmux-floax)                                   | Floating, persistent popup panes                 |
| [`alexwforsythe/tmux-which-key`](https://github.com/alexwforsythe/tmux-which-key)             | Keybinding hints popup (Zellij-style)            |
| [`charlietag/tmux-split-statusbar`](https://github.com/charlietag/tmux-split-statusbar)       | Simulates a second status line                   |
| [`fcsonline/tmux-thumbs`](https://github.com/fcsonline/tmux-thumbs)                           | Visual mouse-less link selector                  |
| [`sainnhe/tmux-fzf`](https://github.com/sainnhe/tmux-fzf)                                     | Fuzzy pane/window switcher                       |
| [`wfxr/tmux-fzf-url`](https://github.com/wfxr/tmux-fzf-url)                                   | Fuzzy URL opener from visible panes              |

---

## 📅 Calendar Integration

Meeting info is displayed in the status bar using `icalBuddy` via `cal.sh`.

```sh
brew install ical-buddy
chmod +x ~/.config/tmux/scripts/cal.sh
```

Update this line in `tmux.conf` if your calendar setup differs:

```sh
set -g @catppuccin_meetings_text '#($HOME/.config/tmux/scripts/cal.sh)'
```

---

## 🧪 Setup & Activation

This is the complete setup process for first-time installation:

### Step 1: Install TPM (if not installed)

```sh
brew install tpm
```

### Step 2: Symlink the tmux config (preferred: Stow)

```sh
cd ~/dotfiles
stow -t ~/.config tmux
```

Alternatively, link manually

```sh
mkdir -p ~/.config/tmux
ln -sf ~/dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf
```

### Step 3: Start a new tmux session

```sh
tmux
```

### Step 4: Inside tmux, install all plugins via TPM

Press: Ctrl-a then I

### Step 5: Reload the config after installation

Press: Ctrl-a then r

Or run: tmux source-file ~/.config/tmux/tmux.conf

### Step 6: Confirm plugins are working

e.g., Ctrl-a + o → opens sessionx; Ctrl-a + p → opens floax

Optional: you can automate this with a Justfile task:

```justfile
tmux-bootstrap:
    mkdir -p ~/.config/tmux
    stow -t ~/.config tmux
    tmux new-session -d -s bootstrap 'sleep 1 && tmux source-file ~/.config/tmux/tmux.conf && tmux display-message "Reloaded tmux config!"'
    echo "Started tmux. Attach with: tmux attach -t bootstrap"
```

---

📁 Folder Structure

```md
tmux/
├── tmux.conf # Main config
├── tmux.keybindings # Cheatsheet viewer (bash script)
├── which-key.yaml # Configuration for which-key plugin
└── scripts/
├── cal.sh # Calendar status script (icalBuddy)
└── gen-tmux-docs # Script to regenerate cheatsheets/docs
```

---

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
