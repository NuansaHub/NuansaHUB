-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ALPHA PROJECT v5.5 [FINAL - DRAG & RESIZE]
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")

local PlaceRemote = RS:WaitForChild("Remotes"):WaitForChild("PlayerPlaceItem")
local FistRemote = RS:WaitForChild("Remotes"):WaitForChild("PlayerFist")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 1. UI BASE
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
local ScreenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
ScreenGui.Name = "AlphaProjectFinal"; ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 480, 0, 380); Main.Position = UDim2.new(0.5, -240, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Main.Active = true
Main.ClipsDescendants = true
Instance.new("UICorner", Main); Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 200)

-- Handle Resize (Pojok Kanan Bawah)
local ResizeHandle = Instance.new("Frame", Main)
ResizeHandle.Size = UDim2.new(0, 20, 0, 20)
ResizeHandle.Position = UDim2.new(1, -20, 1, -20)
ResizeHandle.BackgroundTransparency = 1
ResizeHandle.Active = true

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 2. SYSTEM: DRAG & RESIZE LOGIC
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function MakeDraggable(frame)
    local dragToggle, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not UIS:GetFocusedTextBox() then
            dragToggle = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragToggle = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function MakeResizable(frame, handle)
    local resizing, startPos, startSize
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true; startPos = input.Position; startSize = frame.Size
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then resizing = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startPos
            frame.Size = UDim2.new(0, math.max(300, startSize.X.Offset + delta.X), 0, math.max(200, startSize.Y.Offset + delta.Y))
        end
    end)
end

MakeDraggable(Main)
MakeResizable(Main, ResizeHandle)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 3. MINIMIZE SYSTEM
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
local MinLogo = Instance.new("ImageButton", ScreenGui)
MinLogo.Size = UDim2.new(0, 50, 0, 50); MinLogo.Position = UDim2.new(0, 20, 0.5, -25)
MinLogo.BackgroundColor3 = Color3.fromRGB(15, 15, 20); MinLogo.Visible = false
Instance.new("UICorner", MinLogo); Instance.new("UIStroke", MinLogo).Color = Color3.fromRGB(0, 255, 200)

local MinText = Instance.new("TextLabel", MinLogo)
MinText.Size = UDim2.new(1, 0, 1, 0); MinText.BackgroundTransparency = 1; MinText.Text = "A"
MinText.TextColor3 = Color3.fromRGB(0, 255, 200); MinText.Font = 3; MinText.TextSize = 25

local MinBtn = Instance.new("TextButton", Main)
MinBtn.Size = UDim2.new(0, 30, 0, 30); MinBtn.Position = UDim2.new(1, -70, 0, 5)
MinBtn.Text = "-"; MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255); MinBtn.BackgroundTransparency = 1; MinBtn.TextSize = 35

MinBtn.MouseButton1Click:Connect(function() Main.Visible = false; MinLogo.Visible = true end)
MinLogo.MouseButton1Click:Connect(function() Main.Visible = true; MinLogo.Visible = false end)
MakeDraggable(MinLogo)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 4. PBNB ENGINE & INPUTS (Simplified for Size)
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
_G.AutoPBNB = false; _G.SelectedTargets = {}; _G.SelectedBlockID = 5; _G.HitAmount = 3

local function GetCurrentGrid()
    local Char = Player.Character
    local Root = Char and Char:FindFirstChild("HumanoidRootPart")
    return Root and Vector2.new(math.floor(Root.Position.X / 4.5 + 0.5), math.floor(Root.Position.Y / 4.5 + 0.5)) or Vector2.new(0,0)
end


