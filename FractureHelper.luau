-- Yield Game
if not game:IsLoaded() then
	game.Loaded:Wait()
end

-- Services
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Imports
local WebhookUtils =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/idonthaveoneatm/lua/normal/discordwebhook/src.lua"))()

-- Player Variables
local Player = Players.LocalPlayer

-- Misc Variables
local Data

-- Config Variables
local Config = {
	Global = {
		Key = getgenv().Config.Global.Key,
	},
	Scripts = {
		FractureHelper = getgenv().Config.Scripts.FractureHelper,
		Manual = getgenv().Config.Scripts.Manual,
		Gregg = getgenv().Config.Scripts.Gregg,
	},
	Settings = {
		MainAccount = getgenv().Config.Settings.FractureHelper.MainAccount,
		AltAccount = getgenv().Config.Settings.FractureHelper.AltAccount,
		CheckForLevelUp = getgenv().Config.Settings.FractureHelper.CheckForLevelUp,
		Webhook = {
			Enabled = getgenv().Config.Settings.FractureHelper.Webhook.Enabled,
			Ping = getgenv().Config.Settings.FractureHelper.Webhook.Ping,
			Url = getgenv().Config.Settings.FractureHelper.Webhook.Url,
		},
	},
}
local Levels = {
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
local function LoadFracture()
	if getgenv().IsFractureLoaded == false then
		print("[FRACTURE HELPER] Loading Fracture")
		script_key = Config.Global.Key
		loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/24ae860d718d926527e0d2ee8fec1611.lua"))()

		getgenv().IsFractureLoaded = true
	else
		warn("[FRACTURE HELPER] Fracture Is Already Loaded")
	end
end

local function SaveLevelData()
	local Encoded = HttpService:JSONEncode(Levels)
	writefile("Helper/Levels.json", Encoded)
end

local function ReadLevelData()
	return HttpService:JSONDecode(readfile("Helper/Levels.json"))
end

local function PlayerLeaving(ID: number)
	if ID == 2414851778 then
		print("Lobby")

		Players.PlayerRemoving:Connect(function(plr)
			if plr.Name == Config.Settings.MainAccount or plr.Name == Config.Settings.AltAccount then
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
			if plr.Name == Config.Settings.MainAccount or plr.Name == Config.Settings.AltAccount then
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

local function SendWebhook(Ping: string, Level)
	if Ping == "everyone" then
		Ping = "@eveyone"
	elseif Ping ~= "" then
		Ping = "<@" .. Ping .. ">"
	end

	local MyWebhook = WebhookUtils.createMessage({
		Url = Config.Settings.Webhook.Url,
		username = "Level Webhook",
		content = Ping,
	})

	local EmbedInformation =
		MyWebhook.addEmbed("Level Up", tonumber(string.format("0x%X", math.random(0x000000, 0xFFFFFF))), "")

	EmbedInformation.addField("Player Information", "```Name: " .. Player.Name .. "\n" .. "New Level" .. Level .. "```")

	MyWebhook.sendMessage()
end

-- RunTime
if game.PlaceId == 2414851778 then
	if not isfile("Helper/Levels.json") then
		SaveLevelData()
	end

	PlayerLeaving(game.PlaceId)

	task.spawn(function()
		if Player.Name == Config.Settings.AltAccount then
			print("Lobby Timer Started")
			task.wait(120)

			local Friends = Player:GetFriendsOnline()

			for i, friend in pairs(Friends) do
				if Config.Settings.MainAccount == friend.UserName then
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
	if not isfile("Helper/Levels.json") then
		WriteData()
	end

	-- Getting Level Data
	Data = ReadLevelData()

	-- If Player Leaves
	PlayerLeaving(game.PlaceId)

	-- If Accounts Get Stuck Mid Run
	task.spawn(function()
		print("Dungeon Timer Started")

		if Player.Name == Config.Settings.MainAccount then
			task.wait(360)
			TeleportService:Teleport(2414851778, Player)
		end
	end)

	if Config.Settings.CheckForLevelUp == true then
		if Player.Name == Config.Settings.MainAccount then
			local Level = Players:WaitForChild(Config.Settings.MainAccount):WaitForChild("leaderstats").Level.Value

			for i = 5, 210, 5 do
				if Level >= i and Level <= i + 4 and Data[tostring(i)] == false then
					Levels[tostring(i)] = true
					if Config.Settings.Webhook.Enabled == true then
						SendWebhook(Config.Settings.Webhook.Ping, i)
					end
					SaveLevelData()

					task.wait(3)

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
