-- Moon UI Library v1.0 by AGTV
-- ModuleScript / Lua file
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Theme = {
    Background = Color3.fromRGB(15,15,20),
    TabSelected = Color3.fromRGB(100,140,255),
    Text = Color3.fromRGB(240,240,255),
    ToggleOn = Color3.fromRGB(100,200,255),
    ToggleOff = Color3.fromRGB(70,70,80)
}

local MoonHub = {}

function MoonHub:CreateWindow(title)
    -- ScreenGui parenté à PlayerGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") -- ✅

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

    -- Minimize button
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0,30,0,30)
    MinBtn.Position = UDim2.new(1,-70,0.5,-15)
    MinBtn.BackgroundTransparency = 1
    MinBtn.Text = "-"
    MinBtn.TextColor3 = Theme.Text
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 22
    MinBtn.Parent = TitleBar

    -- Close button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0,30,0,30)
    CloseBtn.Position = UDim2.new(1,-35,0.5,-15)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255,80,80)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 20
    CloseBtn.Parent = TitleBar

    -- Drag fluide
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

    -- TabBar vertical
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

    local function toggleGuiFade()
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

    -- Close / unload avec animation spinner
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

        -- Masquer le GUI après 3 secondes, compatible exécuteur
        task.delay(3, function()
            print("GUI detruit")
            MainFrame.Visible = false
        end)
    end)

    -- CreateTab
    function MoonHub:CreateTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Size=UDim2.new(1,0,0,40)
        TabButton.BackgroundColor3=Theme.Background
        TabButton.BorderSizePixel=0
        TabButton.Text=name
        TabButton.TextColor3=Theme.Text
        TabButton.Font=Enum.Font.GothamBold
        TabButton.TextSize=16
        TabButton.Parent=TabBar

        local Content = Instance.new("Frame")
        Content.Size=UDim2.new(1,-130,1,-50)
        Content.Position=UDim2.new(0,130,0,50)
        Content.BackgroundColor3 = Theme.Background
        Content.BorderSizePixel = 0
        Content.Parent = MainFrame
        Content.Visible=false

        local ElementsLayout = Instance.new("UIListLayout",Content)
        ElementsLayout.Padding = UDim.new(0,10)

        Tabs[name]={Button=TabButton,Content=Content}

        TabButton.MouseButton1Click:Connect(function()
            for _,tab in pairs(Tabs) do
                TweenService:Create(tab.Button,TweenInfo.new(0.2),{BackgroundColor3=Theme.Background}):Play()
                tab.Content.Visible=false
            end
            TweenService:Create(TabButton,TweenInfo.new(0.2),{BackgroundColor3=Theme.TabSelected}):Play()
            Content.Visible=true
            CurrentContent=Content
        end)
        return Content
    end

    -- Toggle stylé
    function MoonHub:CreateToggle(tab,text,default,callback)
        local BtnFrame=Instance.new("Frame")
        BtnFrame.Size=UDim2.new(1,0,0,30)
        BtnFrame.BackgroundTransparency=1
        BtnFrame.Parent=tab

        local Label=Instance.new("TextLabel")
        Label.Size=UDim2.new(0.7,0,1,0)
        Label.BackgroundTransparency=1
        Label.Text=text
        Label.TextColor3=Theme.Text
        Label.Font=Enum.Font.Gotham
        Label.TextSize=14
        Label.TextXAlignment=Enum.TextXAlignment.Left
        Label.Parent=BtnFrame

        local Toggle=Instance.new("Frame")
        Toggle.Size=UDim2.new(0,40,0,20)
        Toggle.Position=UDim2.new(0.75,0,0.5,-10)
        Toggle.BackgroundColor3=default and Theme.ToggleOn or Theme.ToggleOff
        Toggle.Parent=BtnFrame
        Instance.new("UICorner",Toggle).CornerRadius=UDim.new(0,10)

        local Circle=Instance.new("Frame")
        Circle.Size=UDim2.new(0,18,0,18)
        Circle.Position=UDim2.new(default and 0.5 or 0,1,0.5,-9)
        Circle.BackgroundColor3=Color3.fromRGB(255,255,255)
        Circle.Parent=Toggle
        Instance.new("UICorner",Circle).CornerRadius=UDim.new(0,9)

        local state=default
        BtnFrame.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 then
                state=not state
                TweenService:Create(Toggle,TweenInfo.new(0.2),{BackgroundColor3=state and Theme.ToggleOn or Theme.ToggleOff}):Play()
                TweenService:Create(Circle,TweenInfo.new(0.2),{Position=UDim2.new(state and 0.5 or 0,1,0.5,-9)}):Play()
                if callback then callback(state) end
            end
        end)
    end

    -- Slider fluide
    function MoonHub:CreateSlider(tab,text,min,max,default,callback)
        local SliderFrame=Instance.new("Frame")
        SliderFrame.Size=UDim2.new(1,0,0,30)
        SliderFrame.BackgroundTransparency=1
        SliderFrame.Parent=tab

        local Label=Instance.new("TextLabel")
        Label.Size=UDim2.new(1,0,0.5,0)
        Label.BackgroundTransparency=1
        Label.Text=text.." : "..default
        Label.TextColor3=Theme.Text
        Label.Font=Enum.Font.Gotham
        Label.TextSize=14
        Label.TextXAlignment=Enum.TextXAlignment.Left
        Label.Parent=SliderFrame

        local Bar=Instance.new("Frame")
        Bar.Size=UDim2.new(1,0,0,6)
        Bar.Position=UDim2.new(0,0,0.7,0)
        Bar.BackgroundColor3=Color3.fromRGB(50,50,60)
        Bar.Parent=SliderFrame
        Instance.new("UICorner",Bar).CornerRadius=UDim.new(0,3)

        local Fill=Instance.new("Frame")
        Fill.Size=UDim2.new((default-min)/(max-min),0,1,0)
        Fill.BackgroundColor3=Theme.TabSelected
        Fill.Parent=Bar
        Instance.new("UICorner",Fill).CornerRadius=UDim.new(0,3)

        local Circle=Instance.new("Frame")
        Circle.Size=UDim2.new(0,16,0,16)
        Circle.Position=UDim2.new(Fill.Size.X.Scale,0,0.5,-8)
        Circle.BackgroundColor3=Color3.fromRGB(255,255,255)
        Circle.Parent=Bar
        Instance.new("UICorner",Circle).CornerRadius=UDim.new(0,8)

        local dragging=false
        local function updateSlider(posX)
            local rel=math.clamp((posX-Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X,0,1)
            TweenService:Create(Fill,TweenInfo.new(0.1),{Size=UDim2.new(rel,0,1,0)}):Play()
            TweenService:Create(Circle,TweenInfo.new(0.1),{Position=UDim2.new(rel,0,0.5,-8)}):Play()
            local value=math.floor(min+(max-min)*rel)
            Label.Text=text.." : "..value
            if callback then callback(value) end
        end

        Bar.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true updateSlider(input.Position.X) end
        end)
        Bar.InputEnded:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then
                updateSlider(input.Position.X)
            end
        end)
    end

    return MoonHub
end

return MoonHub
