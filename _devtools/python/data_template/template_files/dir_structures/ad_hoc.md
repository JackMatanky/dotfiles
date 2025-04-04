```
${PROJECT_NAME}/
├── .gitignore                    <- Ignores outputs, checkpoints, and system files
├── jupytext.toml                 <- Optional: notebook pairing config for Jupytext users
├── justfile                      <- Optional: command shortcuts (e.g., `just run`)
├── pyproject.toml                <- Dependency list and minimal project metadata
├── README.md                     <- Brief description or goal of the notebook/project
│
├── data/
│   └── 01_raw/                   <- Manual uploads or copy-paste data dumps used in the analysis
│
├── notebooks/                    <- One or more scratch notebooks
│   └── 01_analysis.ipynb         <- Main exploratory or experimental notebook
│                                 <- You can pair it with a `.py` if using Jupytext
│
└── src/                          <- Lightweight helper code for data loading or preprocessing
    ├── __init__.py
    └── quickload.py              <- One-file utility for reading, renaming, or filtering data
```
