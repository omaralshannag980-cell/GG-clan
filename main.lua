local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("XR7_Gaheem_UI")
if old then old:Destroy() end

local function new(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    if parent then obj.Parent = parent end
    return obj
end

local function setClipboard(text)
    local ok = pcall(function()
        if setclipboard then
            setclipboard(text)
        elseif toclipboard then
            toclipboard(text)
        elseif Clipboard and Clipboard.set then
            Clipboard.set(text)
        else
            error("no clipboard")
        end
    end)
    return ok
end

local function notify(text)
    local n = new("TextLabel", {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 20),
        Size = UDim2.fromOffset(260, 36),
        BackgroundColor3 = Color3.fromRGB(30, 30, 38),
        BackgroundTransparency = 0,
        Text = text,
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(230, 230, 240),
        TextWrapped = true,
        ZIndex = 999,
    }, playerGui)
    new("UICorner", { CornerRadius = UDim.new(0, 8) }, n)
    new("UIStroke", { Color = Color3.fromRGB(90, 90, 110) }, n)
    task.delay(1.6, function()
        n:Destroy()
    end)
end

local gui = new("ScreenGui", {
    Name = "XR7_Gaheem_UI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)

local main = new("Frame", {
    Name = "Main",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(620, 420),
    BackgroundColor3 = Color3.fromRGB(18, 18, 22),
    BorderSizePixel = 0,
}, gui)
new("UICorner", { CornerRadius = UDim.new(0, 14) }, main)
new("UIStroke", { Color = Color3.fromRGB(70, 70, 85), Thickness = 1 }, main)

local top = new("Frame", {
    Name = "TopBar",
    Size = UDim2.new(1, 0, 0, 46),
    BackgroundColor3 = Color3.fromRGB(25, 25, 32),
    BorderSizePixel = 0,
}, main)
new("UICorner", { CornerRadius = UDim.new(0, 14) }, top)

new("TextLabel", {
    Position = UDim2.fromOffset(16, 0),
    Size = UDim2.new(1, -100, 1, 0),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(235, 235, 245),
    TextXAlignment = Enum.TextXAlignment.Left,
    Text = "XR7 ~ Gaheem",
}, top)

local close = new("TextButton", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -10, 0.5, 0),
    Size = UDim2.fromOffset(30, 30),
    BackgroundColor3 = Color3.fromRGB(45, 45, 55),
    Text = "×",
    TextSize = 20,
    Font = Enum.Font.GothamBold,
    TextColor3 = Color3.fromRGB(255, 120, 120),
    AutoButtonColor = true,
}, top)
new("UICorner", { CornerRadius = UDim.new(0, 8) }, close)
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local sidebar = new("Frame", {
    Position = UDim2.fromOffset(10, 54),
    Size = UDim2.new(0, 160, 1, -64),
    BackgroundColor3 = Color3.fromRGB(22, 22, 28),
    BorderSizePixel = 0,
}, main)
new("UICorner", { CornerRadius = UDim.new(0, 10) }, sidebar)
new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, sidebar)
new("UIPadding", {
    PaddingTop = UDim.new(0, 8),
    PaddingLeft = UDim.new(0, 8),
    PaddingRight = UDim.new(0, 8),
}, sidebar)

local content = new("Frame", {
    Position = UDim2.fromOffset(180, 54),
    Size = UDim2.new(1, -190, 1, -64),
    BackgroundColor3 = Color3.fromRGB(22, 22, 28),
    BorderSizePixel = 0,
}, main)
new("UICorner", { CornerRadius = UDim.new(0, 10) }, content)

local pages = {}

local function showPage(key)
    for k, page in pairs(pages) do
        page.Visible = (k == key)
    end
end

local function createPage(key, title)
    local page = new("Frame", {
        Name = key,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Visible = false,
    }, content)

    new("TextLabel", {
        Position = UDim2.fromOffset(14, 10),
        Size = UDim2.new(1, -28, 0, 26),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextColor3 = Color3.fromRGB(220, 220, 235),
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = title,
    }, page)

    local scroll = new("ScrollingFrame", {
        Position = UDim2.fromOffset(12, 42),
        Size = UDim2.new(1, -24, 1, -54),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, page)
    new("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, scroll)
    new("UIPadding", { PaddingRight = UDim.new(0, 6) }, scroll)

    pages[key] = page
    return scroll
end

local tabs = {
    { key = "commands", title = "أوامر انفنتي" },
    { key = "scripts",  title = "سكربتات خاصه" },
    { key = "clan",     title = "سكربتات الكلان" },
}

for i, tab in ipairs(tabs) do
    local btn = new("TextButton", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Color3.fromRGB(32, 32, 40),
        Text = tab.title,
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        TextColor3 = Color3.fromRGB(220, 220, 235),
        LayoutOrder = i,
        AutoButtonColor = true,
    }, sidebar)
    new("UICorner", { CornerRadius = UDim.new(0, 8) }, btn)
    btn.MouseButton1Click:Connect(function()
        showPage(tab.key)
    end)
end

local cmdScroll = createPage("commands", "أوامر انفنتي")

local commands = {
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

for i, cmd in ipairs(commands) do
    local b = new("TextButton", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Color3.fromRGB(32, 32, 40),
        Text = cmd,
        TextSize = 14,
        Font = Enum.Font.Code,
        TextColor3 = Color3.fromRGB(225, 225, 235),
        LayoutOrder = i,
        AutoButtonColor = true,
    }, cmdScroll)
    new("UICorner", { CornerRadius = UDim.new(0, 8) }, b)

    b.MouseButton1Click:Connect(function()
        if setClipboard(cmd) then
            notify("تم النسخ: " .. cmd)
        else
            notify("تعذر النسخ")
        end
    end)
end

local scrScroll = createPage("scripts", "سكربتات خاصه")

local scripts = {
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

for i, s in ipairs(scripts) do
    local b = new("TextButton", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Color3.fromRGB(32, 32, 40),
        Text = s.name,
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        TextColor3 = Color3.fromRGB(225, 225, 235),
        LayoutOrder = i,
        AutoButtonColor = true,
    }, scrScroll)
    new("UICorner", { CornerRadius = UDim.new(0, 8) }, b)

    b.MouseButton1Click:Connect(function()
        local ok, err = pcall(function()
            loadstring(s.code)()
        end)
        if ok then
            notify("تم تشغيل: " .. s.name)
        else
            notify("فشل التشغيل: " .. tostring(err))
        end
    end)
end

createPage("clan", "سكربتات الكلان")

showPage("commands")
