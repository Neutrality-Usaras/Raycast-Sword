local players = game:GetService("Players")

local serverStorage = game:GetService("ServerStorage")
local repStorage = game:GetService('ReplicatedStorage')

local modelsFolder = repStorage:WaitForChild("Models") 

--Events
local eventsFolder = repStorage.Events

local ShiftEquip = eventsFolder:WaitForChild("ShiftEquip") --Shift Equip Murasama
local BackToScadbard = eventsFolder:WaitForChild("BackToScadbard")
local WeldToHand = eventsFolder:WaitForChild("WeldToHand")
local WeldToLeft = eventsFolder:WaitForChild("WeldToLeft")
local WeldToRight = eventsFolder:WaitForChild("WeldToRight")

local MurasamaModule = require(serverStorage.Murasama) --Murasama Module

players.PlayerAdded:Connect(function(plr)
	local Chrctr = plr.CharacterAdded:Wait()
	local Torso = plr.Character.UpperTorso
	MurasamaModule:M6DToTorso(plr, Torso, modelsFolder)
end)

players.PlayerRemoving:Connect(function(plr)
	MurasamaModule:PlayerDeleter(plr)
end)

ShiftEquip.OnServerEvent:Connect(function(Plr)
	MurasamaModule:ShiftEquip(Plr)
end)

BackToScadbard.OnServerEvent:Connect(function(Plr)
	MurasamaModule:BackToScabbard(Plr)
end)

WeldToHand.OnServerEvent:Connect(function(Plr)
	MurasamaModule:WeldToArm(Plr)
end)

WeldToLeft.OnServerEvent:Connect(function(Plr)
	MurasamaModule:WeldToLeft(Plr)
end)

WeldToRight.OnServerEvent:Connect(function(Plr)
	MurasamaModule:WeldToRight(Plr)
end)
