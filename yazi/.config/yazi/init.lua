th.git = th.git or {}
th.git.modified = ui.Style():fg("#fce566")
th.git.added = ui.Style():fg("#7bd88f")
th.git.untracked = ui.Style():fg("#5ad4e6")
th.git.ignored = ui.Style():fg("#69676c")
th.git.deleted = ui.Style():fg("#fc618d"):bold()
th.git.updated = ui.Style():fg("#948ae3")

th.git = th.git or {}
th.git.modified_sign = "M"
th.git.added_sign = "A"
th.git.untracked_sign = "?"
th.git.ignored_sign = "I"
th.git.deleted_sign = "D"
th.git.updated_sign = "U"

require("no-status"):setup()
require("git"):setup()

-- Yazi-ZX sidebar toggle support
if os.getenv("YAZI_IDE_SIDEBAR") == "1" then
	require("toggle-pane"):entry("min-parent")
	require("toggle-pane"):entry("min-preview")
end