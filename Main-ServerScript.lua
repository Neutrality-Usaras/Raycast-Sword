local players = game:GetService("Players")

local serverStorage = game:GetService("ServerStorage")
local repStorage = game:GetService('ReplicatedStorage')

local modelsFolder = repStorage:WaitForChild("Models") 

--//Events
local eventsFolder = repStorage:WaitForChild('Events')
local mainRemote = eventsFolder:WaitForChild('remote')
local MurasamaModule = require(serverStorage.Murasama) --Murasama Module

players.PlayerAdded:Connect(function(plr)
	MurasamaModule.M6DToTorso({['plr'] = plr,['modelsFolder'] = modelsFolder})
end)

players.PlayerRemoving:Connect(MurasamaModule.PlayerDeleter)


mainRemote.OnServerEvent:Connect(function(plr, actionName, ...)
	MurasamaModule[actionName](plr, ...)
end)
