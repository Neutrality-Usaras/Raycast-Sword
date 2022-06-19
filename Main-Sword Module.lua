--Quick Docs

--bnsW is a blade and scabbord weld 

--Docs ends

local MurasamaModule = {} --Murasama Module
MurasamaModule.__index = MurasamaModule


local playersMurasamas = {} 

local exampleModels = {
	["scadbardMotor"] = workspace.RealTimePrototype.UpperTorso.SwordTorso.ScadbardMotor,
	["rightHandMotor"] = workspace.ANIMATE3.RightHand.BladeMotor,
	['leftHandMotor'] = workspace.ANIMATE3.LeftHand.ScadbardMotor,
	['bladeMotor'] = workspace.AllMurasamasVersions.ModernTorso.Sword.Blade.BladeMotor.bnsW,
	['leftBladeMotor'] = workspace.Animatti.LeftHand.BladeMotor
} 

setmetatable(MurasamaModule, playersMurasamas)
setmetatable(MurasamaModule, exampleModels)

--Example models connected vars
local scadbardMotor = exampleModels.scadbardMotor
local rightHandMotor = exampleModels.rightHandMotor
local leftHandMotor = exampleModels.leftHandMotor
local bladeMotor = exampleModels.bladeMotor
local leftBladeMotor = exampleModels.leftBladeMotor

--Other vars
local waitingTime = 1.2

local function WeldCreator(...)
	local parent ,name, p0, p1, C0, C1 = unpack(...)
	
	local Weld = Instance.new("Weld", parent)
	Weld.Name = name or 'Weld'
	
	Weld.Part0 = p0
	Weld.Part1 = p1
	
	Weld.C0 = C0 or CFrame.new(0, 0, 0)
	Weld.C1 = C1 or CFrame.new(0, 0, 0)
	
	return Weld
end

function MurasamaModule:PlayerDeleter(plr)
	playersMurasamas[plr] = nil
end



function MurasamaModule:M6DToTorso(plr, torso, modelsFolder) --MOTOR 6D to TORSO
	local murasama = modelsFolder.SwordTorso:Clone()--MURASAMA
	murasama.Parent = torso
	
	local M6D = Instance.new("Motor6D", torso)
	M6D.Part0 = torso
	M6D.Part1 = murasama
	
	playersMurasamas[plr] = murasama.Sword	
end

function MurasamaModule:WeldToArm(plr)
	--Murasama Connected vars
	local playerMurasama = playersMurasamas[plr]
	local swordTorso = playersMurasamas[plr].Parent
	local scabbard = playerMurasama.Scabbard.ScadbardMotor
	
	local STWeld = WeldCreator({swordTorso, "STConst", swordTorso, scabbard, scadbardMotor.C0, scadbardMotor.C1})
	
	local rightHand = plr.Character:WaitForChild("RightHand")
	local blade = playerMurasama.Blade.BladeMotor
	local BSW = playerMurasama.Blade.BladeMotor.bnsW
	local swordTorsoWeld = playerMurasama.Parent.STConst 
	
	swordTorsoWeld:Destroy()
	BSW:Destroy()
	
	local RHandW = WeldCreator({rightHand, 'Weld', rightHand, blade, rightHandMotor.C0, rightHandMotor.C1})
end

function MurasamaModule:ShiftEquip(plr) --SHIFT EQUIP
	local swordTorso = playersMurasamas[plr].Parent
	local playerMurasama = playersMurasamas[plr]
	local scabbard = playersMurasamas[plr].Scabbard.ScadbardMotor
	
	if playerMurasama.Blade.BladeMotor:FindFirstChild("bnsW") then
		local LeftH = plr.Character:WaitForChild("LeftHand")
		local RightH = plr.Character:WaitForChild("RightHand")
		
		local Blade = playerMurasama.Blade.BladeMotor
		
		local STW = swordTorso.STConst --Sword Torso weld!
		local BSW = playerMurasama.Blade.BladeMotor.bnsW --Blade Sword Weld!		


		STW:Destroy()
		BSW:Destroy()
		
		local LHandW = WeldCreator({LeftH, 'Weld', LeftH, scabbard, leftHandMotor.C0, leftHandMotor.C1})
		local RHandW = WeldCreator({RightH, 'Weld', RightH, Blade, rightHandMotor.C0, rightHandMotor.C1})
		
		wait(waitingTime)
		
		LHandW:Destroy()
		
		local STWeld = WeldCreator({swordTorso, 'STConst', swordTorso, scabbard, scadbardMotor.C0, scadbardMotor.C1})
	end
end

function MurasamaModule:BackToScabbard(plr)
	
	local swordTorso = playersMurasamas[plr].Parent
	local playerMurasama = playersMurasamas[plr]
	local scabbard = playerMurasama.Scabbard.ScadbardMotor
	local blade = playerMurasama.Blade.BladeMotor
	
	local RightH = plr.Character:WaitForChild("RightHand")
	local LHWeld = RightH.Weld
	
	LHWeld:Destroy()
	
	
	local WeldToScad = WeldCreator({blade, 'bnsW', blade, scabbard, bladeMotor.C0, bladeMotor.C1})
end

function MurasamaModule:WeldToLeft(plr)
	local playerMurasama = playersMurasamas[plr]
	
	local LeftH = plr.Character:WaitForChild("LeftHand")
	local RightH = plr.Character:WaitForChild("RightHand")
	
	local Blade = playerMurasama.Blade.BladeMotor
	
	RightH.Weld:Destroy()
	
	local LHandW = WeldCreator({LeftH, 'Weld', LeftH, Blade, leftBladeMotor.C0, leftBladeMotor.C1})
end

function MurasamaModule:WeldToRight(plr)
	local playerMurasama = playersMurasamas[plr]
	
	local LeftH = plr.Character:WaitForChild("LeftHand")
	local RightH = plr.Character:WaitForChild("RightHand")
	
	local Blade = playerMurasama.Blade.BladeMotor
	
	LeftH.Weld:Destroy()
	
	local RHandW = WeldCreator({RightH, 'Weld', RightH, Blade, rightHandMotor.C0, rightHandMotor.C1})
end


return MurasamaModule
