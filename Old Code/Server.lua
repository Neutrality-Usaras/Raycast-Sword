local Player = game:GetService("Players")
local SS = game:GetService("ServerStorage")
local RS = game:GetService('ReplicatedStorage')
local MF = RS:WaitForChild("Models") --Models Folder

--Events
local EvF = RS.Events
local ShEqM = EvF:WaitForChild("ShiftEquip") --Shift Equip Murasama
local BackToScadbard = EvF:WaitForChild("BackToScadbard")
local WeldToHand = EvF:WaitForChild("WeldToHand")
local WeldToLeft = EvF:WaitForChild("WeldToLeft")
local WeldToRight = EvF:WaitForChild("WeldToRight")

local MM = require(SS.Murasama) --Murasama Module
Player.PlayerAdded:Connect(function(Plr)
	local Chrctr = Plr.CharacterAdded:Wait()
	local Torso = Plr.Character.UpperTorso
	MM:M6DToT(Torso, MF)
end)

ShEqM.OnServerEvent:Connect(function(Plr, Mrsm, MEquiped)
	MM:SE(Plr, Mrsm, MEquiped)
end)

BackToScadbard.OnServerEvent:Connect(function(Plr, Murasama)
	MM:BackToScad(Plr, Murasama)
end)

WeldToHand.OnServerEvent:Connect(function(Plr, Murasama)
	MM:WeldToArm(Plr, Murasama)
end)

WeldToLeft.OnServerEvent:Connect(function(Plr, Murasama)
	MM:WeldToLeft(Plr, Murasama)
end)

WeldToRight.OnServerEvent:Connect(function(Plr, Murasama)
	MM:WeldToRight(Plr, Murasama)
end)
