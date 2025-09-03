local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Supprimer ancienne GUI si elle existe
if playerGui:FindFirstChild("MoonUI") then
    playerGui.MoonUI:Destroy()
end

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoonUI"
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 350)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainFrame

-- Tab Buttons Frame
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(0, 120, 1, 0)
tabFrame.Position = UDim2.new(0, 0, 0, 0)
tabFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
tabFrame.BorderSizePixel = 0
tabFrame.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.Padding = UDim.new(0, 10)
tabLayout.FillDirection = Enum.FillDirection.Vertical
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Top
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Parent = tabFrame

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -120, 1, 0)
contentFrame.Position = UDim2.new(0, 120, 0, 0)
contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 15)
contentCorner.Parent = contentFrame

-- Fonction de création de Tabs
local tabs = {}
local selectedTab = nil

local function createTab(name)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 40)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.TextColor3 = Color3.fromRGB(200, 200, 200)
    button.Text = name
    button.Font = Enum.Font.GothamBold
    button.TextSize = 16
    button.AutoButtonColor = false
    button.Parent = tabFrame

    -- Arrondi
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = button

    -- Glow permanent
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Outside
    stroke.Color = Color3.fromRGB(0, 170, 255)
    stroke.Transparency = 1 -- désactivé tant que pas sélectionné
    stroke.Parent = button

    -- Contenu associé
    local tabContent = Instance.new("Frame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.Visible = false
    tabContent.BackgroundTransparency = 1
    tabContent.Parent = contentFrame

    -- Sélection du Tab
    button.MouseButton1Click:Connect(function()
        if selectedTab == button then return end

        -- Désactiver ancien tab
        if selectedTab then
            local oldStroke = selectedTab:FindFirstChildOfClass("UIStroke")
            oldStroke.Transparency = 1
            selectedTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            selectedTab.TextColor3 = Color3.fromRGB(200, 200, 200)
            tabs[selectedTab].Visible = false
        end

        -- Activer nouveau tab
        selectedTab = button
        stroke.Transparency = 0 -- glow visible
        button.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabs[button].Visible = true
    end)

    tabs[button] = tabContent
    return tabContent
end

-- Exemple de contenu
local homeTab = createTab("Home")
local label1 = Instance.new("TextLabel")
label1.Size = UDim2.new(1, -20, 0, 40)
label1.Position = UDim2.new(0, 10, 0, 10)
label1.BackgroundTransparency = 1
label1.Text = "Bienvenue sur MoonUI"
label1.TextColor3 = Color3.fromRGB(255, 255, 255)
label1.Font = Enum.Font.GothamBold
label1.TextSize = 18
label1.TextXAlignment = Enum.TextXAlignment.Left
label1.Parent = homeTab

local settingsTab = createTab("Settings")
local label2 = Instance.new("TextLabel")
label2.Size = UDim2.new(1, -20, 0, 40)
label2.Position = UDim2.new(0, 10, 0, 10)
label2.BackgroundTransparency = 1
label2.Text = "Réglages à venir..."
label2.TextColor3 = Color3.fromRGB(255, 255, 255)
label2.Font = Enum.Font.GothamBold
label2.TextSize = 18
label2.TextXAlignment = Enum.TextXAlignment.Left
label2.Parent = settingsTab

-- Sélection par défaut
task.wait()
homeTab.Visible = true
selectedTab = tabFrame:FindFirstChildOfClass("TextButton")
local defaultStroke = selectedTab:FindFirstChildOfClass("UIStroke")
defaultStroke.Transparency = 0
selectedTab.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
selectedTab.TextColor3 = Color3.fromRGB(255, 255, 255)
