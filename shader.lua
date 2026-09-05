-- ===================================================
-- KILLER_VOIDS EXPLOIT OVERRIDE: EVADE RTX SHADER V2 (FIXED LANTAI)
-- EXECUTE IN ROBLOX PLAYER VIA EXECUTOR
-- ===================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

print("😈🔥 KILLER_VOIDS FIXING RTX SHADER: RESTORING FLOOR TEXTURE & REFLECTION...")

-- [1] INJEKSI LIGHTING (Biar grafis tetap sinematik ala RTX)
local function injectShaders()
    if not Lighting:FindFirstChild("KV_Color") then
        local cc = Instance.new("ColorCorrectionEffect")
        cc.Name = "KV_Color"
        cc.Contrast = 0.15
        cc.Saturation = 0.15
        cc.Parent = Lighting
        
        local bloom = Instance.new("BloomEffect")
        bloom.Name = "KV_Bloom"
        bloom.Intensity = 0.3
        bloom.Size = 24
        bloom.Threshold = 1.5
        bloom.Parent = Lighting
    end
end
injectShaders()

-- [2] AUTO-SCAN MAP EVADE (FIX: Jangan ubah jadi Glass transparan, biarkan tekstur asli tapi buat mengkilap)
task.spawn(function()
    while task.wait(3) do
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj.Parent:FindFirstChild("Humanoid") then
                -- Filter part datar besar (lantai/jalan)
                if obj.Size.X > 15 and obj.Size.Z > 15 and obj.Size.Y < 5 then
                    -- JANGAN UBAH JADI GLASS SUPAYA GA TEMBUS PANDANG KE BAWAH VOID!
                    -- Kita cukup naikin Reflectance-nya biar lantai jadi glossy/memantul
                    obj.Reflectance = 0.35 
                end
            end
        end
    end
end)

-- [3] INJEKSI KLONINGAN BAYANGAN (DIKONTROL SUPAYA MUNCUL JELAS DI BAWAH)
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
    
    if not rootPart then return end
    
    for _, p in pairs(character:GetDescendants()) do
        if p:IsA("Instance") then p.Archivable = true end
    end
    character.Archivable = true
    
    local clone = character:Clone()
    if not clone then return end 
    clone.Name = "KV_SHADOW_CLONE"
    
    for _, child in pairs(clone:GetDescendants()) do
        if child:IsA("Script") or child:IsA("LocalScript") then
            child:Destroy()
        elseif child:IsA("BasePart") then
            child.CanCollide = false
            child.CastShadow = false
            child.Massless = true
            
            if child.Name == "HumanoidRootPart" then
                child.Anchored = true
                child.Transparency = 1
            else
                child.Anchored = false
                child.Color = Color3.fromRGB(10, 10, 15) -- Warna bayangan gelap elegan
                child.Material = Enum.Material.SmoothPlastic -- Pakai plastik mulus biar bayangan solid kelihatan
                child.Transparency = 0.45 -- Pas tidak terlalu pudar tapi tetap kelihatan kayak bayangan cermin
            end
        elseif child:IsA("Humanoid") then
            child.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            child.PlatformStand = true
        elseif child:IsA("Decal") or child:IsA("Texture") then
            child.Transparency = 0.6
        end
    end
    
    clone.Parent = cloneFolder
    
    reflectionConnection = RunService.RenderStepped:Connect(function()
        if not character or not character.Parent or not clone or not clone.Parent or (character:FindFirstChild("Humanoid") and character.Humanoid.Health <= 0) then
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
        
        -- Posisi cermin disesuaikan persis di atas lantai tanpa tembus ke bawah
        local mirrorPos = Vector3.new(charCFrame.X, floorY - distFromFloor + 0.05, charCFrame.Z)
        local mirrorCFrame = CFrame.new(mirrorPos) * (charCFrame.Rotation * CFrame.Angles(0, 0, math.pi))
        
        clone:PivotTo(mirrorCFrame)
        
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
    task.wait(1.5)
    deployExploitClone()
end)

if LocalPlayer.Character then
    deployExploitClone()
end

print("😈🔥 KILLER_VOIDS: FIXED! LANTAI KEMBALI NORMAL & REFLEKSI MUNCUL SEMPURNA!")
