{
  config,
  pkgs,
  pkgs-unstable,
  # userSettings,
  ...
}: let
  # Create the Python environment with Python 3.12 and necessary packages
  pythonEnv = pkgs.python312.withPackages (pythonPackages:
    with pythonPackages; [
      ipykernel
      # jupyter
      # ipython-genutils
    ]);
in {
  # Add the created Python environment and other tools to home.packages
  home.packages =
    [
      pythonEnv
    ]
    ++ (with pkgs; [
      pyright # Python LSP
    ]);

  programs = {
    # Enable pyenv for Python version management
    pyenv = {
      enable = true;
      package = pkgs.pyenv;
    };

    # Enable pylint for Python linting
    pylint = {
      enable = true;
      package = pkgs.python312Packages.pylint;
    };

    # Enable ruff for Python linting
    ruff = {
      enable = true;
      package = pkgs.ruff;
      settings = {
        line-length = 100;
        per-file-ignores = {"__init__.py" = ["F401"];};
        lint = {
          select = ["E4" "E7" "E9" "F"];
          ignore = [];
        };
      };
    };
  };
}
