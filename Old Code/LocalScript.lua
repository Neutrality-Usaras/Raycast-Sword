--PLAYER VARS
local Plr = game:GetService("Players").LocalPlayer
local Hum = Plr.Character:WaitForChild("Humanoid")
local PlayerModule = require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"))
local Controls = PlayerModule:GetControls()
local Mursm = Plr.Character.UpperTorso:WaitForChild("SwordTorso")

--SERVICES
local RS = game:GetService("ReplicatedStorage")
local Debris = game:GetService('Debris')

--REPLICATED STORAGE 
local SF = RS.Scripts 

local AC = SF.Animate:Clone() --Animate Script

--Events
local EvF = RS.Events --Events Folder
local ShEqM = EvF:WaitForChild("ShiftEquip") --Shift Equip Murasama
local BackToScadbard = EvF:WaitForChild("BackToScadbard")
local WeldToHand = EvF:WaitForChild("WeldToHand")
local WeldToLeft = EvF:WaitForChild("WeldToLeft")
local WeldToRight = EvF:WaitForChild("WeldToRight")
--

--CHANGING ANIMATIONS
local Animate =  Plr.Character:WaitForChild("Animate")
Animate:Destroy()

AC.Parent = Plr.Character
wait(1)
AC.Disabled = false
--CHANGING ANIMATIONS ENDS

--Bo0leans & Values
local LSH = false
local MEquiped = false
local SwordInScad = true
local SlashAllowed = true
local ClientCD = false
local ccdHolding = false --client cd holding
local RightHolding = false
local Combo = 0
local WCount = 0
local ComboReseter = 0
local DoubleWReseter = tick()
local WaitTime = 0.09
local Charge = 0

local UIS = game:GetService("UserInputService")

--Animations
local AnimsFolder = script:WaitForChild("Animations")

local ShiftAnim = AnimsFolder:WaitForChild('ShiftAnim')
local SAT = Hum:LoadAnimation(ShiftAnim)
SAT:AdjustSpeed(9)

local ShiftHit = AnimsFolder:WaitForChild('ShiftHit')
local SHT = Hum:LoadAnimation(ShiftHit)
SHT.Priority = Enum.AnimationPriority.Action4

local SStanding = AnimsFolder:WaitForChild("StartStanding")

local IdleMA = AnimsFolder:WaitForChild("IdleM")

local AnimMW = AnimsFolder:WaitForChild("WalkMurasama")

local AnimSAW = AnimsFolder:WaitForChild("StartAfterWalk")

local AnimBS1 = AnimsFolder:WaitForChild("BackAfterS1") 

local AnimSa2W = AnimsFolder:WaitForChild("StandAfterW")

local BackToScad = AnimsFolder:WaitForChild("BackToScad")
local ScadBackTrack = Hum:LoadAnimation(BackToScad)
ScadBackTrack.Priority = Enum.AnimationPriority.Action3

local SlashOne = AnimsFolder:WaitForChild('Slash1')
local FirstSA = Hum:LoadAnimation(SlashOne) --First slash anim
FirstSA.Priority = Enum.AnimationPriority.Action4

local SlashTwo = AnimsFolder:WaitForChild("Slash2")
local SecondSA = Hum:LoadAnimation(SlashTwo)
SecondSA.Priority = Enum.AnimationPriority.Action3

local SlashThree = AnimsFolder:WaitForChild("Slash3")
local ThirdSA = Hum:LoadAnimation(SlashThree)
ThirdSA.Priority = Enum.AnimationPriority.Action3

local SlashFour = AnimsFolder:WaitForChild("Slash4")
local FourSA = Hum:LoadAnimation(SlashFour)
FourSA.Priority = Enum.AnimationPriority.Action3

local AnimDW = AnimsFolder:WaitForChild("DWAnim")
local DoubleWAnim = Hum:LoadAnimation(AnimDW)
DoubleWAnim.Priority = Enum.AnimationPriority.Action3

local AnimHDW = AnimsFolder:WaitForChild("DWHitAnim")
local DWHitAnim = Hum:LoadAnimation(AnimHDW)
DWHitAnim.Priority = Enum.AnimationPriority.Action4

local AnimCharge = AnimsFolder:WaitForChild("Charge")
local ChargeAnim = Hum:LoadAnimation(AnimCharge)
ChargeAnim.Priority = Enum.AnimationPriority.Action2

local AnimCMove = AnimsFolder:WaitForChild("ChargeMove")
local ChargeMoveAnim = Hum:LoadAnimation(AnimCMove)
ChargeMoveAnim.Priority = Enum.AnimationPriority.Action3

