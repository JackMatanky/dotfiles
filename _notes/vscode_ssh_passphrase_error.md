# 🛠️ SSH Keychain + VS Code Troubleshooting (macOS)

## 🧭 Goal

Ensure that VS Code (or any macOS GUI app) can access your unlocked SSH key through the `ssh-agent` set up by `keychain`, without prompting for your passphrase again.

---

## ✅ Step-by-Step Workflow

### 🔹 1. Verify the Problem

Run this in VS Code:

```bash
git pull --tags origin main
# → Permission denied (publickey)
```

If it works in Zsh or Nushell but **fails in VS Code**, the issue is likely that GUI apps are not inheriting your SSH environment correctly.

---

### 🔹 2. Verify SSH Agent in Terminal

```bash
ssh-add -l            # Should list your key
echo $SSH_AUTH_SOCK   # Should print a valid Unix socket path
```

If your key is listed and the socket exists, the agent is working in your terminal.

---

### 🔹 3. Set Up Keychain in `~/.zprofile`

```zsh
# ~/.zprofile

export SSH_KEY="$HOME/.ssh/id_ed25519"
eval "$(keychain --eval --quiet --nogui "$SSH_KEY")"

# Export to macOS GUI apps (like VS Code)
if [[ -n "$SSH_AUTH_SOCK" ]]; then
  launchctl setenv SSH_AUTH_SOCK "$SSH_AUTH_SOCK"
fi
```

> 📝 This file is sourced by login shells and GUI apps like VS Code.  
> Do **not** put this in `.zshrc` or `.bashrc`.

---

### 🔹 4. Restart VS Code the Right Way

Fully quit VS Code:

```bash
pkill -x "Visual Studio Code"
```

Then reopen it from the terminal (so it inherits your terminal’s environment):

```bash
code .
```

---

### 🔹 5. Test in VS Code Terminal

Inside the VS Code terminal:

```bash
ssh-add -l               # Should show your SSH key
ssh -T git@github.com    # Should say "Hi USERNAME!"
git pull --tags origin main   # Should work without asking for passphrase
```

---

## ✅ Result

Your SSH key works in VS Code and any GUI app using the same environment. Passphrase prompts no longer appear unless your agent is reset or the system is rebooted.

---

## 📈 Environment Flow Diagram

```mermaid
flowchart TD
    A[SSH Key Exists] --> B[keychain stores key]
    B --> C[agent socket set: SSH_AUTH_SOCK]
    C --> D1[Zsh Terminal Shell]
    C --> D2[Nushell]

    D1 & D2 --> E1[ssh-add -l works]
    E1 --> F[git pull --tags origin main works in terminal]

    C --> G[launchctl setenv SSH_AUTH_SOCK]
    G --> H[GUI apps (VS Code) inherit socket]

    H --> I[VS Code terminal sees SSH_AUTH_SOCK]
    I --> J[ssh-add -l shows key]
    J --> K[git pull --tags origin main works in VS Code]
```

---
