--PLAYER VARS
local Plr = game:GetService("Players").LocalPlayer
local Chrctr = Plr.Character
local Hum = Chrctr:WaitForChild("Humanoid")
local Controls = require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule")):GetControls()

--CHANGING ANIMATIONS
local Animate =  Chrctr:WaitForChild("Animate") 
Animate:Destroy()

--Storages
local replicatedStorage = game:GetService("ReplicatedStorage")

--SERVICES
local userInput = game:GetService("UserInputService")
local Debris = game:GetService('Debris')

--REPLICATED STORAGE 
local scriptsFolder = replicatedStorage.Scripts 

local animateScript = scriptsFolder.Animate:Clone() --Animate Script

--Events
local eventsFolder = replicatedStorage.Events --Events Folder

local remote = eventsFolder:WaitForChild('remote')

--Booleans
local LSH = false --Left shift Holded
local MEquiped = false --Murasama Equiped
local SlashAllowed = true
local hitCD = false
local holdingCD = false 
local shiftCD = false
local rmouseCD = false
local RightHolding = false
local globalLock = false

--Numbers
local Combo = 0 --Number that using to count combo (How much player click on mouse)
local WCount = 0 --Number that using to count Ws (How much player click on  keyboard W button)
local ComboReseter = 0 --tick() for reset combo when neccessary 
local Charge = 0 --Number that using to charge right mouse 
local SPD = 0 --Number that using to track player speed 

local regularWalkSpeed = 20
local fastWalkSpeed = 31

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

local backToScadA = createAnimation('BackToScad', 'Action2')

local doubleWmove = createAnimation('DWAnim', 'Action2')
local doubleWhit = createAnimation('DWHitAnim', 'Action3')

local charge = createAnimation('Charge', 'Action')
local moveCharge = createAnimation('ChargeMove', 'Action')
local hitCharge = createAnimation('ChargeHit', 'Action2')	


local AnimsMurasama = {
	['murasamaIdle'] = createAnimation('IdleM', 'Idle'),
	['startPosing'] = createAnimation('StartStanding', 'Movement'),
	['walkMurasama'] = createAnimation('WalkMurasama', 'Movement'),
	['posingAfterWalk'] = createAnimation('StartAfterWalk', 'Movement'),
	['posingAfterSlashOne'] = createAnimation('BackAfterS1', 'Movement'),
	['posingAfter2W'] = createAnimation('StandAfterW', 'Movement')
}

local slashes = {[0] = createAnimation('Slash1', 'Action'), [1] = createAnimation('Slash2', 'Action'), [2] = createAnimation('Slash3', 'Action'),[3] = createAnimation('Slash4', 'Action')}

local soundSlashes = {[0] = script:WaitForChild("Exhale"), [1] = script:WaitForChild("SlashSound"),[2] = script:WaitForChild("SlashSound"),[3] = script:WaitForChild("SlashSound2")}

local posingSlashes = {[0] = AnimsMurasama.posingAfterSlashOne,[1] = AnimsMurasama.startPosing,[2] = AnimsMurasama.startPosing,[3] = AnimsMurasama.startPosing}

local function stopEA() --Stop equip animations
	for i, animation in pairs(AnimsMurasama) do 
		animation:Stop()
	end
end

local function CreateVelocity(acceleration)
	local BodyVelocity = Instance.new("BodyVelocity", Chrctr.HumanoidRootPart)
	BodyVelocity.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
	BodyVelocity.Velocity = Chrctr.HumanoidRootPart.CFrame.LookVector * acceleration
	
	return BodyVelocity
end

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

--//A little hitboxie
local hitBox = replicatedStorage.Models:WaitForChild('hitBox'):Clone()
hitBox.Parent = Chrctr.HumanoidRootPart

local Weld = WeldCreator({Chrctr.HumanoidRootPart, 'Weld', Chrctr.HumanoidRootPart, hitBox, CFrame.new(0, 0, 0), CFrame.new(0, 0, 2.8)})

local hitBoxValue = hitBox.Value.Value

