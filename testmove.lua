print("=== MESIN SEDOT ZONHUB AKTIF ===")
local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local Drops = workspace:FindFirstChild("Drops")

-- [1] KITA CARI JALUR RAHASIA PRIBADIMU
local PacketFolder = RS:WaitForChild("Remotes"):WaitForChild("PlayerMovementPackets")
local MyRemote = PacketFolder:FindFirstChild(LP.Name)

if not MyRemote then
    print("❌ Remote pribadimu tidak ditemukan! (Tunggu loading game selesai)")
elseif not Drops or #Drops:GetChildren() == 0 then
    print("❌ Tidak ada barang di tanah. Jatuhkan 1 barang untuk tes!")
else
    print("✅ Jalur ditemukan! Menyedot barang...")
    
    local MyHitbox = workspace:FindFirstChild("Hitbox") and workspace.Hitbox:FindFirstChild(LP.Name)
    local PosisiAsli = MyHitbox and Vector2.new(MyHitbox.Position.X, MyHitbox.Position.Y) or Vector2.new(0,0)
    
    for _, item in pairs(Drops:GetChildren()) do
        local targetPart = nil
        if item:IsA("Model") then targetPart = item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")
        elseif item:IsA("BasePart") then targetPart = item
        else targetPart = item:FindFirstChildWhichIsA("BasePart") end
        
        if targetPart then
            -- [2] KITA BUAT KOORDINAT PALSU BARANG TERSEBUT
            local posBarang = targetPart.Position
            local KoordinatPalsu = Vector2.new(posBarang.X, posBarang.Y)
            
            print("Mencuri:", item.Name, "di koordinat", KoordinatPalsu)
            
            -- [3] KITA TEMBAK SERVER DENGAN KOORDINAT PALSU
            -- (Server mengira kita teleportasi kilat ke sana)
            MyRemote:FireServer(KoordinatPalsu)
            
            -- [!] TRIGGER SENTUHAN EKSTRA
            if MyHitbox and firetouchinterest then
                firetouchinterest(MyHitbox, targetPart, 0)
                firetouchinterest(MyHitbox, targetPart, 1)
            end
            
            task.wait(0.2) -- Jeda agar server memproses barang masuk tas
            
            -- [4] KITA KEMBALIKAN KOORDINAT KE POSISI ASLI
            MyRemote:FireServer(PosisiAsli)
            task.wait(0.1)
        end
    end
    print("Operasi Sedot Selesai! Cek tas kamu.")
end
print("================================")
