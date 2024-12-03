# Shell Commands

## NixOS

```nix
nix-channel update
```

### Flakes

```nix
nix flake update
```

```nix
nix flake check
```

```nix
nix flake show
```

```nix
nix flake metadata
```

## Nushell

### Kernel Info

```bash
uname
```

- Example:
╭──────────────────┬──────────────────────────────╮
│ kernel-name      │ Linux                                                     │
│ nodename         │ jackSurfacePro                                            │
│ kernel-release   │ 6.10.5                                                    │
│ kernel-version   │ #1-NixOS SMP PREEMPT_DYNAMIC Wed Aug 14 13:34:38 UTC 2024 │
│ machine          │ x86_64                                                    │
│ operating-system │ GNU/Linux                                                 │
╰──────────────────┴──────────────────────────────╯

List the filenames, sizes, and modification times of items in a directory.

### ls

Usage:
  > ls {flags} ...(pattern)

Flags:
  -h, --help - Display the help message for this command
  -a, --all - Show hidden files
  -l, --long - Get all available columns for each entry (slower; columns are platform-dependent)
  -s, --short-names - Only print the file names, and not the path
  -f, --full-paths - display paths as absolute paths
  -d, --du - Display the apparent directory size ("disk usage") in place of the directory metadata size
  -D, --directory - List the specified directory itself instead of its contents
  -m, --mime-type - Show mime-type in type column instead of 'file' (based on filenames only; files' contents are not examined)

Parameters:
  ...pattern <one_of(glob, string)>: The glob pattern to use.

Input/output types:
  ╭───┬─────────┬────────╮
  │ # │  input  │ output │
  ├───┼─────────┼────────┤
  │ 0 │ nothing │ table  │
  ╰───┴─────────┴────────╯

Examples:
  List visible files in the current directory
  > ls

  List visible files in a subdirectory
  > ls subdir

  List visible files with full path in the parent directory
  > ls -f ..

  List Rust files
  > ls *.rs

  List files and directories whose name do not contain 'bar'
  > ls -s | where name !~ bar

  List all dirs in your home directory
  > ls -a ~ | where type == dir

  List all dirs in your home directory which have not been modified in 7 days
  > ls -as ~ | where type == dir and modified < ((date now) - 7day)

  List given paths and show directories themselves
  > ['/path/to/directory' '/path/to/file'] | each {|| ls -D $in } | flatten

- Find the swapfile with Nushell

```nu
ls -a / | where name == "swapfile"
```

This command will:

    1. `ls -a /`: List all files and directories (including hidden ones with `-a`) in the root directory (`/`).
    2. `where name == "swapfile"`: Filter the output to only show entries where the name column is exactly "swapfile".

If the swapfile exists in your root directory, it will be displayed in the output.

## General

### Swapfile

You got it! Here's a breakdown of common swap-related shell commands in Linux:

1. Checking Swap Status
    - `swapon -s`:  Displays a list of active swap devices with details like size, type, and usage.
    - `cat /proc/swaps`: Shows the contents of the `/proc/swaps` file, providing similar information to `swapon -s`.
    - `free -h`:  Displays memory usage, including RAM and swap, in a human-readable format.
    - `top` or `htop`:  System monitoring tools that show real-time resource usage, including swap.
    - `vmstat`: Provides virtual memory statistics, including details about swap activity.

2.  Enabling and Disabling Swap
    - `sudo swapon /dev/sdX`: Activates a swap partition located at `/dev/sdX` (replace 'X' with the correct partition letter).
    - `sudo swapoff /dev/sdX`: Deactivates the swap partition at `/dev/sdX`.
    - `sudo swapon /path/to/swapfile`: Enables a swap file.
    - `sudo swapoff /path/to/swapfile`:  Disables a swap file.

3.  Creating a Swap File
    - `sudo fallocate -l SIZE /path/to/swapfile`:  Creates a swap file of a specific `SIZE` (e.g., `-l 1G` for 1 gigabyte).
    - `sudo mkswap /path/to/swapfile`:  Formats the file as a swap file.

4.  Adjusting Swap Priority
    - `sudo swapon -p PRIORITY /dev/sdX`:  Enables a swap partition with a specific `PRIORITY` (higher numbers mean higher priority).

- Important Notes:
    - You'll usually need `sudo` (root privileges) for most of these commands that modify the system.
    - Replace placeholders like `/dev/sdX`, `/path/to/swapfile`, `SIZE`, and `PRIORITY` with your actual values.


#### Restart Swapfile in Nixos

1. **Remove the Swap File:**
   - Since you manually created a swap file before, it's important to remove it to avoid any conflicts:
     ```bash
     sudo swapoff /swapfile  # Deactivate the swap file if it's active
     sudo rm /swapfile       # Remove the swap file
     ```

2. **Rebuild and Switch:**
   - Rebuild your NixOS configuration to apply the changes:
     ```bash
     sudo nixos-rebuild switch
     ```

3. **Verify Swap Activation:**
   - After the rebuild, check if the swap is active:
     ```nushell
     swapon -s
     free -h
     ```
