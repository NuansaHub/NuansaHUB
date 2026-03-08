-- [[ ALPHA PROJECT - MOVEMENT TESTER UI ]] --

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- Bersihkan UI lama jika dieksekusi ulang
if getgenv().MovementTestUI then
    getgenv().MovementTestUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MovementTestUI"
-- Amankan UI ke CoreGui agar tidak terhapus saat mati
local success = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = LP:WaitForChild("PlayerGui") end
getgenv().MovementTestUI = ScreenGui

-- Frame Utama
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 220, 0, 140)
Main.Position = UDim2.new(0.5, -110, 0.4, -70)
Main.BackgroundColor3 = Color3.fromRGB(20, 22, 26)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 255, 220); Stroke.Thickness = 1.5

-- Header UI
local Header = Instance.new("TextLabel", Main)
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundTransparency = 1
Header.Text = "  MOVEMENT TESTER"
Header.TextColor3 = Color3.fromRGB(0, 255, 220)
Header.Font = Enum.Font.GothamBlack
Header.TextSize = 13
Header.TextXAlignment = Enum.TextXAlignment.Left

-- Tombol Close (X)
local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundTransparency = 1; CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 14
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Fitur Geser UI (Draggable)
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = Main.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Tombol Tes 1: Teleportasi (CFrame)
local BtnTeleport = Instance.new("TextButton", Main)
BtnTeleport.Size = UDim2.new(1, -20, 0, 35); BtnTeleport.Position = UDim2.new(0, 10, 0, 40)
BtnTeleport.BackgroundColor3 = Color3.fromRGB(35, 38, 45)
BtnTeleport.Text = "Tes 1: Teleport Instan"
BtnTeleport.TextColor3 = Color3.fromRGB(240, 245, 255); BtnTeleport.Font = Enum.Font.GothamSemibold; BtnTeleport.TextSize = 12
Instance.new("UICorner", BtnTeleport).CornerRadius = UDim.new(0, 6)

-- Tombol Tes 2: Jalan Kaki (MoveTo)
local BtnWalk = Instance.new("TextButton", Main)
BtnWalk.Size = UDim2.new(1, -20, 0, 35); BtnWalk.Position = UDim2.new(0, 10, 0, 85)
BtnWalk.BackgroundColor3 = Color3.fromRGB(35, 38, 45)
BtnWalk.Text = "Tes 2: Jalan Kaki"
BtnWalk.TextColor3 = Color3.fromRGB(240, 245, 255); BtnWalk.Font = Enum.Font.GothamSemibold; BtnWalk.TextSize = 12
Instance.new("UICorner", BtnWalk).CornerRadius = UDim.new(0, 6)

-- [[ LOGIKA TOMBOL ]] --

BtnTeleport.MouseButton1Click:Connect(function()
    local Char = LP.Character
    local Root = Char and Char:FindFirstChild("HumanoidRootPart")
    if Root then
        BtnTeleport.Text = "Teleporting..."
        local posAwal = Root.CFrame
        -- Geser 4.5 stud ke kanan
        Root.CFrame = posAwal * CFrame.new(4.5, 0, 0)
        task.wait(1)
        Root.CFrame = posAwal
        BtnTeleport.Text = "Tes 1: Teleport Instan"
    end
end)

BtnWalk.MouseButton1Click:Connect(function()
    local Char = LP.Character
    local Root = Char and Char:FindFirstChild("HumanoidRootPart")
    local Humanoid = Char and Char:FindFirstChild("Humanoid")
    if Root and Humanoid then
        BtnWalk.Text = "Walking..."
        local posAwal = Root.Position
        -- Jalan 4.5 stud ke arah sumbu X
        Humanoid:MoveTo(posAwal + Vector3.new(4.5, 0, 0))
        Humanoid.MoveToFinished:Wait()
        task.wait(1)
        Humanoid:MoveTo(posAwal)
        BtnWalk.Text = "Tes 2: Jalan Kaki"
    end
end)
