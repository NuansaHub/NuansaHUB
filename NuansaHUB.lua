-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- [[ ALPHA PROJECT HUB - v5.5 (REBRANDED) ]] --
-- Sequential PBNB + GitHub Loader
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TS = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

-- Remotes untuk PBNB
local PlaceRemote = RS:WaitForChild("Remotes"):WaitForChild("PlayerPlaceItem")
local FistRemote = RS:WaitForChild("Remotes"):WaitForChild("PlayerFist")

-- Hapus UI lama jika ada
pcall(function() if getgenv().AlphaHubUI then getgenv().AlphaHubUI:Destroy() end end)

-- [[ SETUP UI UTAMA ]] --
local ScreenGui = Instance.new("ScreenGui"); ScreenGui.Name = "AlphaProjectHub"
pcall(function() ScreenGui.Parent = CoreGui end); if not ScreenGui.Parent then ScreenGui.Parent = LP.PlayerGui end
ScreenGui.ResetOnSpawn = false; getgenv().AlphaHubUI = ScreenGui 

-- [[ AESTHETIC THEME: ALPHA CYAN ]] --
local Theme = { 
    Bg = Color3.fromRGB(15, 17, 20),      -- Deep Dark
    Header = Color3.fromRGB(10, 12, 14),  -- Blackout
    Item = Color3.fromRGB(25, 28, 32),    -- Dark Gray
    Text = Color3.fromRGB(240, 245, 255),  -- White
    SubText = Color3.fromRGB(160, 165, 175), -- Gray
    Alpha = Color3.fromRGB(0, 255, 220),   -- Neon Cyan (Utama)
    Discord = Color3.fromRGB(88, 101, 242)
}

-- [[ LOGO KECIL (MINIMIZED) ]] --
local AlphaMinBtn = Instance.new("TextButton", ScreenGui)
AlphaMinBtn.BackgroundColor3 = Theme.Bg; AlphaMinBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
AlphaMinBtn.Size = UDim2.new(0, 60, 0, 60); AlphaMinBtn.Text = "Α"; -- Huruf Alpha Yunani
AlphaMinBtn.TextColor3 = Theme.Alpha; AlphaMinBtn.Font = Enum.Font.GothamBlack
AlphaMinBtn.TextSize = 35; AlphaMinBtn.Visible = false; AlphaMinBtn.AutoButtonColor = false
Instance.new("UICorner", AlphaMinBtn).CornerRadius = UDim.new(1, 0)
local BtnStroke = Instance.new("UIStroke", AlphaMinBtn); BtnStroke.Color = Theme.Alpha; BtnStroke.Thickness = 2

-- [[ FRAME UTAMA ]] --
local Main = Instance.new("Frame", ScreenGui)
Main.BackgroundColor3 = Theme.Bg; Main.Position = UDim2.new(0.5, -275, 0.5, -185)
Main.Size = UDim2.new(0, 550, 0, 370); Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = Theme.Alpha; MainStroke.Thickness = 1.5; MainStroke.Transparency = 0.3

-- Fungsi Drag
local function MakeDraggable(frame, trigger) 
    local dragging, dragInput, dragStart, startPos
    trigger.InputBegan:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) 
        end 
    end)
    trigger.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    UIS.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) 
        end 
    end) 
end
MakeDraggable(Main, Main); MakeDraggable(AlphaMinBtn, AlphaMinBtn)

-- [[ HEADER ]] --
local Header = Instance.new("Frame", Main); Header.BackgroundColor3 = Theme.Header; Header.Size = UDim2.new(1, 0, 0, 50); Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)
-- Menutupi Corner bawah header agar rapi
local HeaderHide = Instance.new("Frame", Header); HeaderHide.BackgroundColor3 = Theme.Header; HeaderHide.Size = UDim2.new(1, 0, 0.5, 0); HeaderHide.Position = UDim2.new(0, 0, 0.5, 0); HeaderHide.BorderSizePixel = 0

