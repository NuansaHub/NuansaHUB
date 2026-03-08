-- [[ ALPHA PROJECT - ZONHUB STYLE AUTO FARM ]] --

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TweenService")
local LP = Players.LocalPlayer

-- Remotes
local PlaceRemote = RS:WaitForChild("Remotes"):WaitForChild("PlayerPlaceItem")
local FistRemote = RS:WaitForChild("Remotes"):WaitForChild("PlayerFist")

-- Cari Halaman "Auto Farm"
local ScreenGui = getgenv().AlphaProjectUI
if not ScreenGui then warn("Alpha Project UI tidak ditemukan!") return end
local Page = ScreenGui:FindFirstChild("Auto FarmPage", true)
if not Page then warn("Halaman Auto Farm tidak ditemukan!") return end

for _, child in pairs(Page:GetChildren()) do
    if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then child:Destroy() end
end

-- [[ VARIABEL GLOBAL FARMING ]] --
_G.Farm_Active = false
_G.Farm_BlockID = 5       
_G.Farm_PlaceDelay = 0.15 
_G.Farm_HitDelay = 0.13   
_G.Farm_HitCount = 3      
_G.Farm_SlotIndex = 1     
_G.Farm_Targets = {}

local Theme = {
    Main = Color3.fromRGB(15, 17, 20),    -- Warna Paling Gelap (Background Tombol)
    Item = Color3.fromRGB(30, 33, 38),    -- Warna Abu Gelap (Background Baris)
    Accent = Color3.fromRGB(0, 255, 220), -- Warna Neon
    Text = Color3.fromRGB(240, 245, 255),
    SubText = Color3.fromRGB(160, 165, 175)
}

local SlotInputBox = nil

-- [[ 0. TOMBOL START (DI ATAS) ]] --
local StartFrame = Instance.new("Frame", Page)
StartFrame.Size = UDim2.new(1, -10, 0, 45); StartFrame.BackgroundTransparency = 1; StartFrame.ZIndex = 1

local StartBtn = Instance.new("TextButton", StartFrame)
StartBtn.Size = UDim2.new(1, 0, 1, 0); StartBtn.BackgroundColor3 = Theme.Main
StartBtn.Text = "AUTO FARM : OFF"; StartBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
StartBtn.Font = Enum.Font.GothamBlack; StartBtn.TextSize = 14; Instance.new("UICorner", StartBtn).CornerRadius = UDim.new(0, 8)
local StartStroke = Instance.new("UIStroke", StartBtn); StartStroke.Color = Color3.fromRGB(255, 80, 80); StartStroke.Thickness = 1.5

StartBtn.MouseButton1Click:Connect(function()
    _G.Farm_Active = not _G.Farm_Active
    if _G.Farm_Active then
        StartBtn.Text = "AUTO FARM : ON"
        StartBtn.TextColor3 = Theme.Accent; StartStroke.Color = Theme.Accent
        TS:Create(StartBtn, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Item}):Play()
    else
        StartBtn.Text = "AUTO FARM : OFF"
        StartBtn.TextColor3 = Color3.fromRGB(255, 80, 80); StartStroke.Color = Color3.fromRGB(255, 80, 80)
        TS:Create(StartBtn, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Main}):Play()
    end
end)

-- [[ 1. SISTEM INVENTORY & DROPDOWN (ZONHUB STYLE + SAPLING FIX) ]] --
local function GetInventoryItems()
    local items = {}
    pcall(function()
        local RS = game:GetService("ReplicatedStorage")
        local InventoryModule = require(RS.Modules.Inventory)
        local ItemsManager = require(RS.Managers.ItemsManager)

        for slotIndex, itemData in pairs(InventoryModule.Stacks) do
            if type(itemData) == "table" and itemData.Id then
                local amount = itemData.Amount or 1
                local itemStringID = itemData.Id 
                local dataInfo = ItemsManager.RequestItemData(itemStringID)
                local realName = (dataInfo and dataInfo.Name) and dataInfo.Name or itemStringID
                
                -- [!] FIX SAPLING: Meniru cara kerja UI game aslinya
                if type(itemStringID) == "string" and string.sub(itemStringID, -8) == "_sapling" then
                    -- Pastikan tidak dobel kata Sapling-nya
                    if not string.match(string.lower(realName), "sapling") then
                        realName = realName .. " Sapling"
                    end
                end
                
                -- Format text agar lebih bersih di list
                local displayName = realName .. " [" .. tostring(slotIndex) .. "]"
                if not items[displayName] then items[displayName] = slotIndex end
            end
        end
    end)
    if next(items) == nil then items["Tas Kosong / Loading"] = nil end
    return items
