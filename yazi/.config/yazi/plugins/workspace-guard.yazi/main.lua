---@meta workspace-guard

--- A Yazi plugin that prevents navigating beyond a defined workspace root.
---@since 25.5.31

local M = {}

--- Setup the plugin with optional configuration
---@param opts? { timeout?: number } Configuration options
function M.setup(opts)
end

local function notify(title, content, level)
	ya.notify({
		title = title,
		content = content,
		timeout = 2,
		level = level or "info",
	})
end

local function is_at_root(cwd, root)
	if not root or root == "" then
		return false
	end

	local normalized_root = root
	if #normalized_root > 1 and normalized_root:sub(-1) == "/" then
		normalized_root = normalized_root:sub(1, -2)
	end

	return cwd == normalized_root
end

local function entry(_, job)
	local args = (job or {}).args or {}
	local cwd = tostring(cx.active.current.cwd)
	local root = os.getenv("YAZI_ZX_ROOT")

	if args[1] == "quit" then
		notify("Quit Blocked", "Press 'qq' to quit yazi", "info")
		return
	end

	if not root or root == "" then
		ya.emit("leave", {})
		return
	end

	if is_at_root(cwd, root) then
		notify("Workspace Lock", "Cannot leave the initial working directory (ZX Mode)", "warn")
		return
	end

	ya.emit("leave", {})
end

return { entry = entry, setup = M.setup }
