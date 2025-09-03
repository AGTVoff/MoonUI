-- rlly easy example for MoonUI Dark / Clean

local MoonUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/AGTVoff/MoonUI/refs/heads/main/MoonUI.lua"))()
local Window = MoonUI:CreateWindow("Test Hub")

-- Tabs
local TabAIM = Window:CreateTab("AIM")
local TabVisual = Window:CreateTab("VISUAL")

-- Variables
local AimbotToggle = false
local WallhackToggle = false

-- Toggles
Window:CreateToggle(TabAIM, "Aimbot", false, function(state)
    AimbotToggle = state
end)

Window:CreateToggle(TabVisual, "Wallhack", false, function(state)
    WallhackToggle = state
end)

-- Slider exemple (optionnel)
Window:CreateSlider(TabAIM, "Smoothness", 1, 20, 10, function(value)
    print("Smoothness set to", value)
end)

-- button (I did a speedhack for example)
Window:CreateButton(TabAIM, "Set Speed to 50", function()
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 50
    end
end)

-- RenderStepped pour Aimbot et Wallhack
game:GetService("RunService").RenderStepped:Connect(function()
    local LocalPlayer = game.Players.LocalPlayer
    if AimbotToggle then
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
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
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
