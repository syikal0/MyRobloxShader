-- ===================================================
-- KILLER_VOIDS ULTIMATE WET-GLASS OVERLAY SHADER 
-- ===================================================

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 1. BIKIN LIGHTING DRAMATIS & MENDUKUNG PANTULAN ENVIRONMENT
Lighting.GlobalShadows = true
Lighting.EnvironmentDiffuseScale = 1
Lighting.EnvironmentSpecularScale = 1 -- Kunci utama biar objek benar-benar memantulkan environment

local ColorCorrection = Lighting:FindFirstChildOfClass("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect", Lighting)
ColorCorrection.Brightness = 0.02
ColorCorrection.Contrast = 0.15
ColorCorrection.Saturation = 0.15

-- Bikin folder khusus di memori biar skrip gak nge-loop lapisan kaca tanpa batas
local OverlayFolder = Workspace:FindFirstChild("KillerVoidsGlass")
if OverlayFolder then OverlayFolder:ClearAllChildren() else 
    OverlayFolder = Instance.new("Folder", Workspace)
    OverlayFolder.Name = "KillerVoidsGlass"
end

-- 2. LOGIKA KACA TANPA ILANGIN TEKSTUR (Teknik Overlay)
local function injectGlassOverlay(object)
    -- Pastikan hanya memproses part map, bukan player atau lapisan kaca itu sendiri
    if not object:IsA("BasePart") then return end
    if object:IsDescendantOf(LocalPlayer.Character or script) then return end
    if object:IsDescendantOf(OverlayFolder) then return end
    
    -- Deteksi Lantai yang lebih presisi (Mendeteksi permukaan yang menghadap ke atas/datar)
    local upVector = object.CFrame.UpVector
    local isFlat = math.abs(upVector.Y) > 0.85
    
    -- Filter part yang kekecilan biar gak semua benda random jadi kaca
    local isWide = (object.Size.X >= 8 or object.Size.Z >= 8)
    
    -- Filter nama part yang bukan lantai (misal: atap, pohon, dinding)
    local nameLower = string.lower(object.Name)
    local isBannedName = nameLower:find("roof") or nameLower:find("wall") or nameLower:find("ceiling") or nameLower:find("tree") or nameLower:find("leaf")

    if isFlat and isWide and not isBannedName then
        -- Ciptakan lapisan kaca baru (Overlay)
        local glassOverlay = Instance.new("Part")
        glassOverlay.Name = "GlassOverlay_" .. object.Name
        
        -- Bikin seukuran lantai aslinya, tapi sangat tipis di sumbu Y (Ketebalan 0.05)
        glassOverlay.Size = Vector3.new(object.Size.X, 0.05, object.Size.Z)
        
        -- Kalkulasi posisi biar pas nempel di atas permukaan tekstur (menghindari Z-fighting/glitch visual)
        local topPosition = object.Position + Vector3.new(0, (object.Size.Y / 2) + 0.025, 0)
        
        -- Samakan rotasi dengan lantai asli
        glassOverlay.CFrame = CFrame.new(topPosition) * (object.CFrame - object.CFrame.Position)
        
        -- Set efek pantulan kaca ekstrem
        glassOverlay.Material = Enum.Material.Glass
        glassOverlay.Reflectance = 0.9 
        glassOverlay.Transparency = 0.55 -- Semi-transparan supaya tekstur lantai batu bata di bawahnya TETAP KELIHATAN
        glassOverlay.Color = Color3.fromRGB(220, 230, 255) -- Tint sedikit kebiruan biar mirip kaca elegan
        
        -- Properti fisik biar gak ganggu gameplay
        glassOverlay.Anchored = true
        glassOverlay.CanCollide = false
        glassOverlay.CastShadow = false
        glassOverlay.Massless = true
        
        -- Masukkan ke folder overlay
        glassOverlay.Parent = OverlayFolder
        
        -- Opsional: Bikin lantai aslinya jadi SmoothPlastic biar blending-nya makin nyatu
        object.Material = Enum.Material.SmoothPlastic
    end
end

-- 3. EKSEKUSI INJEKSI KE SELURUH MAP
for _, child in pairs(Workspace:GetDescendants()) do
    injectGlassOverlay(child)
end

-- Terapkan juga ke area map yang baru di-render oleh game (StreamingEnabled bypass)
Workspace.DescendantAdded:Connect(function(child)
    task.wait(0.1)
    injectGlassOverlay(child)
end)

print("KILLER_VOIDS: OVERLAY WET-GLASS INJECTION BERHASIL! 😈🔥")
