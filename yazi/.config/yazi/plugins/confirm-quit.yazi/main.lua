---@meta confirm-quit

--- A Yazi plugin that requires confirmation before quitting.
---@since 25.5.31

local M = {}

local STATE_FILE = os.getenv("HOME") .. "/.cache/yazi-confirm-quit.state"
local TIMEOUT = 3

local function read_state()
	local f = io.open(STATE_FILE, "r")
	if not f then
		return nil
	end
	local content = f:read("*a")
	f:close()
	return tonumber(content)
end

local function write_state(time)
	local f = io.open(STATE_FILE, "w")
	if f then
		f:write(tostring(time))
		f:close()
	end
end

local function notify(title, content)
	ya.notify({
		title = title,
		content = content,
		timeout = TIMEOUT,
		level = "info",
	})
end

function M.entry()
	local now = os.time()
	local last_time = read_state()

	if last_time and (now - last_time) < TIMEOUT then
		os.remove(STATE_FILE)
		ya.emit("quit", {})
		return
	end

	write_state(now)
	notify("Quit Confirmation", "Press 'q' again within 3s to quit Yazi")
end

return { entry = M.entry }
