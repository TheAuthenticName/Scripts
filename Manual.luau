-- Services
local VirtualInputManager = game:GetService("VirtualInputManager")
local PathFindingService = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- Imports

-- Player Variables
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid: Humanoid = Character:WaitForChild("Humanoid")

-- Misc Variables
local PlayersInGame = {}
local MaxDistance = math.huge
local CurrentClass

-- Pathing Variables
local Waypoints
local NextWaypointIndex
local ReachedConnection

-- Config Variables
local MainConfig = {
	MainAccount = getgenv().Config.MainAccount,
	Bots = getgenv().Config.Bots,
	MainSpeed = getgenv().Config.MainSpeed,
	BotSpeed = getgenv().Config.BotSpeed,
	SkillRange = getgenv().Config.SkillRange,
	Disable3dRenderingOnAlts = getgenv().Config.Disable3dRenderingOnAlts,
}

-- Functions
local function SendWebhook(...: unknown) end

local function SetSpeed(Speed: number)
	OldIndex = hookmetamethod(
		game,
		"__index",
		newcclosure(function(self, property)
			if tostring(self) == "Humanoid" and property == "WalkSpeed" then
				return 17.6
			end
			return OldIndex
		end)
	)

	OldNewIndex = hookmetamethod(
		game,
		"__newindex",
		newcclosure(function(self, property, value)
			if tostring(self) == "Humanoid" and property == "WalkSpeed" then
				value = Speed
			end
			return OldNewIndex(self, property, value)
		end)
	)

	Humanoid.WalkSpeed = Speed
end

local function FindTarget()
	local Closest
	MaxDistance = math.huge

	for i, target in Workspace.dungeon:GetDescendants() do
		if target:IsA("Model") and target.Parent.Name == "enemyFolder" then
			local Distance = (Player.Character.HumanoidRootPart.Position - target.HumanoidRootPart.Position).Magnitude

			if Distance <= MaxDistance then
				MaxDistance = Distance
				Closest = target
			end
		end
		return target
	end
end

local function UseSpells(Delay: number)
	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
	task.wait(Delay)
	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, nil)
end

-- RunTime
if game.PlaceId == 14363263080 then
	print("Dungeon")

	-- Set Speed On Character
	Player.CharacterAdded:Connect(function()
		if Player.Name == MainConfig.MainAccount then
			SetSpeed(MainConfig.MainSpeed)
		else
			SetSpeed(MainConfig.BotSpeed)
		end
	end)

	-- Getting The Class And Player Names
	for name, class in MainConfig.Bots do
		if Player.Name == name then
			CurrentClass = class
		end
		table.insert(PlayersInGame, name)
	end

	-- Yield Until Player Is In Game
	repeat
		task.wait()
	until Workspace:FindFirstChild(MainConfig.MainAccount)

	-- Main
	RunService.RenderStepped:Connect(function()
		if Humanoid.Health > 0 and Workspace:FindFirstChild(MainConfig.MainAccount).Humanoid.Health > 0 then
			task.spawn(function()
				local Path = PathFindingService:CreatePath({
					AgentRadius = 3,
					AgentHeight = 6,
					AgentCanJump = true,
				})

				local success, fail = pcall(function()
					Path:ComputeAsync(
						Character.PrimaryPart.Position,
						Workspace:FindFirstChild(MainConfig.MainAccount).PrimaryPart
					)
				end)

				if success and Path.Status == Enum.PathStatus.Success then
					Waypoints = Path:GetWaypoints()

					if not ReachedConnection then
						ReachedConnection = Humanoid.MoveToFinished:Connect(function(Reached)
							if Reached and NextWaypointIndex < #Waypoints then
								NextWaypointIndex += 1
								Humanoid:MoveTo(Waypoints[NextWaypointIndex].Position)
							else
								ReachedConnection:Disconnect()
							end
						end)
					end
					NextWaypointIndex = 2
					Humanoid:MoveTo(Waypoints[NextWaypointIndex].Position)
				else
					warn("Path Not Computed!" .. fail)
				end
			end)
		end

		if CurrentClass == "Damage" then
			local CurrentTarget = FindTarget()

			if CurrentTarget ~= nil then
				if Humanoid.Health > 0 then
					Character.PrimaryPart.CFrame = CFrame.lookAt(
						Character.PrimaryPart.Position,
						Vector3.new(
							CurrentTarget.PrimaryPart.Position.X,
							Character.PrimaryPart.Position.Y,
							CurrentTarget.PrimaryPart.Position.Z
						)
					)
					UseSpells(3.3)
				end
			end
		elseif CurrentClass == "Healer" then
			for _, Name in PlayersInGame do
				local MaxHealth = Workspace:FindFirstChild(Name).Humanoid.MaxHealth

				if Workspace:FindFirstChild(Name).Humanoid.Health ~= MaxHealth then
					Character.PrimaryPart.CFrame = CFrame.lookAt(
						Character.PrimaryPart.Position,
						Vector3.new(
							Workspace.MainConfig.MainAccount.PrimaryPart.Position.X,
							Character.PrimaryPart.Position.Y,
							Workspace.MainConfig.MainAccount.PrimaryPart.Position.Z
						)
					)
					UseSpells(3)
				end
			end
		end
	end)
end