-- Label Logo & Versi
local Title = Instance.new("TextLabel", Header); Title.Text = "ALPHA"; Title.TextColor3 = Theme.Text; Title.Font = Enum.Font.GothamBlack; Title.TextSize = 22; Title.Size = UDim2.new(0, 80, 1, 0); Title.Position = UDim2.new(0, 20, 0, 0); Title.BackgroundTransparency = 1; Title.TextXAlignment = Enum.TextXAlignment.Left
local Title2 = Instance.new("TextLabel", Header); Title2.Text = "PROJECT"; Title2.TextColor3 = Theme.Alpha; Title2.Font = Enum.Font.GothamBold; Title2.TextSize = 22; TitleVer.Size = UDim2.new(0, 100, 1, 0); Title2.Position = UDim2.new(0, 95, 0, 0); Title2.BackgroundTransparency = 1; Title2.TextXAlignment = Enum.TextXAlignment.Left

local TitleVer = Instance.new("TextLabel", Header); TitleVer.Text = "v5.5"; TitleVer.TextColor3 = Theme.SubText; TitleVer.Font = Enum.Font.Gotham; TitleVer.TextSize = 12; TitleVer.Size = UDim2.new(0, 40, 0, 20); TitleVer.Position = UDim2.new(0, 195, 0.5, -4); TitleVer.BackgroundTransparency = 1; TitleVer.TextXAlignment = Enum.TextXAlignment.Left

-- Tombol Header (Minimize)
local MinBtn = Instance.new("TextButton", Header); MinBtn.Size = UDim2.new(0, 35, 0, 35); MinBtn.Position = UDim2.new(1, -45, 0.5, -17.5); MinBtn.Text = "—"; MinBtn.BackgroundColor3 = Theme.Item; MinBtn.TextColor3 = Theme.Text; MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 14; MinBtn.AutoButtonColor = false
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)

local function ToggleUI() 
    Main.Visible = not Main.Visible; AlphaMinBtn.Visible = not Main.Visible
    if AlphaMinBtn.Visible then AlphaMinBtn.Position = UDim2.new(0, Main.AbsolutePosition.X, 0, Main.AbsolutePosition.Y) else Main.Position = UDim2.new(0, AlphaMinBtn.AbsolutePosition.X, 0, AlphaMinBtn.AbsolutePosition.Y) end 
end
MinBtn.MouseButton1Click:Connect(ToggleUI); AlphaMinBtn.MouseButton1Click:Connect(ToggleUI)

-- [[ SISTEM TAB ]] --
local TabContainer = Instance.new("ScrollingFrame", Main); TabContainer.Size = UDim2.new(0, 150, 1, -50); TabContainer.Position = UDim2.new(0, 0, 0, 50); TabContainer.BackgroundColor3 = Theme.Header; TabContainer.BorderSizePixel = 0; TabContainer.ScrollBarThickness = 0
local TabPadding = Instance.new("UIPadding", TabContainer); TabPadding.PaddingTop = UDim.new(0, 15); TabPadding.PaddingBottom = UDim.new(0, 15)
local TabListLayout = Instance.new("UIListLayout", TabContainer); TabListLayout.Padding = UDim.new(0, 10); TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local PageContainer = Instance.new("Frame", Main); PageContainer.Size = UDim2.new(1, -170, 1, -70); PageContainer.Position = UDim2.new(0, 160, 0, 60); PageContainer.BackgroundTransparency = 1

local Tabs = {}; local Pages = {}

