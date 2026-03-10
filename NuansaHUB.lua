-- [[ ALPHA PROJECT - FIXED CONTROLS ]] --

local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local LP = game:GetService("Players").LocalPlayer

if getgenv().AlphaProjectUI then getgenv().AlphaProjectUI:Destroy() end

local Theme = {
    Main = Color3.fromRGB(15, 17, 20),
    Accent = Color3.fromRGB(0, 255, 220), 
    Header = Color3.fromRGB(10, 12, 14),
    Item = Color3.fromRGB(25, 28, 32),
    Text = Color3.fromRGB(240, 245, 255),
    SubText = Color3.fromRGB(160, 165, 175)
}

-- [[ UI CONSTRUCT ]] --
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "AlphaProject_Main"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling -- Penting agar urutan muncul benar
getgenv().AlphaProjectUI = ScreenGui

-- 1. Logo Kecil (Muncul saat Minimize)
local AlphaLogo = Instance.new("TextButton", ScreenGui)
AlphaLogo.Size = UDim2.new(0, 55, 0, 55)
AlphaLogo.BackgroundColor3 = Theme.Main
AlphaLogo.Position = UDim2.new(0, 50, 0, 50)
AlphaLogo.Text = "N"; AlphaLogo.TextColor3 = Theme.Accent; AlphaLogo.Font = Enum.Font.GothamBlack; AlphaLogo.TextSize = 25
AlphaLogo.Visible = false
AlphaLogo.ZIndex = 10 -- Paling depan
Instance.new("UICorner", AlphaLogo).CornerRadius = UDim.new(1, 0)
local LogoStroke = Instance.new("UIStroke", AlphaLogo); LogoStroke.Color = Theme.Accent; LogoStroke.Thickness = 2

-- 2. Main Frame
local Main = Instance.new("Frame", ScreenGui)
Main.BackgroundColor3 = Theme.Main
Main.Position = UDim2.new(0.5, -250, 0.5, -160)
Main.Size = UDim2.new(0, 500, 0, 320)
Main.BorderSizePixel = 0
Main.ZIndex = 1
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", Main); Stroke.Color = Theme.Accent; Stroke.Thickness = 1.5

-- 3. Header (Area Drag)
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Theme.Header
Header.BorderSizePixel = 0
Header.ZIndex = 2
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Header)
Title.Text = "NUANSAHUB"; Title.Font = Enum.Font.GothamBlack; Title.TextColor3 = Theme.Accent; Title.TextSize = 18
Title.Size = UDim2.new(0.5, 0, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1; Title.TextXAlignment = Enum.TextXAlignment.Left; Title.ZIndex = 3

-- 4. Bikin Segitiga Resize di Pojok Kanan Bawah
local ResizeHandle = Instance.new("TextButton", Main)
ResizeHandle.Name = "ResizeHandle"
ResizeHandle.Size = UDim2.new(0, 25, 0, 25) -- Sedikit lebih besar agar mudah diklik
ResizeHandle.Position = UDim2.new(1, -25, 1, -25) -- Pas di pojok kanan bawah
ResizeHandle.BackgroundTransparency = 1
ResizeHandle.Text = "◢" 
ResizeHandle.TextColor3 = Theme.Accent
ResizeHandle.TextSize = 20
ResizeHandle.ZIndex = 50 -- Angka tinggi agar tidak tertutup konten tab
ResizeHandle.Font = Enum.Font.GothamBold
ResizeHandle.TextXAlignment = Enum.TextXAlignment.Right
ResizeHandle.TextYAlignment = Enum.TextYAlignment.Bottom

-- 5. Logika Fungsi Resize
local function MakeResizable(frame, handle)
    local dragging = false
    local dragStart = nil
    local startSize = nil

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startSize = frame.Size
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            
            -- Hitung ukuran baru
            local newWidth = startSize.X.Offset + delta.X
            local newHeight = startSize.Y.Offset + delta.Y
            
            -- Beri batas minimal agar UI tidak terlalu kecil (Clamp)
            if newWidth < 400 then newWidth = 400 end
            if newHeight < 250 then newHeight = 250 end
            
            -- Terapkan ukuran
            frame.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- Terapkan fungsi ke Main Frame melalui handle segitiga
MakeResizable(Main, ResizeHandle)

-- [[ ALPHA PROJECT - GLOBAL PLAYER COORDINATES ]] --
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local function CreateCoordinateDisplay(character)
    if not character then return end
    
    local head = character:WaitForChild("Head", 5)
    local root = character:WaitForChild("HumanoidRootPart", 5)
    if not head or not root then return end

    if head:FindFirstChild("AlphaCoords") then
        head.AlphaCoords:Destroy()
    end

    local bg = Instance.new("BillboardGui")
    bg.Name = "AlphaCoords"
    bg.Adornee = head
    bg.Size = UDim2.new(0, 150, 0, 40)
    bg.StudsOffset = Vector3.new(0, 2.5, 0) 
    bg.AlwaysOnTop = true

    local txt = Instance.new("TextLabel", bg)
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.TextColor3 = Color3.fromRGB(0, 255, 220) -- Warna Neon Cyan
    txt.TextStrokeTransparency = 0 
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 12

    bg.Parent = head

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not character or not character.Parent or not root then
            connection:Disconnect()
            return
        end
        
        local gridX = math.floor(root.Position.X / 4.5 + 0.5)
        local gridY = math.floor(root.Position.Y / 4.5 + 0.5)
        
        txt.Text = "[ X: " .. gridX .. " | Y: " .. gridY .. " ]"
    end)
