-- Compatibility shim for nvim-treesitter directives broken on Neovim 0.12.
-- In 0.12, match[capture_id] returns TSNode[] instead of TSNode.
-- We override the affected directives with force=true to fix this.
if vim.fn.has("nvim-0.12") == 0 then
  return
end

local ok, query = pcall(require, "vim.treesitter.query")
if not ok then
  return
end

local non_filetype_match_injection_language_aliases = {
  ex = "elixir",
  pl = "perl",
  sh = "bash",
  uxn = "uxntal",
  ts = "typescript",
}

local html_script_type_languages = {
  ["importmap"] = "json",
  ["module"] = "javascript",
  ["application/ecmascript"] = "javascript",
  ["text/ecmascript"] = "javascript",
}

local function get_node(match, id)
  local entry = match[id]
  if type(entry) == "table" then
    return entry[1]
  end
  return entry
end

local function get_parser_from_markdown_info_string(alias)
  local match = vim.filetype.match({ filename = "a." .. alias })
  return match or non_filetype_match_injection_language_aliases[alias] or alias
end

local opts = { force = true, all = false }

query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
  local node = get_node(match, pred[2])
  if not node then
    return
  end
  local alias = vim.treesitter.get_node_text(node, bufnr):lower()
  metadata["injection.language"] = get_parser_from_markdown_info_string(alias)
end, opts)

query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
  local node = get_node(match, pred[2])
  if not node then
    return
  end
  local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
  local configured = html_script_type_languages[type_attr_value]
  if configured then
    metadata["injection.language"] = configured
  else
    local parts = vim.split(type_attr_value, "/", {})
    metadata["injection.language"] = parts[#parts]
  end
end, opts)

query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
  local id = pred[2]
  local node = get_node(match, id)
  if not node then
    return
  end
  local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
  if not metadata[id] then
    metadata[id] = {}
  end
  metadata[id].text = string.lower(text)
end, opts)
