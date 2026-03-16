-- 1. SETTINGS
_G.AutoFarm = false 
_G.Distance = 15 -- High enough so they can't hit you

-- 2. UI LIBRARY
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Flashy Hub | Stable V4",
   LoadingTitle = "Nitro V15 Optimized",
})

-- 3. THE "STABLE" ATTACK LOGIC
local function attack()
    local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool and _G.AutoFarm then
        -- Updated 2026 Remote bypass for M1
        game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("hit", tool.Handle, {})
        tool:Activate()
    end
end

-- 4. MASTER LOOP (No Shaking Version)
spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                local root = char.HumanoidRootPart
                
                for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        
                        -- STABILIZER: Stops NPC from moving/shaking
                        if v:FindFirstChild("HumanoidRootPart") then
                            v.HumanoidRootPart.CanCollide = false
                            v.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                        end

                        repeat
                            task.wait()
                            if not _G.AutoFarm then break end
                            
                            -- POSITION: 15 studs above (Static, no jitter)
                            root.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, _G.Distance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                            
                            -- HITBOX EXPANDER: Makes the NPC reach your punches
                            v.HumanoidRootPart.Size = Vector3.new(25, 25, 25)
                            v.HumanoidRootPart.Transparency = 0.8 -- See-through red box
                            
                            attack()
                        until v.Humanoid.Health <= 0 or not _G.AutoFarm or not v.Parent
                    end
                end
            end)
        end
    end
end)

-- 5. GUI TABS
local MainTab = Window:CreateTab("Main")
MainTab:CreateToggle({
   Name = "Auto Farm Level",
   CurrentValue = false,
   Callback = function(Value) _G.AutoFarm = Value end,
})

-- ANTI-AFK (Stay online while you study)
game.Players.LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

Rayfield:Notify({Title = "STABLE V4 LOADED", Content = "Screen shaking fixed. M1 Active.", Duration = 5})
