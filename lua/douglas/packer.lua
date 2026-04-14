-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use "nvim-lua/plenary.nvim"
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use({ 
    'rose-pine/neovim', 
    as = 'rose-pine',
    config = function()
      vim.cmd('colorscheme rose-pine')
    end

  })

  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use('nvim-treesitter/playground')

  use {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    requires = { {"nvim-lua/plenary.nvim"} }
  }

  use('mbbill/undotree')
  use('tpope/vim-fugitive')

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }

  use {
    'VonHeikemen/lsp-zero.nvim',
    requires = {
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'}, 
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lua'},
      {'L3MON4D3/LuaSnip'},
    }
  }

  use {
    "rachartier/tiny-glimmer.nvim",
    config = function()
      require("tiny-glimmer").setup()
    end
  }

  use({
    "frankroeder/parrot.nvim",
    requires = { 'ibhagwan/fzf-lua', 'nvim-lua/plenary.nvim'},
  })

  use {'iamcco/markdown-preview.nvim'}

  use {
    'greggh/claude-code.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('claude-code').setup()
    end
  }

  use {
    "catgoose/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end
  }

  use {
    "eero-lehtinen/oklch-color-picker.nvim",
    config = function()
      require("oklch-color-picker").setup()
      vim.keymap.set("n", "<leader>v", function()
        require("oklch-color-picker").pick_under_cursor()
      end, { desc = "Color pick under cursor" })
    end
  }


end)