local function HitNBack()
	coroutine.wrap(function()
		Controls:Disable()
		local BodyVelocity = CreateVelocity(30)

		Debris:AddItem(BodyVelocity, .2)
		wait(.5)
		Controls:Enable()
	end)()
end


Hum.Running:Connect(function(speed)
	SPD = speed --Current player speed
	if speed <= 0 and LSH then
		stopEA()
		Hum.WalkSpeed = regularWalkSpeed
		
		shiftAnimation:Stop() --Shift Animation Track
	elseif speed <= 0.5 and MEquiped then  --If player stopped or player standing still then this triggers 
		stopEA()

		AnimsMurasama.posingAfterWalk:Play()
		AnimsMurasama.posingAfterWalk.Stopped:Wait()
		AnimsMurasama.murasamaIdle:Play()
	elseif speed >= 1 and MEquiped then --If player walking with murasama
		stopEA()
		doubleWhit:Stop()
		AnimsMurasama.walkMurasama:Play()	
	end
end)

local leftShift = Enum.KeyCode.LeftShift

local mouseButton1 = Enum.UserInputType.MouseButton1
local mouseButton2 = Enum.UserInputType.MouseButton2



local function hitBoxTouched(part, bodyVelocity)
	if part.Parent:FindFirstChild('Humanoid') and hitBox.CanTouch then
		hitBox.CanTouch = false
		remote:FireServer('CreateHitbox', {part, 50})
		
		if hitBoxValue == 'ShiftEquip' then
			bodyVelocity:Destroy()
		elseif hitBoxValue == 'WHit' then
			bodyVelocity:Destroy()
			
			doubleWmove:Stop()
			doubleWhit:Play()
			WCount = 0
			doubleWhit.Stopped:Wait()
			AnimsMurasama.posingAfter2W:Play()
			globalLock = false
		elseif hitBoxValue == 'rightHold' then
			bodyVelocity:Destroy()
			moveCharge:Stop()
			hitCharge:Play()
			remote:FireServer('ShiftEquip')
			Controls:Enable()
			globalLock = false
			MEquiped = true
		end
	end
end

local func 



local function AddVelocity()
	print('add velocity')

	hitBox.CanTouch = true				
	hitBoxValue = 'WHit'
	local BodyVelocity = CreateVelocity(100) --just creates body velocity				

	hitBox.Touched:Connect(function(part)
		hitBoxTouched(part, BodyVelocity)
	end)

	wait(.5)
	hitBox.CanTouch = false
	BodyVelocity:Destroy()
	doubleWmove:Stop()
	WCount = 0
	globalLock = false
	func:Disconnect()
end

