-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- ALPHA PROJECT v5.5 [FINAL - FIXED MINIMIZE]
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

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- UI SETUP (HARUS DI ATAS SEBELUM TOMBOL DIBUAT)
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
local ScreenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
ScreenGui.Name = "AlphaProjectFinal"; ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 480, 0, 380); Main.Position = UDim2.new(0.5, -240, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Main.Active = true
Instance.new("UICorner", Main); Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 200)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- MINIMIZE SYSTEM (DELTA STYLE)
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Buat Tombol Kecil (Logo Delta Style)
local MinLogo = Instance.new("ImageButton", ScreenGui)
MinLogo.Name = "MinimizeLogo"
MinLogo.Size = UDim2.new(0, 50, 0, 50)
MinLogo.Position = UDim2.new(0, 20, 0.5, -25)
MinLogo.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MinLogo.Visible = false
Instance.new("UICorner", MinLogo).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", MinLogo)
Stroke.Color = Color3.fromRGB(0, 255, 200)
Stroke.Thickness = 2

local MinText = Instance.new("TextLabel", MinLogo)
MinText.Size = UDim2.new(1, 0, 1, 0); MinText.BackgroundTransparency = 1
MinText.Text = "A"; MinText.TextColor3 = Color3.fromRGB(0, 255, 200)
MinText.Font = Enum.Font.GothamBold; MinText.TextSize = 25

-- Tombol Minimize di Header (Sebelah Tombol X)
local MinBtn = Instance.new("TextButton", Main)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0, 5) -- PAS DI KIRI TOMBOL X
MinBtn.Text = "-"; MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.BackgroundTransparency = 1; MinBtn.TextSize = 35

MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false; MinLogo.Visible = true
end)

MinLogo.MouseButton1Click:Connect(function()
    Main.Visible = true; MinLogo.Visible = false
end)

-- Draggable untuk Logo Kecil
local dToggle, dStart, sPos
MinLogo.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dToggle = true; dStart = input.Position; sPos = MinLogo.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dStart
        MinLogo.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dToggle = false end end)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- DRAGGABLE MAIN MENU
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
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
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggle = false end end)

-- Header & Status
local Title = Instance.new("TextLabel", Main); Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "ALPHA PROJECT FINAL"; Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.Font = 3; Title.BackgroundTransparency = 1

-- SISA KODE PBNB ENGINE & INPUTS (SAMA SEPERTI SEBELUMNYA)
-- ... [Tambahkan bagian GetCurrentGrid, PBNB Engine, dan Inputs di bawah sini] ...

-- Close Button (Tetap di paling bawah agar menumpuk paling atas secara visual)
local Cls = Instance.new("TextButton", Main); Cls.Size = UDim2.new(0, 30, 0, 30)
Cls.Position = UDim2.new(1, -35, 0, 5); Cls.Text = "X"; Cls.TextColor3 = Color3.fromRGB(255, 50, 50)
Cls.BackgroundTransparency = 1; Cls.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
