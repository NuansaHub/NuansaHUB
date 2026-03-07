
-- [[ ALPHA PROJECT - ADVANCED AUTO FARM MODULE ]] --

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TweenService")
local LP = Players.LocalPlayer

-- Remotes (Sesuaikan dengan game kamu)
local PlaceRemote = RS:WaitForChild("Remotes"):WaitForChild("PlayerPlaceItem")
local FistRemote = RS:WaitForChild("Remotes"):WaitForChild("PlayerFist")

-- Cari Halaman "Auto Farm" di UI Alpha Project
local ScreenGui = getgenv().AlphaProjectUI
if not ScreenGui then warn("Alpha Project UI tidak ditemukan!") return end
local Page = ScreenGui:FindFirstChild("Auto FarmPage", true)
if not Page then warn("Halaman Auto Farm tidak ditemukan!") return end

-- Bersihkan isi halaman jika module di-execute ulang
for _, child in pairs(Page:GetChildren()) do
    if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then child:Destroy() end
end

-- [[ VARIABEL GLOBAL FARMING ]] --
_G.Farm_Active = false
_G.Farm_BlockID = 5       -- Default ID
_G.Farm_PlaceDelay = 0.15 -- Default Delay Place
_G.Farm_HitDelay = 0.08   -- Default Delay Hit
_G.Farm_HitCount = 3      -- Default Hit
_G.Farm_SlotIndex = nil -- Default ID
_G.Farm_Targets = {}

local Theme = {
    Main = Color3.fromRGB(15, 17, 20),
    Accent = Color3.fromRGB(0, 255, 220), 
    Item = Color3.fromRGB(25, 28, 32),
    Text = Color3.fromRGB(240, 245, 255),
    SubText = Color3.fromRGB(160, 165, 175)
}

-- [[ 1. SISTEM INVENTORY & DROPDOWN (SLOT INDEX MODE) ]] --
local function GetInventoryItems()
    local items = {}
    
    pcall(function()
        local RS = game:GetService("ReplicatedStorage")
        local InventoryModule = require(RS.Modules.Inventory)
        local ItemsManager = require(RS.Managers.ItemsManager)

        -- KITA MEMBACA KEY 'slotIndex' (Nomor kotak tas)
        for slotIndex, itemData in pairs(InventoryModule.Stacks) do
            if type(itemData) == "table" and itemData.Id then
                local amount = itemData.Amount or 1
                local itemStringID = itemData.Id 
                
                local dataInfo = ItemsManager.RequestItemData(itemStringID)
                local realName = (dataInfo and dataInfo.Name) and dataInfo.Name or itemStringID
                
                -- Tampilan Dropdown: Dirt (x50) [Slot: 12]
                local displayName = realName .. " (x" .. amount .. ") [Slot: " .. tostring(slotIndex) .. "]"
                
                -- KITA SIMPAN NOMOR SLOT-NYA! Inilah yang diminta server.
                if not items[displayName] then
                    items[displayName] = slotIndex
                end
            end
        end
    end)
    
    if next(items) == nil then
        items["No Items Found"] = nil
    end
    
    return items
end

-- UI Dropdown
local DropdownFrame = Instance.new("Frame", Page)
DropdownFrame.Size = UDim2.new(1, -10, 0, 35); DropdownFrame.BackgroundColor3 = Theme.Item; Instance.new("UICorner", DropdownFrame)

local DropBtn = Instance.new("TextButton", DropdownFrame)
DropBtn.Size = UDim2.new(1, 0, 1, 0); DropBtn.BackgroundTransparency = 1; DropBtn.Text = "Refresh & Select Block ▼"
DropBtn.TextColor3 = Theme.Accent; DropBtn.Font = Enum.Font.GothamBold; DropBtn.TextSize = 12

