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
  # Map mode to OCR flag
  let ocr_flag = (match $mode {
    "force" => "--force-ocr",
    "skip" => "--skip-text",
    "redo" => "--redo-ocr",
    _ => ""
  })

  # Flags incompatible with --redo-ocr
  let core_flags = (if $ocr_flag == "--redo-ocr" {
    []  # skip deskew and rotate
  } else {
    ["--rotate-pages", "--deskew"]
  })

  if $dry_run {
    print $"🧪 Would OCR: ($input) → ($output) using ($ocr_flag)"
  } else {
    # Build final argument list and run ocrmypdf
    do {
      let args = (
        (if $ocr_flag != "" { [$ocr_flag] } else { [] }) ++
        $core_flags ++
        ["--output-type" "pdf" $input $output]
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
  --mode: string        # OCR mode: force, skip, redo
  --dry-run             # Simulate only
] {
  # Use fd+fzf if no path is provided
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

  # Find all PDFs as separate lines
  let folder_pdfs = (fd . $absolute_path --type file --extension pdf | lines)

  if ($folder_pdfs | is-empty) {
    print $"No PDF files found in folder: ($absolute_path)"
    return
  }

  # Process each PDF
  for pdf in $folder_pdfs {
    let input = ($pdf | path expand)
    let dirname = ($input | path dirname)
    let filename = ($input | path basename)
    let output = ($filename | str replace ".pdf" "_ocr.pdf")
    let full_output = $"($dirname)/($output)"

    # Skip if OCR'd file already exists
    if ($full_output | path exists) {
      print $"⚠️ Skipping (already exists): ($full_output)"
      continue
    }

    print $"OCR'ing: ($filename) in ($dirname)"

    # Change to file directory and run ocrmypdf
    cd $dirname
    ocr_run $filename $output --mode=$mode --dry-run=$dry_run
    cd -
  }

  print (if $dry_run { "🧪 Dry run complete." } else { "✅ Batch OCR complete." })
}

def ocr_img_pipeline [
  path?: string                # Optional: path to input PDF
  --language: string = "eng"   # OCR language (e.g., eng, deu)
  --dpi: int = 300             # Render resolution
  --force-avif                 # Use AVIF instead of WebP
] {
  # Step 1: Choose a PDF file (from argument or fzf)
  let file = (if ($path == null) {
    fd --type file --extension pdf | fzf
  } else {
    $path
  })

  if ($file == "") {
    print "❌ No PDF selected."
    return
  }

  let input_path = ($file | path expand)
  let basename = ($input_path | path basename | str replace ".pdf" "")
  let temp_dir = $"($env.TMPDIR)/ocr_webp_($basename)"
  mkdir $temp_dir
  cd $temp_dir

  # Step 2: Render PDF pages as PNG using Poppler
  print "📄 Rendering PDF pages..."
  pdftoppm -r $dpi -png $input_path page

  # Step 3: Convert PNG pages to compressed images (WebP or AVIF)
  print "🖼 Converting PNGs to compressed format..."
  for image in (list page*.png | get name) {
    let name = ($image | str replace ".png" "")
    let format = (if $force_avif { "avif" } else { "webp" })
    let output = $"($name).($format)"
    if $format == "webp" {
      cwebp -quiet -q 85 $image -o $output
    } else {
      avifenc $image $output
    }
  }

  # Step 4: Run OCR on each image with Tesseract
  print "🔠 Running OCR on each image..."
  for compressed_image in (list *.webp *.avif | get name) {
    let stem = ($compressed_image | path parse | get stem)
    tesseract $compressed_image $stem -l $language --dpi $dpi pdf
  }

  # Step 5: Combine OCR outputs into a final searchable PDF
  print "🧾 Merging OCR results into single PDF..."
  img2pdf *.pdf -o $"($basename)_ocr.pdf"

  # Step 6: Move the result back to original location and clean up
  let result_path = ($input_path | path dirname)
  move $"($basename)_ocr.pdf" $result_path
  remove *

  print $"✅ Done: ($basename)_ocr.pdf → saved to: ($result_path)"
}
