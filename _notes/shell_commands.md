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
