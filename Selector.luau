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
	print("[SELECTOR] Script Execution Stopped")
	return
end

-- Functions
local function LoadFHelper()
	task.spawn(function()
		loadstring(
			game:HttpGet(
				"https://raw.githubusercontent.com/TheAuthenticName/Scripts/refs/heads/main/FractureHelper.luau"
			)
		)()
	end)
end

local function LoadGHelper()
	task.spawn(function()
		loadstring(
			game:HttpGet("https://raw.githubusercontent.com/TheAuthenticName/Scripts/refs/heads/main/GreggHelper.luau")
		)()
	end)
end

-- RunTime
getgenv().IsFractureLoaded = false

if game.PlaceId == 2414851778 then
	if Config.Scripts.FractureHelper == true then
		print("[SELECTOR] Loading Fracture Module")
		LoadFHelper()
	end

	if Config.Scripts.Gregg == true then
		print("[SELECTOR] Loading Gregg Module")
		LoadGHelper()
	end
end

if game.PlaceId == 14363263080 then
	if Config.Scripts.FractureHelper == true then
		print("[SELECTOR] Loading Fracture Module")
		LoadFHelper()
	end

	if Config.Scripts.Gregg == true then
		print("[SELECTOR] Loading Gregg Module")
		LoadGHelper()
	end

	--[[
	if Config.Scripts.Manual == true and Config.Scripts.FractureHelper == false then
		print("[SELECTOR] Loading Manual Module")
		task.spawn(function()
			loadstring(game:HttpGet(""))
		end)
	end]]
end
