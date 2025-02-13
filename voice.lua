local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local ME = ReplicatedStorage.Events.ME

--// Cache
local RPS = game.ReplicatedStorage
local Voice = RPS.Voices:FindFirstChild(_G.dodconfig.useVoice)
local player = game.Players.LocalPlayer
local character = player.Character
local pgui = player.PlayerGui
local status = player.Status
local plr = game.Players.LocalPlayer
local char = plr.Character
local pgui = plr.PlayerGui
local interf = pgui.Interface
local bt = interf.Battle
local main = bt.Main

local heatMode = Instance.new("BoolValue")
local rage = Instance.new("BoolValue")
heatMode.Value = (status.Heat.Value >= 75) and true or false
rage.Value = status:FindFirstChild("ANGRY") and true or false

local function sendNotification(text, color, stroke, sound)
	local upper = string.upper(text)
	-- Fire the notification event
	if sound then
		pgui["Notify"]:Fire(text, sound)
	else
		pgui["Notify"]:Fire(text)
	end
	-- If color is not provided, default to white
	if not color then
		color = Color3.new(1, 1, 1)
	end

	if not stroke then
		stroke = Color3.new(0, 0, 0)
	end

	-- Listen for when a new child is added to NotifyUI.Awards
	for i, v in ipairs(pgui.NotifyUI.Awards:GetChildren()) do
		if v.Name == "XPEx" and v.Text == upper then
			v.Text = text
			v.TextColor3 = color
			v.TextStrokeColor3 = stroke
			v.Text = text
			if v.Text == "Feel the HEAT!!" then
				v.Font = Enum.Font.PermanentMarker
			end
		end
	end
end
	
local function doingHact()
    return (character:FindFirstChild("Heated") and true or false)
end

local function playSound(sound)
	if char.Head:FindFirstChild("Voice") then
		char.Head.Voice:Destroy()		
	end		
    local soundclone = Instance.new("Sound")
    soundclone.Parent = character.Head
    soundclone.Name = "Voice"
    soundclone.SoundId = sound.Value
    soundclone.Volume = 0.7
    soundclone:Play()
    soundclone.Ended:Connect(
        function()
            game:GetService("Debris"):AddItem(soundclone)
        end
    )
end

