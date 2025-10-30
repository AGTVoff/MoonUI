-- MoonUI Dark / Clean by AGTV (Enhanced)
-- Added RGB Border + Keybind + Selector

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local MoonUI = {}
MoonUI.__index = MoonUI

-- RGB Cycle Function
local function rgbCycle()
    local t = tick() % 5 / 5
    return Color3.fromHSV(t, 1, 1)
end

-- Create Window
function MoonUI:CreateWindow(name)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MoonUI"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
    MainFrame.Size = UDim2.new(0, 420, 0, 320)
    MainFrame.Active = true
    MainFrame.Draggable = true

    -- RGB Outline
    local RGBOutline = Instance.new("UIStroke", MainFrame)
    RGBOutline.Thickness = 2
    RGBOutline.Color = Color3.fromRGB(255, 0, 0)

    game:GetService("RunService").RenderStepped:Connect(function()
        RGBOutline.Color = rgbCycle()
    end)

    local Title = Instance.new("TextLabel")
    Title.Parent = MainFrame
    Title.Text = name or "MoonUI"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextScaled = true

    local TabFolder = Instance.new("Folder")
    TabFolder.Name = "Tabs"
    TabFolder.Parent = MainFrame

    local TabButtons = Instance.new("Frame")
    TabButtons.Parent = MainFrame
    TabButtons.Size = UDim2.new(0, 100, 1, -40)
    TabButtons.Position = UDim2.new(0, 0, 0, 40)
    TabButtons.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Parent = MainFrame
    ContentFrame.Position = UDim2.new(0, 100, 0, 40)
    ContentFrame.Size = UDim2.new(1, -100, 1, -40)
    ContentFrame.BackgroundTransparency = 1

    local UIList = Instance.new("UIListLayout", TabButtons)
    UIList.Padding = UDim.new(0, 4)
    UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIList.VerticalAlignment = Enum.VerticalAlignment.Top

    local WindowData = {Tabs = {}, CurrentTab = nil, ContentFrame = ContentFrame, TabFolder = TabFolder}

    function WindowData:CreateTab(tabName)
        local TabButton = Instance.new("TextButton")
        TabButton.Parent = TabButtons
        TabButton.Text = tabName
        TabButton.Size = UDim2.new(1, -10, 0, 30)
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.Font = Enum.Font.GothamBold
        TabButton.TextScaled = true
        TabButton.AutoButtonColor = false
        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(ContentFrame:GetChildren()) do
                if v:IsA("Frame") then v.Visible = false end
            end
            if WindowData.Tabs[tabName] then
                WindowData.Tabs[tabName].Visible = true
                WindowData.CurrentTab = tabName
            end
        end)

        local TabFrame = Instance.new("Frame")
        TabFrame.Parent = ContentFrame
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.BackgroundTransparency = 1
        TabFrame.Visible = false

        local Layout = Instance.new("UIListLayout", TabFrame)
        Layout.Padding = UDim.new(0, 5)

        WindowData.Tabs[tabName] = TabFrame
        if not WindowData.CurrentTab then
            TabFrame.Visible = true
            WindowData.CurrentTab = tabName
        end

        return TabFrame
    end

    function WindowData:CreateToggle(tab, text, default, callback)
        local Toggle = Instance.new("TextButton")
        Toggle.Parent = tab
        Toggle.Size = UDim2.new(1, -10, 0, 30)
        Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        Toggle.Font = Enum.Font.GothamSemibold
        Toggle.TextScaled = true
        Toggle.Text = text .. ": " .. tostring(default)
        local state = default

        Toggle.MouseButton1Click:Connect(function()
            state = not state
            Toggle.Text = text .. ": " .. tostring(state)
            callback(state)
        end)
    end

    function WindowData:CreateSlider(tab, text, min, max, default, callback)
        local Frame = Instance.new("Frame", tab)
        Frame.Size = UDim2.new(1, -10, 0, 50)
        Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

        local Label = Instance.new("TextLabel", Frame)
        Label.Size = UDim2.new(1, 0, 0, 20)
        Label.BackgroundTransparency = 1
        Label.TextColor3 = Color3.new(1, 1, 1)
        Label.Font = Enum.Font.GothamSemibold
        Label.TextScaled = true
        Label.Text = text .. ": " .. default

        local Slider = Instance.new("TextButton", Frame)
        Slider.Position = UDim2.new(0, 10, 0, 25)
        Slider.Size = UDim2.new(1, -20, 0, 10)
        Slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        local ValueBar = Instance.new("Frame", Slider)
        ValueBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        ValueBar.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)

        local dragging = false
        Slider.MouseButton1Down:Connect(function() dragging = true end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        game:GetService("RunService").RenderStepped:Connect(function()
            if dragging then
                local mouseX = UserInputService:GetMouseLocation().X
                local rel = math.clamp((mouseX - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * rel)
                ValueBar.Size = UDim2.new(rel, 0, 1, 0)
                Label.Text = text .. ": " .. val
                callback(val)
            end
        end)
    end

    -- KEYBINDER
    function WindowData:CreateKeybind(tab, text, defaultKey, callback)
        local Btn = Instance.new("TextButton", tab)
        Btn.Size = UDim2.new(1, -10, 0, 30)
        Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Btn.Font = Enum.Font.GothamSemibold
        Btn.TextScaled = true
        Btn.Text = text .. ": [" .. defaultKey .. "]"

        local currentKey = Enum.KeyCode[defaultKey]
        Btn.MouseButton1Click:Connect(function()
            Btn.Text = "Press a key..."
            local conn; conn = UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    currentKey = input.KeyCode
                    Btn.Text = text .. ": [" .. currentKey.Name .. "]"
                    conn:Disconnect()
                end
            end)
        end)

        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == currentKey then
                callback()
            end
        end)
    end

    -- DROPDOWN SELECTOR
    function WindowData:CreateSelector(tab, text, options, default, callback)
        local Frame = Instance.new("Frame", tab)
        Frame.Size = UDim2.new(1, -10, 0, 35)
        Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

        local Btn = Instance.new("TextButton", Frame)
        Btn.Size = UDim2.new(1, 0, 1, 0)
        Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Btn.Font = Enum.Font.GothamSemibold
        Btn.TextScaled = true
        Btn.Text = text .. ": " .. default

        Btn.MouseButton1Click:Connect(function()
            local idx = table.find(options, default) or 1
            idx = idx + 1
            if idx > #options then idx = 1 end
            default = options[idx]
            Btn.Text = text .. ": " .. default
            callback(default)
        end)
    end

    return WindowData
end

return MoonUI
