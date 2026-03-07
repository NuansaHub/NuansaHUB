-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ALPHA PROJECT v5.5 [FINAL - NAME TAG & DRAGGABLE]
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local PlaceRemote = RS:WaitForChild("Remotes"):WaitForChild("PlayerPlaceItem")
local FistRemote = RS:WaitForChild("Remotes"):WaitForChild("PlayerFist")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- DATA & CONFIG
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
_G.AutoPBNB = false
_G.SelectedTargets = {} 
_G.SelectedBlockID = 5  
_G.HitAmount = 3        

-- 1. UI DASAR (Dibuat paling awal agar bisa jadi Parent)
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
local ScreenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
ScreenGui.Name = "AlphaProjectFinal"; ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 480, 0, 380); Main.Position = UDim2.new(0.5, -240, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Main.Active = true
Instance.new("UICorner", Main); Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 200)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 2. MINIMIZE SYSTEM (Logo Kecil & Tombol)
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Logo Kecil (Muncul saat menu ditutup)
local MinLogo = Instance.new("ImageButton", ScreenGui)
MinLogo.Name = "MinimizeLogo"; MinLogo.Size = UDim2.new(0, 50, 0, 50)
MinLogo.Position = UDim2.new(0, 20, 0.5, -25); MinLogo.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MinLogo.Visible = false; Instance.new("UICorner", MinLogo).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", MinLogo); Stroke.Color = Color3.fromRGB(0, 255, 200)

local MinText = Instance.new("TextLabel", MinLogo)
MinText.Size = UDim2.new(1, 0, 1, 0); MinText.BackgroundTransparency = 1; MinText.Text = "A"
MinText.TextColor3 = Color3.fromRGB(0, 255, 200); MinText.Font = 3; MinText.TextSize = 25

-- Tombol Minimize di dalam Menu (Sebelah X)
local MinBtn = Instance.new("TextButton", Main)
MinBtn.Size = UDim2.new(0, 30, 0, 30); MinBtn.Position = UDim2.new(1, -70, 0, 5)
MinBtn.Text = "-"; MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.BackgroundTransparency = 1; MinBtn.TextSize = 35

MinBtn.MouseButton1Click:Connect(function() Main.Visible = false; MinLogo.Visible = true end)
MinLogo.MouseButton1Click:Connect(function() Main.Visible = true; MinLogo.Visible = false end)

-- Fungsi Deteksi Posisi Otomatis
local function GetCurrentGrid()
    local Char = Player.Character
    if not Char then return Vector2.new(0,0) end
    
    local attrX = Char:GetAttribute("PositionX") or Char:GetAttribute("GridX")
    local attrY = Char:GetAttribute("PositionY") or Char:GetAttribute("GridY")
    
    if attrX and attrY then return Vector2.new(attrX, attrY) end
    
    local Root = Char:FindFirstChild("HumanoidRootPart")
    if Root then
        local rawX = math.floor(Root.Position.X / 4.5 + 0.5)
        local rawY = math.floor(Root.Position.Y / 4.5 + 0.5)
        return Vector2.new(rawX, rawY)
    end
    return Vector2.new(0,0)
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- STABLE PBNB ENGINE (SYSTEM: PLACE ALL -> HIT CYCLE)
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
task.spawn(function()
    while true do
        if _G.AutoPBNB and #_G.SelectedTargets > 0 then
            local currentPos = GetCurrentGrid()
            
            -- 1. TAHAP PEMASANGAN (PLACE)
            -- Pasang blok di SEMUA target yang dipilih terlebih dahulu
            for _, offset in pairs(_G.SelectedTargets) do
                if not _G.AutoPBNB then break end
                local finalTarget = Vector2.new(currentPos.X + offset.X, currentPos.Y + offset.Y)
                local cleanTarget = Vector2.new(math.floor(finalTarget.X), math.floor(finalTarget.Y))
                
                pcall(function()
                    PlaceRemote:FireServer(cleanTarget, tonumber(_G.SelectedBlockID))
                end)
            end
            
            task.wait(0.1) -- Jeda singkat agar server memproses pemasangan

            -- 2. TAHAP PEMUKULAN (HIT CYCLE)
            -- Melakukan putaran pukulan sebanyak HitAmount
            for h = 1, (_G.HitAmount or 3) do
                if not _G.AutoPBNB then break end
                
                -- Di setiap putaran, pukul setiap blok 1 kali
                for _, offset in pairs(_G.SelectedTargets) do
                    if not _G.AutoPBNB then break end
                    local finalTarget = Vector2.new(currentPos.X + offset.X, currentPos.Y + offset.Y)
                    local cleanTarget = Vector2.new(math.floor(finalTarget.X), math.floor(finalTarget.Y))
                    
                    pcall(function()
                        FistRemote:FireServer(cleanTarget)
                    end)
                    task.wait(0.1) -- Jeda antar pukulan agar stabil
                end
            end
        end
        task.wait(0.1) -- Jeda sebelum memulai cycle baru
    end
end)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- UI SETUP & DRAGGABLE SYSTEM
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
local ScreenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
ScreenGui.Name = "AlphaProjectFinal"; ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 480, 0, 380); Main.Position = UDim2.new(0.5, -240, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Main.Active = true
Instance.new("UICorner", Main); Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 200)

-- Draggable Logic for HP
local dragToggle, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true; dragStart = input.Position; startPos = Main.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = false
    end
end)

-- Header & Status
local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "ALPHA PROJECT FINAL"; Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.Font = 3; Title.BackgroundTransparency = 1

