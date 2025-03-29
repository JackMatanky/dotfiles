# -----------------------------------------------------------------------------
# Filename: ~/dotfiles/nushell/aliases/ocr_aliases.nu
# OCRmyPDF: https://github.com/ocrmypdf/OCRmyPDF
# -----------------------------------------------------------------------------

# ocr_run: Run or simulate OCR on one file
def ocr_run [
  input: string         # Input PDF
  output: string        # Output path
  --mode: string        # OCR mode: force, skip, redo
  --dry-run             # Simulate only
] {
  # Map mode to flag
  let ocr_flag = (match $mode {
    "force" => "--force-ocr",
    "skip" => "--skip-text",
    "redo" => "--redo-ocr",
    _ => ""
  })

  # Simulate or run
  if $dry_run {
    print $"🧪 Would OCR: ($input) → ($output) using ($ocr_flag)"
  } else {
    do {
      let args = (
        (if $ocr_flag != "" { [$ocr_flag] } else { [] }) ++ [
          "--rotate-pages"
          "--deskew"
          "--output-type" "pdf"
          $input
          $output
        ]
      )
      ocrmypdf ...$args
    }
  }
}

# ocrfile: OCR one PDF (arg or fzf)
def ocrfile [
  path?: string         # Input path (optional)
  --mode: string        # OCR mode
  --dry-run             # Simulate only
] {
  # Select file if not provided
  let file = (if ($path == null) {
    fd --type file --extension pdf | fzf
  } else {
    $path
  })

  if ($file == "") {
    print "No file selected."
    return
  }

  let input = ($file | path expand)
  let output = ($input | str replace ".pdf" "_ocr.pdf")

  ocr_run $input $output --mode=$mode --dry-run=$dry_run
}

# ocrfolder: OCR all PDFs in a folder
def ocrfolder [
  path?: string         # Folder path (optional)
  --mode: string        # OCR mode
  --dry-run             # Simulate only
] {
  # Select folder if not provided
  let folder = (if ($path == null) {
    fd --type directory | fzf
  } else {
    $path
  })

  if ($folder == "") {
    print "No folder selected."
    return
  }

  let absolute_path = ($folder | path expand)

  # Use `.` to match all files inside the given directory
  let folder_pdfs = (fd . $absolute_path --type file --extension pdf)

  if ($folder_pdfs | is-empty) {
    print $"No PDF files found in folder: ($absolute_path)"
    return
  }

  # Process each file
  for pdf in $folder_pdfs {
    let input = ($pdf | path expand)
    let output = ($input | str replace ".pdf" "_ocr.pdf")

    if ($output | path exists) {
      print $"⚠️ Skipping (already exists): ($output)"
      continue
    }

    print $"OCR'ing: ($input)"
    ocr_run $input $output --mode=$mode --dry-run=$dry_run
  }

  print (if $dry_run { "🧪 Dry run complete." } else { "✅ Batch OCR complete." })
}
