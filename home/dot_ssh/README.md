# `dot_ssh/` - SSH Configuration & Key Management

This directory contains SSH client configuration files, connection settings, and key management configurations. These files enable secure, efficient remote connections with customized authentication and connection options.

## 📁 Directory Structure

```
dot_ssh/
├── README.md              # This documentation
└── ssh-config             # SSH client configuration file
```

## 🔧 Core Configuration

### `ssh-config`
**SSH client configuration file** (maps to `~/.ssh/config`)

**Configuration features:**
- **Host definitions**: Named connection profiles for servers and services
- **Authentication settings**: Key-based authentication configuration
- **Connection optimization**: Performance and reliability settings
- **Security hardening**: Secure cipher and protocol configurations
- **Convenience aliases**: Short names for frequently accessed hosts

## 🏗️ Configuration Patterns

### **Host Definitions**
**Standardized connection profiles**

```ssh
# Development servers
Host dev-server
    HostName dev.example.com
    User developer
    Port 2222
    IdentityFile ~/.ssh/dev_server_rsa
    IdentitiesOnly yes
    ForwardAgent no

# Production servers (more restrictive)
Host prod-server
    HostName prod.example.com
    User deploy
    Port 22
    IdentityFile ~/.ssh/prod_server_ed25519
    IdentitiesOnly yes
    ForwardAgent no
    UserKnownHostsFile ~/.ssh/known_hosts_prod
```

### **Service-Specific Configurations**
**Optimized settings for different services**

```ssh
# GitHub configuration
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github_ed25519
    IdentitiesOnly yes
    AddKeysToAgent yes
    UseKeychain yes

# GitLab configuration  
Host gitlab.com
    HostName gitlab.com
    User git
    IdentityFile ~/.ssh/gitlab_ed25519
    IdentitiesOnly yes

# AWS EC2 instances
Host *.aws
    User ec2-user
    IdentityFile ~/.ssh/aws_ec2_key.pem
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
```

### **Connection Optimization**
**Performance and reliability settings**

```ssh
# Connection multiplexing
Host *
    ControlMaster auto
    ControlPath ~/.ssh/connections/%r@%h:%p
    ControlPersist 600

# Keepalive settings
    ServerAliveInterval 60
    ServerAliveCountMax 3
    
# Compression for slow connections
    Compression yes
```

## 🔐 Security Features

### **Key Management**
**SSH key organization and security**

**Key types and usage:**
- **Ed25519 keys**: Modern, secure keys for new connections
- **RSA keys**: Legacy support for older systems
- **ECDSA keys**: Elliptic curve keys for specific requirements
- **Key-per-service**: Separate keys for different services/environments

### **Authentication Security**
**Secure authentication practices**

**Security configurations:**
- **IdentitiesOnly**: Prevent SSH agent key enumeration
- **ForwardAgent**: Controlled agent forwarding for security
- **StrictHostKeyChecking**: Host key verification policies
- **UserKnownHostsFile**: Custom known hosts management
- **PreferredAuthentications**: Authentication method prioritization

### **Connection Security**
**Secure transport and cipher configuration**

```ssh
# Modern security settings
Host secure-*
    KexAlgorithms curve25519-sha256@libssh.org
    HostKeyAlgorithms ssh-ed25519-cert-v01@openssh.com,ssh-ed25519
    Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com
    MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com
```

## 🎯 Common Use Cases

### **Development Workflows**
**SSH configurations for development environments**

```ssh
# Local development VMs
Host local-vm
    HostName 192.168.1.100
    User developer
    IdentityFile ~/.ssh/local_dev_key
    ForwardAgent yes
    ForwardX11 yes

# Remote development server
Host remote-dev
    HostName dev-remote.company.com
    User myuser
    Port 2222
    LocalForward 3000 localhost:3000
    LocalForward 5432 localhost:5432
```

### **Cloud Infrastructure**
**Configuration for cloud service connections**

```ssh
# AWS bastion host
Host aws-bastion
    HostName bastion.aws.company.com
    User ec2-user
    IdentityFile ~/.ssh/aws_bastion.pem
    
# Jump host configuration
Host private-server
    HostName 10.0.1.100
    User admin
    ProxyJump aws-bastion
    IdentityFile ~/.ssh/private_server_key
```

### **Version Control Services**
**Git hosting service configurations**

```ssh
# Multiple GitHub accounts
Host github-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/github_personal_ed25519

Host github-work
    HostName github.com
    User git  
    IdentityFile ~/.ssh/github_work_ed25519
```

## 🔧 Advanced Features

### **Connection Multiplexing**
**Efficient connection reuse**

**Benefits:**
- **Faster connections**: Reuse existing authenticated connections
- **Reduced overhead**: Fewer authentication handshakes
- **Improved performance**: Shared connections for multiple operations
- **Resource efficiency**: Lower system resource usage

**Configuration:**
```ssh
Host *
    ControlMaster auto
    ControlPath ~/.ssh/connections/%r@%h:%p
    ControlPersist 10m
```

### **Port Forwarding**
**Local and remote port forwarding setup**

**Local forwarding:**
```ssh
# Database access through bastion
Host db-tunnel
    HostName bastion.example.com
    User admin
    LocalForward 5432 db-server:5432
    LocalForward 6379 redis-server:6379
```

**Remote forwarding:**
```ssh
# Expose local service to remote server
Host reverse-tunnel
    HostName remote-server.com
    User admin
    RemoteForward 8080 localhost:3000
```

