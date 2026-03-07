-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- [[ ALPHA PROJECT HUB - v5.5 FIX ]] --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TS = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

-- Remotes (Pastikan Path ini benar di game kamu)
local PlaceRemote = RS:WaitForChild("Remotes"):WaitForChild("PlayerPlaceItem")
local FistRemote = RS:WaitForChild("Remotes"):WaitForChild("PlayerFist")

-- Anti-Duplikat UI
pcall(function() if getgenv().AlphaHubUI then getgenv().AlphaHubUI:Destroy() end end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AlphaProjectHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
getgenv().AlphaHubUI = ScreenGui 

local Theme = { 
    Bg = Color3.fromRGB(15, 17, 21),
    Header = Color3.fromRGB(10, 12, 14),
    Item = Color3.fromRGB(25, 28, 32),
    Text = Color3.fromRGB(240, 245, 255),
    SubText = Color3.fromRGB(160, 165, 175),
    Alpha = Color3.fromRGB(0, 255, 220) -- Neon Cyan
}

-- [[ MAIN FRAME ]] --
local Main = Instance.new("Frame", ScreenGui)
Main.BackgroundColor3 = Theme.Bg
Main.Position = UDim2.new(0.5, -275, 0.5, -185)
Main.Size = UDim2.new(0, 550, 0, 370)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Theme.Alpha

-- Logo/Minimized Button
local AlphaMinBtn = Instance.new("TextButton", ScreenGui)
AlphaMinBtn.Size = UDim2.new(0, 50, 0, 50)
AlphaMinBtn.BackgroundColor3 = Theme.Bg
AlphaMinBtn.Text = "A"
AlphaMinBtn.TextColor3 = Theme.Alpha
AlphaMinBtn.Font = Enum.Font.GothamBlack
AlphaMinBtn.TextSize = 25
AlphaMinBtn.Visible = false
Instance.new("UICorner", AlphaMinBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", AlphaMinBtn).Color = Theme.Alpha

-- Dragging Function
local function MakeDraggable(frame, trigger)
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
MakeDraggable(Main, Main)

-- [[ HEADER ]] --
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Theme.Header
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(0, 250, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Text = "ALPHA PROJECT"
Title.TextColor3 = Theme.Alpha
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 20
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- [[ CONTAINERS ]] --
local TabHolder = Instance.new("ScrollingFrame", Main)
TabHolder.Size = UDim2.new(0, 150, 1, -50)
TabHolder.Position = UDim2.new(0, 0, 0, 50)
TabHolder.BackgroundColor3 = Theme.Header
TabHolder.BorderSizePixel = 0
TabHolder.ScrollBarThickness = 0

local PageHolder = Instance.new("Frame", Main)
PageHolder.Size = UDim2.new(1, -160, 1, -60)
PageHolder.Position = UDim2.new(0, 155, 0, 55)
PageHolder.BackgroundTransparency = 1

local TabList = Instance.new("UIListLayout", TabHolder)
TabList.Padding = UDim.new(0, 5)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local Tabs = {}
local Pages = {}

-- [[ TAB CREATOR ]] --
local function NewTab(name)
    local TBtn = Instance.new("TextButton", TabHolder)
    TBtn.Size = UDim2.new(0.9, 0, 0, 35)
    TBtn.BackgroundColor3 = Theme.Item
    TBtn.Text = name
    TBtn.TextColor3 = Theme.SubText
    TBtn.Font = Enum.Font.GothamBold
    TBtn.TextSize = 12
    Instance.new("UICorner", TBtn)
    
    local Page = Instance.new("ScrollingFrame", PageHolder)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.Visible = false
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Theme.Alpha
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

    TBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(Pages) do v.Visible = false end
        for _, v in pairs(Tabs) do 
            TS:Create(v, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Item, TextColor3 = Theme.SubText}):Play()
        end
        Page.Visible = true
        TS:Create(TBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Alpha, TextColor3 = Theme.Bg}):Play()
    end)

    table.insert(Tabs, TBtn)
    table.insert(Pages, Page)
    return Page
end

-- [[ TAB 1: SMART PBNB ]] --
local PBNB = NewTab("Smart PBNB")

-- PBNB Logic & UI
_G.AutoPBNB = false; _G.Targets = {}; _G.B_ID = 5; _G.H_Amt = 3

local function CreateInput(parent, txt, gVar, def)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, 30); f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(0.6, 0, 1, 0); l.Text = txt; l.TextColor3 = Theme.Text; l.Font = Enum.Font.Gotham; l.TextSize = 12; l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left
    local b = Instance.new("TextBox", f); b.Size = UDim2.new(0.3, 0, 0.8, 0); b.Position = UDim2.new(0.6, 0, 0.1, 0); b.Text = tostring(def); b.BackgroundColor3 = Theme.Item; b.TextColor3 = Theme.Alpha; b.Font = Enum.Font.GothamBold; b.TextSize = 12; Instance.new("UICorner", b)
    b.FocusLost:Connect(function() _G[gVar] = tonumber(b.Text) or def end)