local AnimCHit = AnimsFolder:WaitForChild("ChargeHit")
local ChargeHit = Hum:LoadAnimation(AnimCHit)
ChargeHit.Priority = Enum.AnimationPriority.Action3

--Sounds
local SlashSound = script:WaitForChild("SlashSound")
local SlashS2 = script:WaitForChild("SlashSound2")
local Exhale = script:WaitForChild("Exhale")

local AnimsMurasama = {
	IdleMurasama = Hum:LoadAnimation(IdleMA),
	StartIdle = Hum:LoadAnimation(SStanding),
	MurasamaWalk = Hum:LoadAnimation(AnimMW),
	StartAfterWalk = Hum:LoadAnimation(AnimSAW),
	BackSlash1 = Hum:LoadAnimation(AnimBS1),
	StandAfter2W = Hum:LoadAnimation(AnimSa2W)
}

AnimsMurasama.MurasamaWalk.Priority = Enum.AnimationPriority.Action2
AnimsMurasama.MurasamaWalk:AdjustSpeed(20)

AnimsMurasama.StandAfter2W.Priority = Enum.AnimationPriority.Action3

local function stopEA() --Stop equip animations
	for i, animation in pairs(AnimsMurasama) do 
		animation:Stop()
	end
end

local function CD(Time)
	wait(Time)
	ClientCD = false
end

local function CreateVelocity()
	local BodyVelocity = Instance.new("BodyVelocity", Plr.Character.HumanoidRootPart)
	BodyVelocity.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
	BodyVelocity.Velocity = Plr.Character.HumanoidRootPart.CFrame.LookVector * 100
	
	return BodyVelocity
end

local SPD = 0
Hum.Running:Connect(function(speed)
	SPD = speed
	if speed <= 0 and LSH then
		stopEA()
		Hum.WalkSpeed = 20
		
		SAT:Stop() --Shift Animation Track
	end
	
	if speed <= 0.5 and MEquiped  then
		stopEA()
		
		AnimsMurasama.StartAfterWalk:Play()
		AnimsMurasama.StartAfterWalk.Stopped:Wait()
		AnimsMurasama.IdleMurasama:Play()
	elseif speed >= 1 and MEquiped then
		stopEA()
		
		AnimsMurasama.MurasamaWalk:Play()
	end 
end)


local function HitNBack()
	coroutine.wrap(function()
		Controls:Disable()
		local BodyVelocity = Instance.new("BodyVelocity", Plr.Character.HumanoidRootPart)
		BodyVelocity.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
		BodyVelocity.Velocity = Plr.Character.HumanoidRootPart.CFrame.LookVector * 30

		Debris:AddItem(BodyVelocity, .2)
		wait(.5)
		Controls:Enable()
	end)() 
	--AnimsMurasama.StartIdle.Stopped:Wait()
	--if SPD <= 0 and MEquiped then
	--	AnimsMurasama.IdleMurasama:Play()
	--end
end