end
-- Baris Dropdown Utama
local DropRow = Instance.new("Frame", Page)
DropRow.Size = UDim2.new(1, -10, 0, 35)
DropRow.BackgroundColor3 = Theme.Item
Instance.new("UICorner", DropRow).CornerRadius = UDim.new(0, 6)
DropRow.ZIndex = 50 -- ZIndex tinggi agar dropdown melayang di atas segalanya

local DropLbl = Instance.new("TextLabel", DropRow)
DropLbl.Size = UDim2.new(0.5, 0, 1, 0); DropLbl.Position = UDim2.new(0, 10, 0, 0)
DropLbl.Text = "Target Farm Block"; DropLbl.TextColor3 = Theme.Text
DropLbl.Font = Enum.Font.Gotham; DropLbl.TextSize = 12; DropLbl.BackgroundTransparency = 1; DropLbl.TextXAlignment = Enum.TextXAlignment.Left

local DropBtn = Instance.new("TextButton", DropRow)
DropBtn.Size = UDim2.new(0.45, -10, 0.8, 0); DropBtn.Position = UDim2.new(0.55, 0, 0.1, 0)
DropBtn.BackgroundColor3 = Theme.Main; DropBtn.Text = "Select Block..."
DropBtn.TextColor3 = Theme.SubText; DropBtn.Font = Enum.Font.Gotham; DropBtn.TextSize = 11
Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0, 6)

-- List Dropdown Floating (Melayang)
local DropList = Instance.new("ScrollingFrame", DropRow)
DropList.Size = UDim2.new(0.45, -10, 0, 120); DropList.Position = UDim2.new(0.55, 0, 1.1, 0)
DropList.BackgroundColor3 = Theme.Main; DropList.Visible = false
DropList.BorderSizePixel = 0; DropList.ScrollBarThickness = 2
DropList.ZIndex = 100 -- Sangat tinggi agar tidak tertimpa UI bawah
Instance.new("UICorner", DropList).CornerRadius = UDim.new(0, 6)

local DropLayout = Instance.new("UIListLayout", DropList)
DropLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", DropList).PaddingTop = UDim.new(0, 5)

