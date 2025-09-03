local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Theme = {
    Background = Color3.fromRGB(15,15,20),
    TabSelected = Color3.fromRGB(100,140,255),
    Text = Color3.fromRGB(240,240,255),
    ToggleOn = Color3.fromRGB(100,200,255),
    ToggleOff = Color3.fromRGB(70,70,80)
}

local MoonHub = {}

function MoonHub:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0,500,0,350)
    MainFrame.Position = UDim2.new(0.5,-250,0.5,-175)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.ClipsDescendants = true
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,12)

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1,0,0,40)
    TitleBar.BackgroundTransparency = 1
    TitleBar.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1,-100,1,0)
    TitleLabel.Position = UDim2.new(0,10,0,0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 20
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0,30,0,30)
    MinBtn.Position = UDim2.new(1,-70,0.5,-15)
    MinBtn.BackgroundTransparency = 1
    MinBtn.Text = "-"
    MinBtn.TextColor3 = Theme.Text
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 22
    MinBtn.Parent = TitleBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0,30,0,30)
    CloseBtn.Position = UDim2.new(1,-35,0.5,-15)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255,80,80)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 20
    CloseBtn.Parent = TitleBar

    local dragging, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(MainFrame, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = newPos}):Play()
        end
    end)

    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(0,120,1,-50)
    TabBar.Position = UDim2.new(0,0,0,50)
    TabBar.BackgroundColor3 = Theme.Background
    TabBar.BorderSizePixel = 0
    TabBar.Parent = MainFrame
    Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0,8)

    local UIList = Instance.new("UIListLayout", TabBar)
    UIList.FillDirection = Enum.FillDirection.Vertical
    UIList.Padding = UDim.new(0,5)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder

    local Tabs = {}
    local CurrentContent

    local FadeFrame = Instance.new("Frame")
    FadeFrame.Size = UDim2.new(1,0,1,0)
    FadeFrame.BackgroundTransparency = 1
    FadeFrame.BackgroundColor3 = Color3.new(0,0,0)
    FadeFrame.ZIndex = 10
    FadeFrame.Parent = MainFrame

    local function toggleGuiFade()
        if MainFrame.Visible then
            TweenService:Create(FadeFrame, TweenInfo.new(0.25), {BackgroundTransparency = 0.5}):Play()
            task.delay(0.25, function()
                MainFrame.Visible = false
                FadeFrame.BackgroundTransparency = 1
            end)
        else
            MainFrame.Visible = true
            FadeFrame.BackgroundTransparency = 0.5
            TweenService:Create(FadeFrame, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
        end
    end

    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.Insert then
            toggleGuiFade()
        end
    end)

    local OriginalSize = MainFrame.Size

    MinBtn.MouseButton1Click:Connect(function()
        if MainFrame.Size.Y.Offset > 50 then
            TweenService:Create(MainFrame, TweenInfo.new(0.25), {Size = UDim2.new(MainFrame.Size.X.Scale, MainFrame.Size.X.Offset, 0, 40)}):Play()
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.25), {Size = OriginalSize}):Play()
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        local Spinner = Instance.new("TextLabel")
        Spinner.Size = UDim2.new(0,100,0,100)
        Spinner.Position = UDim2.new(0.5,-50,0.5,-50)
        Spinner.BackgroundTransparency = 1
        Spinner.Text = "⏳\nClosing GUI"
        Spinner.TextColor3 = Theme.Text
        Spinner.Font = Enum.Font.GothamBold
        Spinner.TextSize = 20
        Spinner.TextWrapped = true
        Spinner.TextYAlignment = Enum.TextYAlignment.Center
        Spinner.TextXAlignment = Enum.TextXAlignment.Center
        Spinner.Parent = MainFrame

        for _, v in pairs(MainFrame:GetChildren()) do
            if v ~= Spinner then
                v.Visible = false
            end
        end

        task.delay(3, function()
            ScreenGui:Destroy()
        end)
    end)

    function MoonHub:CreateTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.BackgroundColor3 = Theme.Background
        TabButton.Text = name
        TabButton.TextColor3 = Theme.Text
        TabButton.Font = Enum.Font.GothamBold
        TabButton.TextSize = 18
        TabButton.Parent = TabBar

        local TabContent = Instance.new("Frame")
        TabContent.Size = UDim2.new(1, 0, 1, -50)
        TabContent.Position = UDim2.new(0, 120, 0, 50)
        TabContent.BackgroundTransparency = 1
        TabContent.Parent = MainFrame

        local function switchTab()
            if CurrentContent then
                CurrentContent.Visible = false
            end
            TabContent.Visible = true
            CurrentContent = TabContent
        end

        TabButton.MouseButton1Click:Connect(switchTab)

        Tabs[name] = {
            Button = TabButton,
            Content = TabContent,
            Switch = switchTab
        }

        return TabContent
    end

    return MoonHub
end

return MoonHub