end

-- Nyalakan untuk karakter saat ini
if LP.Character then
    CreateCoordinateDisplay(LP.Character)
end

-- Mencegah penumpukan event jika NuansaHub di-execute berulang kali
if getgenv().AlphaCoordsConnection then
    getgenv().AlphaCoordsConnection:Disconnect()
end
getgenv().AlphaCoordsConnection = LP.CharacterAdded:Connect(CreateCoordinateDisplay)

-- [[ TOMBOL MINIMIZE & CLOSE ]] --
-- Close (X)
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "×"; CloseBtn.TextColor3 = Color3.new(1,1,1); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 20
CloseBtn.ZIndex = 5
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- Minimize (-)
local MinBtn = Instance.new("TextButton", Header)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -75, 0.5, -15)
MinBtn.BackgroundColor3 = Theme.Item
MinBtn.Text = "—"; MinBtn.TextColor3 = Theme.Text; MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 12
MinBtn.ZIndex = 5
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

-- [[ FUNGSI DRAG (SISTEM BARU) ]] --
local function MakeDraggable(frame, trigger)
    local dragging, dragInput, dragStart, startPos
    trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Terapkan Drag
MakeDraggable(Main, Header)
MakeDraggable(AlphaLogo, AlphaLogo)

-- [[ LOGIKA TOMBOL ]] --
CloseBtn.MouseButton1Click:Connect(function() 
    ScreenGui:Destroy(); getgenv().AlphaProjectUI = nil 
end)

MinBtn.MouseButton1Click:Connect(function() 
    Main.Visible = false; AlphaLogo.Visible = true 
end)

AlphaLogo.MouseButton1Click:Connect(function() 
    Main.Visible = true; AlphaLogo.Visible = false 
end)

-- (Bagian AddTab dan AddModule tetap sama di bawah ini...)
-- [[ NAVIGATION & MODULES ]] --
local TabHolder = Instance.new("ScrollingFrame", Main)
TabHolder.Size = UDim2.new(0, 140, 1, -55); TabHolder.Position = UDim2.new(0, 5, 0, 50)
TabHolder.BackgroundColor3 = Theme.Header; TabHolder.BorderSizePixel = 0; TabHolder.ScrollBarThickness = 0; TabHolder.ZIndex = 2
Instance.new("UIListLayout", TabHolder).Padding = UDim.new(0, 5)

local PageHolder = Instance.new("Frame", Main)
PageHolder.Size = UDim2.new(1, -155, 1, -55); PageHolder.Position = UDim2.new(0, 150, 0, 50); PageHolder.BackgroundTransparency = 1; PageHolder.ZIndex = 2

local Tabs = {}; local Pages = {}

