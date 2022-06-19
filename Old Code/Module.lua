local MM = {} --Murasama Module
MM.__index = MM

local WaitingTime = 1.2

function MM:M6DToT(Torso, MF) --MOTOR 6D to TORSO
	local M = MF.SwordTorso:Clone() --MURASAMA
	M.Parent = Torso
	local M6D = Instance.new("Motor6D", Torso)
	M6D.Part0 = Torso
	M6D.Part1 = M
end

function MM:WeldToArm(Plr, Murasama)
	local Scabbard = Murasama.Sword.Scabbard.ScadbardMotor
	local STWeld = Instance.new("Weld", Plr.Character.UpperTorso.SwordTorso)
	STWeld.Name = "STConst"
	STWeld.Part0 = Plr.Character.UpperTorso.SwordTorso
	STWeld.Part1 = Scabbard
	STWeld.C0 = workspace.RealTimePrototype.UpperTorso.SwordTorso.ScadbardMotor.C0
	STWeld.C1 = workspace.RealTimePrototype.UpperTorso.SwordTorso.ScadbardMotor.C1
	
	local RightH = Plr.Character:WaitForChild("RightHand")
	local RHandW = Instance.new("Weld", RightH)
	local Blade = Murasama:WaitForChild("Sword").Blade.BladeMotor
	local BSW = Murasama.Sword.Blade.BladeMotor.bnsW
	local STW = Murasama.STConst --Sword Torso weld!
	
	STW:Destroy()
	BSW:Destroy()
	
	RHandW.Part0 = RightH
	RHandW.Part1 = Blade
	RHandW.C0 = workspace.ANIMATE3.RightHand.BladeMotor.C0
	RHandW.C1 = workspace.ANIMATE3.RightHand.BladeMotor.C1
end

function MM:SE(Plr, Murasama, IsEquiped) --SHIFT EQUIP
	if Murasama.Sword.Blade.BladeMotor:FindFirstChild("bnsW") then
		
		print("Right")
		local STWeld = Instance.new("Weld", Plr.Character.UpperTorso.SwordTorso)
		STWeld.Name = "STConst"
		local LeftH = Plr.Character:WaitForChild("LeftHand")
		local RightH = Plr.Character:WaitForChild("RightHand")
		local Blade = Murasama.Sword.Blade.BladeMotor
		local Scabbard = Murasama.Sword.Scabbard.ScadbardMotor
		local STW = Murasama.STConst --Sword Torso weld!
		local BSW = Murasama.Sword.Blade.BladeMotor.bnsW or 0 --Blade Sword Weld!		
		local LHandW = Instance.new("Weld", LeftH)
		local RHandW = Instance.new("Weld", RightH)
		print(LHandW.Parent)


		STW:Destroy()
		BSW:Destroy()
		LHandW.Part0 = LeftH
		LHandW.Part1 = Scabbard
		LHandW.C0 = workspace.ANIMATE3.LeftHand.ScadbardMotor.C0
		LHandW.C1 = workspace.ANIMATE3.LeftHand.ScadbardMotor.C1

		RHandW.Part0 = RightH
		RHandW.Part1 = Blade
		RHandW.C0 = workspace.ANIMATE3.RightHand.BladeMotor.C0
		RHandW.C1 = workspace.ANIMATE3.RightHand.BladeMotor.C1
		wait(WaitingTime)
		LHandW:Destroy()
		STWeld.Part0 = Plr.Character.UpperTorso.SwordTorso
		STWeld.Part1 = Scabbard
		STWeld.C0 = workspace.RealTimePrototype.UpperTorso.SwordTorso.ScadbardMotor.C0
		STWeld.C1 = workspace.RealTimePrototype.UpperTorso.SwordTorso.ScadbardMotor.C1
		print("End")
	else

		local STWeld = Instance.new("Weld", Plr.Character.UpperTorso.SwordTorso)
		STWeld.Name = "STConst"
		local LeftH = Plr.Character:WaitForChild("LeftHand")
		local RightH = Plr.Character:WaitForChild("RightHand")
		local Blade = Murasama:WaitForChild("Sword").Blade.BladeMotor
		local Scabbard = Murasama.Sword.Scabbard.ScadbardMotor
		local STW = Murasama.STConst --Sword Torso weld!
		local LHandW = Instance.new("Weld", LeftH)
		local RHandW = Instance.new("Weld", RightH)

		STW:Destroy()

		LHandW.Part0 = LeftH
		LHandW.Part1 = Scabbard
		LHandW.C0 = workspace.ANIMATE3.LeftHand.ScadbardMotor.C0
		LHandW.C1 = workspace.ANIMATE3.LeftHand.ScadbardMotor.C1

		RHandW.Part0 = RightH
		RHandW.Part1 = Blade
		RHandW.C0 = workspace.ANIMATE3.RightHand.BladeMotor.C0
		RHandW.C1 = workspace.ANIMATE3.RightHand.BladeMotor.C1
		wait(WaitingTime)
		LHandW:Destroy()
		STWeld.Part0 = Plr.Character.UpperTorso
		STWeld.Part1 = Scabbard
		STWeld.C0 = workspace.RealTimePrototype.UpperTorso.SwordTorso.ScadbardMotor.C0
		STWeld.C1 = workspace.RealTimePrototype.UpperTorso.SwordTorso.ScadbardMotor.C1
		print("End")
	end
end

function MM:BackToScad(Plr, Murasama)
	local RightH = Plr.Character:WaitForChild("RightHand")
	local LHWeld = RightH.Weld
	LHWeld:Destroy()
	
	local Blade = Murasama.Sword.Blade.BladeMotor
	local Scabbard = Murasama.Sword.Scabbard.ScadbardMotor
	
	local WeldExample = workspace.AllMurasamasVersions.ModernTorso.Sword.Blade.BladeMotor.bnsW
	
	
	local WeldToScad = Instance.new("Weld", Blade)
	WeldToScad.Name = "bnsW"
	WeldToScad.Part0 = Blade
	WeldToScad.Part1 = Scabbard
	WeldToScad.C0 = WeldExample.C0
	WeldToScad.C1 = WeldExample.C1
end

function MM:WeldToLeft(Plr, Murasama)
	print("Weld on left")
	local LeftH = Plr.Character:WaitForChild("LeftHand")
	local LHandW = Instance.new("Weld", LeftH)
	local RightH = Plr.Character:WaitForChild("RightHand")
	
	local Blade = Murasama:WaitForChild("Sword").Blade.BladeMotor
	
	RightH.Weld:Destroy()
	
	LHandW.Part0 = LeftH
	LHandW.Part1 = Blade
	LHandW.C0 = workspace.Animatti.LeftHand.BladeMotor.C0
	LHandW.C1 = workspace.Animatti.LeftHand.BladeMotor.C1
end

function MM:WeldToRight(Plr, Murasama)
	local LeftH = Plr.Character:WaitForChild("LeftHand")
	local RightH = Plr.Character:WaitForChild("RightHand")
	local RHandW = Instance.new("Weld", RightH)
	
	local Blade = Murasama.Sword.Blade.BladeMotor
	
	LeftH.Weld:Destroy()
	
	RHandW.Part0 = RightH
	RHandW.Part1 = Blade
	RHandW.C0 = workspace.ANIMATE3.RightHand.BladeMotor.C0
	RHandW.C1 = workspace.ANIMATE3.RightHand.BladeMotor.C1
end

return MM
