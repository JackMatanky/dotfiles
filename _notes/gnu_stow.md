# GNU Stow

Reference for managing dotfiles using [GNU Stow](https://www.gnu.org/software/stow/).
Documentation: https://www.gnu.org/software/stow/manual/stow.html

## General Usage

To install a package:

```bash
cd /usr/local/stow
stow package1
```

To uninstall a package:

```bash
cd /usr/local/stow
stow -D package1
```

By using GNU Stow, you can keep your system organized and reduce the complexity of managing software installations.

## Install Software from Source using GNU Stow

For the demonstration purpose, we will see how to install the latest version of curl using GNU Stow on a Linux system.

1. Update Your System:

Ensure your system package database is up-to-date.

```bash
sudo apt update   # For Debian/Ubuntu-based systems
sudo yum update   # For CentOS/RHEL systems
sudo dnf update   # For Fedora systems
sudo pacman -Syu  # For Arch Linux systems
```

2. Install Required Development Tools:

Install the necessary development tools if they are not already installed.

```bash
sudo apt install build-essential   # Debian/Ubuntu
sudo yum groupinstall "Development Tools"   # CentOS/RHEL
sudo dnf groupinstall "Development Tools"   # Fedora
sudo pacman -S base-devel   # Arch Linux
```

You will also need to install the OpenSSL development libraries if you want to compile curl with the OpenSSL backend. For example on Debian-based systems, you can install OpenSSL development libraries using command:

```bash
sudo apt install libssl-dev
```

If you want to compile curl with the GnuTLS backend, install the following on a Debian-based systems:

```bash
sudo apt install libgnutls28-dev libgnutls30
```

3. Install GNU Stow:

Ensure GNU Stow is installed.

```bash
sudo pacman -S stow     # Arch Linux
sudo apt install stow   # Debian/Ubuntu
sudo yum install stow   # Older CentOS/RHEL
sudo dnf install stow   # Latest Fedora/RHEL/AlmaLinux/Rocky Linux
```

4. Download and Extract curl Source Code:

Download the latest Curl source code from its official releases page and extract it.

```bash
wget https://github.com/curl/curl/releases/download/curl-8_8_0/curl-8.8.0.tar.gz
tar xvf curl-8.8.0.tar.gz
```

5. Configure the Build with the Prefix:

Cd into the extracted directory:

```bash
cd curl-8.8.0
```

Configure the Build with the TLS backend and installation directory to be managed by GNU Stow.

```bash
./configure --with-ssl --prefix=/usr/local/stow/curl-8.8.0
```

If you want to configure Curl with GnuTLS, use this command instead:

```bash
./configure --with-gnutls --prefix=/usr/local/stow/curl-8.8.0
```

6. Compile the Software:

```bash
make
```

7. Install the Software:

```bash
sudo make install
```

8. Use GNU Stow to Manage the Installation:

Change to the stow directory and use stow to manage the installation.

```bash
cd /usr/local/stow
sudo stow curl-8.8.0
```

9. Verify the Installation:

Verify that Curl is correctly installed and accessible.

```bash
curl --version
```

Sample Output:

```bash
curl 8.8.0 (x86_64-pc-linux-gnu) libcurl/8.8.0 OpenSSL/1.1.1w zlib/1.2.11
Release-Date: 2024-05-22
Protocols: dict file ftp ftps gopher gophers http https imap imaps ipfs ipns mqtt pop3 pop3s rtsp smb smbs smtp smtps telnet tftp
Features: alt-svc AsynchDNS HSTS HTTPS-proxy IPv6 Largefile libz NTLM SSL threadsafe TLS-SRP UnixSockets
```

By following these steps, you will have installed the latest version of curl using GNU Stow, ensuring a clean and organized installation.

## Update Software from Older Version

To update from an earlier version of Curl (e.g., 8.7.1) to the latest version (e.g., 8.8.0) using GNU Stow, you can follow these steps:

1. Uninstall the Old Version:

First, you need to uninstall the old version of Curl. Since you installed it using GNU Stow, you can simply unstow it.

```bash
cd /usr/local/stow
sudo stow -D curl-8.7.1
```

And then, go back to your home directory:

```bash
cd
```

2. Download and Extract the Latest Curl Source Code:

Download the latest version of Curl and extract it.

```bash
wget https://github.com/curl/curl/releases/download/curl-8_8_0/curl-8.8.0.tar.gz
tar -xzf curl-8.8.0.tar.gz
cd curl-8.8.0
```

3. Configure and Build the Latest Curl:

Configure the build environment and compile the latest version of Curl.

```bash
./configure --with-ssl --prefix=/usr/local/stow/curl-8.8.0
[or]
./configure --with-gnutls --prefix=/usr/local/stow/curl-8.8.0
make
sudo make install
```

4. Use GNU Stow to Manage the New Installation:

```bash
cd /usr/local/stow
sudo stow curl-8.8.0
```

5. Verify the Update:

Verify that the latest version of Curl is correctly installed and accessible.

```bash
curl --version
```

6. Remove the Older Version (Optional):

While GNU Stow will unlink the old version, it won't remove the old directory. To fully remove the old version of Curl after installing the new one:

```bash
sudo rm -rf /usr/local/stow/curl-8.7.1
```

This process ensures that you can easily manage and update multiple versions of Curl using GNU Stow, making it convenient to switch between different versions if needed.

## Advanced Usage of GNU Stow

GNU Stow offers several advanced options and features that can enhance its utility and flexibility. Here are some of them:

1. Relocatable Packages:

Stow allows you to create packages that can be relocated without changing their contents. This means the same package can be stowed in different places without modifying the files.

You can use the `--dir` and `--target` options to specify the source directory of the packages and the target directory where the symlinks should be created.

Example:

```bash
stow --dir=/path/to/packages --target=/usr/local package_name
```

2. Simulating Stow Operations:

Before making actual changes, you can simulate stow operations to see what would happen. This helps avoid mistakes.

We can use the `-n` or `--no` option to perform a dry run.

Example:

```bash
stow -n package_name
```

3. Verbose Output:

Get detailed information about what stow is doing. This can be useful for debugging or understanding the actions being performed.

Use the `-v` or `--verbose` option to view detailed information.

Example:

```bash
stow -v package_name
```

4. Ignoring Files and Directories:

You can tell Stow to ignore certain files or directories within the package.

Create a `.stow-local-ignore` file in the package directory listing the files or directories to ignore.

Example:

Create a `.stow-local-ignore` file with the following content:

```bash
.git
README.md
```

5. Restow and Destow:

**Restow**: This operation first unstows the package and then stows it again. It’s useful for refreshing symlinks after making changes to the package contents.

Usage:

```bash
stow -R package_name
```

**Destow**: This operation removes the symlinks created by stow.

Usage:

```bash
stow -D package_name
```

6. Adopting Pre-existing Files:

Stow can adopt files that already exist in the target directory. This is useful for bringing existing files under stow’s management without having to move them manually.

Use the `--adopt` option.

Example:

```bash
stow --adopt package_name
```

7. Conflict Handling:

Stow can detect and handle conflicts between packages.

Use the `--override` option to forcefully overwrite existing files.

Example:

```bash
stow --override package_name
```

8. Custom Stow Directories:

You can specify custom directories for stowing packages, which allows for more flexibility in organizing your software.

Use the `--dir` option to specify the source directory and `--target` to specify the target directory.

Example:

```bash
stow --dir=/custom/source --target=/custom/target package_name
```

For a complete list of options, you can refer to the `stow` man page:

```bash
man stow
```

### Example: Using Multiple Options

Here’s an example that combines several advanced options:

```bash
stow --dir=/path/to/packages --target=/usr/local --verbose --no --adopt --override package_name
```

Here's a breakdown of each option:

- `--dir`: Specifies the source directory of the package.
- `--target`: Specifies the target directory for the symlinks.
- `--verbose`: Provides detailed output of the operation.
- `--no`: Performs a dry run to simulate the operation.
- `--adopt`: Adopts pre-existing files in the target directory.
- `--override`: Forcefully overwrites existing files.

## GNU Stow Cheat Sheet

1. Stow a package:

```bash
stow package_name
```

Creates symlinks for package_name in the parent directory.

2. Unstow a package:

```bash
stow -D package_name
```

Removes symlinks for package_name.

3. Restow a package:

```bash
stow -R package_name
```

Unstows and then re-stows package_name.

4. Specify source directory:

```bash
stow --dir=/path/to/packages package_name
```

Sets the source directory where packages are located.

5. Specify target directory:

```bash
stow --target=/path/to/target package_name
```

Sets the target directory where symlinks should be created.

6. Simulate the operation (dry run):

```bash
stow -n package_name
```

Performs a dry run without making any changes.

7. Verbose output:

```bash
stow -v package_name
```

Provides detailed output of the operation.

8. Adopt pre-existing files:

```bash
stow --adopt package_name
```

Adopts existing files in the target directory.

9. Force override conflicts:

```bash
stow --override package_name
```

Overwrites existing files in the target directory.

10. Ignore specific files or directories:

Create a `.stow-local-ignore` file in the package directory with the files or directories to ignore.

Example `.stow-local-ignore` content:

```bash
.git
README.md
```

11. Stow a package from a custom directory to a custom target:

```bash
stow --dir=/path/to/packages --target=/path/to/target package_name
```

12. Unstow a package and remove its directory:

```bash
stow -D package_name
sudo rm -rf /usr/local/stow/package_name
```

13. Restow a package with verbose output:

```bash
stow -Rv package_name
```

14. Adopt existing files into Stow management:

```bash
stow --adopt package_name
```

15. Dry run to check what would happen:

```bash
stow -n package_name
```

Summary of Options

- `-D / --delete`: Unstows a package by removing its symlinks.
- `-R / --restow`: Unstows and re-stows a package.
- `-n / --no`: Dry run (simulate the operation).
- `-v / --verbose`: Verbose output.
- `--dir`: Specify the source directory.
- `--target`: Specify the target directory.
- `--adopt`: Adopt pre-existing files.
- `--override`: Force overwrite of existing files.
