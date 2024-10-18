-- Waits For Game
repeat
	task.wait()
until game:IsLoaded()

-- Services
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

-- Player Variables
local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

-- Misc Variables
local Data

-- Config Variables
local Config = {
	Settings = {
		MainAccount = getgenv().Config.Settings.MainAccount,
		AltAccount = getgenv().Config.Settings.AltAccount,
		CheckForLevelUp = getgenv().Config.Settings.CheckForLevelUp,
		Key = getgenv().Config.Settings.Key,
	},
	GreggScript = {
		Enabled = getgenv().Config.GreggScript.Enabled,
	},
}
local MainAccount = Config.Settings.MainAccount
local AltAccount = Config.Settings.AltAccount
local LevelConfig = {
	["5"] = false,
	["10"] = false,
	["15"] = false,
	["20"] = false,
	["25"] = false,
	["30"] = false,
	["35"] = false,
	["40"] = false,
	["45"] = false,
	["50"] = false,
	["55"] = false,
	["60"] = false,
	["65"] = false,
	["70"] = false,
	["75"] = false,
	["80"] = false,
	["85"] = false,
	["90"] = false,
	["95"] = false,
	["100"] = false,
	["105"] = false,
	["110"] = false,
	["115"] = false,
	["120"] = false,
	["125"] = false,
	["130"] = false,
	["135"] = false,
	["140"] = false,
	["145"] = false,
	["150"] = false,
	["155"] = false,
	["160"] = false,
	["165"] = false,
	["170"] = false,
	["175"] = false,
	["180"] = false,
	["185"] = false,
	["190"] = false,
	["195"] = false,
	["200"] = false,
	["205"] = false,
	["210"] = false,
	["215"] = false,
}

-- Functions
local function SaveLevelData()
	local Encoded = HttpService:JSONEncode(LevelConfig)
	writefile("FractureHelper/Levels.json", Encoded)
end

local function ReadLevelData()
	return HttpService:JSONDecode(readfile("FractureHelper/Levels.json"))
end

local function LoadFracture()
	script_key = Config.Settings.Key
	loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/24ae860d718d926527e0d2ee8fec1611.lua"))()
end

local function Leaving(ID: number)
	if ID == 2414851778 then
		print("Lobby")

		Players.PlayerRemoving:Connect(function(plr)
			if plr.Name == MainAccount or plr.Name == AltAccount then
				print("Waiting 40 Seconds")

				task.wait(40)

				if Players:FindFirstChild(plr.Name) then
					print(`{plr.Name} Has Rejoined!`)
					return
				else
					print("Teleporting")

					local Friends = Player:GetFriendsOnline()

					for i, friend in Friends do
						if plr.Name == friend.UserName then
							local FriendGame = friend.PlaceId
							local FriendServer = friend.GameId

							TeleportService:TeleportToPlaceInstance(FriendGame, FriendServer, Player)
						end
					end
				end
			end
		end)
	elseif ID == 14363263080 then
		Players.PlayerRemoving:Connect(function(plr)
			if plr.Name == MainAccount or plr.Name == AltAccount then
				task.wait(20)

				print("Teleporting")

				local Friends = Player:GetFriendsOnline()

				for i, friend in Friends do
					if plr.Name == friend.UserName then
						local FriendGame = friend.PlaceId
						local FriendServer = friend.GameId

						TeleportService:TeleportToPlaceInstance(FriendGame, FriendServer, Player)
					end
				end
			end
		end)
	end
end

-- RunTime
if game.PlaceId == 2414851778 then
	if not isfile("FractureHelper/Levels.json") then
		SaveLevelData()
	end

	Leaving(game.PlaceId)

	task.spawn(function()
		if Player.Name == AltAccount then
			print("Lobby Timer Started")
			task.wait(120)

			local Friends = Player:GetFriendsOnline()

			for i, friend in pairs(Friends) do
				if MainAccount == friend.UserName then
					local FriendGame = friend.PlaceId
					local FriendServer = friend.GameId

					TeleportService:TeleportToPlaceInstance(FriendGame, FriendServer, Player)
				end
			end
		end
	end)

	task.wait(5)

	LoadFracture()
end

if game.PlaceId == 14363263080 then
	if not isfile("FractureHelper.json") then
		WriteData()
	end

	Data = ReadLevelData()

	Leaving(game.PlaceId)

	task.spawn(function()
		print("Dungeon Timer Started")

		if Player.Name == MainAccount then
			task.wait(360)
			TeleportService:Teleport(2414851778, Player)
		end
	end)

	if Config.GreggScript.Enabled == true then
		task.spawn(function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/TheAuthenticName/Scripts/refs/heads/main/Gregg.luau"))()
		end)
	end

	task.wait(5)

	if Config.Settings.CheckForLevelUp == true then
		if Player.Name == MainAccount then
			local Level = Players:WaitForChild(MainAccount):WaitForChild("leaderstats").Level.Value

			for i = 5, 210, 5 do
				if Level >= i and Level <= i + 4 and Data[tostring(i)] == false then
					LevelConfig[tostring(i)] = true
					SaveLevelData()
					task.wait(5)
					TeleportService:Teleport(2414851778, Player)
					break
				end
			end
			LoadFracture()
		end
	else
		LoadFracture()
	end
end
