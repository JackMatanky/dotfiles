# Dotfile

My dotfiles repo managed with GNU Stow on MacOS.

## Apps

### CLI

#### Shell

- [Nushell](https://www.nushell.sh/)

    ```bash
    brew install nushell
    ```

- [ZSH](https://zsh.sourceforge.io/)

    - [ZSH Autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)

    ```bash
    brew install zsh-autosuggestions
    ```

    - [ZSH Syntax Highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

    ```bash
    brew install zsh-syntax-highlighting
    ```

    - [ZSH Autocomplete](https://github.com/marlonrichert/zsh-autocomplete)

    ```bash
    brew install zsh-autocomplete
    ```

##### Plugins

- [Carapace](https://carapace.sh/)

```bash
brew install carapace
```

- [eza](https://eza.rocks/)

```bash
brew install eza
```

- [fzf](https://junegunn.github.io/fzf/)

```bash
brew install fzf
```

- [ripgrep](https://github.com/BurntSushi/ripgrep)

```bash
brew install ripgrep
```

- [fd](https://github.com/sharkdp/fd)

```bash
brew install fd
```

#### Terminal Emulator

- [Wezterm](https://wezfurlong.org/wezterm/)

```bash
brew install --cask wezterm
```

#### Prompt

- [Starship](https://starship.rs/)

```bash
brew install starship
```

### Development

#### [Neovim](https://neovim.io/)

```bash
brew install neovim
```

#### [Zed](https://zed.dev/)

```bash
brew install --cask zed
```

- [Java Development Kit]()

used for zotero libreoffice plugin

```bash
brew install openjdk
```

If you need to have openjdk first in your PATH, run:
  echo 'export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"' >> /Users/jack/.config/zsh/.zshrc

For compilers to find openjdk you may need to set:
  export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"

#### Version Control

```bash
brew install git
brew install lazygit
```

```bash
brew install keychain
```

### Brower

- [Firefox](https://www.mozilla.org/firefox/)

```bash
brew install --cask firefox
```

### PKM

- [Obsidian](https://obsidian.md/)

```bash
brew install --cask obsidian
```

- [LibreOffice](https://www.libreoffice.org/)

```bash
brew install --cask libreoffice
```

- LibreOffice Language Pack

```bash
brew install --cask libreoffice-language-pack
```

- [Anki](https://apps.ankiweb.net/)

```bash
brew install --cask anki
brew install webp
brew install avif
```
