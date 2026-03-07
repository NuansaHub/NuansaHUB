-- [[ ALPHA PROJECT - STAGE 3: GITHUB LOADER ]] --

-- Fungsi untuk membuat tombol eksekusi script dari GitHub
local function AddCloudModule(parentPage, title, description, rawUrl)
    -- 1. Kotak Container Module
    local ModuleFrame = Instance.new("Frame", parentPage)
    ModuleFrame.Size = UDim2.new(1, -10, 0, 80)
    ModuleFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 30)
    ModuleFrame.BorderSizePixel = 0
    
    local ModCorner = Instance.new("UICorner", ModuleFrame)
    ModCorner.CornerRadius = UDim.new(0, 8)
    
    local ModStroke = Instance.new("UIStroke", ModuleFrame)
    ModStroke.Color = Theme.Accent
    ModStroke.Transparency = 0.8

    -- 2. Judul & Deskripsi
    local ModTitle = Instance.new("TextLabel", ModuleFrame)
    ModTitle.Text = title
    ModTitle.Font = Enum.Font.GothamBold
    ModTitle.TextColor3 = Theme.Accent
    ModTitle.TextSize = 14
    ModTitle.Size = UDim2.new(0.6, 0, 0, 25)
    ModTitle.Position = UDim2.new(0, 10, 0, 5)
    ModTitle.BackgroundTransparency = 1
    ModTitle.TextXAlignment = Enum.TextXAlignment.Left

    local ModDesc = Instance.new("TextLabel", ModuleFrame)
    ModDesc.Text = description
    ModDesc.Font = Enum.Font.Gotham
    ModDesc.TextColor3 = Theme.SubText
    ModDesc.TextSize = 11
    ModDesc.Size = UDim2.new(0.6, 0, 0, 40)
    ModDesc.Position = UDim2.new(0, 10, 0, 30)
    ModDesc.BackgroundTransparency = 1
    ModDesc.TextWrapped = true
    ModDesc.TextXAlignment = Enum.TextXAlignment.Left
    ModDesc.TextYAlignment = Enum.TextYAlignment.Top

    -- 3. Tombol Load (Eksekusi)
    local LoadBtn = Instance.new("TextButton", ModuleFrame)
    LoadBtn.Size = UDim2.new(0.3, 0, 0, 35)
    LoadBtn.Position = UDim2.new(0.65, 0, 0.5, -17)
    LoadBtn.BackgroundColor3 = Theme.Accent
    LoadBtn.Text = "LOAD SCRIPT"
    LoadBtn.TextColor3 = Theme.Main
    LoadBtn.Font = Enum.Font.GothamBold
    LoadBtn.TextSize = 12
    Instance.new("UICorner", LoadBtn)

    -- 4. LOGIKA LOADER (Inti)
    LoadBtn.MouseButton1Click:Connect(function()
        LoadBtn.Text = "LOADING..."
        LoadBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        
        -- Menjalankan script dari web secara aman (pcall)
        task.spawn(function()
            local success, err = pcall(function()
                local code = game:HttpGet(rawUrl) -- Ambil script dari GitHub
                local func = loadstring(code)     -- Ubah string jadi kode eksekusi
                if func then
                    func() -- Jalankan!
                else
                    error("Gagal compile script. Cek link RAW kamu!")
                end
            end)

            if success then
                LoadBtn.Text = "READY ✅"
                LoadBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            else
                LoadBtn.Text = "ERROR ❌"
                LoadBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                warn("Alpha Project Error: " .. tostring(err))
            end
            
            task.wait(2)
            LoadBtn.Text = "LOAD SCRIPT"
            LoadBtn.BackgroundColor3 = Theme.Accent
        end)
    end)
end

-- 5. CARA IMPLEMENTASI KE TAB
-- Panggil variabel tab yang sudah dibuat di Tahap 2
local FarmPage = AddTab("Auto Farm") -- Ini dari fungsi AddTab sebelumnya

-- Tambahkan module di dalam tab Auto Farm
AddCloudModule(
    FarmPage, 
    "Auto Farm", 
    "Auto Farm simple", 
    "https://raw.githubusercontent.com/NuansaHub/NuansaHUB/refs/heads/main/AutoFarm.lua"
)
