-- rlly easy example for MoonUI

local MoonUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/AGTVoff/MoonUI/refs/heads/main/MoonUI.lua"))()
local Window = MoonUI:CreateWindow("Test Hub")

-- this is Tabs
local TabAIM = Window:CreateTab("AIM")
local TabVisual = Window:CreateTab("VISUAL")

-- variables for toggle
local AimbotToggle = false
local WallhackToggle = false

-- toggles creation
Window:CreateToggle(TabAIM, "Aimbot", false, function(state)
    AimbotToggle = state
end)

Window:CreateToggle(TabVisual, "Wallhack", false, function(state)
    WallhackToggle = state
end)

-- RenderStep pour aimbot et wallhack
game:GetService("RunService").RenderStepped:Connect(function()
    if AimbotToggle then
        local LocalPlayer = game.Players.LocalPlayer
        local closest
        local minDist = math.huge
        for i,v in pairs(game.Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (v.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = v
                end
            end
        end
        if closest and closest.Character and closest.Character:FindFirstChild("HumanoidRootPart") then
            game.Workspace.CurrentCamera.CFrame = CFrame.new(game.Workspace.CurrentCamera.CFrame.Position, closest.Character.HumanoidRootPart.Position)
        end
    end

    if WallhackToggle then
        for i,v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local part = v.Character.HumanoidRootPart
                if not part:FindFirstChild("Highlight") then
                    local hl = Instance.new("Highlight")
                    hl.Adornee = part
                    hl.FillColor = Color3.fromRGB(0,255,255)
                    hl.FillTransparency = 0.5
                    hl.OutlineTransparency = 1
                    hl.Parent = part
                end
            end
        end
    end
end)

