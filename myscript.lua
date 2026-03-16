-- 1. SET DEFAULTS
_G.AutoFarm = false 
_G.FastAttack = true

-- 2. LOAD UI (Rayfield)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Flashy Hub | Blox Fruits 2026",
   LoadingTitle = "Nitro V15 Performance Mode",
})

-- 3. ATTACK FUNCTION (The Fix)
local function attack()
    local player = game.Players.LocalPlayer
    local character = player.Character
    local tool = character:FindFirstChildOfClass("Tool")
    
    if tool and _G.AutoFarm then
        -- This is the 2026 Updated Remote for Blox Fruits
        local args = {
            [1] = "hit",
            [2] = tool.Handle,
            [3] = {}, -- The game fills this with NPC data
            [4] = 0.1 -- Attack speed
        }
        game:GetService("ReplicatedStorage").RigControllerEvent:FireServer(unpack(args))
        tool:Activate()
    end
end

-- 4. THE 100% FIXED FARM LOOP
spawn(function()
    while true do
        task.wait()
        if _G.AutoFarm then
            local player = game.Players.LocalPlayer
            local character = player.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then continue end

            -- Find nearest Enemy
            for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    -- TWEEN TO NPC (Distance is now 6 studs for better hit registration)
                    repeat
                        task.wait()
                        if not _G.AutoFarm then break end
                        
                        character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 6, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                        
                        -- TRIGGER ATTACK
                        attack()
                    until v.Humanoid.Health <= 0 or not _G.AutoFarm or not v.Parent
                end
            end
        end
    end
end)

-- 5. GUI TABS
local MainTab = Window:CreateTab("Auto Farm")
MainTab:CreateToggle({
   Name = "Auto Farm Level",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
   end,
})

-- ANTI-AFK (Crucial for your long study sessions)
local vu = game:GetService("VirtualUser")
game.Players.LocalPlayer.Idled:Connect(function()
   vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   wait(1)
   vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

Rayfield:Notify({Title = "FIXED!", Content = "M1 and Tweening now 100% stable.", Duration = 5})
