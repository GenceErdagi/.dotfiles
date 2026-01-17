local function entry()
	ya.notify({
		title = "Quit Confirmation",
		content = "Press 'q' again to quit Yazi",
		timeout = 3,
		level = "info",
	})
end

return { entry = entry }
