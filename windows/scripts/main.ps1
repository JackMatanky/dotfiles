Write-Host "==> Running full Windows dev environment setup..." -ForegroundColor Cyan

. .\install-winget.ps1
. .\install-scoop.ps1
. .\install-python-tools.ps1
. .\install-node-tools.ps1
. .\install-rust-tools.ps1
. .\post-install-tasks.ps1

Write-Host "🎉 All done." -ForegroundColor Green