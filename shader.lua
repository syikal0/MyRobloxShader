-- ===================================================
-- KILLER_VOIDS EVADE HARDCORE REFLECTION SHADER
-- ===================================================

local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 1. EFEK VISUAL LIGHTING (Pasti Kelihatan Perbedaannya)
local ColorCorrection = Lighting:FindFirstChildOfClass("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect", Lighting)
ColorCorrection.Brightness = 0.05
ColorCorrection.Contrast = 0.25
ColorCorrection.Saturation = 0.1

local Bloom = Lighting:FindFirstChildOfClass("BloomEffect") or Instance.new("BloomEffect", Lighting)
Bloom.Intensity = 0.6
Bloom.Size = 24
Bloom.Threshold = 0.6

-- 2. FUNGSI PAKSA LANTAI JADI KACA & HAPUS TEKSTUR
local function forceReflection(object)
    -- Abaikan karakter player & NPC
    if object:IsA("BasePart") and not object:IsDescendantOf(LocalPlayer.Character or script) then
        -- Cek apakah objek merupakan part map (bukan item kecil/senjata)
        if object.Size.X > 5 or object.Size.Z > 5 or object.Size.Y > 5 then
            
            -- Hapus tekstur/decal yang menutupi pantulan kaca
            for _, child in pairs(object:GetChildren()) do
                if child:IsA("Texture") or child:IsA("Decal") then
                    child:Destroy()
                end
            end
            
            -- Paksa ubah material dan tingkat pantulan
            object.Material = Enum.Material.Glass
            object.Reflectance = 0.8 -- Nilai tinggi biar langsung kelihatan efek lantainya
        end
    end
end

-- Terapkan ke seluruh Map Evade
for _, child in pairs(Workspace:GetDescendants()) do
    forceReflection(child)
end

-- Terapkan ke objek baru yang muncul/loaded
Workspace.DescendantAdded:Connect(function(child)
    task.wait(0.05)
    forceReflection(child)
end)

print("KILLER_VOIDS Evade Glass Shader Loaded! 😈🔥")
