{
  config,
  pkgs,
  ...
}: let
  # Create the Python environment with Python 3.12 and necessary packages
  pythonEnv = pkgs.python312.withPackages (pythonPackages:
    with pythonPackages; [
      python-lsp-server # LSP
      pylsp-mypy # Type Checker
      python-lsp-ruff # Linter
      pylsp-rope # Autocompletion

      ipykernel # Notebooks

      # Libraries
      pandas
      numpy
    ]);
in {
  # Add the created Python environment and other tools to home.packages
  home.packages =
    [
      pythonEnv
    ]
    ++ (with pkgs; [
      pyright # LSP
      uv # Package Installer
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
        include = ["*.py" "*.ipynb"];
        indent-width = 4;
        line-length = 80;
        # The style in which violation messages should be formatted
        output-format = "concise";
        # When preview mode is enabled, Ruff will use unstable rules, fixes, and formatting.
        preview = false;
        # Whether to show an enumeration of all fixed lint violations.
        show-fixes = true; # Default false
        lint = {
          per-file-ignores = {"__init__.py" = ["F401"];};
          select = ["E4" "E7" "E9" "F"];
          ignore = [];
          flake8-import-conventions = {
            aliases = {
              "altair" = "alt";
              "matplotlib" = "mpl";
              "matplotlib.pyplot" = "plt";
              "numpy" = "np";
              "pandas" = "pd";
              "seaborn" = "sns";
              "tensorflow" = "tf";
              "tkinter" = "tk";
              "holoviews" = "hv";
              "panel" = "pn";
              "plotly.express" = "px";
              "polars" = "pl";
              "pyarrow" = "pa";
            };
          };
        };
        # For isort import sorting, see
        # https://docs.astral.sh/ruff/settings/#lintisort
      };
    };
  };
}