task.spawn(function()
    while true do
        -- Cek apakah tombol Start aktif dan ada koordinat yang dipilih
        if _G.AutoPBNB and #_G.SelectedTargets > 0 then
            
            -- Ambil koordinat player saat ini sebagai patokan grid
            local currentPos = GetCurrentGrid()
            
            -- --- TAHAP 1: MELETAKKAN SEMUA BLOK (PUT PHASE) ---
            -- Sama seperti "for index, target in CoordList" di AHK kamu
            for _, offset in ipairs(_G.SelectedTargets) do
                if not _G.AutoPBNB then break end -- Cek jika user stop di tengah jalan
                
                -- Hitung koordinat tujuan (Vector2)
                local tx = math.floor(currentPos.X + offset.X)
                local ty = math.floor(currentPos.Y + offset.Y)
                local targetVector2 = Vector2.new(tx, ty)

                -- Kirim perintah Taruh (PlayerPlaceItem)
                pcall(function()
                    -- [1] = Koordinat, [2] = ID Blok
                    PlaceRemote:FireServer(targetVector2, tonumber(_G.SelectedBlockID))
                end)
                
                -- Sleep(EditPut.Value) -> Kita ganti dengan task.wait
                task.wait(0.12) 
            end

            -- Jeda singkat transisi (agar blok sempat muncul di server)
            task.wait(0.2)

            -- --- TAHAP 2: MENGHANCURKAN SEMUA BLOK (BREAK PHASE) ---
            -- Di AHK kamu bisa menambahkan loop Klik di sini
            for h = 1, (_G.HitAmount or 3) do -- Ulangi pukulan sebanyak HitAmount
                if not _G.AutoPBNB then break end
                
                for _, offset in ipairs(_G.SelectedTargets) do
                    if not _G.AutoPBNB then break end
                    
                    local tx = math.floor(currentPos.X + offset.X)
                    local ty = math.floor(currentPos.Y + offset.Y)
                    local targetVector2 = Vector2.new(tx, ty)

                    -- Kirim perintah Pukul (PlayerFist)
                    pcall(function()
                        FistRemote:FireServer(targetVector2)
                    end)
                    
                    task.wait(0.08) -- Jeda antar pukulan (biar stabil)
                end
            end
        end
        
        -- Jeda sebelum memulai siklus baru (mencegah lag)
        task.wait(0.1)
    end
end)

-- Header & Rest of UI
local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "ALPHA PROJECT FINAL"; Title.TextColor3 = Color3.fromRGB(0, 255, 200); Title.BackgroundTransparency = 1

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
                    -- Simpan dengan koordinat yang pasti bulat
                    table.insert(_G.SelectedTargets, {X = math.floor(x), Y = math.floor(y)})
                    b.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
                    b.TextColor3 = Color3.fromRGB(0,0,0)
                else
                    -- Hapus berdasarkan koordinat X dan Y yang cocok
                    for i, v in ipairs(_G.SelectedTargets) do
                        if v.X == math.floor(x) and v.Y == math.floor(y) then
                            table.remove(_G.SelectedTargets, i)
                            break
                        end
                    end
                    b.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
                    b.TextColor3 = Color3.fromRGB(255,255,255)
                end
            end)
        end
    end
end

local Side = Instance.new("Frame", Main); Side.Size = UDim2.new(0, 220, 0, 220)
Side.Position = UDim2.new(0, 260, 0, 140); Side.BackgroundTransparency = 1
Instance.new("UIListLayout", Side).Padding = UDim.new(0, 10)

local function MakeBtn(txt, cb)
    local b = Instance.new("TextButton", Side); b.Size = UDim2.new(1, 0, 0, 60)
    b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(40, 40, 45); b.TextColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", b)
    local s = false; b.MouseButton1Click:Connect(function() s = not s; b.BackgroundColor3 = s and Color3.fromRGB(0, 150, 150) or Color3.fromRGB(40, 40, 45); cb(s) end)
end

MakeBtn("START AUTO PBNB", function(v) _G.AutoPBNB = v end)
MakeBtn("RESET TARGETS", function() _G.SelectedTargets = {} end)

local Cls = Instance.new("TextButton", Main); Cls.Size = UDim2.new(0, 30, 0, 30)
Cls.Position = UDim2.new(1, -35, 0, 5); Cls.Text = "X"; Cls.TextColor3 = Color3.fromRGB(255, 50, 50)
Cls.BackgroundTransparency = 1; Cls.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
