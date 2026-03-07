-- [[ ALPHA PROJECT - OFFICIAL LOADER ]] --
-- GitHub: NuansaHub/NuansaHUB

local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local LP = game:GetService("Players").LocalPlayer

-- CLEANER: Hapus UI lama agar tidak menumpuk
if getgenv().AlphaProjectUI then getgenv().AlphaProjectUI:Destroy() end

local Theme = {
    Main = Color3.fromRGB(15, 17, 20),
    Accent = Color3.fromRGB(0, 255, 220), -- Neon Cyan Alpha
    Header = Color3.fromRGB(10, 12, 14),
    Item = Color3.fromRGB(25, 28, 32),
    Text = Color3.fromRGB(240, 245, 255),
    SubText = Color3.fromRGB(160, 165, 175)
}

-- [[ UI CONSTRUCT ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "AlphaProject_Main"
ScreenGui.ResetOnSpawn = false
getgenv().AlphaProjectUI = ScreenGui

local Main = Instance.new("Frame", ScreenGui)
Main.BackgroundColor3 = Theme.Main
Main.Position = UDim2.new(0.5, -250, 0.5, -160)
Main.Size = UDim2.new(0, 500, 0, 320)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Theme.Accent; Stroke.Thickness = 1.5; Stroke.Transparency = 0.5

-- Header
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Theme.Header
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Header)
Title.Text = "ALPHA PROJECT"
Title.Font = Enum.Font.GothamBlack; Title.TextColor3 = Theme.Accent; Title.TextSize = 18
Title.Size = UDim2.new(1, 0, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1; Title.TextXAlignment = Enum.TextXAlignment.Left

-- Drag Function
local function EnableDrag(frame, trigger)
    local dragging, dragInput, dragStart, startPos
    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
EnableDrag(Main, Header)

-- [[ NAVIGATION SYSTEM ]] --
local TabHolder = Instance.new("ScrollingFrame", Main)
TabHolder.Size = UDim2.new(0, 140, 1, -55); TabHolder.Position = UDim2.new(0, 5, 0, 50)
TabHolder.BackgroundColor3 = Theme.Header; TabHolder.BorderSizePixel = 0; TabHolder.ScrollBarThickness = 0
Instance.new("UIListLayout", TabHolder).Padding = UDim.new(0, 5)

local PageHolder = Instance.new("Frame", Main)
PageHolder.Size = UDim2.new(1, -155, 1, -55); PageHolder.Position = UDim2.new(0, 150, 0, 50); PageHolder.BackgroundTransparency = 1

local Tabs = {}; local Pages = {}

local function AddTab(name)
    local TabBtn = Instance.new("TextButton", TabHolder)
    TabBtn.Size = UDim2.new(0.95, 0, 0, 35); TabBtn.BackgroundColor3 = Theme.Main
    TabBtn.Text = name; TabBtn.TextColor3 = Theme.Text; TabBtn.Font = Enum.Font.GothamMedium; TabBtn.TextSize = 12
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
    local bStroke = Instance.new("UIStroke", TabBtn); bStroke.Color = Theme.Accent; bStroke.Transparency = 0.8

    local Page = Instance.new("ScrollingFrame", PageHolder)
    Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1; Page.BorderSizePixel = 0; Page.ScrollBarThickness = 2; Page.ScrollBarImageColor3 = Theme.Accent
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)

    TabBtn.MouseButton1Click:Connect(function()
        for i, v in pairs(Pages) do v.Visible = false end
        for i, v in pairs(Tabs) do 
            TS:Create(v, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Main, TextColor3 = Theme.Text}):Play()
            v.UIStroke.Transparency = 0.8
        end
        Page.Visible = true
        TS:Create(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.Main}):Play()
        bStroke.Transparency = 0
    end)
    table.insert(Tabs, TabBtn); table.insert(Pages, Page)
    return Page
end

-- [[ MODULE LOADER (Untuk Script Raw Baru) ]] --
local function AddModule(parentPage, title, desc, rawLink)
    local Frame = Instance.new("Frame", parentPage)
    Frame.Size = UDim2.new(1, -10, 0, 70); Frame.BackgroundColor3 = Theme.Item; Instance.new("UICorner", Frame)
    Instance.new("UIStroke", Frame).Color = Theme.Accent; Frame.UIStroke.Transparency = 0.8

    local t = Instance.new("TextLabel", Frame); t.Text = title; t.Size = UDim2.new(0.6, 0, 0, 25); t.Position = UDim2.new(0, 10, 0, 5); t.TextColor3 = Theme.Accent; t.Font = Enum.Font.GothamBold; t.BackgroundTransparency = 1; t.TextXAlignment = Enum.TextXAlignment.Left
    local d = Instance.new("TextLabel", Frame); d.Text = desc; d.Size = UDim2.new(0.6, 0, 0, 30); d.Position = UDim2.new(0, 10, 0, 30); d.TextColor3 = Theme.SubText; d.Font = Enum.Font.Gotham; d.TextSize = 10; d.BackgroundTransparency = 1; d.TextWrapped = true; d.TextXAlignment = Enum.TextXAlignment.Left; d.TextYAlignment = Enum.TextYAlignment.Top

    local Btn = Instance.new("TextButton", Frame)
    Btn.Size = UDim2.new(0.3, 0, 0, 30); Btn.Position = UDim2.new(0.65, 0, 0.5, -15); Btn.BackgroundColor3 = Theme.Accent; Btn.Text = "EXECUTE"; Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 11; Instance.new("UICorner", Btn)

    Btn.MouseButton1Click:Connect(function()
        Btn.Text = "Loading..."
        pcall(function() loadstring(game:HttpGet(rawLink))() end)
        task.wait(1); Btn.Text = "Executed ✅"
        task.wait(1); Btn.Text = "EXECUTE"
    end)
end

-- [[ SETUP TABS ]] --
local Tab1 = AddTab("Home")
local Tab2 = AddTab("Auto Farm")

-- Contoh memasukkan script raw baru di tab Auto Farm
AddModule(Tab2, "Main Autofarm", "Script auto farm batu & kayu versi terbaru.", "LINK_RAW_SCRIPT_AUTOFARM_KAMU_DISINI")

-- Auto Open First Tab
if Tabs[1] then Pages[1].Visible = true; Tabs[1].BackgroundColor3 = Theme.Accent; Tabs[1].TextColor3 = Theme.Main; Tabs[1].UIStroke.Transparency = 0 end
