{
  config,
  pkgs,
  lib,
  pkgs-unstable,
  inputs,
  systemSettings,
  ...
}: let
  zedDir = builtins.path {
    path = ../../zed;
    name = "zed";
  };
  configDir = ".config/zed/";
in {
  home = {
    file = {
      "${configDir}settings.json".source = "${zedDir}/settings.json";
      "${configDir}keymap.json".source = "${zedDir}/keymap.json";
      "${configDir}snippets/".source = "${zedDir}/snippets";
    };
    packages =
      with pkgs-unstable; [
        zed-editor
      ];
    #   ++ [
    #     inputs.simple-completion-language-server.defaultPackage.${systemSettings.system}
    #   ];
  };
  # programs.zed-editor = {
  #   enable = true;
  #   extensions = [
  #     "base16"
  #     "basher"
  #     "csv"
  #     "dbml"
  #     "git-firefly"
  #     "html"
  #     "just"
  #     "latex"
  #     "markdown-oxide"
  #     "mermaid"
  #     "nix"
  #     "pylsp"
  #     "python-refactoring"
  #     "rainbow-csv"
  #     "ruff"
  #     "sagemath"
  #     "snippets"
  #     "sql"
  #     "toml"
  #     "typst"
  #   ];
    # extraPackages = with pkgs; [
    #   nixd
    # ];

    # simple-completion-language-server = pkgs.callPackage inputs.simple-completion-language-server {};
  };
}
