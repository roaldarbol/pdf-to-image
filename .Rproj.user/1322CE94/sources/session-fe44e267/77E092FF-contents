-- Lua filter for Quarto to convert PDF images to WebP only in HTML output

-- Check if the current output format is HTML
local is_html = (quarto and quarto.doc.is_format("html"))

-- Function to check if a file exists
local function file_exists(name)
  local f = io.open(name, "r")
  if f then f:close() end
  return f ~= nil
end

-- Function to get the modification time of a file using a shell command
local function file_mod_time(name)
  local handle = io.popen('stat -f "%m" "' .. name .. '"') -- macOS or BSD
  local result = handle:read("*a")
  handle:close()
  
  return tonumber(result)
end

function Image(elem)
  -- Only proceed if output format is HTML and the image is a PDF
  if is_html and elem.src:match("%.pdf$") then
    -- Define new filename for the WebP version
    local webp_src = elem.src:gsub("%.pdf$", ".webp")

    -- Check if WebP file exists and compare modification times
    local pdf_time = file_mod_time(elem.src)
    local webp_time = file_exists(webp_src) and file_mod_time(webp_src)

    -- If WebP doesn't exist or the PDF is newer, convert PDF to WebP
    if not webp_time or (pdf_time and pdf_time > webp_time) then
      -- Run the ImageMagick command to convert PDF to WebP
      os.execute(string.format('magick -density 600 -colorspace RGB "%s" "%s"', elem.src, webp_src))
    end

    -- Update image source to the new or existing WebP file
    elem.src = webp_src
  end

  return elem
end