local Status = Instance.new("TextLabel", Main); Status.Size = UDim2.new(1, -40, 0, 30)
Status.Position = UDim2.new(0, 20, 0, 45); Status.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Status.TextColor3 = Color3.fromRGB(255, 255, 255); Status.Text = "Syncing Grid..."
Instance.new("UICorner", Status)

task.spawn(function()
    while task.wait(0.3) do
        local g = GetCurrentGrid()
        Status.Text = "COORD: "..g.X..", "..g.Y.." | ID: ".._G.SelectedBlockID
    end
end)

-- Inputs
local InputFrame = Instance.new("Frame", Main); InputFrame.Size = UDim2.new(1, -40, 0, 40)
InputFrame.Position = UDim2.new(0, 20, 0, 85); InputFrame.BackgroundTransparency = 1

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- SECTION: INPUT SYSTEM (ID BLOCK & HIT AMOUNT)
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function CreateInp(text, pos, size, defaultValue)
    local i = Instance.new("TextBox", InputFrame)
    i.Size = size
    i.Position = pos
    i.PlaceholderText = text
    i.Text = tostring(defaultValue) -- Menampilkan angka default saat UI muncul
    i.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    i.TextColor3 = Color3.fromRGB(255, 255, 255)
    i.Font = Enum.Font.GothamBold
    i.TextSize = 14
    Instance.new("UICorner", i)
    return i
end

-- Membuat Box untuk ID Block
local IDInp = CreateInp("ID (Dirt=5)", UDim2.new(0, 0, 0, 0), UDim2.new(0, 210, 1, 0), _G.SelectedBlockID)

-- Membuat Box untuk Jumlah Pukulan (Hit)
local HitInp = CreateInp("Hits (3)", UDim2.new(0, 230, 0, 0), UDim2.new(0, 210, 1, 0), _G.HitAmount)

-- LOGIKA AGAR TERSAMBUNG KE ENGINE PBNB:
IDInp.FocusLost:Connect(function(enterPressed)
    local val = tonumber(IDInp.Text)
    if val then
        _G.SelectedBlockID = val
        print("ID Block diubah ke: " .. val)
    else
        IDInp.Text = tostring(_G.SelectedBlockID) -- Balikin ke angka lama kalau yang diketik bukan angka
    end
end)

HitInp.FocusLost:Connect(function(enterPressed)
    local val = tonumber(HitInp.Text)
    if val then
        _G.HitAmount = val
        print("Jumlah Hit diubah ke: " .. val)
    else
        HitInp.Text = tostring(_G.HitAmount) -- Balikin ke angka lama jika error
    end
end)

-- Grid Selector (Updated for Stability)
local GridBox = Instance.new("Frame", Main); GridBox.Size = UDim2.new(0, 220, 0, 220)
GridBox.Position = UDim2.new(0, 20, 0, 140); GridBox.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Instance.new("UIGridLayout", GridBox).CellSize = UDim2.new(0, 40, 0, 40)

for y = 2, -2, -1 do
    for x = -2, 2 do
        local b = Instance.new("TextButton", GridBox)
        b.Text = (x == 0 and y == 0) and "ME" or x..","..y
        b.BackgroundColor3 = (x == 0 and y == 0) and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(45, 45, 50)
        Instance.new("UICorner", b); b.TextColor3 = Color3.fromRGB(255,255,255)
        
        if x ~= 0 or y ~= 0 then
            local act = false
            b.MouseButton1Click:Connect(function()
                act = not act
                if act then
                    -- Pastikan simpan sebagai angka bulat (math.floor)
                    table.insert(_G.SelectedTargets, {X = math.floor(x), Y = math.floor(y)})
                    b.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
                    b.TextColor3 = Color3.fromRGB(0,0,0)
                else
                    -- Menghapus target dengan lebih akurat
                    for i, v in ipairs(_G.SelectedTargets) do
                        if v.X == x and v.Y == y then
                            table.remove(_G.SelectedTargets, i)
                            break -- Berhenti setelah ketemu agar tidak merusak indeks loop
                        end
                    end
                    b.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
                    b.TextColor3 = Color3.fromRGB(255,255,255)
                end
            end)
        end
    end
end

-- Side Buttons
local Side = Instance.new("Frame", Main); Side.Size = UDim2.new(0, 220, 0, 220)
Side.Position = UDim2.new(0, 260, 0, 140); Side.BackgroundTransparency = 1
Instance.new("UIListLayout", Side).Padding = UDim.new(0, 10)

local function MakeBtn(txt, cb)
    local b = Instance.new("TextButton", Side); b.Size = UDim2.new(1, 0, 0, 60)
    b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(40, 40, 45); b.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", b)
    local s = false; b.MouseButton1Click:Connect(function() s = not s; b.BackgroundColor3 = s and Color3.fromRGB(0, 150, 150) or Color3.fromRGB(40, 40, 45); cb(s) end)
end

MakeBtn("START AUTO PBNB", function(v) _G.AutoPBNB = v end)
MakeBtn("RESET TARGETS", function() _G.SelectedTargets = {}; for _,v in pairs(GridBox:GetChildren()) do if v:IsA("TextButton") and v.Text ~= "ME" then v.BackgroundColor3 = Color3.fromRGB(45, 45, 50); v.TextColor3 = Color3.fromRGB(255,255,255) end end end)

-- Close Button
local Cls = Instance.new("TextButton", Main); Cls.Size = UDim2.new(0, 30, 0, 30)
Cls.Position = UDim2.new(1, -35, 0, 5); Cls.Text = "X"; Cls.TextColor3 = Color3.fromRGB(255, 50, 50)
Cls.BackgroundTransparency = 1; Cls.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
