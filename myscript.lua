-- 1. SET DEFAULTS (Stop the auto-start glitch)
_G.AutoFarm = false 
_G.AutoClick = false

-- 2. LOAD UI LIBRARY (Rayfield)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Flashy Hub | Blox Fruits",
   LoadingTitle = "Nitro V15 Performance Mode",
   ConfigurationSaving = { Enabled = false }
})

-- 3. ESSENTIAL SERVICES
local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer

-- 4. MOVEMENT FUNCTION (Tweening)
function tweenTo(targetCFrame)
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    
    local distance = (root.Position - targetCFrame.p).Magnitude
    local speed = 150 -- Safe speed for your Nitro V15 setup
    local info = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
    
    local tween = TweenService:Create(root, info, {CFrame = targetCFrame})
    tween:Play()
    return tween
end

-- 5. CREATING THE UI TABS
local MainTab = Window:CreateTab("Auto Farm")

MainTab:CreateToggle({
   Name = "Start Level Farm",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      _G.AutoClick = Value -- Auto-activates clicking when farming
   end,
})

-- 6. THE "BRAIN" (Farming Loop)
spawn(function()
    while true do
        task.wait(0.1)
        if _G.AutoFarm then
            pcall(function()
                -- Find enemies in the workspace
                for i, v in pairs(game.Workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and _G.AutoFarm then
                        -- Fly to the enemy (Stay slightly above them)
                        local farmTween = tweenTo(v.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
                        
                        -- While near the enemy, keep attacking
                        repeat
                            task.wait(0.1)
                            -- Auto M1 Logic
                            local tool = player.Character:FindFirstChildOfClass("Tool")
                            if tool then 
                                tool:Activate() 
                                -- Remote for Blox Fruits M1 bypass
                                game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("hit", tool.Handle, {})
                            end
                        until not v.Parent or v.Humanoid.Health <= 0 or not _G.AutoFarm
                    end
                end
            end)
        end
    end
end)

-- 7. ANTI-AFK (Stops the 20min kick)
local VirtualUser = game:GetService("VirtualUser")
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

Rayfield:Notify({
   Title = "Flashy Hub Loaded",
   Content = "Ready to farm. Good luck!",
   Duration = 5,
   Image = 4483362458,
})