userInput.InputBegan:Connect(function(Input, InChat)
	if InChat then return end
	if globalLock then return end
	
	if Input.KeyCode == leftShift then
		
		if SPD >= 1 then --Run 
			LSH = true
			
			Hum.WalkSpeed = fastWalkSpeed
			
			shiftAnimation:Play()
			
			if MEquiped == true and not backToScadA.IsPlaying then --That make sword come back to scabbard
				globalLock = true
				
				MEquiped = false
				stopEA()
				backToScadA:Play()
				delay(1, function()
					remote:FireServer('BackToScabbard')		
				end)
				backToScadA.Stopped:Wait()
				globalLock = false
			end
		else --If player stands still 
			print("Player stand still")
		end
	end
	
	if Input.UserInputType == mouseButton1 then
		if (LSH and SPD >= 5 and not MEquiped) and not shiftCD then --That condition will work when player runs, holding shift and pressed Mouse1 
			shiftCD = true
			remote:FireServer('ShiftEquip')
			SlashAllowed = false

			shiftAnimation:Stop()

			Controls:Disable()

			shiftHitAnimation:Play()
			MEquiped = true
			
			wait(.4)
			
			hitBox.CanTouch = true			
			hitBoxValue = 'ShiftEquip'
			local BodyVelocity = CreateVelocity(100)
			
			hitBox.Touched:Connect(function(part)
				hitBoxTouched(part, BodyVelocity)
			end)
			
			delay(.2, function()
				hitBox.CanTouch = false		
				BodyVelocity:Destroy()			
			end)
			
			shiftHitAnimation.Stopped:Wait()
			SlashAllowed = true
			
			AnimsMurasama.startPosing:Play()
			Controls:Enable()
			Combo = 1 
			ComboReseter = tick()
			wait(5)
			shiftCD = false
		elseif not LSH or SPD <= 0 and not backToScadA.IsPlaying then --This triggered when player standing or walking 
			if (tick() - ComboReseter) > 1 then
				Combo = 0
			end
			ComboReseter = tick()
			if not MEquiped then --if Murasama not equiped this triggered
				MEquiped = true
				remote:FireServer('WeldToArm')
			end	
			
			if hitCD == false and shiftHitAnimation.IsPlaying ~= true and SlashAllowed then 
				local currentCombo = Combo
				stopEA()
				hitCD = true
				if Combo == 3 then
					globalLock = true
					slashes[Combo]:Play()
					soundSlashes[Combo]:Play()	
					
					remote:FireServer('ArmWeld', {Chrctr:WaitForChild('LeftHand'), Chrctr:WaitForChild('RightHand'), 'leftBladeMotor'})
					
					HitNBack() 
					remote:FireServer('CreateRay')
					slashes[Combo].Stopped:Wait()
					
					remote:FireServer('ArmWeld',{Chrctr:WaitForChild('RightHand'), Chrctr:WaitForChild('LeftHand'), 'rightHandMotor'})
					
					AnimsMurasama.posingAfterSlashOne:Play()
					globalLock = false
			
					Combo = 0
					wait(1)
					hitCD = false
					return nil
				end
				
				
				slashes[Combo]:Play() --Slash Animation
				soundSlashes[Combo]:Play() --Slash sounds
				HitNBack() --Function which makes velocity and disables player controls (with corountine)
				remote:FireServer('CreateRay')
				slashes[Combo].Stopped:Wait()
				Combo += 1
				hitCD = false
				
				posingSlashes[currentCombo]:Play()
			end
		end
	end
	
	if Input.UserInputType == mouseButton2 then

		
		if WCount > 1 and tick() - DoubleWReseter < 1 and not rmouseCD then --If player presses W button more that 1 time then this triggered 
			rmouseCD = true
			globalLock = true
			WCount = 0
			

			if not MEquiped then
				remote:FireServer('WeldToArm')

				MEquiped = true
			end
			
			
			doubleWmove:Play()
			
			func = doubleWmove:GetMarkerReachedSignal("AddVelocity"):Connect(AddVelocity)
			wait(5)
			rmouseCD = false
		end
		
		if holdingCD == false and SPD == 0 and not globalLock then
			if MEquiped then
				doubleWhit:Stop()
				stopEA()	
				print('equiped')
				
				remote:FireServer('BackToScabbard')		
				MEquiped = false
				
				stopEA()	
			end
			
			Controls:Disable()
			
			charge:Play()
			
			RightHolding = true
			
			while RightHolding do  --Holding right mouse
				Charge += .5
				if Charge >= 1.5 then
					RightHolding = false
					globalLock = true
					Charge = 0	
					moveCharge:Play()
					
					hitBox.CanTouch = true				
					hitBoxValue = 'rightHold'			
					
					local Velocity = CreateVelocity(100)
					
					hitBox.Touched:Connect(function(part)
						hitBoxTouched(part, Velocity)
					end)
					
					delay(.4, function()
						Velocity:Destroy()
						moveCharge:Stop()
						
						Controls:Enable()
						globalLock = false
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
	if Input.KeyCode == leftShift then --Stop running
		LSH = false
		Hum.WalkSpeed = regularWalkSpeed
		shiftAnimation:Stop()
	end
	
	if Input.UserInputType == mouseButton2 then
		if RightHolding then
			Controls:Enable()
			holdingCD = true
			Charge = 0
			
			charge:Stop()
			RightHolding = false
			wait(2)
			holdingCD = false
		end
	end
end)
