require("no-status"):setup()

-- Yazi-ZX sidebar toggle support
if os.getenv("YAZI_IDE_SIDEBAR") == "1" then
	require("toggle-pane"):entry("min-parent")
	require("toggle-pane"):entry("min-preview")
end
