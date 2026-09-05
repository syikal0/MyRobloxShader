-- ===================================================
-- KILLER_VOIDS CUSTOM REFLECTION & LIGHTING SHADER
-- ===================================================

local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

-- 1. UBAH LIGHTING GAME JADI MAXIMUM VISUAL
pcall(function()
    Lighting.Technology = Enum.Technology.Future -- Memaksa engine render ke Future Lighting
    Lighting.GlobalShadows = true
    Lighting.Brightness = 2
    Lighting.OutdoorAmbient = Color3.fromRGB(120, 120, 120)
end)

-- 2. TAMBAHKAN EFEK VISUAL POST-PROCESSING
local ColorCorrection = Lighting:FindFirstChildOfClass("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect", Lighting)
ColorCorrection.Brightness = 0.05
ColorCorrection.Contrast = 0.15
ColorCorrection.Saturation = 0.2

local Bloom = Lighting:FindFirstChildOfClass("BloomEffect") or Instance.new("BloomEffect", Lighting)
Bloom.Intensity = 0.4
Bloom.Size = 24
Bloom.Threshold = 0.8

-- 3. BIKIN LANTAI BISA MANTULIN BAYANGAN / AVATAR (KACA EFFECT)
local function applyGlassReflection(object)
    if object:IsA("BasePart") then
        -- Cek apakah nama part mengindikasikan lantai / floor / base
        local nameLower = string.lower(object.Name)
        if nameLower:find("floor") or nameLower:find("base") or nameLower:find("ground") or object.Size.X > 20 or object.Size.Z > 20 then
            object.Material = Enum.Material.Glass -- Ubah jadi Glass
            object.Reflectance = 0.4 -- Set tingkat pantulan (0.1 - 1.0)
        end
    end
end

-- Terapkan ke semua part yang sudah ada di Map
for _, child in pairs(Workspace:GetDescendants()) do
    applyGlassReflection(child)
end

-- Terapkan ke part baru yang di-render saat game berjalan
Workspace.DescendantAdded:Connect(function(child)
    task.wait(0.1)
    applyGlassReflection(child)
end)

print("KILLER_VOIDS Shader Successfully Loaded! 😈🔥")
