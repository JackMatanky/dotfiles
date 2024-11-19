{
  config,
  pkgs,
  pkgs-unstable,
  userSettings,
  ...
}: let
  dotfiles = "../../..";
  # Centralized definition for the aliases file
  aliasesConfig = "~/.config/aliases.sh";

  # Centralized session variables for reuse across Bash and Zsh
  commonSessionVariables = {
    PATH = builtins.concatStringsSep ":" [
      "${config.home.homeDirectory}/.local/bin" # User binaries
      "/run/current-system/sw/bin" # System binaries
      "/nix/var/nix/profiles/default/bin" # Nix default profile binaries
      "${config.home.homeDirectory}/.cargo/bin" # Rust's Cargo binaries
      "${config.home.homeDirectory}/.node/bin" # Node.js binaries
      "$PATH" # Preserve existing PATH
    ];
    TERMINAL = "${pkgs.alacritty}/bin/alacritty"; # Default terminal emulator
    EDITOR = "zed"; # Default editor
  };
in {
  home.file = {
    # Configuration files for shells and other programs
    ".config/aliases.sh".source = ../../aliases.sh;
    # ".zshrc".source = ../../zsh/.zshrc;
    ".config/starship/".source = ../../starship;
    ".config/alacritty/".source = ../../alacritty;
  };

  programs = {
    # Bash Configuration
    bash = {
      enable = true; # Enable Bash as a managed program
      enableCompletion = true; # Enable Bash command-line completion

      # History configuration
      historySize = 10000; # Number of commands to keep in memory
      historyFileSize = 100000; # Number of commands to keep in the history file
      historyControl = ["ignoredups" "erasedups"]; # Avoid duplicates in history

      # Session variables for Bash
      sessionVariables = commonSessionVariables;

      # Additional commands appended to ~/.bashrc
      bashrcExtra = ''
        # Load custom aliases if present
        if [ -f ${aliasesConfig} ]; then
          source ${aliasesConfig}
        fi

        # Zoxide initialization
        eval "$(zoxide init bash)"

        # Starship prompt initialization
        eval "$(starship init bash)"
      '';
    };

    # Zsh Configuration
    zsh = {
      enable = true; # Enable Zsh as a managed program
      enableCompletion = true; # Enable command-line completion
      autosuggestion.enable = true; # Enable autosuggestions
      syntaxHighlighting.enable = true; # Enable syntax highlighting
      historySubstringSearch.enable = true; # Enable substring history search

      # Session variables for Zsh
      sessionVariables = commonSessionVariables;

      # Use shellInit to source the aliases file and initialize utilities
      # Use initExtra to source the aliases file and initialize utilities
      initExtra = ''
        # Load custom aliases
        if [ -f ${aliasesConfig} ]; then
          source ${aliasesConfig}
        fi

        # Zoxide initialization
        eval "$(zoxide init zsh)"

        # Starship prompt initialization
        eval "$(starship init zsh)"
      '';
    };

    # Nushell Configuration
    nushell = {
      enable = true; # Enable Nushell as a managed program
      configFile.source = ../../nushell/config.nu;
      envFile.source = ../../nushell/env.nu; # Link to the Nushell environment configuration
    };

    # Alacritty: Terminal emulator
    alacritty = {
      enable = true;
    };

    # Starship: Shell prompt
    starship = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };

    # Zoxide: Fast directory navigation
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };

    # Carapace: Command-line autocompletion
    carapace = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };
  };
}
