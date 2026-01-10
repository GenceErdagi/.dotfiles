--- @since 25.5.31
--- @sync entry

local function entry(self, job)
	job = type(job) == "string" and { args = { job } } or job
	local args = job.args or {}

	local cwd = tostring(cx.active.current.cwd)
	local root = os.getenv("YAZI_ZX_ROOT")

	-- Handle quit protection
	if args[1] == "quit" then
		ya.notify({
			title = "Quit Blocked",
			content = "Press 'qq' to quit yazi",
			timeout = 2,
			level = "info",
		})
		return
	end

	-- If not running via zx (env var not set), just behave like normal 'leave'
	if not root or root == "" then
		ya.emit("leave", {})
		return
	end

	-- Normalize root path (remove trailing slash if present, unless root is just "/")
	if #root > 1 and root:sub(-1) == "/" then
		root = root:sub(1, -2)
	end

	-- Check if we are at the root
	if cwd == root then
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
end

return { entry = entry }