local function RefreshDropdown()
    for _, child in pairs(DropList:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    
    for displayName, slotIndex in pairs(GetInventoryItems()) do
        local ItemBtn = Instance.new("TextButton", DropList)
        ItemBtn.Size = UDim2.new(1, 0, 0, 25); ItemBtn.BackgroundTransparency = 1
        ItemBtn.Text = displayName; ItemBtn.TextColor3 = Theme.SubText
        ItemBtn.Font = Enum.Font.Gotham; ItemBtn.TextSize = 11; ItemBtn.ZIndex = 101
        
        ItemBtn.MouseButton1Click:Connect(function()
            _G.Farm_SlotIndex = slotIndex 
            DropBtn.Text = displayName
            
            if SlotInputBox then SlotInputBox.Text = tostring(slotIndex) end
            DropList.Visible = false
        end)
    end
    DropList.CanvasSize = UDim2.new(0, 0, 0, DropLayout.AbsoluteContentSize.Y + 10)
end

DropBtn.MouseButton1Click:Connect(function() 
    if not DropList.Visible then RefreshDropdown() end
    DropList.Visible = not DropList.Visible 
end)
RefreshDropdown()

-- [[ 2 & 3. SETTINGS: MANUAL INPUT & DELAY (ZONHUB STYLE) ]] --
local function CreateSetting(label, defaultVal, globalVar)
    local Frame = Instance.new("Frame", Page)
    Frame.Size = UDim2.new(1, -10, 0, 35)
    Frame.BackgroundColor3 = Theme.Item -- Background baris abu-abu
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    Frame.ZIndex = 1 -- ZIndex rendah agar dropdown bisa melayang di atasnya
    
    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size = UDim2.new(0.5, 0, 1, 0); Lbl.Position = UDim2.new(0, 10, 0, 0)
    Lbl.Text = label; Lbl.TextColor3 = Theme.Text; Lbl.Font = Enum.Font.Gotham; Lbl.TextSize = 12
    Lbl.BackgroundTransparency = 1; Lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local Box = Instance.new("TextBox", Frame)
    Box.Size = UDim2.new(0.45, -10, 0.8, 0); Box.Position = UDim2.new(0.55, 0, 0.1, 0)
    Box.BackgroundColor3 = Theme.Main; Box.TextColor3 = Theme.Accent
    Box.Font = Enum.Font.GothamBold; Box.TextSize = 12; Box.Text = tostring(defaultVal); Box.ZIndex = 1
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)
    
    Box.FocusLost:Connect(function() _G[globalVar] = tonumber(Box.Text) or defaultVal end)
    return Box 
end

SlotInputBox = CreateSetting("Manual Slot Tas (Xeno):", _G.Farm_SlotIndex, "Farm_SlotIndex") 
CreateSetting("Place Delay (Detik):", _G.Farm_PlaceDelay, "Farm_PlaceDelay")
CreateSetting("Hit Delay (Detik):", _G.Farm_HitDelay, "Farm_HitDelay")
CreateSetting("Hit Count (Pukulan):", _G.Farm_HitCount, "Farm_HitCount")

-- [[ 4. AUTO COLLECT (MAGNET) TOGGLE ]] --
_G.AutoCollect = false
local CollectFrame = Instance.new("Frame", Page)
CollectFrame.Size = UDim2.new(1, -10, 0, 35)
CollectFrame.BackgroundColor3 = Theme.Item 
Instance.new("UICorner", CollectFrame).CornerRadius = UDim.new(0, 6)
CollectFrame.ZIndex = 1

local CollectLbl = Instance.new("TextLabel", CollectFrame)
CollectLbl.Size = UDim2.new(0.6, 0, 1, 0); CollectLbl.Position = UDim2.new(0, 10, 0, 0)
CollectLbl.Text = "Auto Collect (Magnet)"; CollectLbl.TextColor3 = Theme.Text
CollectLbl.Font = Enum.Font.Gotham; CollectLbl.TextSize = 12
CollectLbl.BackgroundTransparency = 1; CollectLbl.TextXAlignment = Enum.TextXAlignment.Left

local CollectBtn = Instance.new("TextButton", CollectFrame)
CollectBtn.Size = UDim2.new(0, 50, 0, 22); CollectBtn.Position = UDim2.new(1, -60, 0.5, -11)
CollectBtn.BackgroundColor3 = Theme.Main; CollectBtn.Text = "OFF"
CollectBtn.TextColor3 = Color3.fromRGB(255, 80, 80); CollectBtn.Font = Enum.Font.GothamBold; CollectBtn.TextSize = 10
Instance.new("UICorner", CollectBtn).CornerRadius = UDim.new(0, 4)
local CollectStroke = Instance.new("UIStroke", CollectBtn); CollectStroke.Color = Color3.fromRGB(255, 80, 80); CollectStroke.Thickness = 1

CollectBtn.MouseButton1Click:Connect(function()
    _G.AutoCollect = not _G.AutoCollect
    if _G.AutoCollect then
        CollectBtn.Text = "ON"; CollectBtn.TextColor3 = Theme.Accent; CollectStroke.Color = Theme.Accent
        TS:Create(CollectBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Item}):Play()
    else
        CollectBtn.Text = "OFF"; CollectBtn.TextColor3 = Color3.fromRGB(255, 80, 80); CollectStroke.Color = Color3.fromRGB(255, 80, 80)
        TS:Create(CollectBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Main}):Play()
    end
