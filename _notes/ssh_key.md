# SSH

## SSH Key Generation for GitHub and GitLab

### 1. Generate an SSH Key Pair

Open your terminal and run the following command:

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

- Replace `"your_email@example.com"` with the email address you use for GitHub/GitLab.
    ```bash
    ssh-keygen -t ed25519 -C "JackMatanky@gmail.com"
    ```
- When prompted to "Enter a file in which to save the key," you can press Enter to accept the default location (`~/.ssh/id_ed25519`).
- You can optionally set a passphrase for added security.

This command generates two files in the `.ssh` directory within your home directory:

- `id_ed25519`: Your private key (keep this secure!)
- `id_ed25519.pub`: Your public key (you'll share this with GitHub and GitLab)

### 2. Start the SSH Agent

```bash
eval "$(ssh-agent -s)"
```

This starts the `ssh-agent` in the background, which will hold your private key in memory for use by SSH.

### 3. Add the SSH Key to the Agent

```bash
ssh-add ~/.ssh/id_ed25519
```

This adds your private key to the `ssh-agent`. If you set a passphrase, you'll be prompted to enter it here.

### 4. Add the Public Key to GitHub

1. Copy the contents of your public key file (`id_ed25519.pub`) to your clipboard:

   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```

2. Go to your GitHub settings:
   - Click on your profile picture in the top right corner of any GitHub page.
   - Select "Settings."
   - Click on "SSH and GPG keys" in the left sidebar.

3. Click the "New SSH key" button.
4. Give your key a descriptive title (e.g., "My Laptop").
5. Paste the contents of your public key into the "Key" field.
6. Click "Add SSH key."

### 5. Add the Public Key to GitLab

1.  If you used the same public key as for GitHub, you can skip copying it again. Otherwise, copy the contents of your public key file (`id_ed25519.pub`) to your clipboard:

    ```bash
    cat ~/.ssh/id_ed25519.pub | clip
    ```

2. Go to your GitLab settings:
   - Click on your profile picture in the top right corner of any GitLab page.
   - Select "Preferences."
   - Click on "SSH Keys" in the left sidebar.

3. Paste the contents of your public key into the "Key" field.
4. Give your key a descriptive title (e.g., "My Laptop").
5. Optionally set an expiration date for the key.
6. Click "Add key."

#### 6. Test the Connection

You can test your SSH connection to GitHub and GitLab by running the following commands:

```bash
ssh -T git@github.com
ssh -T git@gitlab.com
```
## SSH Passphrase Management

Using Keychain to Manage SSH Keys
    - Keychain is a tool that helps manage your SSH keys and their passphrases, so you don't have to enter the passphrase every time you use the key. It keeps the key loaded for the session, improving workflow and security.
1. Install Keychain
    - Install Keychain if it is not already installed. On macOS, you can use Homebrew:
    ```bash
    brew install keychain
    ```
2. Configure SSH Key with Keychain
    - In order to use Keychain, you need to specify the SSH key file (e.g., id_ed25519) in your configuration. This can be done by adding the following to your shell configuration file (e.g., .bashrc, .zshrc, or .nu for NuShell):

    For NuShell:
    See (Nushell Cookbook: Manage SSH Passphrase)[https://www.nushell.sh/cookbook/ssh_agent.html]
    ```bash
    # Run keychain to load the SSH key and environment variables
    keychain --eval --quiet $env.HOME/.ssh/id_ed25519
        | lines
        | where not ($it | is-empty)
        | parse "{k}={v}; export {k2};"
        | select k v
        | transpose --header-row
        | into record
        | load-env
    ```
    This command loads your SSH key without prompting for the passphrase each time.
3. Verifying Keychain
    - You can verify that the SSH key has been loaded correctly by running:

    ```bash
    ssh-add -l
    ```
    This will list the loaded SSH keys. If the correct key is listed, it means Keychain is working as expected.
4. Automatic Key Loading
    - By adding the Keychain configuration to your shell startup file, Keychain will automatically load the SSH key at the beginning of each session, ensuring the key is ready for use without needing to re-enter the passphrase.
