local Configs_HUB = {
    Cor_Hub = Color3.fromRGB(15, 15, 15),
    Cor_Options = Color3.fromRGB(28, 28, 28),
    Cor_Stroke = Color3.fromRGB(255, 50, 50),
    Cor_Text = Color3.fromRGB(255, 255, 255),
    Cor_DarkText = Color3.fromRGB(150, 150, 150),
    Corner_Radius = UDim.new(0, 12),
    Text_Font = Enum.Font.FredokaOne
}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

local ClickSound = Instance.new("Sound")
ClickSound.SoundId = "rbxassetid://6895079853"
ClickSound.Volume = 1.5
ClickSound.Parent = SoundService

local function Create(instance, parent, props)
    local new = Instance.new(instance, parent)
    if props then
        for prop, value in pairs(props) do
            new[prop] = value
        end
    end
    return new
end

local function SetProps(instance, props)
    if instance and props then
        for prop, value in pairs(props) do
            instance[prop] = value
        end
    end
    return instance
end

local function Corner(parent, props)
    local new = Create("UICorner", parent)
    new.CornerRadius = Configs_HUB.Corner_Radius
    if props then SetProps(new, props) end
    return new
end

local function Stroke(parent, props)
    local new = Create("UIStroke", parent)
    new.Color = Configs_HUB.Cor_Stroke
    new.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    new.Thickness = 2
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 20, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 50))
    }
    gradient.Rotation = 0
    gradient.Parent = new
    coroutine.wrap(function()
        while new.Parent do
            gradient.Rotation = (gradient.Rotation + 2) % 360
            RunService.RenderStepped:Wait()
        end
    end)()
    if props then SetProps(new, props) end
    return new
end

local function CreateTween(instance, prop, value, time, tweenWait)
    local tween = TweenService:Create(instance, TweenInfo.new(time, Enum.EasingStyle.Linear), {[prop] = value})
    tween:Play()
    if tweenWait then
        tween.Completed:Wait()
    end
end

local existing = CoreGui:FindFirstChild("REDz HUB library")
if existing then existing:Destroy() end

local currentRank = {text = "عضو", color = Color3.fromRGB(255, 255, 255)}

