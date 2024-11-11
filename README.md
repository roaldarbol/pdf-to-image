# pdf-to-image Extension For Quarto
The `pdf-to-image` converts your PDF figures to `webp` images for use in HTML rendering of your Quarto project.
The extension does the following:
- Adds a converted version of your `pdf` file to `webp` format in the source folder.
- Re-converts only when the source `pdf` file is updated.

## Requirements
The extension requires a working installation of [ImageMagick](https://imagemagick.org/script/download.php).

## Installing
```bash
quarto add roaldarbol/pdf-to-image
```

This will install the extension under the `_extensions` subdirectory.
If you're using version control, you will want to check in this directory.

## Using
To use the extension, simply install it and preview/render your project.

## Example
Here is the source code for a minimal example: [example.qmd](example.qmd).

