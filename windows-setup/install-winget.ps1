$wingetPackages = @(
    "Git.Git",
    "Microsoft.WindowsTerminal",
    "GNU.Bash",
    "Starship.Starship",
    "JanDeDobbeleer.OhMyPosh",
    "sharkdp.fd",
    "junegunn.fzf",
    "ajeetdsouza.zoxide",
    "sharkdp.bat",
    "BurntSushi.ripgrep",
    "eza-community.eza",
    "GNU.Stow",
    "Python.Python.3.13",
    "PostgreSQL.PostgreSQL",
    "Oracle.MySQL",
    "OpenJS.NodeJS",
    "Lua.Lua",
    "EclipseAdoptium.Temurin.21.JDK",
    "Pandoc.Pandoc",
    "OCRmyPDF.OCRmyPDF",
    "Poppler.Poppler",
    "Tesseract.Tesseract",
    "ImageMagick.ImageMagick",
    "FFmpeg.FFmpeg",
    "WebP.WebP",
    "QPDF.QPDF"
)

foreach ($pkg in $wingetPackages) {
    winget install --id=$pkg -e --accept-source-agreements --accept-package-agreements
}