-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

-- Imports
local WebhookUtils =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/idonthaveoneatm/lua/normal/discordwebhook/src.lua"))()

-- Player Variables
local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

-- Misc Variables
local DataEvent = ReplicatedStorage:WaitForChild("dataRemoteEvent")
local DungeonName = Workspace:WaitForChild("dungeonName")

-- Material Variables
local Materials = { ["Warforged Metal"] = 0, ["Obsidian Chunk"] = 0, ["Gold Bar"] = 0, ["Astral Amethyst"] = 0 }

-- Config Variables
local Config = {
	Global = {
		Key = getgenv().Config.Global.Key,
	},
	Settings = {
		ResetOnGregg = getgenv().Config.Gregg.ResetOnGregg,
		ResetInLocations = getgenv().Config.Gregg.ResetInLocations,
		Webhook = {
			Enabled = getgenv().Config.Gregg.Webhook.Enabled,
			Ping = getgenv().Config.Gregg.Webhook.Ping,
			Url = getgenv().Config.Gregg.Webhook.Url,
		},
	},
}

-- Functions
local function SaveGreggData()
	local CraftingUI = PlayerGui:WaitForChild("CraftingUI")

	CraftingUI.Enabled = true

	local MaterialGui = CraftingUI.Main.Topbar

	repeat
		task.wait()
	until MaterialGui["Astral Amethyst"].TextLabel.Text ~= 888
		or MaterialGui["Gold Bar"].TextLabel.Text ~= 888
		or MaterialGui["Obsidian Chunk"].TextLabel.Text ~= 888
		or MaterialGui["Warforged Metal"].TextLabel.Text ~= 888

	task.wait(1)

	Materials["Astral Amethyst"] = MaterialGui["Astral Amethyst"].TextLabel.Text
	Materials["Gold Bar"] = MaterialGui["Gold Bar"].TextLabel.Text
	Materials["Obsidian Chunk"] = MaterialGui["Obsidian Chunk"].TextLabel.Text
	Materials["Warforged Metal"] = MaterialGui["Warforged Metal"].TextLabel.Text

	local Encoded = HttpService:JSONEncode(Materials)
	writefile("Helper/Gregg.json", Encoded)
end

local function ReadGreggData()
	if isfile("Helper/Gregg.json") then
		return HttpService:JSONDecode(readfile("Helper/Gregg.json"))
	else
		Player:Kick("No Data File Found, Please Go To Lobby!")
		return
	end
end

local function ResetPlayer()
	if Player.Character then
		Player.Character.Humanoid.Health = 0
	end

	repeat
		task.wait()
	until PlayerGui.RevivePrompt.Enabled == true

	DataEvent:FireServer({ [1] = { [1] = { ["\3"] = "closeRevive" }, [2] = "\13" } })
	PlayerGui.RevivePrompt.Enabled = false
end

local function SendGreggWebhook(Ping: string, Material: string, Added: string, Total: number)
	if Ping == "everyone" then
		Ping = "@eveyone"
	elseif Ping ~= "" then
		Ping = "<@" .. Ping .. ">"
	end

	local MyWebhook = WebhookUtils.createMessage({
		Url = Config.Settings.Webhook.Url,
		username = "Gregg Webhook",
		content = Ping,
	})

	local EmbedInformation =
		MyWebhook.addEmbed("Gregg Defeated", tonumber(string.format("0x%X", math.random(0x000000, 0xFFFFFF))), "")

	EmbedInformation.addField(
		":bust_in_silhouette: Player Information",
		"```Name: " .. Player.Name .. "\n" .. "Dungeon: " .. DungeonName.Value .. "```"
	)

	EmbedInformation.addField(
		":mag: Material Information",
		"```Material: " .. Material .. "\n" .. "Amount Added: " .. Added .. "\n" .. "Total Amount: " .. Total .. "```"
	)

	MyWebhook.sendMessage()
end

-- RunTime
if game.PlaceId == 2414851778 then
	SaveGreggData()
end

if game.PlaceId == 14363263080 then
	local Data = ReadGreggData()

	if Config.Settings.ResetOnGregg == true then
		print("[GREGG HELPER]: Resetting On Gregg")

		if DungeonName.Value ~= "Yokai Peak" then
			game.Workspace.DescendantRemoving:Connect(function(Mob)
				if Mob.Name == "Gregg" and Mob.Humanoid.Health <= 0 then
					ResetPlayer()
				end
			end)
		end
	end

	if Config.Settings.Webhook.Enabled == true then
		print("[GREGG HELPER]: Sending Webhook")

		Workspace.DescendantRemoving:Connect(function(Mob)
			if Mob.Name == "Gregg" then
				local GreggGui = PlayerGui.CrossDungeonGregg.greggRewards:WaitForChild("Material")
				local MaterialsAdded = GreggGui:WaitForChild("TextLabel").Text
				local MaterialImage = GreggGui:WaitForChild("ImageLabel").Image

				local MaterialType, TotalAmount

				if MaterialImage == "rbxassetid://17166874566" then
					MaterialType = "Warforged Metal"
				elseif MaterialImage == "rbxassetid://17166875877" then
					MaterialType = "Obsidian Chunk"
				elseif MaterialImage == "rbxassetid://17166876539" then
					MaterialType = "Gold Bar"
				elseif MaterialImage == "rbxassetid://17109342015" then
					MaterialType = "Astral Amethyst"
				end

				for i, v in Data do
					if i == MaterialType then
						TotalAmount = v
					end
				end

				local Path = Materials[MaterialType] + tonumber(string.sub(MaterialsAdded, 2))
				local Encoded = HttpService:JSONEncode(Path)

				TotalAmount += tonumber(string.sub(MaterialsAdded, 2))

				writefile("Helper/Gregg.json", Encoded)

				SendGreggWebhook(Config.Settings.Webhook.Ping, MaterialType, MaterialsAdded, TotalAmount)
			end
		end)
	end

	if Config.Settings.ResetInLocations == true then
		print("[GREGG HELPER]: Resetting In Locations")

		if DungeonName.Value == "Samurai Palace" then
			Workspace.DescendantAdded:Connect(function(Mob)
				if Mob.Name == "Sanada Yukimura" then
					ResetPlayer()
				end
			end)
		elseif DungeonName.Value == "Steampunk Sewers" then
			Workspace.dungeon.room4.DescendantAdded:Connect(function(Mob)
				if Mob.Name == "Hammer Bot" then
					ResetPlayer()
				end
			end)
		elseif DungeonName.Value == "Orbital Outpost" then
			Workspace.DescendantAdded:Connect(function(Mob)
				if Mob.Name == "Tesla Master" then
					ResetPlayer()
				end
			end)
		elseif DungeonName.Value == "Enchanted Forest" then
			Workspace.DescendantAdded:Connect(function(Mob)
				if Mob.Name == "Crystal Golem" then
					ResetPlayer()
				end
			end)
		elseif DungeonName.Value == "Gilded Skies" then
			Workspace.DescendantAdded:Connect(function(Mob)
				if Mob.Name == "General Cragg" then
					ResetPlayer()
				end
			end)
		end
	end
end
