-- Waits For Game
repeat
	task.wait()
until game:IsLoaded()

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

-- Player Variables
local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

-- Misc Variables
local DataEvent = ReplicatedStorage:WaitForChild("dataRemoteEvent")
local DungeonName = Workspace:WaitForChild("dungeonName")

-- Config Variables
local Config = {
	GreggScript = {
		ResetInLocations = getgenv().Config.GreggScript.ResetInLocations,
		ResetOnGregg = getgenv().Config.GreggScript.ResetOnGregg,
		Webhook = {
			Enabled = getgenv().Config.GreggScript.Webhook.Enabled,
			Url = getgenv().Config.GreggScript.Webhook.Url,
		},
	},
}

-- Functions
local function SendGreggWebhook()
	local data, url

	task.spawn(function()
		url = ""
		data = {
			["embeds"] = {
				{
					["footer"] = {
						["text"] = "Death To All Greggs",
					},

					["title"] = "Gregg Defeated Webhook",
					["description"] = Player.Name .. " Has Killed Gregg In " .. DungeonName.Value,
					["type"] = "rich",
					["color"] = tonumber(string.format("0x%X", math.random(0x000000, 0xFFFFFF))),
				},
			},
		}
		repeat
			task.wait()
		until data

		local newdata = game:GetService("HttpService"):JSONEncode(data)
		local headers = { ["Content-Type"] = "application/json" }
		local request = http_request or request or HttpPost or syn.request or http.request
		local abcdef = { Url = url, Body = newdata, Method = "POST", Headers = headers }
		request(abcdef)
	end)
end

local function ResetPlayer()
	Player.Character.Humanoid.Health = 0

	repeat
		task.wait()
	until PlayerGui.RevivePrompt.Enabled == true

	DataEvent:FireServer({ [1] = { [1] = { ["\3"] = "closeRevive" }, [2] = "\13" } })
	PlayerGui.RevivePrompt.Enabled = false
end

-- RunTime
task.spawn(function()
	if DungeonName.Value ~= "Yokai Peak" then
		Workspace.DescendantRemoving:Connect(function(Mob)
			if Mob.Name == "Gregg" then
				if Mob.Humanoid.Health <= 0 then
					if Config.GreggScript.Webhook.Enabled == true then
						SendGreggWebhook()
					else
						print("Not Sending Webhook")
					end

					if Config.GreggScript.ResetOnGregg == true then
						ResetPlayer()
					else
						print("Not Resetting On Gregg Death")
					end
				end
			end
		end)
	end
end)

if Config.GreggScript.ResetInLocations == true then
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
	else
		print("Not Resetting In Optimal Locations")
	end
end