local function GetRandom(Instance)
    local children = Instance:GetChildren()
    local random = children[math.random(1, #children)]
    return random
end
local receivedsound

plr.ChildAdded:Connect(
    function(child)
        if child.Name == "InBattle" then
            receivedsound = GetRandom(Voice.BattleStart)
            playSound(receivedsound)
        end
    end
)

status.ChildAdded:Connect(function(c)
	if c.Name == "ANGRY" then
		rage.Value = true
	elseif c.Name == "Grabbed" then
		receivedsound = GetRandom(Voice.Grabbed)
		playSound(receivedsound)
	end
end)

status.ChildRemoved:Connect(function(c)
	if c.Name == "ANGRY" then
		rage.Value = false
	end
end)

status.Heat:GetPropertyChangedSignal("Value"):Connect(function()
	if status.Heat.Value >= 75 then
		heatMode.Value = true
	else
		heatMode.Value = false
	end
end)

heatMode:GetPropertyChangedSignal("Value"):Connect(function()
	if heatMode.Value then
		receivedsound = GetRandom(Voice.HeatMode)
		playSound(receivedsound)
	end
end)

rage:GetPropertyChangedSignal("Value"):Connect(function()
	if rage.Value then
		receivedsound = GetRandom(Voice.Rage)
		playSound(receivedsound)
	end
end)

local HeatActionCD = false
char.ChildAdded:Connect(
    function(child)
        if child.Name == "Heated" and child:WaitForChild("Heating", 0.5).Value ~= character then
            local isThrowing = child:WaitForChild("Throwing", 0.5)
            if not isThrowing then
                if (main.HeatMove.TextLabel.Text ~= "Ultimate Essence " and main.HeatMove.TextLabel.Text ~= "Ultimate Essence '88" and main.HeatMove.TextLabel.Text ~= "Essence of the Dragon God") then
                    receivedsound = GetRandom(Voice.HeatAction)
                else
					if _G.dodconfig.useVoice == "Kiryu" then
	                	receivedsound = Voice.Taunt['taunt2 (2)']
					else
						receivedsound = GetRandom(Voice.Taunt)
					end
				end
			end
		    if main.HeatMove.TextLabel.Text ~= "Essence of Terror" and not (main.HeatMove.TextLabel.Text ~= "Ultimate Essence " or main.HeatMove.TextLabel.Text ~= "Ultimate Essence '88" or main.HeatMove.TextLabel.Text ~= "Essence of the Dragon God") then						
		    	repeat task.wait() until not doingHact()
		    end
            playSound(receivedsound)
            print(receivedsound)
        end
        local HitCD = false
        if child.Name == "Hitstunned" and not character:FindFirstChild("Ragdolled") then
            if HitCD == false then
                HitCD = true
                receivedsound = GetRandom(Voice.Pain)
                playSound(receivedsound)
                delay(
                    2,
                    function()
                        HitCD = false
                    end
                )
            end
        end
        if child.Name == "Ragdolled" then
            receivedsound = GetRandom(Voice.Knockdown)
            playSound(receivedsound)
        end
        if child.Name == "ImaDea" then
            receivedsound = GetRandom(Voice.Death)
            playSound(receivedsound)
        end
        if child.Name == "Stunned" then
            receivedsound = GetRandom(Voice.Stun)
            playSound(receivedsound)
        end
    end
)

character.ChildRemoved:Connect(
    function(child)
        if child.Name == "Ragdolled" then
            wait(0.1)
            if not string.match(status.CurrentMove.Value.Name, "Getup") then
                receivedsound = GetRandom(Voice.Recover)
                playSound(receivedsound)
            end
        end
    end
)

character.HumanoidRootPart.ChildAdded:Connect(
    function(child)
        if child.Name == "KnockOut" or child.Name == "KnockOutRare" then
            child.Volume = 0
        end
    end
)

local EvadeCD = false
status.FFC.CEvading.Changed:Connect(
    function()
        if status.FFC.Evading.Value == true and character:FindFirstChild("BeingHacked") and not EvadeCD then
            EvadeCD = true
            receivedsound = GetRandom(Voice.Dodge)
            playSound(receivedsound)
            delay(
                3,
                function()
                    EvadeCD = false
                end
            )
        end
    end
)
local fakeTauntSound = RPS.Sounds:FindFirstChild("Laugh"):Clone()
fakeTauntSound.Parent = RPS.Sounds
fakeTauntSound.Name = "FakeLaugh"
fakeTauntSound.Volume.Value = 0
RPS.Moves.Taunt.Sound.Value = "FakeLaugh"
RPS.Moves.DragonTaunt.Sound.Value = "FakeLaugh"
RPS.Moves.RushTaunt.Sound.Value = "FakeLaugh"
if Voice:FindFirstChild("Scream") then
	RPS.Moves.BeastTaunt.Sound.Value = "FakeLaugh"
end

status.Taunting.Changed:Connect(
    function()
        if status.Taunting.Value == true then
        	if status.CurrentMove.Value.Name ~= "BeastTaunt" then
	            receivedsound = GetRandom(Voice.Taunt)
	            playSound(receivedsound)
			else
				receivedsound = GetRandom(Voice.Scream)
	            playSound(receivedsound)
			end
        end
    end
)
local LightAttackCD = false
status.CurrentMove.Changed:Connect(
    function()
        if string.match(status.CurrentMove.Value.Name, "Attack") or string.match(status.CurrentMove.Value.Name, "Punch") then
            if LightAttackCD == false then
                LightAttackCD = true
                receivedsound = GetRandom(Voice.LightAttack)
                playSound(receivedsound)
                delay(
                    0.35,
                    function()
                        LightAttackCD = false
                    end
                )
            end
        else
            if
                not string.match(status.CurrentMove.Value.Name, "Taunt") and
                    not string.match(status.CurrentMove.Value.Name, "Grab") and
                    not string.match(status.CurrentMove.Value.Name, "CounterHook")
             then
                receivedsound = GetRandom(Voice.HeavyAttack)
                playSound(receivedsound)
            end
        end
    end
)
sendNotification("VOICE LOADED", Color3.new(1,0,0), Color3.new(0,0,0), "HeatDepleted")
