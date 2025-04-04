```
${PROJECT_NAME}/
├── .gitignore                    <- Git exclusions for cache, environments, and temporary files
├── jupytext.toml                 <- Jupytext configuration for notebook pairing (e.g., ipynb <-> py:percent)
├── justfile                      <- Reproducible task runner (e.g., `just init`, `just run`)
├── pyproject.toml                <- Project metadata and dependency specification (PEP 621, used with uv)
├── README.md                     <- Top-level README with setup instructions and project overview
│
├── data/                         <- Data, structured by transformation stage
│   ├── 00_external/              <- External data from APIs, vendors, or third parties
│   ├── 01_raw/                   <- Immutable raw data as originally acquired
│   ├── 02_interim/               <- Data that has been lightly cleaned or reshaped
│   └── 03_processed/             <- Fully cleaned, transformed data used for modeling
│
├── notebooks/                    <- Jupyter notebooks (paired with `.py` files if Jupytext is used)
│   ├── 01_cleaning.ipynb         <- Initial data loading and sanitization
│   ├── 02_exploration.ipynb      <- Exploratory Data Analysis (EDA)
│   ├── 03_features.ipynb         <- Feature engineering and selection
│   └── 04_modeling.ipynb         <- Model development and evaluation
│                                 <- Naming: `NN_description.ipynb` or `NN_initials_description.ipynb`
│
├── reports/                      <- Outputs generated from analysis or notebooks
│   ├── figures/                  <- Plots and visual assets used in reports
│   └── report.md                 <- Summarized findings, insights, or deliverables
│
├── references/                   <- Background material: data dictionaries, papers, manuals, etc.
│
├── models/                       <- Serialized models, intermediate predictions, and metadata
│   └── README.md                 <- Optional: model architecture notes, version history, etc.
│
├── docs/                         <- Optional mkdocs or Sphinx documentation project
│
└── src/                          <- Core logic for data, features, modeling, and plotting
    ├── __init__.py               <- Makes `src` a proper Python module
    ├── config.py                 <- Global configuration (e.g., paths, constants, flags)
    ├── dataset.py                <- Data I/O, acquisition, and initial parsing logic
    ├── features.py               <- Feature engineering methods
    ├── modeling/                 <- Training and inference code
    │   ├── __init__.py
    │   ├── train.py              <- Model fitting logic
    │   └── predict.py            <- Evaluation and inference utilities
    └── plots.py                  <- Plotting and visualization code
```
