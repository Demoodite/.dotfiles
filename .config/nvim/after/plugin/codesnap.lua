require("codesnap").setup({
    mac_window_bar = true,
    title = "CodeSnap.nvim",
    code_font_family = "CaskaydiaCove Nerd Font",
    watermark_font_family = "Pacifico",
    watermark = "",
    bg_theme = "summer",
    breadcrumbs_separator = "/",
    has_breadcrumbs = true,
    has_line_number = true,
    show_workspace = true,
    min_width = 0,
    bg_x_padding = 122,
    bg_y_padding = 82,
    save_path = os.getenv("XDG_PICTURES_DIR") or (os.getenv("HOME") .. "/Pictures")
})