return {
  plugins = {
    "AstroNvim/astrocommunity",
    { import = [
      "astrocommunity.colorscheme.nord-nvim",
      "astrocommunity.completion.codeium-vim",
      "astrocommunity.completion.copilot-lua-cmp"
      ] }
    -- ... import any community contributed plugins here
  }
}