local DropList = Instance.new("ScrollingFrame", Page)
DropList.Size = UDim2.new(1, -10, 0, 150); DropList.BackgroundColor3 = Theme.Item; DropList.Visible = false
DropList.BorderSizePixel = 0; DropList.ScrollBarThickness = 2; Instance.new("UICorner", DropList)
local DropLayout = Instance.new("UIListLayout", DropList); DropLayout.Padding = UDim.new(0, 2)
DropList.ZIndex = 5 -- Supaya tidak tertimpa UI bawahnya

-- Fungsi untuk mengisi/me-refresh daftar item
local function RefreshDropdown()
    for _, child in pairs(DropList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    for displayName, slotIndex in pairs(GetInventoryItems()) do
        local ItemBtn = Instance.new("TextButton", DropList)
        ItemBtn.Size = UDim2.new(1, 0, 0, 25); ItemBtn.BackgroundColor3 = Theme.Main
        ItemBtn.Text = " " .. displayName; ItemBtn.TextColor3 = Theme.Text
        ItemBtn.Font = Enum.Font.Gotham; ItemBtn.TextSize = 11; Instance.new("UICorner", ItemBtn)
        ItemBtn.TextXAlignment = Enum.TextXAlignment.Left; ItemBtn.ZIndex = 6
        
        ItemBtn.MouseButton1Click:Connect(function()
            -- Simpan Nomor Slot ke variabel
            _G.Farm_SlotIndex = slotIndex 
            DropBtn.Text = "Selected: " .. displayName .. " ▼"
            DropList.Visible = false
        end)
    end
    DropList.CanvasSize = UDim2.new(0, 0, 0, DropLayout.AbsoluteContentSize.Y + 5)
end

-- Klik tombol dropdown: Refresh tas dulu, baru munculkan list
DropBtn.MouseButton1Click:Connect(function() 
    if not DropList.Visible then
        RefreshDropdown()
    end
    DropList.Visible = not DropList.Visible 
end)

-- Panggil refresh sekali saat UI pertama kali terbuka
RefreshDropdown()

-- [[ 3 & 4. SETTINGS: DELAY & HIT COUNT ]] --
local function CreateSetting(label, defaultVal, globalVar)
    local Frame = Instance.new("Frame", Page)
    Frame.Size = UDim2.new(1, -10, 0, 30); Frame.BackgroundTransparency = 1
    
    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size = UDim2.new(0.6, 0, 1, 0); Lbl.Text = label; Lbl.TextColor3 = Theme.Text; Lbl.Font = Enum.Font.Gotham; Lbl.TextSize = 12; Lbl.BackgroundTransparency = 1; Lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local Box = Instance.new("TextBox", Frame)
    Box.Size = UDim2.new(0.35, 0, 0.8, 0); Box.Position = UDim2.new(0.65, 0, 0.1, 0)
    Box.BackgroundColor3 = Theme.Item; Box.TextColor3 = Theme.Accent; Box.Font = Enum.Font.GothamBold; Box.TextSize = 12; Box.Text = tostring(defaultVal); Instance.new("UICorner", Box)
    
    Box.FocusLost:Connect(function() _G[globalVar] = tonumber(Box.Text) or defaultVal end)
end

CreateSetting("Place Delay (Detik):", _G.Farm_PlaceDelay, "Farm_PlaceDelay")
CreateSetting("Hit Delay (Detik):", _G.Farm_HitDelay, "Farm_HitDelay")
CreateSetting("Hit Count (Pukulan):", _G.Farm_HitCount, "Farm_HitCount")

-- [[ 5. SELECT FARM TILES (GRID SELECTOR) ]] --
local GridBox = Instance.new("Frame", Page)
GridBox.Size = UDim2.new(1, -10, 0, 180); GridBox.BackgroundColor3 = Theme.Item; Instance.new("UICorner", GridBox)
local GInner = Instance.new("Frame", GridBox)
GInner.Size = UDim2.new(0, 160, 0, 160); GInner.Position = UDim2.new(0.5, -80, 0.5, -80); GInner.BackgroundTransparency = 1
local GLat = Instance.new("UIGridLayout", GInner); GLat.CellSize = UDim2.new(0, 28, 0, 28); GLat.CellPadding = UDim2.new(0, 4, 0, 4)

for y = 2, -2, -1 do
    for x = -2, 2 do
        local b = Instance.new("TextButton", GInner); b.Text = (x==0 and y==0) and "ME" or ""
        b.BackgroundColor3 = (x==0 and y==0) and Theme.Accent or Theme.Main; b.TextColor3 = Theme.Main; b.Font = Enum.Font.GothamBold; b.TextSize = 10; Instance.new("UICorner", b)
        if x ~= 0 or y ~= 0 then
            local act = false
            b.MouseButton1Click:Connect(function()
                act = not act
                if act then 
                    table.insert(_G.Farm_Targets, {X=x, Y=y})
                    TS:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent}):Play()
                else 
                    for i,v in ipairs(_G.Farm_Targets) do if v.X==x and v.Y==y then table.remove(_G.Farm_Targets, i) break end end 
                    TS:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Main}):Play()
                end
            end)
        end
    end
