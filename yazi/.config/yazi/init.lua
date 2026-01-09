require("no-status"):setup()

if os.getenv("YAZI_IDE_SIDEBAR") == "1" then
	require("toggle-pane"):entry("min-parent")
	require("toggle-pane"):entry("min-preview")
end