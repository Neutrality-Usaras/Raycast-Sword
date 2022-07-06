--Quick Docs

--bnsW is a blade and scabbord weld 

--Docs ends

local MurasamaModule = {} --Murasama Module
MurasamaModule.__index = MurasamaModule


local playersMurasamas = {} 

local examplesFolder = workspace.Examples
local exampleModels = {
	["scadbardMotor"] = examplesFolder.RealTimePrototype.UpperTorso.SwordTorso.ScadbardMotor,
	["rightHandMotor"] = examplesFolder.ANIMATE3.RightHand.BladeMotor,
	['leftHandMotor'] = examplesFolder.ANIMATE3.LeftHand.ScadbardMotor,
	['bladeMotor'] = workspace.AllMurasamasVersions.ModernTorso.Sword.Blade.BladeMotor.bnsW,
	['leftBladeMotor'] = examplesFolder.Animatti.LeftHand.BladeMotor
} 

local plrCD = {}

setmetatable(MurasamaModule, playersMurasamas)
setmetatable(MurasamaModule, exampleModels)

--Example models connected vars
local scadbardMotor = exampleModels.scadbardMotor
local rightHandMotor = exampleModels.rightHandMotor
local leftHandMotor = exampleModels.leftHandMotor
local bladeMotor = exampleModels.bladeMotor
local leftBladeMotor = exampleModels.leftBladeMotor

--//Services
local Debris = game:GetService('Debris')

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

local function CreateVelocity(...)
	local chrtct, acceleration, extraPower = unpack(...)
	local HRP = chrtct.HumanoidRootPart
	
	local BodyVelocity = Instance.new("BodyVelocity", HRP)
	BodyVelocity.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
	HRP.CFrame = CFrame.new(HRP.Position, extraPower.Position)
	BodyVelocity.Velocity = -(extraPower.CFrame.lookVector * acceleration)
	

	return BodyVelocity
end

function MurasamaModule.PlayerDeleter(plr)
	playersMurasamas[plr] = nil
	plrCD[plr] = nil
end

function MurasamaModule:M6DToTorso() --MOTOR 6D to TORSO
	
	local Chrctr = self.plr.CharacterAdded:Wait()
	local torso = self.plr.Character.UpperTorso
	
	local murasama = self.modelsFolder.SwordTorso:Clone()--MURASAMA
	murasama.Parent = torso
	
	local M6D = Instance.new("Motor6D", torso)
	M6D.Part0 = torso
	M6D.Part1 = murasama
	
	playersMurasamas[self.plr] = murasama.Sword
	plrCD[self.plr] = false
end

function MurasamaModule.WeldToArm(plr)
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


function MurasamaModule.ArmWeld(plr, ...)
	local armToConnect, armToDelete, Motor = unpack(...)
	
	local playerMurasama = playersMurasamas[plr]
	local Blade = playerMurasama.Blade.BladeMotor
	
	armToDelete.Weld:Destroy()

	WeldCreator({armToConnect, 'Weld', armToConnect, Blade, exampleModels[Motor].C0, exampleModels[Motor].C1})
end

function MurasamaModule.ShiftEquip(plr) --SHIFT EQUIP
	
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

function MurasamaModule.BackToScabbard(plr)
	local swordTorso = playersMurasamas[plr].Parent
	local playerMurasama = playersMurasamas[plr]
	local scabbard = playerMurasama.Scabbard.ScadbardMotor
	local blade = playerMurasama.Blade.BladeMotor
	
	local RightH = plr.Character:WaitForChild("RightHand")
	local LHWeld = RightH.Weld
	
	LHWeld:Destroy()
	
	
	local WeldToScad = WeldCreator({blade, 'bnsW', blade, scabbard, bladeMotor.C0, bladeMotor.C1})
end


local raycastParams = RaycastParams.new()

function MurasamaModule.CreateRay(plr)
	local playerMurasama = playersMurasamas[plr]
	local rayPart = plr.Character.HumanoidRootPart
	
	local rayDirection = rayPart.CFrame.lookVector * 10
	local rayOrigin = rayPart.Position
	raycastParams.FilterDescendantsInstances = {plr.Character, workspace.Baseplate}
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	
	local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
	
	--local rayPart2 = playerMurasama.Blade.rayPart
	--local rayOrig2 = rayPart2.Position
	--local rayDir2 = rayPart2.CFrame.lookVector * 100
	
	--local rayResult2 = workspace:Raycast(rayOrig2, rayDir2, raycastParams)
	
	if raycastResult then
		
		local randomPart = raycastResult.Instance
		local acceleration = -25.5
		local extraPower = rayPart.CFrame.lookVector
		
		if randomPart.Parent:FindFirstChild('Humanoid') then
			local preyHumanoid = randomPart.Parent.Humanoid
			local character = randomPart.Parent
			 
			local bodyVelocity = CreateVelocity({character, acceleration, rayPart})
			preyHumanoid:TakeDamage(7.5)
			Debris:AddItem(bodyVelocity, .2)
		end
	--elseif rayResult2 then
	--	print(rayResult2.Instance)
	--	print('Hit by second ray')
	end
end

function MurasamaModule.CreateHitbox(plr, ...)
	if not plrCD[plr] then
		plrCD[plr] = true
		local part, damage = unpack(...)
		local preyHum = part.Parent.Humanoid
		preyHum:TakeDamage(damage)		
		wait(4)
		plrCD[plr] = false
	end 
end

return MurasamaModule