end

CreateInput(PBNB, "Block ID:", "B_ID", 5)
CreateInput(PBNB, "Hit Amount:", "H_Amt", 3)

-- Grid Selector
local GridBox = Instance.new("Frame", PBNB)
GridBox.Size = UDim2.new(1, 0, 0, 160); GridBox.BackgroundColor3 = Theme.Item; Instance.new("UICorner", GridBox)
local GInner = Instance.new("Frame", GridBox)
GInner.Size = UDim2.new(0, 140, 0, 140); GInner.Position = UDim2.new(0.5, -70, 0.5, -70); GInner.BackgroundTransparency = 1
local GLat = Instance.new("UIGridLayout", GInner); GLat.CellSize = UDim2.new(0, 24, 0, 24); GLat.CellPadding = UDim2.new(0, 4, 0, 4)

for y = 2, -2, -1 do
    for x = -2, 2 do
        local b = Instance.new("TextButton", GInner); b.Text = (x==0 and y==0) and "A" or ""
        b.BackgroundColor3 = (x==0 and y==0) and Theme.Alpha or Theme.Bg; b.TextColor3 = Theme.Text; b.Font = Enum.Font.GothamBold; b.TextSize = 10; Instance.new("UICorner", b)
        if x ~= 0 or y ~= 0 then
            local act = false
            b.MouseButton1Click:Connect(function()
                act = not act
                if act then table.insert(_G.Targets, {X=x, Y=y}); b.BackgroundColor3 = Theme.Alpha; b.TextColor3 = Theme.Bg
                else for i,v in ipairs(_G.Targets) do if v.X==x and v.Y==y then table.remove(_G.Targets, i) break end end b.BackgroundColor3 = Theme.Bg; b.TextColor3 = Theme.Text end
            end)
        end
    end
end

-- Start Button
local SBtn = Instance.new("TextButton", PBNB)
SBtn.Size = UDim2.new(1, 0, 0, 40); SBtn.Text = "START PBNB"; SBtn.BackgroundColor3 = Theme.Item; SBtn.TextColor3 = Theme.Alpha; SBtn.Font = Enum.Font.GothamBold; Instance.new("UICorner", SBtn)
SBtn.MouseButton1Click:Connect(function()
    _G.AutoPBNB = not _G.AutoPBNB
    SBtn.Text = _G.AutoPBNB and "STOP PBNB" or "START PBNB"
    TS:Create(SBtn, TweenInfo.new(0.3), {BackgroundColor3 = _G.AutoPBNB and Theme.Alpha or Theme.Item, TextColor3 = _G.AutoPBNB and Theme.Bg or Theme.Alpha}):Play()
end)

-- [[ PBNB ENGINE ]] --
task.spawn(function()
    while true do
        if _G.AutoPBNB and #_G.Targets > 0 then
            local Char = LP.Character; local Root = Char and Char:FindFirstChild("HumanoidRootPart")
            if Root then
                local cp = Vector2.new(math.floor(Root.Position.X/4.5 + 0.5), math.floor(Root.Position.Y/4.5 + 0.5))
                for _, o in ipairs(_G.Targets) do
                    pcall(function() PlaceRemote:FireServer(Vector2.new(cp.X+o.X, cp.Y+o.Y), _G.B_ID) end)
                    task.wait(0.12)
                end
                task.wait(0.2)
                for i = 1, _G.H_Amt do
                    for _, o in ipairs(_G.Targets) do
                        pcall(function() FistRemote:FireServer(Vector2.new(cp.X+o.X, cp.Y+o.Y)) end)
                        task.wait(0.08)
                    end
                end
            end
        end
        task.wait(0.2)
    end
end)

-- [[ TAB LAIN (GITHUB) ]] --
local function ExternalTab(name, link)
    local P = NewTab(name)
    local l = Instance.new("TextLabel", P); l.Size = UDim2.new(1,0,0,30); l.Text = "Click Tab to Load GitHub Script"; l.TextColor3 = Theme.SubText; l.BackgroundTransparency = 1
end

ExternalTab("Auto Farm", "")
ExternalTab("Factory", "")

-- [[ FIX: AUTO SHOW FIRST TAB ]] --
task.wait(0.1)
if Tabs[1] then
    -- Trigger visual klik manual
    Tabs[1].BackgroundColor3 = Theme.Alpha
    Tabs[1].TextColor3 = Theme.Bg
    Pages[1].Visible = true
end
