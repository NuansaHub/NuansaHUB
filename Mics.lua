-- [[ ALPHA PROJECT - MISC.LUA (FITUR TAMBAHAN) ]] --

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TS = game:GetService("TweenService")
local LP = Players.LocalPlayer

-- Cari Halaman UI (Misal nama halamannya "MiscPage")
local ScreenGui = getgenv().AlphaProjectUI
if not ScreenGui then warn("Alpha Project UI tidak ditemukan!") return end
local Page = ScreenGui:FindFirstChild("MiscPage", true) 
if not Page then warn("Halaman Misc tidak ditemukan!") return end

-- Bersihkan isi halaman sebelum memuat ulang (Mencegah UI ganda)
for _, child in pairs(Page:GetChildren()) do
    if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then child:Destroy() end
end

-- Tema Warna (Sesuai dengan Auto Farm)
local Theme = {
    Main = Color3.fromRGB(15, 17, 20),    
    Item = Color3.fromRGB(30, 33, 38),    
    Accent = Color3.fromRGB(0, 255, 220), 
    Text = Color3.fromRGB(240, 245, 255),
    SubText = Color3.fromRGB(160, 165, 175)
}

-- [[ VARIABEL GLOBAL MISC ]] --
_G.Misc_HideName = false
_G.Misc_FakeName = "Alpha_User" -- Nama palsu bawaan

-- ==========================================
-- [[ 1. UI INPUT NAMA PALSU (TEXTBOX) ]]
-- ==========================================
local InputFrame = Instance.new("Frame", Page)
InputFrame.Size = UDim2.new(1, -10, 0, 35)
InputFrame.BackgroundColor3 = Theme.Item
Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 6)
InputFrame.ZIndex = 1

local InputLbl = Instance.new("TextLabel", InputFrame)
InputLbl.Size = UDim2.new(0.5, 0, 1, 0)
InputLbl.Position = UDim2.new(0, 10, 0, 0)
InputLbl.Text = "Set Nama Palsu:"
InputLbl.TextColor3 = Theme.Text
InputLbl.Font = Enum.Font.Gotham
InputLbl.TextSize = 12
InputLbl.BackgroundTransparency = 1
InputLbl.TextXAlignment = Enum.TextXAlignment.Left

local NameBox = Instance.new("TextBox", InputFrame)
NameBox.Size = UDim2.new(0.45, -10, 0.8, 0)
NameBox.Position = UDim2.new(0.55, 0, 0.1, 0)
NameBox.BackgroundColor3 = Theme.Main
NameBox.TextColor3 = Theme.Accent
NameBox.Font = Enum.Font.GothamBold
NameBox.TextSize = 12
NameBox.Text = _G.Misc_FakeName
NameBox.ClearTextOnFocus = false
Instance.new("UICorner", NameBox).CornerRadius = UDim.new(0, 6)