local function ApplyRank()
    local char = LocalPlayer.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local old = head:FindFirstChild("RankBillboard")
    if old then old:Destroy() end
    local bb = Instance.new("BillboardGui")
    bb.Name = "RankBillboard"
    bb.Size = UDim2.new(0, 200, 0, 50)
    bb.StudsOffset = Vector3.new(0, 2.5, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 300
    bb.Parent = head
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = currentRank.text
    label.TextColor3 = currentRank.color
    label.TextStrokeTransparency = 0
    local sum = label.TextColor3.R + label.TextColor3.G + label.TextColor3.B
    label.TextStrokeColor3 = (sum < 1.5) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = true
    label.Parent = bb
end

local function SetRank(text, color)
    currentRank.text = text
    currentRank.color = color
    ApplyRank()
end

local function HandleChar(char)
    char:WaitForChild("Head", 10)
    task.wait(0.3)
    ApplyRank()
end

if LocalPlayer.Character then
    task.spawn(HandleChar, LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(HandleChar)

local started = false

local function StartScript()
    if started then return end
    started = true

    local ScreenGui = Create("ScreenGui", CoreGui, {
        Name = "REDz HUB library",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local IntroGui = Create("ScreenGui", CoreGui, {
        Name = "𝑮𝑮_Intro",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local IntroBG = Create("Frame", IntroGui, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0
    })

    local IntroText = Create("TextLabel", IntroBG, {
        Size = UDim2.new(0, 400, 0, 100),
        Position = UDim2.new(0.5, -200, 0.5, -50),
        BackgroundTransparency = 1,
        Font = Configs_HUB.Text_Font,
        Text = "𝑮𝑮~𝒍𝒂𝒏𝒔𝒉𝒆𝒓",
        TextSize = 35,
        TextColor3 = Color3.fromRGB(255, 0, 0),
        TextScaled = true
    })

    task.spawn(function()
        while IntroGui and IntroGui.Parent do
            CreateTween(IntroText, "TextColor3", Color3.fromRGB(40, 0, 0), 0.5, true)
            CreateTween(IntroText, "TextColor3", Color3.fromRGB(255, 50, 50), 0.5, true)
        end
    end)

    task.wait(2)
    CreateTween(IntroBG, "BackgroundTransparency", 1, 0.5, false)
    CreateTween(IntroText, "TextTransparency", 1, 0.5, true)
    IntroGui:Destroy()

    local OpenHubButton = Create("ImageButton", ScreenGui, {
        Size = UDim2.new(0, 60, 0, 60),
        Position = UDim2.new(0, 30, 0.5, -30),
        BackgroundColor3 = Configs_HUB.Cor_Options,
        Image = "rbxassetid://106176016019821",
        Active = true,
        Draggable = true,
        AutoButtonColor = false
    })
    Corner(OpenHubButton, {CornerRadius = UDim.new(1, 0)})
    Stroke(OpenHubButton)

    local Menu_Notifi = Create("Frame", ScreenGui, {
        Size = UDim2.new(0, 300, 1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1
    })
    Create("UIPadding", Menu_Notifi, {
        PaddingLeft = UDim.new(0, 25),
        PaddingTop = UDim.new(0, 25),
        PaddingBottom = UDim.new(0, 50)
    })
    Create("UIListLayout", Menu_Notifi, {
        Padding = UDim.new(0, 15),
        VerticalAlignment = Enum.VerticalAlignment.Bottom
    })

    local function MakeNotifi(Configs)
        local Title = Configs.Title or "𝑮𝑮 ~ 𝒍𝒂𝒏𝒔𝒉𝒆𝒓"
        local text = Configs.Text or "Notification"
        local timewait = Configs.Time or 5

        local Frame1 = Create("Frame", Menu_Notifi, {
            Size = UDim2.new(2, 0, 0, 0),
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.Y,
            Name = "Title"
        })

        local Frame2 = Create("Frame", Frame1, {
            Size = UDim2.new(0, Menu_Notifi.Size.X.Offset - 50, 0, 0),
            BackgroundColor3 = Configs_HUB.Cor_Hub,
            Position = UDim2.new(0, Menu_Notifi.Size.X.Offset, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y
        })
        Corner(Frame2)
        Stroke(Frame2)

        Create("TextLabel", Frame2, {
            Size = UDim2.new(1, -40, 0, 25),
            Font = Configs_HUB.Text_Font,
            Text = Title,
            TextSize = 16,
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0, 10, 0, 5)
        })

        Create("TextLabel", Frame2, {
            Size = UDim2.new(1, -30, 0, 0),
            Position = UDim2.new(0, 15, 0, 35),
            TextSize = 14,
            TextColor3 = Configs_HUB.Cor_Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = text,
            Font = Configs_HUB.Text_Font,
            BackgroundTransparency = 1,
            TextWrapped = true
        })

        local FrameSize = Create("Frame", Frame2, {
            Size = UDim2.new(1, -4, 0, 2),
            BackgroundColor3 = Configs_HUB.Cor_Stroke,
            Position = UDim2.new(0, 2, 0, 30),
            BorderSizePixel = 0
        })
        Corner(FrameSize)

        task.spawn(function()
            CreateTween(FrameSize, "Size", UDim2.new(0, 0, 0, 2), timewait, true)
        end)

        task.spawn(function()
            CreateTween(Frame2, "Position", UDim2.new(0, -20, 0, 0), 0.5, true)
            CreateTween(Frame2, "Position", UDim2.new(), 0.1, true)
            task.wait(timewait)
            if Frame2 and Frame2.Parent then
                CreateTween(Frame2, "Position", UDim2.new(0, -20, 0, 0), 0.1, true)
                CreateTween(Frame2, "Position", UDim2.new(0, Menu_Notifi.Size.X.Offset, 0, 0), 0.5, true)
                Frame1:Destroy()
            end
        end)
    end

    local Menu = Create("Frame", ScreenGui, {
        BackgroundColor3 = Configs_HUB.Cor_Hub,
        Position = UDim2.new(0.5, -500/2, 0.5, -320/2),
        Active = true,
        Draggable = true,
        Size = UDim2.new(0, 500, 0, 320),
        Visible = false
    })
    Corner(Menu)
    Stroke(Menu)

    OpenHubButton.MouseButton1Click:Connect(function()
        Menu.Visible = not Menu.Visible
    end)

    local HubBGImage = Create("ImageLabel", Menu, {
        Name = "HubBackground",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://118002360765644",
        ImageTransparency = 0.3,
        ScaleType = Enum.ScaleType.Crop,
        ZIndex = 0
    })
    Corner(HubBGImage)

    local TopBar = Create("Frame", Menu, {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 25),
        ZIndex = 2
    })

    local RotatingImage = Create("ImageLabel", TopBar, {
        Name = "RotatingLogo",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 2, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://106176016019821",
        ZIndex = 3
    })
    Corner(RotatingImage, {CornerRadius = UDim.new(1, 0)})

    local TitleLabel = Create("TextLabel", TopBar, {
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 28, 0, 0),
        BackgroundTransparency = 1,
        Font = Configs_HUB.Text_Font,
        Text = "𝑮𝑮 ~ 𝒍𝒂𝒏𝒔𝒉𝒆𝒓",
        TextSize = 16,
        TextColor3 = Color3.fromRGB(255, 40, 40),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3
    })

    coroutine.wrap(function()
        while TitleLabel and TitleLabel.Parent do
            CreateTween(TitleLabel, "TextColor3", Color3.fromRGB(35, 0, 0), 0.8, true)
            CreateTween(TitleLabel, "TextColor3", Color3.fromRGB(255, 40, 40), 0.8, true)
        end
    end)()

    local ButtonsFrame = Create("Frame", TopBar, {
        Size = UDim2.new(0, 40, 1, -5),
        Position = UDim2.new(1, -10, 0, 2.5),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1
    })

    local Minimize_BTN = Create("TextButton", ButtonsFrame, {
        Text = "-",
        TextColor3 = Configs_HUB.Cor_Text,
        Size = UDim2.new(0.5, 0, 1, 0),
        BackgroundTransparency = 1,
        Font = Configs_HUB.Text_Font,
        TextYAlignment = Enum.TextYAlignment.Bottom,
        TextSize = 25
    })

    local IsMinimized = false
    Minimize_BTN.MouseButton1Click:Connect(function()
        IsMinimized = not IsMinimized
        Minimize_BTN.Text = IsMinimized and "+" or "-"
        local targetHeight = IsMinimized and 35 or 320
        CreateTween(Menu, "Size", UDim2.new(0, 500, 0, targetHeight), 0.15, false)
    end)

    local Close_Button = Create("TextButton", ButtonsFrame, {
        Text = "×",
        TextYAlignment = Enum.TextYAlignment.Bottom,
        TextColor3 = Configs_HUB.Cor_Text,
        Size = UDim2.new(0.5, 0, 1, 0),
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Font = Configs_HUB.Text_Font,
        TextSize = 25
    })

    local function CreateClose()
        IsMinimized = false
        Minimize_BTN.Text = "-"
        CreateTween(Menu, "Size", UDim2.new(0, 500, 0, 320), 0.3, false)

        local CloseGui = Create("TextButton", Menu, {
            BackgroundColor3 = Configs_HUB.Cor_Hub,
            Size = UDim2.new(1, 0, 1, 0),
            AutoButtonColor = false,
            Text = "",
            BackgroundTransparency = 0.5,
            ZIndex = 5
        })
        Corner(CloseGui)

        local CloseMenu = Create("Frame", CloseGui, {
            Size = UDim2.new(0.7, 0, 0.7, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundColor3 = Configs_HUB.Cor_Hub
        })
        Corner(CloseMenu)
        Stroke(CloseMenu)

        Create("TextLabel", CloseMenu, {
            Size = UDim2.new(0.8, 0, 0.25, 0),
            Text = "Are you sure you want to close this script?",
            Position = UDim2.new(0.1, 0, 0.2, 0),
            TextColor3 = Configs_HUB.Cor_Text,
            Font = Configs_HUB.Text_Font,
            TextScaled = true,
            BackgroundTransparency = 1
        })

        local Confirm = Create("TextButton", CloseMenu, {
            Size = UDim2.new(0.35, 0, 0.3, 0),
            Position = UDim2.new(0.1, 0, 0.5, 0),
            BackgroundColor3 = Configs_HUB.Cor_Hub,
            Text = "Close Script",
            Font = Configs_HUB.Text_Font,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 20
        })
        Corner(Confirm)
        Stroke(Confirm)

        local Cancel = Create("TextButton", CloseMenu, {
            Size = UDim2.new(0.35, 0, 0.3, 0),
            Position = UDim2.new(0.55, 0, 0.5, 0),
            BackgroundColor3 = Configs_HUB.Cor_Hub,
            Text = "Cancel",
            Font = Configs_HUB.Text_Font,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 20
        })
        Corner(Cancel)
        Stroke(Cancel)

        Confirm.MouseButton1Click:Connect(function()
            ScreenGui:Destroy()
        end)
        Cancel.MouseButton1Click:Connect(function()
            CloseGui:Destroy()
        end)
    end

    Close_Button.MouseButton1Click:Connect(CreateClose)

    local line_Containers = Create("Frame", Menu, {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 2
    })

    local function Add_Line(props)
        local line = Create("Frame", line_Containers, props)
        line.BackgroundColor3 = Configs_HUB.Cor_Stroke
        line.BorderSizePixel = 0
    end

    Add_Line({Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0, TopBar.Size.Y.Offset)})
    Add_Line({Size = UDim2.new(0, 1, 1, -(TopBar.Size.Y.Offset + 1)), Position = UDim2.new(0, 140, 0, TopBar.Size.Y.Offset)})

    local Sidebar = Create("Frame", Menu, {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 6, 0, 30),
        Size = UDim2.new(0, 130, 1, -36),
        ZIndex = 2
    })
    Create("UIListLayout", Sidebar, {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    local Content = Create("Frame", Menu, {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 145, 0, 30),
        Size = UDim2.new(1, -151, 1, -36),
        ZIndex = 2
    })

    local Pages = {}
    local tabCounter = 0
    local btnCounter = 0

    local function ShowPage(key)
        for k, page in pairs(Pages) do
            page.Visible = (k == key)
        end
    end

    local function MakeTab(tabKey, tabTitle)
        tabCounter = tabCounter + 1
        local btn = Create("TextButton", Sidebar, {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Configs_HUB.Cor_Options,
            Text = tabTitle,
            Font = Configs_HUB.Text_Font,
            TextColor3 = Configs_HUB.Cor_Text,
            TextSize = 13,
            AutoButtonColor = false,
            LayoutOrder = tabCounter
        })
        Corner(btn)
        Stroke(btn)

        local page = Create("Frame", Content, {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false
        })

        local scroll = Create("ScrollingFrame", page, {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y
        })
        Create("UIListLayout", scroll, {
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        Create("UIPadding", scroll, {
            PaddingRight = UDim.new(0, 8)
        })

        Pages[tabKey] = page

        btn.MouseButton1Click:Connect(function()
            ShowPage(tabKey)
        end)

        return scroll
    end

    local function AddButton(parent, text, callback)
        btnCounter = btnCounter + 1
        local btn = Create("TextButton", parent, {
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = Configs_HUB.Cor_Options,
            Text = text,
            Font = Configs_HUB.Text_Font,
            TextColor3 = Configs_HUB.Cor_Text,
            TextSize = 13,
            AutoButtonColor = false,
            LayoutOrder = btnCounter
        })
        Corner(btn)
        Stroke(btn)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    local CmdScroll = MakeTab("commands", "أوامر انفنتي")

    local Commands = {
        "Replicationlag 999",
        "2022materials",
        "clearerror",
        "nofog",
        "autokeypress",
        "autokeypress nan",
        "datalimit 660",
        "backtrack 999",
        "backtrack nan",
        "antilag",
        "antikick",
        "antiafk",
        "xray",
    }

    for _, cmd in ipairs(Commands) do
        AddButton(CmdScroll, cmd, function()
            local ok = pcall(function()
                if setclipboard then
                    setclipboard(cmd)
                elseif toclipboard then
                    toclipboard(cmd)
                elseif Clipboard and Clipboard.set then
                    Clipboard.set(cmd)
                else
                    error("no clipboard")
                end
            end)
            if ok then
                MakeNotifi({Title = "تم النسخ", Text = cmd, Time = 2})
            else
                MakeNotifi({Title = "خطأ", Text = "المنفذ لا يدعم الحافظة", Time = 3})
            end
        end)
    end

    local ScrScroll = MakeTab("scripts", "سكربتات خاصه")

    local Scripts = {
        {
            name = "سكربت1 انصاري",
            code = 'loadstring(game:HttpGet("https://gist.githubusercontent.com/Yemenx/e976b6c7c681e67ebe0f31f88ebb6ac6/raw/536a222c673c23ba43ebe29dfcc29a53c8808eea/ANSRY.YAMEN.VAMPAIRE.lua"))()',
        },
        {
            name = "سكربت 2 ابو عتب",
            code = 'loadstring(game:HttpGet("https://gist.githubusercontent.com/yhmwd406-boop/2dd250fe58d63fabee981b085afc10c5/raw/8bf78e204f3f04cac8bea68e887a95f41c8b81c4/%25D8%25B3%25D9%2583%25D8%25B1%25D8%25A8%25D8%25AA%2520%25D8%25B9%25D8%25AF%25D8%25A7%25D8%25A7%25D8%25AA"))()',
        },
        {
            name = "سكربت3 antikick",
            code = 'loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-AntiAFK-v-AntiKick-V3-v-Kick-Attempt-Logger-27977"))()',
        },
        {
            name = "سكربت 4 تسجيل",
            code = 'loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-NO9AT-SAMLAT-47637"))()',
        },
        {
            name = "المفتاح AL-QYADAH~F7LK",
            code = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/professor-f7lk/CLAN_AL-QYADAH/refs/heads/main/README.md"))()',
        },
    }

    for _, s in ipairs(Scripts) do
        AddButton(ScrScroll, s.name, function()
            local ok, err = pcall(function()
                loadstring(s.code)()
            end)
            if ok then
                MakeNotifi({Title = "تم التشغيل", Text = s.name, Time = 2})
            else
                MakeNotifi({Title = "فشل التشغيل", Text = tostring(err), Time = 3})
            end
        end)
    end

    local RankScroll = MakeTab("ranks", "رتب")

    local function AddRankSection(rankName, rankColor, password, isMember)
        btnCounter = btnCounter + 1
        local row = Create("Frame", RankScroll, {
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = Configs_HUB.Cor_Options,
            LayoutOrder = btnCounter
        })
        Corner(row)
        Stroke(row)

        local nameLabel = Create("TextLabel", row, {
            Size = UDim2.new(0.28, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = rankName,
            Font = Configs_HUB.Text_Font,
            TextColor3 = rankColor,
            TextSize = 14
        })
        if rankColor == Color3.fromRGB(0, 0, 0) then
            local s = Create("UIStroke", nameLabel)
            s.Color = Color3.fromRGB(255, 255, 255)
            s.Thickness = 1
        end

        if not isMember then
            local tb = Create("TextBox", row, {
                Size = UDim2.new(0.42, -10, 0.7, 0),
                Position = UDim2.new(0.29, 0, 0.15, 0),
                BackgroundColor3 = Configs_HUB.Cor_Hub,
                PlaceholderText = "كلمة السر...",
                Font = Configs_HUB.Text_Font,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                PlaceholderColor3 = Configs_HUB.Cor_DarkText,
                TextSize = 12,
                Text = "",
                ClearTextOnFocus = false
            })
            Corner(tb)
            Stroke(tb)

            local btn = Create("TextButton", row, {
                Size = UDim2.new(0.28, -10, 0.7, 0),
                Position = UDim2.new(0.72, 0, 0.15, 0),
                BackgroundColor3 = Configs_HUB.Cor_Hub,
                Text = "تفعيل",
                Font = Configs_HUB.Text_Font,
                TextColor3 = Configs_HUB.Cor_Text,
                TextSize = 13,
                AutoButtonColor = false
            })
            Corner(btn)
            Stroke(btn)

            btn.MouseButton1Click:Connect(function()
                if tb.Text == password then
                    SetRank(rankName, rankColor)
                    MakeNotifi({Title = "تم التفعيل", Text = "رتبتك الآن: " .. rankName, Time = 2})
                else
                    MakeNotifi({Title = "خطأ", Text = "كلمة السر غير صحيحة", Time = 2})
                end
            end)
        else
            local btn = Create("TextButton", row, {
                Size = UDim2.new(0.42, -10, 0.7, 0),
                Position = UDim2.new(0.29, 0, 0.15, 0),
                BackgroundColor3 = Configs_HUB.Cor_Hub,
                Text = "بدون كلمة سر",
                Font = Configs_HUB.Text_Font,
                TextColor3 = Configs_HUB.Cor_Text,
                TextSize = 12,
                AutoButtonColor = false
            })
            Corner(btn)
            Stroke(btn)
            btn.MouseButton1Click:Connect(function()
                SetRank(rankName, rankColor)
                MakeNotifi({Title = "تم التفعيل", Text = "رتبتك الآن: " .. rankName, Time = 2})
            end)
        end
    end

    AddRankSection("مالك", Color3.fromRGB(0, 0, 0), "6767", false)
    AddRankSection("أدمن", Color3.fromRGB(255, 0, 0), "scopa", false)
    AddRankSection("عضو", Color3.fromRGB(255, 255, 255), nil, true)

    ShowPage("commands")
end

local PasswordGui = Create("ScreenGui", CoreGui, {
    Name = "𝑮𝑮_PasswordGate",
    ResetOnSpawn = false,
    DisplayOrder = 999,
    IgnoreGuiInset = true
})

local pBg = Create("Frame", PasswordGui, {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0
})

local pBox = Create("Frame", pBg, {
    Size = UDim2.new(0, 380, 0, 195),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    BackgroundColor3 = Configs_HUB.Cor_Hub,
    BorderSizePixel = 0
})
Corner(pBox)
Stroke(pBox)

Create("TextLabel", pBox, {
    Size = UDim2.new(1, 0, 0, 30),
    Position = UDim2.new(0, 0, 0, 12),
    BackgroundTransparency = 1,
    Text = "𝑮𝑮 ~ 𝒍𝒂𝒏𝒔𝒉𝒆𝒓",
    Font = Configs_HUB.Text_Font,
    TextColor3 = Color3.fromRGB(255, 40, 40),
    TextSize = 20
})

Create("TextLabel", pBox, {
    Size = UDim2.new(1, 0, 0, 20),
    Position = UDim2.new(0, 0, 0, 48),
    BackgroundTransparency = 1,
    Text = "أدخل كلمة السر للدخول",
    Font = Configs_HUB.Text_Font,
    TextColor3 = Configs_HUB.Cor_DarkText,
    TextSize = 13
})

local pTextBox = Create("TextBox", pBox, {
    Size = UDim2.new(0.8, 0, 0, 34),
    Position = UDim2.new(0.1, 0, 0, 78),
    BackgroundColor3 = Configs_HUB.Cor_Options,
    PlaceholderText = "كلمة السر...",
    Font = Configs_HUB.Text_Font,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    PlaceholderColor3 = Configs_HUB.Cor_DarkText,
    TextSize = 14,
    Text = "",
    ClearTextOnFocus = true
})
Corner(pTextBox)
Stroke(pTextBox)

local pStatus = Create("TextLabel", pBox, {
    Size = UDim2.new(1, 0, 0, 20),
    Position = UDim2.new(0, 0, 0, 116),
    BackgroundTransparency = 1,
    Text = "",
    Font = Configs_HUB.Text_Font,
    TextColor3 = Color3.fromRGB(255, 80, 80),
    TextSize = 12
})

local pSubmit = Create("TextButton", pBox, {
    Size = UDim2.new(0.5, 0, 0, 34),
    Position = UDim2.new(0.25, 0, 0, 145),
    BackgroundColor3 = Configs_HUB.Cor_Options,
    Text = "تأكيد",
    Font = Configs_HUB.Text_Font,
    TextColor3 = Configs_HUB.Cor_Text,
    TextSize = 15,
    AutoButtonColor = false
})
Corner(pSubmit)
Stroke(pSubmit)

local function TryUnlock()
    if pTextBox.Text == "GG-on-top-forever" then
        PasswordGui:Destroy()
        StartScript()
    else
        pStatus.Text = "كلمة السر غير صحيحة"
        pTextBox.Text = ""
    end
end

pSubmit.MouseButton1Click:Connect(TryUnlock)
pTextBox.FocusLost:Connect(function(enter)
    if enter then TryUnlock() end
end)
