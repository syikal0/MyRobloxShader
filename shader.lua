-- ===================================================
-- KILLER_VOIDS IMPROVED REFLECTION & LIGHTING SHADER
-- ===================================================

local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

-- 1. POST-PROCESSING (Pasti Work 100% di Client)
local ColorCorrection = Lighting:FindFirstChildOfClass("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect", Lighting)
ColorCorrection.Brightness = 0.02
ColorCorrection.Contrast = 0.2
ColorCorrection.Saturation = 0.25

local Bloom = Lighting:FindFirstChildOfClass("BloomEffect") or Instance.new("BloomEffect", Lighting)
Bloom.Intensity = 0.5
Bloom.Size = 24
Bloom.Threshold = 0.7

-- 2. AUTO-LOGIC LANTAI MANTUL
local function applyGlassReflection(object)
    if object:IsA("BasePart") and not object:IsDescendantOf(game.Players.LocalPlayer.Character or script) then
        -- Deteksi part berukuran lebar (kemungkinan besar lantai/pijakan)
        if object.Size.X >= 15 or object.Size.Z >= 15 then
            -- SmoothPlastic + Reflectance memberikan efek glossy/pemantulan yang konsisten
            object.Material = Enum.Material.SmoothPlastic
            object.Reflectance = 0.35
        end
    end
end

-- Terapkan ke Map
for _, child in pairs(Workspace:GetDescendants()) do
    applyGlassReflection(child)
end

Workspace.DescendantAdded:Connect(function(child)
    task.wait(0.1)
    applyGlassReflection(child)
end)

print("KILLER_VOIDS Optimized Shader Active! 😈🔥")