NameBox.FocusLost:Connect(function()
    -- Simpan nama barunya
    if NameBox.Text ~= "" then
        _G.Misc_FakeName = NameBox.Text
    else
        NameBox.Text = "Anonim"
        _G.Misc_FakeName = "Anonim"
    end
    
    -- [FITUR BARU] Update instan kalau tombol sedang ON
    if _G.Misc_HideName then
        pcall(function()
            for _, p in pairs(game:GetService("Players"):GetPlayers()) do
                local Char = p.Character
                if Char and Char:FindFirstChild("HumanoidRootPart") then
                    local NameTag = Char.HumanoidRootPart:FindFirstChild("NameTagUI")
                    if NameTag then
                        for _, objek in pairs(NameTag:GetDescendants()) do
                            if objek:IsA("TextLabel") and objek:GetAttribute("Locked") then
                                -- Langsung timpa semua label yang sudah terkunci dengan nama baru
                                objek.Text = _G.Misc_FakeName
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- ==========================================
-- [[ 2. UI TOGGLE SENSOR NAMA ]]
-- ==========================================
local SensorFrame = Instance.new("Frame", Page)
SensorFrame.Size = UDim2.new(1, -10, 0, 35)
SensorFrame.BackgroundColor3 = Theme.Item
Instance.new("UICorner", SensorFrame).CornerRadius = UDim.new(0, 6)
SensorFrame.ZIndex = 1

local SensorLbl = Instance.new("TextLabel", SensorFrame)
SensorLbl.Size = UDim2.new(0.6, 0, 1, 0)
SensorLbl.Position = UDim2.new(0, 10, 0, 0)
SensorLbl.Text = "Sensor Nama (Spoof)"
SensorLbl.TextColor3 = Theme.Text
SensorLbl.Font = Enum.Font.Gotham
SensorLbl.TextSize = 12
SensorLbl.BackgroundTransparency = 1
SensorLbl.TextXAlignment = Enum.TextXAlignment.Left

local SensorBtn = Instance.new("TextButton", SensorFrame)
SensorBtn.Size = UDim2.new(0.45, -10, 0.1, 22)
SensorBtn.Position = UDim2.new(0.58, -10, 0.5, -11)
SensorBtn.BackgroundColor3 = Theme.Main
SensorBtn.Text = "OFF"
SensorBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
SensorBtn.Font = Enum.Font.GothamBold
SensorBtn.TextSize = 10
Instance.new("UICorner", SensorBtn).CornerRadius = UDim.new(0, 4)
local SensorStroke = Instance.new("UIStroke", SensorBtn)
SensorStroke.Color = Color3.fromRGB(255, 80, 80)
SensorStroke.Thickness = 1

SensorBtn.MouseButton1Click:Connect(function()
    _G.Misc_HideName = not _G.Misc_HideName
    if _G.Misc_HideName then
        SensorBtn.Text = "ON"
        SensorBtn.TextColor3 = Theme.Accent
        SensorStroke.Color = Theme.Accent
        TS:Create(SensorBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Main}):Play()
    else
        SensorBtn.Text = "OFF"
        SensorBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
        SensorStroke.Color = Color3.fromRGB(255, 80, 80)
        TS:Create(SensorBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Main}):Play()
        
        -- Kembalikan nama asli jika dimatikan
        local Char = LP.Character
        if Char and Char:FindFirstChild("HumanoidRootPart") then
            local NameTag = Char.HumanoidRootPart:FindFirstChild("NameTagUI")
            if NameTag and NameTag:FindFirstChild("Text") then
                local namaAsli = ("%s"):format(LP:GetAttribute("namePrefix") or "") .. LP.DisplayName
                NameTag.Text.Text = namaAsli
                if NameTag.Text:FindFirstChild("Shadow") then
                    NameTag.Text.Shadow.Text = namaAsli
                end
            end
        end
    end
end)

-- ==========================================
-- [[ 3. ENGINE SENSOR NAMA PRESISI (ONLY NAME) ]]
-- ==========================================
task.spawn(function()
    while true do
        if _G.Misc_HideName then
            pcall(function()
                -- Ambil semua player di server
                for _, p in pairs(game:GetService("Players"):GetPlayers()) do
                    local Char = p.Character
                    if Char and Char:FindFirstChild("HumanoidRootPart") then
                        local NameTag = Char.HumanoidRootPart:FindFirstChild("NameTagUI")
                        
                        if NameTag then
                            -- Cari hanya label yang berisi Nama Asli (Username atau DisplayName)
                            for _, objek in pairs(NameTag:GetDescendants()) do
                                if objek:IsA("TextLabel") then
                                    
                                    -- FILTER: Cek apakah teksnya adalah nama si pemain
                                    -- Kita pakai string.find agar jika ada prefix/titile tetap terdeteksi
                                    if objek.Text == p.Name or objek.Text == p.DisplayName or string.find(objek.Text, p.DisplayName) then
                                        
                                        -- Ganti hanya jika belum sesuai nama palsu
                                        if objek.Text ~= _G.Misc_FakeName then
                                            objek.Text = _G.Misc_FakeName
                                        end
                                        
                                        -- Kunci agar tidak ditimpa script game (Anti-Overlap)
                                        if not objek:GetAttribute("Locked") then
                                            objek:SetAttribute("Locked", true)
                                            objek:GetPropertyChangedSignal("Text"):Connect(function()
                                                if _G.Misc_HideName and (objek.Text ~= _G.Misc_FakeName) then
                                                    objek.Text = _G.Misc_FakeName
                                                end
                                            end)
                                        end
                                    end
                                    
                                end
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.5) 
    end
end)