local function CreateTab(TabName, DescText, isLocalPBNB)
    local TBtn = Instance.new("TextButton", TabContainer); TBtn.Size = UDim2.new(0.9, 0, 0, 38); TBtn.BackgroundColor3 = Theme.Item; TBtn.Text = TabName; TBtn.TextColor3 = Theme.SubText; TBtn.Font = Enum.Font.GothamMedium; TBtn.TextSize = 13; TBtn.AutoButtonColor = false
    Instance.new("UICorner", TBtn).CornerRadius = UDim.new(0, 8)
    local TStroke = Instance.new("UIStroke", TBtn); TStroke.Color = Theme.Bg; TStroke.Thickness = 1.5
    
    local Page = Instance.new("ScrollingFrame", PageContainer); Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.BorderSizePixel = 0; Page.ScrollBarThickness = 3; Page.ScrollBarImageColor3 = Theme.Alpha
    local PagePadding = Instance.new("UIPadding", Page); PagePadding.PaddingRight = UDim.new(0, 5)
    local PageLayout = Instance.new("UIListLayout", Page); PageLayout.Padding = UDim.new(0, 10); PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local LTitle = Instance.new("TextLabel", Page); LTitle.Size = UDim2.new(1,0,0,30); LTitle.BackgroundTransparency = 1; LTitle.Text = TabName .. " Module"; LTitle.TextColor3 = Theme.Alpha; LTitle.Font = Enum.Font.GothamBold; LTitle.TextSize = 18; LTitle.TextXAlignment = Enum.TextXAlignment.Left
    local LDesc = Instance.new("TextLabel", Page); LDesc.Size = UDim2.new(1,0,0,35); LDesc.BackgroundTransparency = 1; LDesc.Text = DescText; LDesc.TextColor3 = Theme.SubText; LDesc.Font = Enum.Font.Gotham; LDesc.TextSize = 12; LDesc.TextWrapped = true; LDesc.TextXAlignment = Enum.TextXAlignment.Left; LDesc.TextYAlignment = Enum.TextYAlignment.Top
    local Div = Instance.new("Frame", Page); Div.Size = UDim2.new(1,0,0,1); Div.BackgroundColor3 = Theme.Item; Div.BorderSizePixel = 0 div.LayoutOrder = 1
    
    TBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, t in pairs(Tabs) do TS:Create(t, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Item}):Play(); t.TextColor3 = Theme.SubText; t.Font = Enum.Font.GothamMedium; t:FindFirstChild("UIStroke").Color = Theme.Bg end
        Page.Visible = true
        TS:Create(TBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 40, 45)}):Play()
        TBtn.TextColor3 = Theme.Alpha; TBtn.Font = Enum.Font.GothamBold; TBtn:FindFirstChild("UIStroke").Color = Theme.Alpha
    end)
    table.insert(Tabs, TBtn); table.insert(Pages, Page); return Page, TBtn
end

-- [[ SISTEM GITHUB LOADER (Untuk Tab Lain) ]] --
local function AddExternalModule(TabName, DescText, githubRawLink)
    local Page, TBtn = CreateTab(TabName, DescText, false)
    
    local StatusLabel = Instance.new("TextLabel", Page)
    StatusLabel.Size = UDim2.new(1,0,0,40); StatusLabel.BackgroundTransparency = 1; StatusLabel.Text = "⏳ Menghubungkan ke GitHub..."; StatusLabel.TextColor3 = Theme.SubText StatusLabel.Font = Enum.Font.GothamMedium; StatusLabel.TextSize = 13; StatusLabel.LayoutOrder = 2
    
    local isLoaded = false
    TBtn.MouseButton1Click:Connect(function()
        if not isLoaded and githubRawLink ~= "" then
            isLoaded = true
            task.spawn(function()
                local success, scriptCode = pcall(game.HttpGet, game, githubRawLink)
                if success then
                    local func, compileErr = loadstring(scriptCode)
                    if func then
                        StatusLabel.Text = "⚡ Module Berhasil Dimuat!"; StatusLabel.TextColor3 = Theme.Alpha
                        task.delay(1, function() StatusLabel:Destroy() end)
                        pcall(func, Page) -- Jalankan script dengan pass Page sebagai parent
                    else StatusLabel.Text = "❌ Error Compile: " .. tostring(compileErr); StatusLabel.TextColor3 = Color3.fromRGB(255, 85, 85) end
                else StatusLabel.Text = "❌ Gagal mengambil file Raw GitHub!"; StatusLabel.TextColor3 = Color3.fromRGB(255, 85, 85) end
            end)
        end
    end)
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- [[ MODUL 1: LOCAL PBNB (INTEGRATED) ]] --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
_G.AutoPBNB = false; _G.SelectedTargets = {}; _G.SelectedBlockID = 5; _G.HitAmount = 3

local PBNBPage = CreateTab("Smart PBNB", "Otomatis Put dan Break (Sequential) dengan sensor deteksi.", true)

