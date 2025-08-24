# -----------------------------------------------------------------------------
# Filename: ~/.config/nushell/aliases/ocr_aliases.nu
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
    ["--optimize 3", "--rotate-pages", "--deskew"]
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

# # ocrfolder: OCR all PDFs in a folder using GNU parallel
# def ocrfolder [
#   path?: string         # Folder path (optional)
#   --mode: string        # OCR mode: force, skip, redo
#   --dry-run             # Simulate only
# ] {
#   # Determine the OCR flag from the mode
#   let ocr_flag = (match $mode {
#     "force" => "--force-ocr",
#     "skip" => "--skip-text",
#     "redo" => "--redo-ocr",
#     _ => ""
#   })

#   # Use fd+fzf if no path is provided
#   let folder = (if ($path == null) {
#     fd --type directory | fzf
#   } else {
#     $path
#   })

#   if ($folder == "") {
#     print "No folder selected."
#     return
#   }

#   let absolute_path = ($folder | path expand)

#   # Find all PDFs
#   let folder_pdfs = (fd . $absolute_path --type file --extension pdf | lines)

#   if ($folder_pdfs | is-empty) {
#     print $"No PDF files found in folder: ($absolute_path)"
#     return
#   }

#   # Build shell commands to run in parallel
#   let commands = (
#     $folder_pdfs
#     | each {|pdf|
#         let input = ($pdf | path expand)
#         let output = ($input | str replace ".pdf" "_ocr.pdf")

#         if ($output | path exists) {
#           $"echo '⚠️ Skipping (already exists): ($output)'"
#         } else if ($dry_run) {
#           $"echo '🧪 Would OCR: ($input) → ($output) using ($ocr_flag)'"
#         } else {
#           $"ocrmypdf ($ocr_flag) --output-type pdf --optimize 3 --rotate-pages --deskew ($input) ($output)"
#         }
#       }
#   )

#   # Save and run using parallel if not a dry run
#   let script_path = $"($env.TMPDIR | default '/tmp')/ocr_batch.sh"
#   $commands | str join "\n" | save -f $script_path

#   if ($dry_run) {
#     print "🧪 Dry run commands:"
#     open $script_path | lines | each {|line| print $line }
#   } else {
#     bash -c $"cat ($script_path) | parallel -j (nproc)"
#     print "✅ Batch OCR complete."
#   }
# }

# -----------------------------------------------
# OCR Image Pipeline
# -----------------------------------------------
# >>> Helper Functions <<<
# Convert PDF to PNG using Poppler
def render_pdf_to_png [input: string, dpi: int] {
  print "📄 Rendering PDF pages to PNG..."
  pdftoppm -r $dpi -png $input page
}

# Compress PNGs to WebP or AVIF
def compress_images [format: string] {
  print $"🖼 Converting PNGs to ($format)..."

  for img in (ls page*.png | get name) {
    let base = ($img | str replace ".png" "")
    let out = $"($base).($format)"

    print $"🔧 Converting: ($img) → ($out)"

    if $format == "webp" {
      let result = (cwebp -quiet -q 85 $img -o $out | complete)
    } else {
      let result = (avifenc $img $out | complete)
    }

    if ($out | path exists) {
      print $"✅ Success: ($out)"
    } else {
      print $"❌ Failed to create: ($out)"
    }
  }
}

# Run Tesseract OCR on images
def run_tesseract_ocr [format: string, lang: string, dpi: int] {
  print "🔠 Running OCR..."

  # Manually filter files matching *.webp or *.avif
  let images = (ls | where name ends-with $format | get name)

  if ($images | is-empty) {
    print $"⚠️ No ($format) files found for OCR."
    return
  }

  for img in $images {
    let base = ($img | path parse | get stem)
    tesseract $img $base -l $lang --dpi $dpi pdf
  }
}

# Merge OCR’d pages into final PDF
def merge_ocr_pdfs [basename: string] {
  print "🧾 Merging OCR PDFs..."

  let valid_pdfs = (
    ls *.pdf
    | where size > 0
    | get name
  )

  if ($valid_pdfs | is-empty) {
    print "❌ No valid OCR PDFs to merge."
    return
  }

  img2pdf ...$valid_pdfs -o $"($basename)_ocr.pdf"
}

# >>> Main Function <<<
def ocr_img_pipeline [
  path?: string                 # Optional: input PDF path
  --language: string = "eng"   # OCR language
  --dpi: int = 150             # Render DPI
  --force-avif                 # Use AVIF instead of WebP
] {
  # Step 1: Choose PDF via argument or fzf
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
  let temp_dir = $"($env.TMPDIR)/ocr_temp_($basename)"
  mkdir $temp_dir
  cd $temp_dir

  # Step 2: Render and compress pages
  render_pdf_to_png $input_path $dpi
  let format = (if $force_avif { "avif" } else { "webp" })
  compress_images $format

  # Step 3: OCR each compressed image
  run_tesseract_ocr $format $language $dpi

  # Step 4: Combine results into one PDF
  merge_ocr_pdfs $basename

  # Step 5: Move and clean up
  let final = $"($basename)_ocr.pdf"
  let out_dir = ($input_path | path dirname)
  if ($final | path exists) {
    mv $final $out_dir
    print $"✅ Done: ($final) → saved to: ($out_dir)"
  } else {
    print "⚠️ No output PDF found."
  }

  remove --force *
}
