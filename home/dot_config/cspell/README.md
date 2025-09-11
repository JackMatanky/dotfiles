# CSpell Dictionary Setup

This file documents the external dictionaries configured in `cspell.json`.
Since JSON does not support comments, the following installation notes were removed from the config and preserved here.

## 🧩 Installed Dictionaries

To enable support for Hebrew and Python-related terminology, install the following CSpell dictionaries globally:

### Hebrew Dictionary

```sh
npm install -g @cspell/dict-he
```

Path used in cspell.json:

```sh
/opt/homebrew/lib/node_modules/@cspell/dict-he/hebrew-words.txt
```

### Python Dictionary

```sh
npm install -g @cspell/dict-python
```

Path used in cspell.json:

```sh
/opt/homebrew/lib/node_modules/@cspell/dict-python/python.txt
```

## 🔧 Notes

- These global paths assume Homebrew is installed under /opt/homebrew. If using a different Node setup (e.g., NVM), adjust the paths accordingly.
- The dictionary files are loaded manually via dictionaryDefinitions rather than auto-resolved.
