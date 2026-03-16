local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer

function tweenTo(targetCFrame)
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    
    local distance = (root.Position - targetCFrame.p).Magnitude
    local speed = 150 -- Adjust this; too fast = kick
    local info = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
    
    local tween = TweenService:Create(root, info, {CFrame = targetCFrame})
    tween:Play()
    return tween
end
_G.AutoFarm = true -- Global variable to toggle the farm

spawn(function()
    while _G.AutoFarm do
        task.wait(0.1)
        -- 1. Find the nearest enemy
        for i, v in pairs(game.Workspace.Enemies:GetChildren()) do
            if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                -- 2. Fly to them (Tween)
                local farmTween = tweenTo(v.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)) -- Stay 10 studs above
                farmTween.Completed:Wait()
                
                -- 3. Kill them (Simple Click)
                local tool = player.Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end
        end
    end
end)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "My 2026 Blox Hub",
   LoadingTitle = "Nitro V15 Performance Mode",
})

local MainTab = Window:CreateTab("Auto Farm")

MainTab:CreateToggle({
   Name = "Start Level Farm",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
   end,
})
