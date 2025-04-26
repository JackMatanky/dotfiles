if (!(Test-Path "$env:USERPROFILE\scoop")) {
    Invoke-RestMethod get.scoop.sh | Invoke-Expression
    scoop install git
}

scoop bucket add extras
scoop bucket add nerd-fonts

scoop install `
    zellij `
    nushell `
    helix `
    yazi `
    rustup `
    lua-language-server `
    rust-analyzer `
    luajit `
    keychain

scoop update *