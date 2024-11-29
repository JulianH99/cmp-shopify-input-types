-- HACK: god forgive
local plugin_dir = debug.getinfo(1, "S").source:match("@(.*)/")
local filepath = plugin_dir .. "/shopify-input-values.json"

local cmp = require("cmp")

if not vim.fn.filereadable(filepath) then
  vim.notify("Values file is not readable")
  return
end

local ok, values = pcall(vim.fn.json_decode, vim.fn.readfile(filepath))

if not ok then
  vim.notify("Failed to parse json file")
  return {}
end

local source = {}

source.new = function()
  return setmetatable({}, { __index = source })
end

source.complete = function(_, request, callback)
  local input = string.sub(request.context.cursor_before_line, request.offset)
  local results = {}

  for _, value in ipairs(values) do
    if vim.startswith(value["value"], input) or vim.endswith(value["value"], input) then
      table.insert(results, {
        word = value["value"],
        label = value["value"],
        kind = cmp.lsp.CompletionItemKind.Value, -- could not find a better one
        documentation = {
          kind = "markdown",
          value = value["documentation"],
        },
      })
    end
  end

  callback({ items = results, isIncomplete = true })
end

source.is_available = function()
  return vim.bo.filetype == "liquid"
end

return source
