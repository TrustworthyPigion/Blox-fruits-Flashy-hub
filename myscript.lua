-- 1. SETTINGS
_G.AutoFarm = false 
_G.Distance = 15 -- High and safe from NPC hits

-- 2. UI LIBRARY
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Flashy Hub | Ultra Smooth",
   LoadingTitle = "Nitro V15 Optimized",
})

-- 3. THE KILLER LOGIC (Hitbox + Attack)
local function attack()
    local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool and _G.AutoFarm then
        -- This bypasses the 2026 combat check
        game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("hit", tool.Handle, {})
        tool:Activate()
    end
end

-- 4. MASTER FARM LOOP
spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                local root = char.HumanoidRootPart
                
                for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        -- Disables physics for the NPC so they don't fall
                        if v:FindFirstChild("HumanoidRootPart") then
                            v.HumanoidRootPart.CanCollide = false
                            v.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                        end

                        repeat
                            task.wait()
                            if not _G.AutoFarm then break end
                            
                            -- Position you 15 studs ABOVE (No shake)
                            root.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, _G.Distance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                            
                            -- HITBOX EXPANDER (The Fix for M1)
                            -- Makes the enemy "huge" so your punch reaches them from the sky
                            v.HumanoidRootPart.Size = Vector3.new(20, 20, 20)
                            v.HumanoidRootPart.Transparency = 0.8 -- See-through so it looks clean
                            
                            attack()
                        until v.Humanoid.Health <= 0 or not _G.AutoFarm or not v.Parent
                    end
                end
            end)
        end
    end
end)

-- 5. GUI TABS
local MainTab = Window:CreateTab("Auto Farm")
MainTab:CreateToggle({
   Name = "Start Level Farm",
   CurrentValue = false,
   Callback = function(Value) _G.AutoFarm = Value end,
})

-- ANTI-AFK (Stay active for your scholarship/school work)
game.Players.LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

Rayfield:Notify({Title = "ULTRA SMOOTH", Content = "Screen shaking fixed. Hitbox active.", Duration = 5})
