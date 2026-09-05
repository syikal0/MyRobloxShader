-- ===================================================
-- KILLER_VOIDS STRICT FLOOR-ONLY GLASS SHADER
-- ===================================================

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local LocalPlayer = game:GetService("Players").LocalPlayer

-- 1. FIX LIGHTING & HAPUS SILAU (Biar bayangan tegas & mata gak sakit)
Lighting.GlobalShadows = true
local Bloom = Lighting:FindFirstChildOfClass("BloomEffect")
if Bloom then 
    Bloom.Intensity = 0.05 -- Matiin silau lampu/api biar gak over-exposed
end
local ColorCorrection = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
if ColorCorrection then
    ColorCorrection.Brightness = 0
    ColorCorrection.Contrast = 0.1
end

-- 2. LOGIKA SUPER KETAT HANYA UNTUK LANTAI / PIJAKAN
local function makeFloorGlassOnly(object)
    if object:IsA("BasePart") and not object:IsDescendantOf(LocalPlayer.Character or script) then
        
        -- Rumus Deteksi Lantai: Lebarnya harus gede (X dan Z > 20), tapi tipis/ceper (Y <= 5)
        local isFloorShape = (object.Size.X > 20 and object.Size.Z > 20 and object.Size.Y <= 5)
        
        -- Deteksi tambahan dari nama part
        local nameLower = string.lower(object.Name)
        local isFloorName = nameLower:find("floor") or nameLower:find("ground") or nameLower:find("road") or nameLower:find("asphalt")

        -- JIKA BENERAN LANTAI, UBAH JADI KACA! Sisa objek hiraukan.
        if isFloorShape or isFloorName then
            object.Material = Enum.Material.Glass
            object.Reflectance = 1 -- Mentokin ke 1 biar pantulan cahaya/langit maksimal kayak kaca basah
            
            -- Jangan hapus tekstur biar tetap natural, cukup timpa materialnya.
        end
    end
end

-- Terapkan ke semua objek di map
for _, child in pairs(Workspace:GetDescendants()) do
    makeFloorGlassOnly(child)
end

-- Terapkan ke area map yang baru ke-load
Workspace.DescendantAdded:Connect(function(child)
    task.wait(0.05)
    makeFloorGlassOnly(child)
end)

print("KILLER_VOIDS: Misi Selesai! Cuma Lantai yang jadi Kaca! 😈🔥")
