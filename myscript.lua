-- 1. SETTINGS
_G.AutoFarm = false 
_G.Distance = 12 -- High enough so they can't hit you

-- 2. UI LIBRARY
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Flashy Hub | Final V3",
   LoadingTitle = "Nitro V15 Optimized",
})

-- 3. THE "KILL AURA" & ATTACK LOGIC
local function attack()
    local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool and _G.AutoFarm then
        -- Updated 2026 Remote bypass
        game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("hit", tool.Handle, {})
        tool:Activate()
    end
end

-- 4. THE MASTER LOOP
spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        repeat
                            task.wait()
                            if not _G.AutoFarm then break end
                            
                            -- POSITION: Stay 12 studs above for safety
                            char.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, _G.Distance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                            
                            -- BRING MOB (Forces the NPC hitbox into your range)
                            v.HumanoidRootPart.CanCollide = false
                            v.HumanoidRootPart.Size = Vector3.new(10, 10, 10)
                            v.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, -6, 0)
                            
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

-- ANTI-AFK (Stay online while you study Organic Chemistry)
game.Players.LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

Rayfield:Notify({Title = "V3 READY", Content = "High Flight + Hitbox Expander Active", Duration = 5})
