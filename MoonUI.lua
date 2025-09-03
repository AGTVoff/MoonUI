-- Toggle stylé avec contour
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
    Toggle.BorderSizePixel = 1
    Toggle.BorderColor3 = Theme.ButtonBorder -- contour
    Toggle.Parent=BtnFrame
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0,10)
    ToggleCorner.Parent = Toggle

    local Circle=Instance.new("Frame")
    Circle.Size=UDim2.new(0,18,0,18)
    Circle.Position=UDim2.new(default and 0.5 or 0,1,0.5,-9)
    Circle.BackgroundColor3=Color3.fromRGB(255,255,255)
    Circle.BorderSizePixel = 1
    Circle.BorderColor3 = Theme.ButtonBorder -- contour du levier
    Circle.Parent=Toggle
    Instance.new("UICorner",Circle).CornerRadius = UDim.new(0,9)

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

-- Slider fluide limité à la taille du contour et avec levier bordé
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
    Bar.BackgroundColor3=Color3.fromRGB(40,40,45)
    Bar.BorderSizePixel = 1
    Bar.BorderColor3 = Theme.ButtonBorder -- contour du slider
    Bar.Parent=SliderFrame
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(0,3)
    BarCorner.Parent = Bar

    local Fill=Instance.new("Frame")
    Fill.Size=UDim2.new((default-min)/(max-min),0,1,0)
    Fill.BackgroundColor3=Color3.fromRGB(60,60,65)
    Fill.Parent=Bar
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0,3)
    FillCorner.Parent = Fill

    local Circle=Instance.new("Frame")
    Circle.Size=UDim2.new(0,16,0,16)
    Circle.Position=UDim2.new(Fill.Size.X.Scale,0,0.5,-8)
    Circle.BackgroundColor3=Color3.fromRGB(255,255,255)
    Circle.BorderSizePixel = 1
    Circle.BorderColor3 = Theme.ButtonBorder -- contour du levier
    Circle.Parent=Bar
    Instance.new("UICorner",Circle).CornerRadius = UDim.new(0,8)

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
