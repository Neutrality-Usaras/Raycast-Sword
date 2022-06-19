--PLAYER VARS
local Plr = game:GetService("Players").LocalPlayer
local Hum = Plr.Character:WaitForChild("Humanoid")
local Controls = require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule")):GetControls()

--Storages
local replicatedStorage = game:GetService("ReplicatedStorage")

--SERVICES
local userInput = game:GetService("UserInputService")
local Debris = game:GetService('Debris')

--REPLICATED STORAGE 
local scriptsFolder = replicatedStorage.Scripts 

local animateScript = scriptsFolder.Animate:Clone() --Animate Script

--Events
local EvF = replicatedStorage.Events --Events Folder
local shiftEquipMurasama = EvF:WaitForChild("ShiftEquip") --Shift Equip Murasama
local BackToScadbard = EvF:WaitForChild("BackToScadbard")
local WeldToHand = EvF:WaitForChild("WeldToHand")
local WeldToLeft = EvF:WaitForChild("WeldToLeft")
local WeldToRight = EvF:WaitForChild("WeldToRight")
--

--CHANGING ANIMATIONS
local Animate =  Plr.Character:WaitForChild("Animate") 
Animate:Destroy()

animateScript.Parent = Plr.Character
wait(1)
animateScript.Disabled = false
--CHANGING ANIMATIONS ENDS

--Booleans
local LSH = false --Left shift Holded
local MEquiped = false --Murasama Equiped
local SlashAllowed = true
local hitCD = false
local holdingCD = false 
local RightHolding = false

--Numbers
local Combo = 0 --Number that using to count combo (How much player click on mouse)
local WCount = 0 --Number that using to count Ws (How much player click on  keyboard W button)
local ComboReseter = 0 --tick() for reset combo when neccessary 
local Charge = 0 --Number that using to charge right mouse 
local SPD = 0 --Number that using to track player speed 

--Other values 
local DoubleWReseter = tick()

--Animations & Animation functions
local AnimsFolder = script:WaitForChild("Animations")

local function createAnimation(animation, animationPriority) 
	local quickAnimation = AnimsFolder:WaitForChild(animation)
	local animationLoad = Hum:LoadAnimation(quickAnimation)
	animationLoad.Priority = Enum.AnimationPriority[animationPriority]
	
	return animationLoad
end

local shiftAnimation = createAnimation('ShiftAnim', 'Action')
local shiftHitAnimation = createAnimation('ShiftHit', 'Action2')

local startPosing = createAnimation('StartStanding', 'Movement')
local murasamaIdle = createAnimation('IdleM', 'Idle')
local walkMurasama = createAnimation('WalkMurasama', 'Movement')
local posingAfterWalk = createAnimation('StartAfterWalk', 'Movement')
local posingAfterSlashOne = createAnimation('BackAfterS1', 'Movement')
local posingAfter2W = createAnimation('StandAfterW', 'Movement')

local backToScadA = createAnimation('BackToScad', 'Action2')

local Slash1 = createAnimation('Slash1', 'Action')
local Slash2 = createAnimation('Slash2', 'Action')
local Slash3 = createAnimation('Slash3', 'Action')
local Slash4 = createAnimation('Slash4', 'Action')

local doubleWmove = createAnimation('DWAnim', 'Action2')
local doubleWhit = createAnimation('DWHitAnim', 'Action3')

local charge = createAnimation('Charge', 'Action')
local moveCharge = createAnimation('ChargeMove', 'Action')
local hitCharge = createAnimation('ChargeHit', 'Action2')


--Sounds
local SlashSound = script:WaitForChild("SlashSound")
local finalSlashSound = script:WaitForChild("SlashSound2")
local Exhale = script:WaitForChild("Exhale")


local AnimsMurasama = {
	[1] = murasamaIdle,
	[2] = startPosing,
	[3] = walkMurasama,
	[4] = posingAfterWalk,
	[5] = posingAfterSlashOne,
	[6] = posingAfter2W
}

local slashes = {
	[0] = Slash1,
	[1] = Slash2,
	[2] = Slash3,
	[3] = Slash4
}

local soundSlashes = {
	[0] = Exhale, 
	[1] = SlashSound,
	[2] = SlashSound,
	[3] = finalSlashSound
}

local posingSlashes = {
	[0] = posingAfterSlashOne,
	[1] = startPosing,
	[2] = startPosing,
	[3] = startPosing
}

local function stopEA() --Stop equip animations
	for i, animation in pairs(AnimsMurasama) do 
		animation:Stop()
	end
end

local function CreateVelocity()
	local BodyVelocity = Instance.new("BodyVelocity", Plr.Character.HumanoidRootPart)
	BodyVelocity.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
	BodyVelocity.Velocity = Plr.Character.HumanoidRootPart.CFrame.LookVector * 100
	
	return BodyVelocity
end

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
end


Hum.Running:Connect(function(speed)
	SPD = speed --Current player speed
	if speed <= 0 and LSH then
		stopEA()
		Hum.WalkSpeed = 20
		
		shiftAnimation:Stop() --Shift Animation Track
	elseif speed <= 0.5 and MEquiped then  --If player stopped or player standing still then this triggers 
		stopEA()

		posingAfterWalk:Play()
		posingAfterWalk.Stopped:Wait()
		murasamaIdle:Play()
	elseif speed >= 1 and MEquiped then --If player walking with murasama
		stopEA()

		walkMurasama:Play()	
	end
end)