local function AddTab(name)
    local TabBtn = Instance.new("TextButton", TabHolder)
    TabBtn.Size = UDim2.new(0.95, 0, 0, 35); TabBtn.BackgroundColor3 = Theme.Main
    TabBtn.Text = name; TabBtn.TextColor3 = Theme.Text; TabBtn.Font = Enum.Font.GothamMedium; TabBtn.TextSize = 12; TabBtn.ZIndex = 3
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
    local bStroke = Instance.new("UIStroke", TabBtn); bStroke.Color = Theme.Accent; bStroke.Transparency = 0.8

    local Page = Instance.new("ScrollingFrame", PageHolder)
    Page.Name = name .. "Page" -- [!] INI YANG DITAMBAHKAN AGAR BISA DITEMUKAN AUTOFARM
    Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1; Page.BorderSizePixel = 0; Page.ScrollBarThickness = 2; Page.ScrollBarImageColor3 = Theme.Accent; Page.ZIndex = 3
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

-- [[ MODULE LOADER ]] --
local function AddModule(parentPage, title, desc, rawLink)
    local Frame = Instance.new("Frame", parentPage)
    Frame.Size = UDim2.new(1, -10, 0, 70); Frame.BackgroundColor3 = Theme.Item; Frame.ZIndex = 4
    Instance.new("UICorner", Frame)
    Instance.new("UIStroke", Frame).Color = Theme.Accent

    local t = Instance.new("TextLabel", Frame); t.Text = title; t.Size = UDim2.new(0.6, 0, 0, 25); t.Position = UDim2.new(0, 10, 0, 5); t.TextColor3 = Theme.Accent; t.Font = Enum.Font.GothamBold; t.BackgroundTransparency = 1; t.TextXAlignment = Enum.TextXAlignment.Left; t.ZIndex = 5
    local d = Instance.new("TextLabel", Frame); d.Text = desc; d.Size = UDim2.new(0.6, 0, 0, 30); d.Position = UDim2.new(0, 10, 0, 30); d.TextColor3 = Theme.SubText; d.Font = Enum.Font.Gotham; d.TextSize = 10; d.BackgroundTransparency = 1; d.TextWrapped = true; d.TextXAlignment = Enum.TextXAlignment.Left; d.ZIndex = 5

    local Btn = Instance.new("TextButton", Frame)
    Btn.Size = UDim2.new(0.3, 0, 0, 30); Btn.Position = UDim2.new(0.65, 0, 0.5, -15); Btn.BackgroundColor3 = Theme.Accent; Btn.Text = "EXECUTE"; Btn.Font = Enum.Font.GothamBold; Btn.TextSize = 11; Btn.ZIndex = 6
    Instance.new("UICorner", Btn)

    Btn.MouseButton1Click:Connect(function()
        Btn.Text = "Loading..."
        
        -- Gunakan task.spawn agar UI tidak freeze saat loading
        task.spawn(function()
            local success, err = pcall(function() 
                loadstring(game:HttpGet(rawLink))() 
            end)
            
            if success then
                Btn.Text = "Executed ✅"
            else
                Btn.Text = "Error ❌"
                warn("ALPHA PROJECT ERROR: " .. tostring(err)) -- Muncul di F9
            end
            
            task.wait(1.5)
            Btn.Text = "EXECUTE"
        end)
    end)
end

-- SETUP TAB
local Tab1 = AddTab("Home")
local Tab2 = AddTab("Auto Farm")
local tab3 = AddTab("Misc")

AddModule(Tab1, "Welcome to NuansaHub", "Pilih tab di samping untuk melihat fitur yang tersedia.", "https://raw.githubusercontent.com/NuansaHub/NuansaHUB/refs/heads/main/Mics.lua")
AddModule(Tab2, "Main Autofarm", "Update Terbaru.", "https://raw.githubusercontent.com/NuansaHub/NuansaHUB/refs/heads/main/AutoFarm.lua")

if Tabs[1] then Pages[1].Visible = true; Tabs[1].BackgroundColor3 = Theme.Accent; Tabs[1].TextColor3 = Theme.Main; Tabs[1].UIStroke.Transparency = 0 end