end)

-- [[ 4. SELECT FARM TILES (GRID SELECTOR) ]] --
local GridBox = Instance.new("Frame", Page)
GridBox.Size = UDim2.new(1, -10, 0, 180); GridBox.BackgroundColor3 = Theme.Item; Instance.new("UICorner", GridBox).CornerRadius = UDim.new(0, 6)
GridBox.ZIndex = 1
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

-- [[ ENGINE AUTO COLLECT & AUTO FARM (PRIORITY SYSTEM) ]] --

-- Fungsi Pintar untuk Mengambil Barang (Bypass Xeno)
local function CollectDrops()
    local dropsFolder = workspace:FindFirstChild("Drops")
    if not dropsFolder then return end
    
    local drops = dropsFolder:GetChildren()
    if #drops == 0 then return end -- Kalau tidak ada barang, batalkan
    
    local Char = LP.Character
    local Root = Char and Char:FindFirstChild("HumanoidRootPart")
    if not Root then return end
    
    -- Simpan posisi asli karaktermu sebelum memungut barang
    local originalCFrame = Root.CFrame
    local hasCollected = false
    
    for _, item in pairs(drops) do
        if not _G.Farm_Active or not _G.AutoCollect then break end
        
        local targetPart = nil
        if item:IsA("BasePart") then 
            targetPart = item
        elseif item:IsA("Model") and item.PrimaryPart then 
            targetPart = item.PrimaryPart
        else 
            targetPart = item:FindFirstChildWhichIsA("BasePart") 
        end
        
        if targetPart then
            hasCollected = true
            
            -- [!] TRIK XENO: Teleportasi fisik langsung ke atas barang
            Root.CFrame = targetPart.CFrame
            
            -- Coba pakai magnet eksploit jika executor mendukung
            if firetouchinterest then
                pcall(function()
                    firetouchinterest(Root, targetPart, 0)
                    firetouchinterest(Root, targetPart, 1)
                end)
            end
            
            -- Jeda 0.15 detik per barang agar server mendeteksi "sentuhan" kaki karaktermu
            task.wait(0.15) 
        end
    end
    
    -- Setelah tas penuh/semua diambil, teleportasi KEMBALI ke posisi semula untuk lanjut farming
    if hasCollected then
        Root.CFrame = originalCFrame
        task.wait(0.1) -- Jeda stabilisasi
    end
end

local function GetCurrentGrid()
    local Char = LP.Character
    local Root = Char and Char:FindFirstChild("HumanoidRootPart")
    return Root and Vector2.new(math.floor(Root.Position.X / 4.5 + 0.5), math.floor(Root.Position.Y / 4.5 + 0.5)) or Vector2.new(0,0)
end

-- MESIN UTAMA
task.spawn(function()
    while true do
        if _G.Farm_Active and #_G.Farm_Targets > 0 then
            
            -- [!] PRIORITAS 1: CEK & AMBIL BARANG SEBELUM MENARUH BLOK
            if _G.AutoCollect then
                CollectDrops()
            end
            
            local cp = GetCurrentGrid()
            
            -- PHASE 1: FORCE PLACE
            for _, o in ipairs(_G.Farm_Targets) do
                if not _G.Farm_Active then break end
                local tx, ty = math.floor(cp.X + o.X), math.floor(cp.Y + o.Y)
                
                if _G.Farm_SlotIndex ~= nil then 
                    pcall(function() PlaceRemote:FireServer(Vector2.new(tx, ty), _G.Farm_SlotIndex) end)
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
                    pcall(function() FistRemote:FireServer(Vector2.new(tx, ty)) end)
                    task.wait(_G.Farm_HitDelay)
                end
            end
            
            -- [!] PRIORITAS 2: CEK & AMBIL BARANG LAGI SETELAH BLOK HANCUR
            if _G.AutoCollect then
                CollectDrops()
            end
            
        end
        task.wait(0.1)
    end
end)
