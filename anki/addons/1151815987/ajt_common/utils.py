# Copyright: Ajatt-Tools and contributors; https://github.com/Ajatt-Tools
# License: GNU AGPL, version 3 or later; http://www.gnu.org/licenses/agpl.html

import functools
import os
from typing import Optional
from collections.abc import Iterable


def ui_translate(key: str) -> str:
    return key.capitalize().replace("_", " ")


def find_executable_with_distutils(name: str) -> Optional[str]:
    """
    Tries to find 'executable' using distutils.
    Fedora might not have distutils present. If this is the case, don't crash and return None.
    """
    try:
        from distutils.spawn import find_executable as _find
    except ImportError:
        return None
    else:
        return _find(name)


HARDCODED_PATHS = (
    "/usr/bin",
    "/opt/homebrew/bin",
    "/usr/local/bin",
    "/bin",
    os.path.join(os.getenv("HOME", "/home/user"), ".local", "bin"),
)


def find_executable_hardcoded(name: str) -> Optional[str]:
    def _iter() -> Iterable[str]:
        return map(lambda path: os.path.join(path, name), HARDCODED_PATHS)

    for path_to_exe in _iter():
        if os.path.isfile(path_to_exe):
            return path_to_exe


@functools.cache
def find_executable(name: str) -> Optional[str]:
    """
    If possible, use the executable installed in the system.
    Otherwise, try fallback paths.
    """
    return find_executable_with_distutils(name) or find_executable_hardcoded(name)


def main():
    print("distutils", find_executable_with_distutils("anki"))
    print("hardcoded", find_executable_hardcoded("anki"))
    print("all", find_executable("anki"))


if __name__ == "__main__":
    main()