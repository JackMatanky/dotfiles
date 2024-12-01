# NixOS Install

1. Use USB to boot NixOS
2. Update the initially downloaded packages:
    ```nix
    nix-channel update
    ```
3. Generate SSH Key
3. Add Git package with one of the following options:
    a.
    ```nix
    nix-env -iA nixpkgs.git
    ```
    b.
    ```nix
    nix run nixpkgs#git --command "git clone git@github.com:JackMatanky/dotfiles.git ~/.dotfiles"
    ```
    c. Add git to environment packages in etc/nixos/configuration.nix
4. Clone repository from GitHub
    ```bash
    git clone git@github.com:JackMatanky/dotfiles.git ~/.dotfiles
    ```
5. Run a rebuild
    ```nix
    sudo nixos-rebuild switch --flake .#<hostname> --show-trace
    ```
6. Activate Home Manager if not activated with flake:
    ```nix
    nix run .#homeConfigurations.<username>.activationPackage
    ```
