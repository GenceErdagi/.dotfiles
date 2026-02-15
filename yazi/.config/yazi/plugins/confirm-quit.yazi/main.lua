local state_file = os.getenv("HOME") .. "/.cache/yazi-confirm-quit.state"

local function read_state()
	local f = io.open(state_file, "r")
	if not f then
		return nil
	end
	local content = f:read("*a")
	f:close()
	return tonumber(content)
end

local function write_state(time)
	local f = io.open(state_file, "w")
	if f then
		f:write(tostring(time))
		f:close()
	end
end

local function entry()
	local now = os.time()
	local last_time = read_state()

	-- If last press was within 3 seconds, actually quit
	if last_time and (now - last_time) < 3 then
		os.remove(state_file)
		ya.emit("quit", {})
		return
	end

	-- Otherwise, show notification and record time
	write_state(now)
	ya.notify({
		title = "Quit Confirmation",
		content = "Press 'q' again within 3s to quit Yazi",
		timeout = 3,
		level = "info",
	})
end

return { entry = entry }
