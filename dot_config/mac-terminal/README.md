# Terminal.app Configuration in Dotfiles

This folder contains a version-controlled copy of Terminal.app preferences and a bootstrap script to apply them on a new system.

## 📁 Folder Structure

```txt
mac-terminal
├── README.md
├── apply_terminal_settings.sh      # Bootstrap script to import settings
└── com.apple.Terminal.plist        # Exported Terminal settings
```

## ✅ How It Works

Terminal.app stores its settings in:

```sh
~/Library/Preferences/com.apple.Terminal.plist
```

Instead of symlinking this file (which is unsafe), we export/import it using macOS’s `defaults` system.

## 🧪 Exporting Your Current Settings

To capture your current Terminal configuration:

```sh
defaults export com.apple.Terminal ~/dotfiles/terminal/com.apple.Terminal.plist
```

This saves all Terminal settings to your dotfiles.

## 🚀 Applying Settings on a New Machine

To import the settings from your dotfiles:

```sh
cd ~/dotfiles/terminal
./apply.sh
```

This will run:

```sh
defaults import com.apple.Terminal ./com.apple.Terminal.plist
```

Terminal will now use your custom configuration.

## 🛑 Do Not Symlink `.plist` Files

Avoid symlinking `com.apple.Terminal.plist` into `~/Library/Preferences/`.
macOS caches and overwrites these files, which leads to unpredictable behavior.

## 🎨 Optional: Using Custom Profiles

If you use `.terminal` profile files (exported manually from Terminal → Settings → Profiles):

1. Save them in `terminal/profiles/`
2. Import them on a new system with:

```sh
open ./profiles/SolarizedDark.terminal
```

To make a profile default:
- Go to Terminal → Settings → General → “On startup, open…” and select your desired profile.

## 📦 Automation

Add this to your dotfiles bootstrap routine:

```sh
~/dotfiles/terminal/apply_terminal_settings.sh
```

Or wrap it into a general `macos_bootstrap.sh` if you manage multiple app settings.

### 🛠️ Make the Script Executable

Before you can run the `apply.sh` script, make sure it’s executable:

```sh
chmod +x ~/dotfiles/terminal/apply_terminal_settings.sh
```

You can then run it with:

```sh
~/dotfiles/terminal/apply_terminal_settings.sh
```
