-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', { desc = 'NeoTree reveal' } },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },

  config = function()
    vim.fn.sign_define('DiagnosticSignError', { text = ' ', texthl = 'DiagnosticSignError' })
    vim.fn.sign_define('DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticSignWarn' })
    vim.fn.sign_define('DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo' })
    vim.fn.sign_define('DiagnosticSignHint', { text = '󰌵', texthl = 'DiagnosticSignHint' })

    require('neo-tree').setup {
      close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
      popup_border_style = 'rounded',
      enable_git_status = true,
      enable_diagnostics = true,
      enable_normal_mode_for_inputs = false, -- Enable normal mode for input dialogs.
      open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' }, -- when opening files, do not use windows containing these filetypes or buftypes
      sort_case_insensitive = false, -- used when sorting files and directories in the tree

      default_component_configs = {
        container = {
          enable_character_fade = true,
        },
        indent = {
          indent_size = 2,
          padding = 1, -- extra padding on left hand side
          -- indent guides
          with_markers = true,
          indent_marker = '│',
          last_indent_marker = '└', -- └
          highlight = 'NeoTreeIndentMarker',
          -- expander config, needed for nesting files
          with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',

          --expander_collapsed = "",
          --expander_expanded = "",
          --expander_highlight = "NeoTreeExpander",
        },
        icon = {
          folder_closed = '',
          folder_open = '',
          -- folder_closed = "",
          -- folder_open = "",
          -- folder_closed = " ",
          -- folder_open = " ",
          folder_empty = '',
          --folder_empty = "󰜌",
          --folder_empty_open = "󰜌",
          default = ' ',
          highlight = 'NeoTreeFileIcon',
        },
        modified = {
          symbol = '[+]',
          highlight = 'NeoTreeModified',
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = 'NeoTreeFileName',
        },
        git_status = {
          symbols = {
            -- Change type
            added = '', -- or "✚", but this is redundant info if you use git_status_colors on the name
            modified = '', -- or "", but this is redundant info if you use git_status_colors on the name
            deleted = '', -- this can only be used in the git_status source
            renamed = '󰁕', -- this can only be used in the git_status source",
            -- Status type
            untracked = '',
            ignored = '',
            -- unstaged = "",
            --unstaged = "U",
            unstaged = '󰄱',
            staged = '',
            conflict = '',
          },
        },
        document_symbols = {
          kinds = {
            File = { icon = '󰈙', hl = 'Tag' },
            Namespace = { icon = '󰌗', hl = 'Include' },
            Package = { icon = '󰏖', hl = 'Label' },
            Class = { icon = '󰌗', hl = 'Include' },
            Property = { icon = '󰆧', hl = '@property' },
            Enum = { icon = '󰒻', hl = '@number' },
            Function = { icon = '󰊕', hl = 'Function' },
            String = { icon = '󰀬', hl = 'String' },
            Number = { icon = '󰎠', hl = 'Number' },
            Array = { icon = '󰅪', hl = 'Type' },
            Object = { icon = '󰅩', hl = 'Type' },
            Key = { icon = '󰌋', hl = '' },
            Struct = { icon = '󰌗', hl = 'Type' },
            Operator = { icon = '󰆕', hl = 'Operator' },
            TypeParameter = { icon = '󰊄', hl = 'Type' },
            StaticMethod = { icon = '󰠄 ', hl = 'Function' },
          },
        },
        diagnostics = {
          symbols = {
            hint = '󰌵',
            info = '',
            warn = '',
            error = '',
          },
          highlights = {
            hint = 'DiagnosticSignHint',
            info = 'DiagnosticSignInfo',
            warn = 'DiagnosticSignWarn',
            error = 'DiagnosticSignError',
          },
        },
      },
      -- A list of functions, each representing a global custom command
      -- that will be available in all sources (if not overridden in `opts[source_name].commands`)
      -- see `:h neo-tree-global-custom-commands`
      commands = {},
      window = {
        position = 'left',
        width = 50,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ['<space>'] = {
            'toggle_node',
            nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
          },
          ['<1-LeftMouse>'] = 'open',
          ['o'] = 'open',
          ['<cr>'] = 'open',
          ['<return>'] = 'open',
          ['<esc>'] = 'revert_preview',
          ['P'] = { 'toggle_preview', config = { use_float = true } },
          ['l'] = 'focus_preview',
          ['S'] = 'open_split',
          ['s'] = 'open_vsplit',
          -- ["S"] = "split_with_window_picker",
          -- ["s"] = "vsplit_with_window_picker",
          ['t'] = 'open_tabnew',
          ['w'] = 'open_with_window_picker',
          ['C'] = 'close_node',
          ['z'] = 'close_all_nodes',
          ['a'] = {
            'add',
            -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
            -- some commands may take optional config options, see `:h neo-tree-mappings` for details
            config = {
              show_path = 'none', -- "none", "relative", "absolute"
            },
          },
          ['A'] = 'add_directory', -- also accepts the config.show_path option.
          ['d'] = 'delete',
          ['r'] = 'rename',
          ['y'] = 'copy_to_clipboard',
          ['x'] = 'cut_to_clipboard',
          ['p'] = 'paste_from_clipboard',
          ['c'] = 'copy', -- takes text input for destination
          ['m'] = 'move', -- takes text input for destination
          ['q'] = 'close_window',
          ['R'] = 'refresh',
          ['?'] = 'show_help',
          ['<'] = 'prev_source',
          ['>'] = 'next_source',
        },
      },
      nesting_rules = {
        -- ["js"] = { "js.map" },
      },
      filesystem = {
        filtered_items = {
          visible = false, -- when true, they will just be displayed differently than normal items
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            --"node_modules"
          },
          hide_by_pattern = { -- uses glob style patterns
            --"*.meta"
          },
          never_show = { -- remains hidden even if visible is toggled to true
            --".DS_Store",
            --"thumbs.db"
          },
        },
        follow_current_file = {
          enabled = true, -- This will find and focus the file in the active buffer every time
          --               -- the current file is changed while the tree is open.
          leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
        },
        -- time the current file is changed while the tree is open.
        group_empty_dirs = false, -- when true, empty folders will be grouped together
        hijack_netrw_behavior = 'open_default', -- netrw disabled, opening a directory opens neo-tree
        -- in whatever position is specified in window.position
        -- "open_current",  -- netrw disabled, opening a directory opens within the
        -- window like netrw would, regardless of window.position
        -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
        use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
        -- instead of relying on nvim autocmd events.
        window = {
          mappings = {
            ['<bs>'] = 'navigate_up',
            ['.'] = 'set_root',
            ['H'] = 'toggle_hidden',
            ['/'] = 'fuzzy_finder',
            ['D'] = 'fuzzy_finder_directory',
            ['#'] = 'fuzzy_sorter', -- fuzzy sorting using the fzy algorithm
            -- ["D"] = "fuzzy_sorter_directory",
            ['f'] = 'filter_on_submit',
            ['<c-x>'] = 'clear_filter',
            ['[g'] = 'prev_git_modified',
            [']g'] = 'next_git_modified',
          },
          fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
            ['<down>'] = 'move_cursor_down',
            ['<C-n>'] = 'move_cursor_down',
            ['<up>'] = 'move_cursor_up',
            ['<C-p>'] = 'move_cursor_up',
          },
        },

        commands = {}, -- Add a custom command or override a global one using the same function name
      },
      buffers = {
        follow_current_file = {
          enabled = true, -- This will find and focus the file in the active buffer every time
          --              -- the current file is changed while the tree is open.
          leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
        },
        -- time the current file is changed while the tree is open.
        group_empty_dirs = true, -- when true, empty folders will be grouped together
        show_unloaded = true,
        window = {
          mappings = {
            ['bd'] = 'buffer_delete',
            ['<bs>'] = 'navigate_up',
            ['.'] = 'set_root',
          },
        },
      },
      git_status = {
        window = {
          position = 'float',
          mappings = {
            ['gA'] = 'git_add_all',
            ['gu'] = 'git_unstage_file',
            ['ga'] = 'git_add_file',
            ['gr'] = 'git_revert_file',
            ['gc'] = 'git_commit',
            ['gp'] = 'git_push',
            ['gg'] = 'git_commit_and_push',
          },
        },
      },
      source_selector = {
        winbar = true,
        statusline = false, -- toggle to show selector on statusline
        content_layout = 'center',
        tabs_layout = 'equal',
        sources = {
          {
            source = 'filesystem',
            display_name = ' 󰉓 Files ',
          },
        },
      },
      renderers = {
        directory = {
          { 'indent' },
          { 'icon' },
          { 'current_filter' },
          {
            'container',
            content = {
              { 'name', zindex = 10 },
              -- {
              --   "symlink_target",
              --   zindex = 10,
              --   highlight = "NeoTreeSymbolicLinkTarget",
              -- },
              { 'clipboard', zindex = 10 },
              {
                'diagnostics',
                errors_only = true,
                zindex = 20,
                align = 'right',
                hide_when_expanded = false,
              },
              {
                'git_status',
                zindex = 10,
                align = 'right',
                hide_when_expanded = true,
              },
            },
          },
        },
        file = {
          { 'indent' },
          { 'icon' },
          {
            'container',
            content = {
              {
                'name',
                zindex = 10,
              },
              -- {
              --   "symlink_target",
              --   zindex = 10,
              --   highlight = "NeoTreeSymbolicLinkTarget",
              -- },
              { 'clipboard', zindex = 10 },
              { 'bufnr', zindex = 10 },
              { 'modified', zindex = 20, align = 'right' },
              { 'diagnostics', zindex = 20, align = 'right' },
              { 'git_status', zindex = 15, align = 'right' },
            },
          },
        },
        message = {
          { 'indent', with_markers = false },
          { 'name', highlight = 'NeoTreeMessage' },
        },
        terminal = {
          { 'indent' },
          { 'icon' },
          { 'name' },
          { 'bufnr' },
        },
      },
    }

    if string.sub(vim.g.colors_name, 1, string.len 'catppuccin') == 'catppuccin' then
      vim.api.nvim_set_hl(0, 'NeoTreeCursorLine', { fg = '#192005', bg = '#209fb5' })
      vim.api.nvim_set_hl(0, 'NeoTreeNormal', { fg = '#192005', bg = '#FFF8E3' })
      vim.api.nvim_set_hl(0, 'NeoTreeNormalNC', { fg = '#192005', bg = '#FFF8E3' })
      vim.api.nvim_set_hl(0, 'NeoTreeSignColumn', { fg = '#192005', bg = '#FFF8E3' })
      vim.api.nvim_set_hl(0, 'NeoTreeSatusLine', { fg = '#192005', bg = '#FFF8E3' })
      vim.api.nvim_set_hl(0, 'NeoTreeSatusLineNC', { fg = '#192005', bg = '#FFF8E3' })
      vim.api.nvim_set_hl(0, 'NeoTreeTabActive', { fg = '#192005', bg = '#b4dfe4' })
    elseif string.sub(vim.g.colors_name, 1, string.len 'gruvbox') == 'gruvbox' then
      vim.api.nvim_set_hl(0, 'NeoTreeCursorLine', { fg = '#192005', bg = '#afd787' })
    else
      print 'CursorLine not defined for NeoTree'
    end
  end,
}
