-- Moon UI Library v1.0 by AGTV - FULL BLACK + Contours uniformes pour tous
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Theme = {
    Background = Color3.fromRGB(0,0,0),
    TabSelected = Color3.fromRGB(0,0,0),
    Text = Color3.fromRGB(230,230,230),
    ToggleOn = Color3.fromRGB(30,30,30),
    ToggleOff = Color3.fromRGB(15,15,15),
    Button = Color3.fromRGB(0,0,0),
    ButtonBorder = Color3.fromRGB(50,50,50),
    OptionBG = Color3.fromRGB(0,0,0)
}

local MoonHub = {}

function MoonHub:CreateWindow(title)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0,500,0,350)
    MainFrame.Position = UDim2.new(0.5,-250,0.5,-175)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.ClipsDescendants = true
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,12)

    -- TitleBar
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

    -- Drag
    local dragging, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,
                                     startPos.Y.Scale,startPos.Y.Offset+delta.Y)
            TweenService:Create(MainFrame,TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Position=newPos}):Play()
        end
    end)

    -- TabBar
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

    -- Fade Insert
    local FadeFrame = Instance.new("Frame")
    FadeFrame.Size = UDim2.new(1,0,1,0)
    FadeFrame.BackgroundTransparency = 1
    FadeFrame.BackgroundColor3 = Color3.new(0,0,0)
    FadeFrame.ZIndex = 10
    FadeFrame.Parent = MainFrame

    local guiKilled = false
    local function toggleGuiFade()
        if guiKilled then return end
        if MainFrame.Visible then
            TweenService:Create(FadeFrame,TweenInfo.new(0.25),{BackgroundTransparency=0.5}):Play()
            task.delay(0.25,function() MainFrame.Visible=false; FadeFrame.BackgroundTransparency=1 end)
        else
            MainFrame.Visible=true
            FadeFrame.BackgroundTransparency=0.5
            TweenService:Create(FadeFrame,TweenInfo.new(0.25),{BackgroundTransparency=1}):Play()
        end
    end
    UserInputService.InputBegan:Connect(function(input,gpe)
        if not gpe and input.KeyCode==Enum.KeyCode.Insert then toggleGuiFade() end
    end)

    -- Minimize
    local OriginalSize = MainFrame.Size
    MinBtn.MouseButton1Click:Connect(function()
        if MainFrame.Size.Y.Offset>50 then
            TweenService:Create(MainFrame,TweenInfo.new(0.25),{Size=UDim2.new(MainFrame.Size.X.Scale,MainFrame.Size.X.Offset,0,40)}):Play()
        else
            TweenService:Create(MainFrame,TweenInfo.new(0.25),{Size=OriginalSize}):Play()
        end
    end)

    -- Close with animation
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

        for _,v in pairs(MainFrame:GetChildren()) do
            if v ~= Spinner and v:IsA("GuiObject") then
                v.Visible = false
            end
        end

        task.delay(3, function()
            MainFrame.Visible = false
            guiKilled = true
        end)
    end)

    -- CreateTab
    function MoonHub:CreateTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Size=UDim2.new(1,0,0,40)
        TabButton.BackgroundColor3=Theme.Background
        TabButton.BorderSizePixel = 1
        TabButton.BorderColor3 = Theme.ButtonBorder
        TabButton.Text=name
        TabButton.TextColor3=Theme.Text
        TabButton.Font=Enum.Font.GothamBold
        TabButton.TextSize=16
        TabButton.Parent=TabBar
        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0,8)

        local Content = Instance.new("Frame")
        Content.Size=UDim2.new(1,-130,1,-50)
        Content.Position=UDim2.new(0,130,0,50)
        Content.BackgroundColor3 = Theme.Background
        Content.BorderSizePixel = 1
        Content.BorderColor3 = Theme.ButtonBorder
        Content.Parent = MainFrame
        Content.Visible=false
        Instance.new("UICorner", Content).CornerRadius = UDim.new(0,8)

        local ElementsLayout = Instance.new("UIListLayout",Content)
        ElementsLayout.Padding = UDim.new(0,10)

        Tabs[name]={Button=TabButton,Content=Content}

        local function updateTabStyle(selected)
            for _,tab in pairs(Tabs) do
                if tab.Button == selected then
                    TweenService:Create(tab.Button,TweenInfo.new(0.25),{BackgroundColor3=Theme.TabSelected}):Play()
                else
                    TweenService:Create(tab.Button,TweenInfo.new(0.25),{BackgroundColor3=Theme.Background}):Play()
                end
            end
        end

        TabButton.MouseButton1Click:Connect(function()
            for _,tab in pairs(Tabs) do
                tab.Content.Visible=false
            end
            Content.Visible=true
            CurrentContent=Content
            updateTabStyle(TabButton)
        end)

        if not CurrentContent then
            Content.Visible=true
            CurrentContent=Content
            updateTabStyle(TabButton)
        end

        return Content
    end

    -- Les options (Toggle, Slider, Button) utiliseront toutes ce même style uniforme
    local function CreateOptionFrame(parent)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1,0,0,35)
        frame.BackgroundColor3 = Theme.OptionBG
        frame.BorderSizePixel = 1
        frame.BorderColor3 = Theme.ButtonBorder
        frame.Parent = parent
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0,8)
        return frame
    end
