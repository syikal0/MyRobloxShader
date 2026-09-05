-- ===================================================
-- KILLER_VOIDS EXPLOIT OVERRIDE: ENVIRONMENT REFLECTION ONLY
-- EXECUTE IN ROBLOX PLAYER VIA EXECUTOR
-- ===================================================

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

print("😈🔥 KILLER_VOIDS: INJECTING SCENE REFLECTIONS...")

-- [1] INJEKSI LIGHTING PBR (Wajib untuk memunculkan pantulan map & langit)
local function injectShaders()
    if not Lighting:FindFirstChild("KV_Color") then
        local cc = Instance.new("ColorCorrectionEffect")
        cc.Name = "KV_Color"
        cc.Contrast = 0.15
        cc.Saturation = 0.15
        cc.Parent = Lighting
        
        local bloom = Instance.new("BloomEffect")
        bloom.Name = "KV_Bloom"
        bloom.Intensity = 0.2
        bloom.Size = 24
        bloom.Threshold = 2.0
        bloom.Parent = Lighting
    end
    
    -- KUNCI UTAMA: Paksa engine merender pantulan Environment Map ke permukaan objek
    Lighting.GlobalShadows = true
    Lighting.EnvironmentSpecularScale = 1
    Lighting.EnvironmentDiffuseScale = 1
end
injectShaders()

-- [2] AUTO-SCAN MAP (Lantai glossy, 0% transparan, menangkap refleksi sekitar)
task.spawn(function()
    while task.wait(3) do
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj.Parent:FindFirstChild("Humanoid") then
                -- Filter dimensi untuk menargetkan jalan/lantai
                if obj.Size.X > 15 and obj.Size.Z > 15 and obj.Size.Y < 5 then
                    
                    -- 1. Kunci transparansi di 0 agar lantai tetap solid dan tidak nembus
                    obj.Transparency = 0 
                    
                    -- 2. Tarik reflectance ke level maksimal untuk efek cermin
                    obj.Reflectance = 0.9 
                    
                    -- 3. Override material ke SmoothPlastic. 
                    -- Jika dihapus, lantai akan pakai tekstur asli tapi pantulan jadi kusam/blur.
                    obj.Material = Enum.Material.SmoothPlastic 
                end
            end
        end
    end
end)

print("😈🔥 KILLER_VOIDS: DONE! LANTAI MENGKILAP MANTULIN LINGKUNGAN!")