userInput.InputBegan:Connect(function(Input, InChat)
	if InChat then return end
	
	if Input.KeyCode == Enum.KeyCode.LeftShift then
		
		if SPD >= 1 then --Run 
			LSH = true
			
			Hum.WalkSpeed = 31
			
			shiftAnimation:Play()
			
			if MEquiped == true and not backToScadA.IsPlaying then --That make sword come back to scabbard
				MEquiped = false
				stopEA()
				backToScadA:Play()
				delay(1, function()
					BackToScadbard:FireServer()		
				end)
				backToScadA.Stopped:Wait()
			end
		else --If player stands still 
			print("Player stand still")
		end
	end
	
	if Input.UserInputType == Enum.UserInputType.MouseButton1 then
		if LSH and SPD >= 5 and not MEquiped then --That condition will work when player runs, holding shift and pressed Mouse1 
			shiftEquipMurasama:FireServer()
			SlashAllowed = false

			shiftAnimation:Stop()

			Controls:Disable()

			shiftHitAnimation:Play()
			MEquiped = true

			wait(.4)
			local BodyVelocity = CreateVelocity()
			
			Debris:AddItem(BodyVelocity, .2)
			shiftHitAnimation.Stopped:Wait()
			SlashAllowed = true
			
			startPosing:Play()
			Controls:Enable()
			Combo = 1 
			ComboReseter = tick()
		elseif not LSH or SPD <= 0 and not backToScadA.IsPlaying then --This triggered when player standing or walking 
			if (tick() - ComboReseter) > 1 then
				Combo = 0
			end
			ComboReseter = tick()
			if not MEquiped then --if Murasama not equiped this triggered
				MEquiped = true
				WeldToHand:FireServer()
			end	
			
			if hitCD == false and shiftHitAnimation.IsPlaying ~= true and SlashAllowed then 
				local currentCombo = Combo
				stopEA()
				hitCD = true
				if Combo == 3 then
					slashes[Combo]:Play()
					soundSlashes[Combo]:Play()	
					
					WeldToLeft:FireServer()
					
					HitNBack() 
					
					slashes[Combo].Stopped:Wait()
					
					WeldToRight:FireServer()
					
					posingAfterSlashOne:Play()
			
					Combo = 0
					wait(1)
					hitCD = false
					return nil
				end
				
				
				slashes[Combo]:Play() --Slash Animation
				soundSlashes[Combo]:Play() --Slash sounds
				HitNBack() --Function which makes velocity and disables player controls (with corountine)
				slashes[Combo].Stopped:Wait()
				Combo += 1
				hitCD = false
				
				posingSlashes[currentCombo]:Play()
			end
		end
	end
	
	if Input.UserInputType == Enum.UserInputType.MouseButton2 then
		
		if WCount > 1 and tick() - DoubleWReseter < 1 then --If player presses W button more that 1 time then this triggered 
			if MEquiped then
				stopEA()	

				BackToScadbard:FireServer()
				MEquiped = false
			end
			
			RightHolding = false
			charge:Stop()
			SlashAllowed = false
			if not MEquiped then
				MEquiped = true
				WeldToHand:FireServer()
			end	
			
			doubleWmove:Play()
			doubleWmove:GetMarkerReachedSignal("AddVelocity"):Connect(function()
				local BodyVelocity = CreateVelocity() --just creates body velocity

				delay(.2, function()
					BodyVelocity:Destroy()
					doubleWmove:Stop()
					doubleWhit:Play()
					WCount = 0
					doubleWhit.Stopped:Wait()
					posingAfter2W:Play()
					SlashAllowed = true
				end)
			end)
		end
		
		if holdingCD == false and SPD == 0 then
			if MEquiped then
				stopEA()	

				BackToScadbard:FireServer()
				MEquiped = false
			end
			
			charge:Play()
			
			RightHolding = true
			
			while RightHolding do  --Holding right mouse
				Charge += .5
				if Charge >= 1.5 then
					RightHolding = false
					Charge = 0	
					moveCharge:Play()
					local Velocity = CreateVelocity()
					delay(.4, function()
						Velocity:Destroy()
						moveCharge:Stop()
						hitCharge:Play()
						shiftEquipMurasama:FireServer()
						MEquiped = true
					end)
				end
				wait(.5)
			end
		end			
	end
	
	if Input.KeyCode == Enum.KeyCode.W then
		if tick() - DoubleWReseter < 1 then
			WCount += 1 
			DoubleWReseter = tick()
		else
			WCount = 0
			DoubleWReseter = tick()
		end
	end
end)



userInput.InputEnded:Connect(function(Input, InChat)
	if InChat then return end
	if Input.KeyCode == Enum.KeyCode.LeftShift then --Stop running
		LSH = false
		Hum.WalkSpeed = 20
		shiftAnimation:Stop()
	end
	
	if Input.UserInputType == Enum.UserInputType.MouseButton2 then
		if RightHolding then
			holdingCD = true
			Charge = 0
			
			charge:Stop()
			RightHolding = false
			wait(2)
			holdingCD = false
		end
	end
end)
