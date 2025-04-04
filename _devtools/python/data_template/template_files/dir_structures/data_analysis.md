```
${PROJECT_NAME}/
├── .gitignore                    <- Git exclusions for caches, environments, notebook checkpoints, etc.
├── jupytext.toml                 <- Configuration for notebook pairing (.ipynb <-> .py) if Jupytext is used
├── justfile                      <- Task runner for reproducible automation (e.g., `just init`, `just notebooks`)
├── pyproject.toml                <- Project configuration and dependency management (PEP 621, used with uv)
├── README.md                     <- Project overview, setup instructions, and documentation entry point
│
├── data/                         <- Input data organized by level of transformation
│   ├── 00_external/              <- Raw data from third-party sources (e.g., APIs, vendors)
│   ├── 01_raw/                   <- Unmodified original data as received or collected
│   ├── 02_interim/               <- Lightly cleaned or merged data
│   └── 03_processed/             <- Final dataset used in analysis or visualizations
│
├── notebooks/                    <- Jupyter notebooks used to explore and analyze data
│   ├── 01_cleaning.ipynb         <- Data loading, inspection, and basic cleaning steps
│   ├── 02_exploration.ipynb      <- Exploratory data analysis (EDA), correlations, distributions
│   ├── 03_visualization.ipynb    <- Static and interactive plots for storytelling
│   └── 04_summary.ipynb          <- Key takeaways, stakeholder-oriented results
│                                 <- Naming convention: `NN_topic.ipynb` (or `NN_initials_topic.ipynb`)
│
├── reports/                      <- Generated outputs from the analysis
│   ├── figures/                  <- Plots, charts, and visual assets
│   └── report.md                 <- Markdown-based executive summary or technical report
│
├── references/                   <- Contextual and supporting resources: data dictionaries, manuals, papers
│
├── docs/                         <- Optional documentation site (e.g., mkdocs or Sphinx config and source)
│
└── src/                          <- Core reusable analysis logic
    ├── __init__.py               <- Marks `src` as a Python module
    ├── config.py                 <- Centralized configuration (e.g., file paths, options)
    ├── dataset.py                <- Scripts to read, clean, and join data
    ├── features.py               <- Code for engineered or aggregated variables
    └── plots.py                  <- Common chart templates or wrappers (e.g., seaborn, matplotlib)
```
