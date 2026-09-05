-- ===================================================
-- KILLER_VOIDS AVATAR CLONE REFLECTION INJECTOR
-- ===================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Hapus klon lama kalau ada biar gak numpuk
if Workspace:FindFirstChild("KV_ReflectionClone") then
    Workspace.KV_ReflectionClone:Destroy()
end

local cloneFolder = Instance.new("Folder")
cloneFolder.Name = "KV_ReflectionClone"
cloneFolder.Parent = Workspace

-- Fungsi buat nge-clone avatar player ke bawah lantai
local function createReflectionClone()
    local character = LocalPlayer.Character
    if not character then return end
    
    -- Pastikan character punya HumanoidRootPart
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    -- Clone model character
    character.Archivable = true
    local clone = character:Clone()
    clone.Name = "ShadowReflection"
    
    -- Hapus script atau komponen yang gak perlu di clone biar gak error/lag
    for _, child in pairs(clone:GetDescendants()) do
        if child:IsA("Script") or child:IsA("LocalScript") then
            child:Destroy()
        elseif child:IsA("BasePart") then
            child.Transparency = 0.3 -- Agak transparan ala bayangan air/kaca
            child.CanCollide = false
            child.CastShadow = false
            -- Ubah warna jadi agak gelap atau kebiruan biar mirip bayangan
            child.Color = Color3.fromRGB(40, 40, 50)
        end
    end

    clone.Parent = cloneFolder

    -- Loop sinkronisasi posisi (Membalik posisi Y agar ada di bawah lantai)
    task.spawn(function()
        while clone and clone.Parent and character and character.Parent do
            local originalRoot = character:FindFirstChild("HumanoidRootPart")
            local cloneRoot = clone:FindFirstChild("HumanoidRootPart")
            
            if originalRoot and cloneRoot then
                -- Ambil posisi player, lalu balik posisinya ke bawah (kurangi sumbu Y)
                -- Asumsi tinggi lantai dasar ada di sekitar Y = 0 atau menyesuaikan posisi kaki
                local pos = originalRoot.Position
                local targetCFrame = CFrame.new(pos.X, pos.Y - (originalRoot.Size.Y * 2.2), pos.Z) * originalRoot.Rotation
                
                -- Putar orientasi vertikalnya biar pas (efek cermin)
                cloneRoot.CFrame = targetCFrame
            end
            task.wait()
        end
        if clone then clone:Destroy() end
    end)
end

-- Eksekusi buat bikin klon bayangan
createReflectionClone()

-- Kalau player respawn/mati, buat ulang klonnya
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if Workspace:FindFirstChild("KV_ReflectionClone") then
        Workspace.KV_ReflectionClone:ClearAllChildren()
    end
    createReflectionClone()
end)

print("KILLER_VOIDS: AVATAR CLONE REFLECTION ACTIVE! 😈🔥")
