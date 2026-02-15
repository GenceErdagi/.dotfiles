-- Confirm Quit Plugin
-- Press 'q' once to show confirmation, press 'q' again within 3 seconds to quit

local STATE_FILE = "/tmp/yazi_confirm_quit_state"

local function read_state()
	local f = io.open(STATE_FILE, "r")
	if f then
		local time = tonumber(f:read("*l"))
		f:close()
		return time
	end
	return nil
end

local function write_state(time)
	local f = io.open(STATE_FILE, "w")
	if f then
		f:write(tostring(time) .. "\n")
		f:close()
	end
end

local function clear_state()
	os.remove(STATE_FILE)
end

local function entry()
	local now = os.time()
	local last_time = read_state()
	
	-- Check if we're in confirmation mode (within 3 seconds)
	if last_time and (now - last_time) <= 3 then
		-- Second press - actually quit
		clear_state()
		ya.emit("quit", {})
	else
		-- First press - show confirmation and set state
		ya.notify({
			title = "Quit Confirmation",
			content = "Press 'q' again to quit Yazi",
			timeout = 3,
			level = "info",
		})
		
		-- Store state for next keypress
		write_state(now)
	end
end

return { entry = entry }