-- Fungsi bantu UI
local function MakeSlider(parent, label, default, max, globalVar)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, 40); f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(0.4, 0, 1, 0); l.Text = label..": "..default; l.TextColor3 = Theme.Text; l.Font = Enum.Font.Gotham; l.TextSize = 12; l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left
    local b = Instance.new("TextBox", f); b.Size = UDim2.new(0.5, 0, 0, 25); b.Position = UDim2.new(0.45, 0, 0.5, -12.5); b.Text = tostring(default); b.BackgroundColor3 = Theme.Bg; b.TextColor3 = Theme.Alpha; b.Font = Enum.Font.GothamBold; b.TextSize = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6); Instance.new("UIStroke", b).Color = Theme.Item
    b.FocusLost:Connect(function() local val = tonumber(b.Text) or default; _G[globalVar] = math.clamp(val, 1, max); b.Text = tostring(_G[globalVar]); l.Text = label..": ".._G[globalVar] end)
end

-- Input Area
local Inputs = Instance.new("Frame", PBNBPage); Inputs.Size = UDim2.new(1, 0, 0, 90); Inputs.BackgroundColor3 = Theme.Item
Instance.new("UICorner", Inputs).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", Inputs).Color = Theme.Alpha; InputsStroke.Transparency = 0.8
local InpLayout = Instance.new("UIListLayout", Inputs); InpLayout.Padding = UDim.new(0, 2); InpLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; InpLayout.VerticalAlignment = Enum.VerticalAlignment.Center
MakeSlider(Inputs, "Block/Seed ID", 5, 9999, "SelectedBlockID")
MakeSlider(Inputs, "Pukulan (Hits)", 3, 20, "HitAmount")

-- Grid Area
local GridFrame = Instance.new("Frame", PBNBPage); GridFrame.Size = UDim2.new(1, 0, 0, 180); GridFrame.BackgroundColor3 = Theme.Item
Instance.new("UICorner", GridFrame).CornerRadius = UDim.new(0, 8)
local GridInner = Instance.new("Frame", GridFrame); GridInner.Size = UDim2.new(0, 160, 0, 160); GridInner.Position = UDim2.new(0.5, -80, 0.5, -80); GridInner.BackgroundTransparency = 1
Instance.new("UIGridLayout", GridInner).CellSize = UDim2.new(0, 28, 0, 28); GridInner.UIGridLayout.CellPadding = UDim2.new(0, 4, 0, 4)

for y = 2, -2, -1 do
    for x = -2, 2 do
        local b = Instance.new("TextButton", GridInner); b.Text = (x == 0 and y == 0) and "A" or ""
        b.BackgroundColor3 = (x == 0 and y == 0) and Theme.Alpha or Theme.Bg; b.TextColor3 = (x == 0 and y == 0) and Theme.Bg or Theme.Text; b.Font = Enum.Font.GothamBold; b.TextSize = 12
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        if x ~= 0 or y ~= 0 then
            local act = false
            b.MouseButton1Click:Connect(function()
                act = not act
                if act then table.insert(_G.SelectedTargets, {X = math.floor(x), Y = math.floor(y)}); TS:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Alpha, TextColor3 = Theme.Bg}):Play()
                else for i, v in ipairs(_G.SelectedTargets) do if v.X == math.floor(x) and v.Y == math.floor(y) then table.remove(_G.SelectedTargets, i) break end end TS:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Bg, TextColor3 = Theme.Text}):Play() end
            end)
        end
    end
end

-- Controls
local CtrlFrame = Instance.new("Frame", PBNBPage); CtrlFrame.Size = UDim2.new(1, 0, 0, 40); CtrlFrame.BackgroundTransparency = 1
local CtrlLayout = Instance.new("UIListLayout", CtrlFrame); CtrlLayout.FillDirection = Enum.FillDirection.Horizontal; CtrlLayout.Padding = UDim.new(0, 10); CtrlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function MakeBtn(parent, txt, cb, isToggle)
    local b = Instance.new("TextButton", parent); b.Size = UDim2.new(0.48, 0, 1, 0); b.Text = txt; b.BackgroundColor3 = Theme.Item; b.TextColor3 = Theme.Text; b.Font = Enum.Font.GothamBold; b.TextSize = 12; b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8); local s = Instance.new("UIStroke", b); s.Color = Theme.Alpha; s.Transparency = 0.6
    
    if isToggle then local on = false; b.MouseButton1Click:Connect(function() on = not on; cb(on); TS:Create(b, TweenInfo.new(0.3), {BackgroundColor3 = on and Theme.Alpha or Theme.Item, TextColor3 = on and Theme.Bg or Theme.Text}):Play(); b.Text = on and "STOP PBNB" or "START PBNB" end)
    else b.MouseButton1Click:Connect(cb); b.MouseEnter:Connect(function() TS:Create(s, TweenInfo.new(0.2), {Transparency = 0}):Play() end); b.MouseLeave:Connect(function() TS:Create(s, TweenInfo.new(0.2), {Transparency = 0.6}):Play() end) end
