-- ===================================================
-- KILLER_VOIDS CLEAN & NATURAL SHADER (NO GLARE)
-- ===================================================

local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LocalPlayer = game:GetService("Players").LocalPlayer

-- 1. FIX LIGHTING & SHADOW (Bikin Bayangan Tegas & Gak Silau)
Lighting.GlobalShadows = true

local ColorCorrection = Lighting:FindFirstChildOfClass("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect", Lighting)
ColorCorrection.Brightness = 0
ColorCorrection.Contrast = 0.1
ColorCorrection.Saturation = 0.15

local Bloom = Lighting:FindFirstChildOfClass("BloomEffect") or Instance.new("BloomEffect", Lighting)
Bloom.Intensity = 0.15 -- Dikecilkan biar api/cahaya gak meledak
Bloom.Size = 12
Bloom.Threshold = 0.95

-- 2. DEDIKASI KHUSUS LANTAI / ROAD (Gak Kena ke Pohon/Mobil)
local function applyNaturalReflection(object)
    if object:IsA("BasePart") and not object:IsDescendantOf(LocalPlayer.Character or script) then
        local nameLower = string.lower(object.Name)
        
        -- Deteksi khusus jalan, lantai, atau part pijakan lebar
        local isFloor = nameLower:find("road") or nameLower:find("street") or nameLower:find("floor") or nameLower:find("asphalt") or nameLower:find("ground")
        local isWidePart = (object.Size.X > 25 and object.Size.Z > 25 and object.Size.Y < 5)

        if isFloor or isWidePart then
            -- Gunakan SmoothPlastic + Reflectance Halus (Bikin Efek Glossy/Basah Natural)
            object.Material = Enum.Material.SmoothPlastic
            object.Reflectance = 0.18 -- Nilai pas biar gak bikin sakit mata
        end
    end
end

-- Terapkan ke Map
for _, child in pairs(Workspace:GetDescendants()) do
    applyNaturalReflection(child)
end

Workspace.DescendantAdded:Connect(function(child)
    task.wait(0.05)
    applyNaturalReflection(child)
end)

print("KILLER_VOIDS Clean Shader Applied! 😈🔥")
