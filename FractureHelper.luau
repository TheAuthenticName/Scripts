-- Config
local Config = {
	Scripts = {
		FractureHelper = getgenv().Config.FractureHelper.Enabled,
		Manual = getgenv().Config.Manual.Enabled,
		Gregg = getgenv().Config.Gregg.Enabled,
	},
}

-- Functions
local function LoadFractureHelper()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/TheAuthenticName/Scripts/refs/heads/main/FractureHelper.luau"))()
end

local function LoadGreggHelper()
	loadstring(game:HttpGet(""))
end

-- RunTime
if game.PlaceId == 2414851778 then
	-- Load Fracture Helper Module
	if Config.Scripts.FractureHelper == true then
		print(`[SELECTOR]: Loading Fracture Helper`)
		task.spawn(function()
			LoadFractureHelper()
		end)
	end

	-- Load Gregg Module
	if Config.Scripts.Gregg == true then
		print(`[SELECTOR]: Loading Gregg Helper`)
		task.spawn(function()
			LoadGreggHelper()
		end)
	end
end

if game.PlaceId == 14363263080 then
	-- Load Fracture Helper Module
	if Config.Scripts.FractureHelper == true then
		print(`[SELECTOR]: Loading Fracture Helper`)
		task.spawn(function()
			LoadFractureHelper()
		end)
	end

	-- Load Gregg Module
	if Config.Scripts.Gregg == true then
		print(`[SELECTOR]: Loading Gregg Helper`)
		task.spawn(function()
			LoadGreggHelper()
		end)
	end
end
