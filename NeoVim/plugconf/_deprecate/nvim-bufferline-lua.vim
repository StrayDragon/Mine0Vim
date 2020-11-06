lua require'bufferline'.setup{
  options = {
    view = "multiwindow" | "default",
    numbers = "none" | "ordinal" | "buffer_id",
    number_style = "superscript" | "",
    mappings = true | false,
    buffer_close_icon= '',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    max_name_length = 18,
    tab_size = 18,
    show_buffer_close_icons = true | false,
    -- can also be a table containing 2 custom separators
    -- [focused and unfocused]. eg: { '|', '|' }
    separator_style = "thick" | "thin" | { 'any', 'any' },
    enforce_regular_tabs = false | true,
    always_show_bufferline = true | false,
    sort_by = 'extension' | 'directory' | function(buffer_a, buffer_b)
      -- add custom logic
      return buffer_a.modified > buffer_b.modified
    end
  }
}