UIS.InputBegan:Connect(function(Input, InChat)
	if InChat then return end
	if Input.KeyCode == Enum.KeyCode.LeftShift then
		
		if SPD >= 1 then
			LSH = true
			Hum.WalkSpeed = 31
			SAT:Play()
			if MEquiped == true and not ScadBackTrack.IsPlaying then
				MEquiped = false
				stopEA()
				ScadBackTrack:Play()
				delay(1, function()
					BackToScadbard:FireServer(Mursm)		
				end)
				ScadBackTrack.Stopped:Wait()
				SwordInScad = true
			end
		else
			print("bb")
		end
	end
	
	if Input.UserInputType == Enum.UserInputType.MouseButton1 then
		if LSH and SPD >= 5 and SwordInScad then
			ShEqM:FireServer(Mursm, MEquiped)
			SwordInScad = false
			SlashAllowed = false

			SAT:Stop()

			Controls:Disable()

			SHT:Play()
			MEquiped = true

			wait(.4)
			local BodyVelocity = CreateVelocity()
			
				Debris:AddItem(BodyVelocity, .2)
			SHT.Stopped:Wait()
			SlashAllowed = true
			
			AnimsMurasama.StartIdle:Play()
			Controls:Enable()
			Combo = 1 
			ComboReseter = tick()
			AnimsMurasama.StartIdle.Stopped:Wait()
			if SPD <= 0 and MEquiped then
				AnimsMurasama.IdleMurasama:Play()
			end
		elseif not LSH or SPD <= 0 and not ScadBackTrack.IsPlaying then
			if (tick() - ComboReseter) > 1 then
				Combo = 0
			end
			ComboReseter = tick()
			if not MEquiped then
				MEquiped = true
				WeldToHand:FireServer(Mursm)
				SwordInScad = false
			end	
			
			if ClientCD == false and SHT.IsPlaying ~= true and SlashAllowed then
				stopEA()
				if Combo == 0 then
					ClientCD = true
					ScadBackTrack:Stop()
					FirstSA:Play()
					Combo += 1
					HitNBack()
					--SlashSound:Play()
					--SlashS2:Play()
					Exhale:Play()
					FirstSA.Stopped:Wait()
					AnimsMurasama.BackSlash1:Play()
					ClientCD = false
					print("CD restored!")
				elseif Combo == 1 then
					ClientCD = true
					FirstSA:Stop()
					stopEA()
					SecondSA:Play()
					Combo += 1
					HitNBack()
					SlashS2:Play()
					Exhale:Play()
					SecondSA.Stopped:Wait()
					--AnimsMurasama.StartIdle:Play()
					ClientCD = false
					print("CD restored!")
				elseif Combo == 2 then
					ClientCD = true
					SecondSA:Stop()
					stopEA()
					ThirdSA:Play()
					Combo += 1
					HitNBack()
					SlashS2:Play()
					ThirdSA.Stopped:Wait()
					AnimsMurasama.StartIdle:Play()
					wait(WaitTime)
					ClientCD = false
					print("CD restored!")
				elseif Combo == 3 then
					ClientCD = true
					ThirdSA:Stop()
					stopEA()
					FourSA:Play()
					WeldToLeft:FireServer(Mursm)
					Combo = 0 
					HitNBack()
					SlashSound:Play()
					FourSA.Stopped:Wait()
					WeldToRight:FireServer(Mursm)
					AnimsMurasama.StartIdle:Play()
					wait(1)
					ClientCD = false
				end	
			end

			--if Combo < 3 then
			--	print("Combo < 3")
			--	ClientCD = true
			--	CD(WaitTime)
			--elseif Combo == 3 then
			--	ClientCD = true
			--	CD(3)
			--end
		end
	end
	
	if Input.UserInputType == Enum.UserInputType.MouseButton2 then
		RightHolding = true
		ChargeAnim:Play()
		if MEquiped then
			BackToScadbard:FireServer(Mursm)
			stopEA()	
			MEquiped = false
			stopEA()	
		end
		
		if WCount > 1 then --Это быстрый выпад 
			RightHolding = false
			ChargeAnim:Stop()
			SlashAllowed = false
			if not MEquiped then
				MEquiped = true
				WeldToHand:FireServer(Mursm)
				SwordInScad = false
			end	
			print("Dobule W")
			DoubleWAnim:Play()
			DoubleWAnim:GetMarkerReachedSignal("AddVelocity"):Connect(function()
				local BodyVelocity = CreateVelocity()

				delay(.2, function()
					BodyVelocity:Destroy()
					DoubleWAnim:Stop()
					DWHitAnim:Play()
					WCount = 0
					DWHitAnim.Stopped:Wait()
					AnimsMurasama.StandAfter2W:Play()
					SlashAllowed = true
				end)
			end)
		end
		
		if ccdHolding == false then
			while RightHolding do --Это понятно
				print("Holding...")
				Charge += .5
				if  Charge == 1.5 then
					RightHolding = false
					Charge = 0	
					ChargeMoveAnim:Play()
					local Velocity = CreateVelocity()
					delay(.4, function()
						Velocity:Destroy()
						ChargeMoveAnim:Stop()
						ChargeHit:Play()
						--ChargeHit:GetMarkerReachedSignal("AddSword"):Connect(function()
						ShEqM:FireServer(Mursm, MEquiped)
						MEquiped = true
						--end)
					end)
				end
				wait(.5)
			end
		end			
		end
	
	--if Input.KeyCode == Enum.KeyCode.Space then
	--	print("Space	")
	--	stopEA()
	--end
	
	if Input.KeyCode == Enum.KeyCode.W then
		if tick() - DoubleWReseter < 2 then
			print("True")
			WCount += 1 
			DoubleWReseter = tick()
		else
			print("Reset")
			WCount = 0
			DoubleWReseter = tick()
		end
	end
	
end)

UIS.InputEnded:Connect(function(Input, InChat)
	if InChat then return end
	if Input.KeyCode == Enum.KeyCode.LeftShift then
		LSH = false
		Hum.WalkSpeed = 20
		SAT:Stop()
	end
	
	if Input.UserInputType == Enum.UserInputType.MouseButton2 then
		ccdHolding = true
		Charge = 0
		RightHolding = false
		ChargeAnim:Stop()
		wait(2)
		ccdHolding = false
	end
end)
