-- ===================================================
-- KILLER_VOIDS EXPLOIT OVERRIDE: EVADE RTX SHADER & REFLECTION
-- EXECUTE IN ROBLOX PLAYER VIA EXECUTOR
-- ===================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

print("😈🔥 KILLER_VOIDS INJECTING RTX SHADER TO EVADE...")

-- [1] INJEKSI LIGHTING (BIAR EFEK KACANYA MENGKILAP ALA RTX)
local function injectShaders()
    if not Lighting:FindFirstChild("KV_Color") then
        local cc = Instance.new("ColorCorrectionEffect")
        cc.Name = "KV_Color"
        cc.Contrast = 0.25
        cc.Saturation = 0.3
        cc.Parent = Lighting
        
        local bloom = Instance.new("BloomEffect")
        bloom.Name = "KV_Bloom"
        bloom.Intensity = 0.6
        bloom.Size = 24
        bloom.Threshold = 1.5
        bloom.Parent = Lighting
    end
end
injectShaders()

-- [2] AUTO-SCAN MAP EVADE (UBAH LANTAI JADI KACA)
-- Berjalan di background biar tiap ronde ganti map, lantainya tetep jadi kaca
task.spawn(function()
    while task.wait(3) do -- Cek tiap 3 detik biar gak bikin executor crash
        -- Evade biasanya masukin map ke Workspace. Cek semua part gede
        for _, obj in pairs(Workspace:GetDescendants()) do
            -- Abaikan karakter player/bot biar gak ikutan jadi kaca
            if obj:IsA("BasePart") and not obj.Parent:FindFirstChild("Humanoid") then
                -- Targetin part yang lumayan lebar (biasanya lantai/jalan)
                if obj.Size.X > 15 and obj.Size.Z > 15 and obj.Material ~= Enum.Material.Glass then
                    obj.Material = Enum.Material.Glass
                    obj.Transparency = 0.55 -- Transparan biar bayangan nembus
                    obj.Reflectance = 0.35 -- Mantulin cahaya (Glossy)
                    obj.Color = Color3.fromRGB(15, 15, 20) -- Warna dark biar elegan
                end
            end
        end
    end
end)

-- [3] INJEKSI KLONINGAN BAYANGAN (ANTI-LAG & BYPASS EVADE RIG)
local cloneFolder = Workspace:FindFirstChild("KV_ReflectionFolder")
if not cloneFolder then
    cloneFolder = Instance.new("Folder")
    cloneFolder.Name = "KV_ReflectionFolder"
    cloneFolder.Parent = Workspace
else
    cloneFolder:ClearAllChildren()
end

local reflectionConnection

local function deployExploitClone()
    if reflectionConnection then
        reflectionConnection:Disconnect()
    end
    
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart", 5)
    
    if not rootPart then return end -- Kalo lagi mati/spectate, batalkan
    
    character.Archivable = true
    local clone = character:Clone()
    clone.Name = "KV_SHADOW_CLONE"
    
    -- Hapus sampah dari klonan biar exploit lu gak ke-detect anti-cheat
    for _, child in pairs(clone:GetDescendants()) do
        if child:IsA("Script") or child:IsA("LocalScript") then
            child:Destroy()
        elseif child:IsA("BasePart") then
            child.CanCollide = false
            child.CastShadow = false
            child.Massless = true
            if child.Name ~= "HumanoidRootPart" then
                child.Color = Color3.fromRGB(30, 30, 40)
                child.Material = Enum.Material.SmoothPlastic
            end
        elseif child:IsA("Humanoid") then
            child.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            child.PlatformStand = true -- Lumpuhkan humanoid klonan biar diem
        end
    end
    
    clone.Parent = cloneFolder
    
    -- Sync posisi & animasi secara brutal tiap frame!
    reflectionConnection = RunService.RenderStepped:Connect(function()
        if not character or not character.Parent or not clone or not clone.Parent or character.Humanoid.Health <= 0 then
            return
        end
        
        local rayOrigin = rootPart.Position
        local rayDirection = Vector3.new(0, -50, 0)
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {character, cloneFolder}
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        
        local raycastResult = Workspace:Raycast(rayOrigin, rayDirection, rayParams)
        local floorY = rootPart.Position.Y - (rootPart.Size.Y * 1.5)
        
        if raycastResult then
            floorY = raycastResult.Position.Y
        end
        
        local charCFrame = rootPart.CFrame
        local distFromFloor = charCFrame.Y - floorY
        
        -- Proyeksi cermin ke bawah
        local mirrorPos = Vector3.new(charCFrame.X, floorY - distFromFloor, charCFrame.Z)
        local mirrorCFrame = CFrame.new(mirrorPos) * (charCFrame.Rotation * CFrame.Angles(0, 0, math.pi))
        
        local cloneRoot = clone:FindFirstChild("HumanoidRootPart")
        if cloneRoot then
            cloneRoot.CFrame = mirrorCFrame
        end
        
        -- Paksa sinkronisasi engsel pergerakan Evade
        for _, motor in pairs(character:GetDescendants()) do
            if motor:IsA("Motor6D") then
                local cloneMotor = clone:FindFirstChild(motor.Name, true)
                if cloneMotor and cloneMotor:IsA("Motor6D") then
                    cloneMotor.Transform = motor.Transform
                end
            end
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1) -- Tunggu rig Evade ke-load sempurna di client
    deployExploitClone()
end)

if LocalPlayer.Character then
    deployExploitClone()
end

print("😈🔥 KILLER_VOIDS: EVADE RTX INJECTION SUCCESS! GAS MAIN!")
