local get_state = ya.sync(function()
	return {
		cwd = tostring(cx.active.current.cwd),
		root = os.getenv("YAZI_ZX_ROOT"),
	}
end)

return {
	entry = function(_, args)
		local state = get_state()
		
		-- Handle quit protection
		if args and #args > 0 and args[1] == "quit" then
			ya.notify({
				title = "Quit Blocked",
				content = "Press 'qq' to quit yazi",
				timeout = 2,
				level = "info",
			})
			return
		end
		
		-- If not running via zx (env var not set), just behave like normal 'leave'
		if not state.root or state.root == "" then
			ya.emit("leave", {})
			return
		end

		-- Check if we are at the root
		if state.cwd == state.root then
			ya.notify({
				title = "Workspace Lock",
				content = "Cannot leave the initial working directory (ZX Mode)",
				timeout = 2,
				level = "warn",
			})
			return
		end

		-- Otherwise, leave
		ya.emit("leave", {})
	end,
}
