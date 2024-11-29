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

local function Notify(Text, Sound, Color, Fonts) --text function, sounds: tp, buzz, Gong, HeatDepleted
    local Text1 = string.upper(Text)
    if Sound then
        pgui.Notify:Fire(Text, Sound)
    else
        pgui.Notify:Fire(Text)
    end
    if Color then
        for i, v in pairs(pgui.NotifyUI.Awards:GetChildren()) do
            if v.Name == "XPEx" and v.Text == Text1 then
                v.Text = Text
                v.TextColor3 = Color
                if Fonts then
                    v.Font = Enum.Font[Fonts]
                end
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
local HeatActionCD = false
char.ChildAdded:Connect(
    function(child)
        if child.Name == "Heated" and child:WaitForChild("Heating", 0.5).Value ~= character then
            local isThrowing = child:WaitForChild("Throwing", 0.5)
            if not isThrowing then
                if main.HeatMove.TextLabel.Text ~= "Ultimate Essence " then
                    receivedsound = GetRandom(Voice.HeatAction)
		    if main.HeatMove.TextLabel.Text ~= "Essence of Terror" then						
		    	repeat task.wait() until not doingHact()
		    end
                    playSound(receivedsound)
                    print(receivedsound)
                end
            end
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
RPS.Moves.RushTaunt.Sound.Value = "FakeLaugh"
RPS.Moves.GoonTaunt.Sound.Value = "FakeLaugh"
status.Taunting.Changed:Connect(
    function()
        if status.Taunting.Value == true and status.CurrentMove.Value.Name ~= "BeastTaunt" then
            receivedsound = GetRandom(Voice.Taunt)
            playSound(receivedsound)
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
Notify("Voice Mod loaded", nil, Color3.fromRGB(255, 255, 255), "RobotoMono")
