-- Lua filter for Quarto to convert PDF images to WebP only in HTML output

-- Check if the current output format is HTML
local is_html = (quarto and quarto.doc.is_format("html"))

-- Detect operating system: returns "windows", "mac", or "linux"
local function get_os()
  local sep = package.config:sub(1, 1)
  if sep == "\\" then return "windows" end
  local handle = io.popen("uname -s 2>/dev/null")
  if handle then
    local result = handle:read("*a"):gsub("%s+", "")
    handle:close()
    if result == "Darwin" then return "mac" end
  end
  return "linux"
end

local os_type = get_os()

-- Detect whether ImageMagick 7 (magick) or 6 (convert) is available
local function get_magick_cmd()
  local handle = io.popen("which magick 2>/dev/null")
  if handle then
    local result = handle:read("*a"):gsub("%s+", "")
    handle:close()
    if result ~= "" then return "magick" end
  end
  return "convert"
end

local magick_cmd = get_magick_cmd()

-- Function to check if a file exists
local function file_exists(name)
  local f = io.open(name, "r")
  if f then f:close() end
  return f ~= nil
end

-- Function to get the modification time of a file using a shell command
local function file_mod_time(name)
  local cmd
  if os_type == "mac" then
    cmd = 'stat -f "%m" "' .. name .. '"'
  else
    cmd = 'stat -c "%Y" "' .. name .. '"'
  end
  local handle = io.popen(cmd)
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
      os.execute(string.format('%s -density 600 -colorspace RGB "%s" "%s"', magick_cmd, elem.src, webp_src))
    end

    -- Update image source to the new or existing WebP file
    elem.src = webp_src
  end

  return elem
end