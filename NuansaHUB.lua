-- [[ ALPHA PROJECT - FULL INTEGRATED BASE v1.0 ]] --

local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local LP = game:GetService("Players").LocalPlayer

-- [[ 1. CLEANER & THEME ]] --
if getgenv().AlphaProjectUI then getgenv().AlphaProjectUI:Destroy() end

local Theme = {
    Main = Color3.fromRGB(15, 17, 20),
    Accent = Color3.fromRGB(0, 255, 220), -- Neon Cyan
    Header = Color3.fromRGB(10, 12, 14),
    Item = Color3.fromRGB(25, 28, 32),
    Text = Color3.fromRGB(240, 245, 255),
    SubText = Color3.fromRGB(160, 165, 175)
}

-- [[ 2. CORE UI SETUP ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "AlphaProject_Official"
ScreenGui.ResetOnSpawn = false
getgenv().AlphaProjectUI = ScreenGui

local Main = Instance.new("Frame", ScreenGui)
Main.Name = "MainFrame"
Main.BackgroundColor3 = Theme.Main
Main.Position = UDim2.new(0.5, -250, 0.5, -150)
Main.Size = UDim2.new(0, 500, 0, 320)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Theme.Accent; MainStroke.Thickness = 1.2; MainStroke.Transparency = 0.4

-- Header
local Header = Instance.new("Frame", Main)
Header.Name = "Header"
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

-- [[ 3. TAB & PAGE SYSTEM ]] --
local TabHolder = Instance.new("ScrollingFrame", Main)
TabHolder.Size = UDim2.new(0, 140, 1, -55); TabHolder.Position = UDim2.new(0, 5, 0, 50)
TabHolder.BackgroundColor3 = Theme.Header; TabHolder.BorderSizePixel = 0; TabHolder.ScrollBarThickness = 0
Instance.new("UIListLayout", TabHolder).Padding = UDim.new(0, 5)

local PageHolder = Instance.new("Frame", Main)
PageHolder.Size = UDim2.new(1, -155, 1, -55); PageHolder.Position = UDim2.new(0, 150, 0, 50); PageHolder.BackgroundTransparency = 1

local Tabs = {}; local Pages = {}

local function AddTab(name)
    local TabBtn = Instance.new("TextButton", TabHolder)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 35); TabBtn.BackgroundColor3 = Theme.Main
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

-- [[ 4. GITHUB LOADER FUNCTION ]] --
local function AddCloudModule(parentPage, title, description, rawUrl)
    local ModuleFrame = Instance.new("Frame", parentPage)
    ModuleFrame.Size = UDim2.new(1, -10, 0, 80); ModuleFrame.BackgroundColor3 = Theme.Item; ModuleFrame.BorderSizePixel = 0
    Instance.new("UICorner", ModuleFrame).CornerRadius = UDim.new(0, 8)
    local mStroke = Instance.new("UIStroke", ModuleFrame); mStroke.Color = Theme.Accent; mStroke.Transparency = 0.8

    local ModTitle = Instance.new("TextLabel", ModuleFrame)
    ModTitle.Text = title; ModTitle.Font = Enum.Font.GothamBold; ModTitle.TextColor3 = Theme.Accent; ModTitle.TextSize = 13
    ModTitle.Size = UDim2.new(0.6, 0, 0, 25); ModTitle.Position = UDim2.new(0, 10, 0, 5); ModTitle.BackgroundTransparency = 1; ModTitle.TextXAlignment = Enum.TextXAlignment.Left

    local ModDesc = Instance.new("TextLabel", ModuleFrame)
    ModDesc.Text = description; ModDesc.Font = Enum.Font.Gotham; ModDesc.TextColor3 = Theme.SubText; ModDesc.TextSize = 10
    ModDesc.Size = UDim2.new(0.6, 0, 0, 40); ModDesc.Position = UDim2.new(0, 10, 0, 30); ModDesc.BackgroundTransparency = 1; ModDesc.TextWrapped = true; ModDesc.TextXAlignment = Enum.TextXAlignment.Left; ModDesc.TextYAlignment = Enum.TextYAlignment.Top

    local LoadBtn = Instance.new("TextButton", ModuleFrame)
    LoadBtn.Size = UDim2.new(0.32, 0, 0, 32); LoadBtn.Position = UDim2.new(0.65, 0, 0.5, -16); LoadBtn.BackgroundColor3 = Theme.Accent
    LoadBtn.Text = "LOAD SCRIPT"; LoadBtn.TextColor3 = Theme.Main; LoadBtn.Font = Enum.Font.GothamBold; LoadBtn.TextSize = 11; Instance.new("UICorner", LoadBtn)

    LoadBtn.MouseButton1Click:Connect(function()
        LoadBtn.Text = "LOADING..."
        task.spawn(function()
            local success, err = pcall(function()
                local code = game:HttpGet(rawUrl)
                loadstring(code)()
            end)
            if success then
                LoadBtn.Text = "ACTIVE ✅"; LoadBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            else
                LoadBtn.Text = "ERROR ❌"; LoadBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                warn("Error: " .. tostring(err))
            end
            task.wait(2); LoadBtn.Text = "LOAD SCRIPT"; LoadBtn.BackgroundColor3 = Theme.Accent
        end)
    end)
end

-- [[ 5. SETUP MODULES ]] --
local Home = AddTab("Home")
local Farm = AddTab("Auto Farm")

-- Isi Tab Home
local Welcome = Instance.new("TextLabel", Home)
Welcome.Size = UDim2.new(1,0,0,30); Welcome.BackgroundTransparency = 1; Welcome.Text = "Welcome to Alpha Project"; Welcome.TextColor3 = Theme.Text; Welcome.Font = Enum.Font.Gotham; Welcome.TextSize = 14

-- Isi Tab Auto Farm (Ganti URL di bawah dengan link RAW GitHub kamu)
AddCloudModule(Farm, "Auto Farm", "Auto Put and Break and Collect", "https://raw.githubusercontent.com/NuansaHub/NuansaHUB/refs/heads/main/AutoFarm.lua")
AddCloudModule(Farm, "Auto Plant", "Menanam bibit secara otomatis di area kosong.", "")

-- Auto Select Tab Pertama
if Pages[1] then Pages[1].Visible = true; Tabs[1].BackgroundColor3 = Theme.Accent; Tabs[1].TextColor3 = Theme.Main; Tabs[1].UIStroke.Transparency = 0 end
