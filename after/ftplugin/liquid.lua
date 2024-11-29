local has_cmp, cmp = pcall(require, "cmp")

if not has_cmp then
  return
end

-- NOTE : file was being sourced twice. augroup and aucommand did not help
if vim.g.cmp_shopify_input_types_loaded then
  return
end

vim.g.cmp_shopify_input_types_loaded = true

local source = require("cmp-shopify-input-types.source")

if not source.new then
  return
end

cmp.register_source("shopify-input-types", source.new())