end

MakeBtn(CtrlFrame, "START PBNB", function(v) _G.AutoPBNB = v end, true)
MakeBtn(CtrlFrame, "RESET TARGETS", function() _G.SelectedTargets = {}; for _,v in pairs(GridInner:GetChildren()) do if v:IsA("TextButton") and v.Text ~= "A" then TS:Create(v, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Bg, TextColor3 = Theme.Text}):Play() end end end, false)

-- PBNB Engine
local function GetCurrentGrid()
    local Char = LP.Character; local Root = Char and Char:FindFirstChild("HumanoidRootPart")
    return Root and Vector2.new(math.floor(Root.Position.X / 4.5 + 0.5), math.floor(Root.Position.Y / 4.5 + 0.5)) or Vector2.new(0,0)
end
local function CheckBlockAt(tx, ty)
    local cp = Vector3.new(tx * 4.5, ty * 4.5, 0); local cs = Vector3.new(2, 2, 5) 
    local p = OverlapParams.new(); p.FilterType = Enum.RaycastFilterType.Exclude; p.FilterDescendantsInstances = {LP.Character}
    return #workspace:GetPartBoundsInBox(CFrame.new(cp), cs, p) > 0
end

task.spawn(function()
    while true do
        if _G.AutoPBNB and #_G.SelectedTargets > 0 then
            local targets = {}; for _, v in ipairs(_G.SelectedTargets) do table.insert(targets, v) end
            local cp = GetCurrentGrid()
            for _, o in ipairs(targets) do if not _G.AutoPBNB then break end local tx, ty = math.floor(cp.X + o.X), math.floor(cp.Y + o.Y)
                if not CheckBlockAt(tx, ty) then pcall(function() PlaceRemote:FireServer(Vector2.new(tx, ty), tonumber(_G.SelectedBlockID)) end) task.wait(0.12) end
            end
            task.wait(0.2)
            for h = 1, (_G.HitAmount) do if not _G.AutoPBNB then break end
                for _, o in ipairs(targets) do if not _G.AutoPBNB then break end local tx, ty = math.floor(cp.X + o.X), math.floor(cp.Y + o.Y)
                    if CheckBlockAt(tx, ty) then pcall(function() FistRemote:FireServer(Vector2.new(tx, ty)) end) task.wait(0.08) end
                end
            end
        end
        task.wait(0.2)
    end
end)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- [[ MODUL 2: EXTERNAL GITHUB MODULES ]] --
-- Masukkan Link Raw GitHub kamu yang baru di sini nanti
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- CONTOH: (Ganti link kosong ini dengan link Raw GitHub kamu yang baru)
AddExternalModule("Auto Farm", "Sistem farming Kayu/Batu otomatis (Ganti Link RAW!).", "") 
AddExternalModule("Factory Auto", "Otomatisasi mesin pabrik (Ganti Link RAW!).", "")
AddExternalModule("Auto Clear", "Pembersih World otomatis (Ganti Link RAW!).", "")

-- [[ Masukkan link GitHub lama ZonHub sebagai backup/contoh ]] --
AddExternalModule("ZonHub Manager", "Inventory manager lama ZonHub.", "https://raw.githubusercontent.com/ZonHUBs/ZONHUB/refs/heads/main/manager.lua")

-- Klik Tab pertama otomatis saat load
task.defer(function() if Tabs[1] then Tabs[1].MouseButton1Click:FireServer() end end)
