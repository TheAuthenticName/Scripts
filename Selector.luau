-- Yield Game
if not game:IsLoaded() then
	game.Loaded:Wait()
end

-- Config
local Config = {
	Global = {
		Enabled = getgenv().Config.Global.Enabled,
		Key = getgenv().Config.Global.Key,
	},
	Scripts = {
		FractureHelper = getgenv().Config.Scripts.FractureHelper,
		Manual = getgenv().Config.Scripts.Manual,
		Gregg = getgenv().Config.Scripts.Gregg,
	},
}

-- Checking If Script Should Run
if Config.Global.Enabled ~= true then
	print("Script Execution Stopped")
	return
end

-- Functions
local function LoadFracture()
	if getgenv().IsFractureLoaded == false then
		script_key = Config.Global.Key
		loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/24ae860d718d926527e0d2ee8fec1611.lua"))()

		getgenv().IsFractureLoaded = true
	else
		warn("Fracture Is Already Loaded")
	end
end

-- RunTime
if game.PlaceId == 2414851778 then
	if Config.Scripts.FractureHelper == true then
		print("Loading Fracture Module")
		loadstring(game:HttpGet("https://raw.githubusercontent.com/TheAuthenticName/Scripts/refs/heads/main/FractureHelper.luau"))()
	end
end

if game.PlaceId == 14363263080 then
	if Config.Scripts.FractureHelper == true then
		print("Loading Fracture Module")
		task.spawn(function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/TheAuthenticName/Scripts/refs/heads/main/FractureHelper.luau"))()
		end)
	end

	if Config.Scripts.Gregg == true then
		print("Loading Gregg Module")
		task.spawn(function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/TheAuthenticName/Scripts/refs/heads/main/GreggHelper.luau"))()
		end)
	end

	--[[
	if Config.Scripts.Manual == true and Config.Scripts.FractureHelper == false then
		print("Loading Manual Module")
		task.spawn(function()
			loadstring(game:HttpGet(""))
		end)
	end]]

	if Config.Scripts.FractureHelper == false and Config.Scripts.Manual == false and Config.Scripts.Gregg == false then
		LoadFracture()
	end
end