end

-- [[ TOMBOL START/STOP ]] --
local StartBtn = Instance.new("TextButton", Page)
StartBtn.Size = UDim2.new(1, -10, 0, 40); StartBtn.BackgroundColor3 = Theme.Main; StartBtn.Text = "START AUTO FARM"
StartBtn.TextColor3 = Theme.Accent; StartBtn.Font = Enum.Font.GothamBlack; StartBtn.TextSize = 14; Instance.new("UICorner", StartBtn)
local StartStroke = Instance.new("UIStroke", StartBtn); StartStroke.Color = Theme.Accent; StartStroke.Thickness = 1.5

StartBtn.MouseButton1Click:Connect(function()
    _G.Farm_Active = not _G.Farm_Active
    if _G.Farm_Active then
        StartBtn.Text = "STOP AUTO FARM"
        TS:Create(StartBtn, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.Main}):Play()
    else
        StartBtn.Text = "START AUTO FARM"
        TS:Create(StartBtn, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Main, TextColor3 = Theme.Accent}):Play()
    end
end)

-- [[ ENGINE AUTO FARM ]] --
local function GetCurrentGrid()
    local Char = LP.Character
    local Root = Char and Char:FindFirstChild("HumanoidRootPart")
    return Root and Vector2.new(math.floor(Root.Position.X / 4.5 + 0.5), math.floor(Root.Position.Y / 4.5 + 0.5)) or Vector2.new(0,0)
end

task.spawn(function()
    while true do
        if _G.Farm_Active and #_G.Farm_Targets > 0 then
            local cp = GetCurrentGrid()
            
            -- PHASE 1: FORCE PLACE
            for _, o in ipairs(_G.Farm_Targets) do
                if not _G.Farm_Active then break end
                local tx, ty = math.floor(cp.X + o.X), math.floor(cp.Y + o.Y)
                
                -- Pastikan Slot sudah dipilih
                if _G.Farm_SlotIndex ~= nil then 
                    pcall(function() 
                        -- KIRIM NOMOR SLOT KE SERVER (Persis seperti script asli gamenya)
                        PlaceRemote:FireServer(Vector2.new(tx, ty), _G.Farm_SlotIndex) 
                    end)
                end
                task.wait(_G.Farm_PlaceDelay)
            end
            
            task.wait(0.4) 
            
            -- PHASE 2: FORCE BREAK
            for i = 1, _G.Farm_HitCount do
                if not _G.Farm_Active then break end
                for _, o in ipairs(_G.Farm_Targets) do
                    if not _G.Farm_Active then break end
                    local tx, ty = math.floor(cp.X + o.X), math.floor(cp.Y + o.Y)
                    
                    pcall(function() 
                        FistRemote:FireServer(Vector2.new(tx, ty)) 
                    end)
                    task.wait(_G.Farm_HitDelay)
                end
            end
        end
        task.wait(0.1)
    end
end)