### **Jump Hosts & Proxy Commands**
**Multi-hop connections through intermediate servers**

```ssh
# Direct proxy jump
Host target-server
    HostName 10.0.1.100
    User admin
    ProxyJump bastion-server

# Complex proxy chain
Host deep-server
    HostName 10.0.2.50
    User admin
    ProxyJump bastion1,bastion2
```

## 🛠️ Configuration Management

### **Dynamic Configuration**
**Template-based configuration with chezmoi**

**Template features:**
- **Environment-specific settings**: Different configs per environment
- **Credential management**: Secure handling of keys and certificates
- **Host discovery**: Dynamic host list generation
- **Conditional configuration**: Settings based on system conditions

### **Key Rotation**
**SSH key lifecycle management**

**Best practices:**
1. **Regular rotation**: Periodic key replacement
2. **Key retirement**: Safe removal of old keys
3. **Access audit**: Regular review of key usage
4. **Emergency procedures**: Rapid key revocation process
5. **Documentation**: Record of key purposes and locations

### **Backup & Recovery**
**SSH configuration backup strategies**

**Backup components:**
- **Configuration files**: SSH config and known_hosts
- **Private keys**: Secure backup of authentication keys
- **Host information**: Known hosts and fingerprints
- **Custom scripts**: SSH-related automation and tools

## 🔍 Troubleshooting

### **Connection Issues**
**Common SSH connection problems and solutions**

**Debug techniques:**
```bash
# Verbose SSH debugging
ssh -vvv hostname

# Test specific configuration
ssh -F ~/.ssh/config -T git@github.com

# Check key loading
ssh-add -l
```

**Common problems:**
- **Permission issues**: Incorrect file/directory permissions
- **Key authentication**: Wrong key or key not loaded
- **Host verification**: Unknown or changed host keys
- **Network connectivity**: Firewall or routing issues
- **Configuration syntax**: Invalid SSH config syntax

### **Performance Issues**
**Optimizing SSH connection performance**

**Performance tuning:**
- **Connection multiplexing**: Reuse existing connections
- **Compression**: Enable compression for slow links
- **Keepalive settings**: Prevent connection timeouts
- **Cipher selection**: Choose appropriate encryption methods
- **MTU optimization**: Adjust packet sizes for network conditions

## 📊 Security Monitoring

### **Access Logging**
**Monitoring SSH access and usage**

**Log analysis:**
- **Connection attempts**: Successful and failed connections
- **Key usage**: Which keys are being used when
- **Host access**: Patterns of server access
- **Anomaly detection**: Unusual access patterns
- **Compliance reporting**: Access audit trails

### **Security Hardening**
**Enhanced security configurations**

**Hardening measures:**
- **Key type restrictions**: Use only modern, secure key types
- **Cipher restrictions**: Disable weak encryption methods
- **Host key verification**: Strict host key checking
- **Agent forwarding limits**: Restrict agent forwarding usage
- **Connection limits**: Rate limiting and concurrent connection limits

## 📚 Best Practices

### **Configuration Organization**
**Maintaining clean, manageable SSH configurations**

**Organization strategies:**
- **Logical grouping**: Group similar hosts and services
- **Consistent naming**: Standardized host naming conventions
- **Documentation**: Comments explaining complex configurations
- **Modularization**: Separate configs for different environments
- **Version control**: Track configuration changes over time

### **Security Guidelines**
**SSH security best practices**

**Security recommendations:**
- **Use Ed25519 keys**: Modern, secure key algorithm
- **Unique keys per service**: Separate keys for different purposes
- **Disable password auth**: Use key-based authentication only
- **Regular key rotation**: Periodic key replacement
- **Monitor access**: Log and review SSH access patterns

### **Performance Optimization**
**Maximizing SSH connection efficiency**

**Optimization techniques:**
- **Connection pooling**: Reuse authenticated connections
- **Appropriate compression**: Balance CPU vs bandwidth
- **Optimal keepalive**: Prevent unnecessary disconnections
- **Smart timeouts**: Balance responsiveness vs resource usage
- **Network-aware settings**: Adapt to network conditions

## 🔗 Related Resources

### **SSH Documentation**
- **OpenSSH manual**: Comprehensive SSH configuration reference
- **Key generation**: Best practices for SSH key creation
- **Security guides**: SSH security hardening recommendations
- **Integration guides**: SSH integration with other tools and services

### **Chezmoi Integration**
- **Template variables**: Dynamic SSH configuration generation
- **Secret management**: Secure handling of SSH keys and passphrases
- **Multi-machine sync**: Consistent SSH config across devices
- **Environment-specific**: Different configs for different contexts

## 🎨 Advanced Customization

### **Custom SSH Commands**
**Aliases and helper scripts for common SSH operations**

```bash
# SSH with specific config
alias ssh-prod='ssh -F ~/.ssh/config.prod'

# Tunnel shortcuts  
alias db-tunnel='ssh -L 5432:localhost:5432 db-server'

# Quick server access
alias web-server='ssh web@production-server'
```

### **Integration with Other Tools**
**SSH configuration integration with development tools**

**Tool integrations:**
- **Git**: SSH key configuration for Git repositories
- **VS Code**: Remote development over SSH
- **Terminal multiplexers**: Screen/tmux with SSH sessions
- **Backup tools**: rsync and similar tools using SSH
- **Monitoring**: SSH-based server monitoring and alerts
