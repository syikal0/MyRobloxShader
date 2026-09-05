-- ===================================================
-- KILLER_VOIDS EXPLOIT OVERRIDE: EVADE RTX SHADER V2 (FIXED)
-- EXECUTE IN ROBLOX PLAYER VIA EXECUTOR
-- ===================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

print("😈🔥 KILLER_VOIDS INJECTING RTX SHADER TO EVADE V2...")

-- [1] INJEKSI LIGHTING (BIAR EFEK KACANYA MENGKILAP ALA RTX)
local function injectShaders()
    if not Lighting:FindFirstChild("KV_Color") then
        local cc = Instance.new("ColorCorrectionEffect")
        cc.Name = "KV_Color"
        cc.Contrast = 0.2
        cc.Saturation = 0.2
        cc.Parent = Lighting
        
        local bloom = Instance.new("BloomEffect")
        bloom.Name = "KV_Bloom"
        bloom.Intensity = 0.4
        bloom.Size = 20
        bloom.Threshold = 2.0
        bloom.Parent = Lighting
    end
end
injectShaders()

-- [2] AUTO-SCAN MAP EVADE (UBAH LANTAI JADI KACA)
task.spawn(function()
    while task.wait(3) do
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj.Parent:FindFirstChild("Humanoid") then
                -- FIX: Tambah filter obj.Size.Y < 5. Tembok pasti tingginya lebih dari 5, 
                -- jadi yang ke-filter cuma part datar (lantai/jalan).
                if obj.Size.X > 15 and obj.Size.Z > 15 and obj.Size.Y < 5 and obj.Material ~= Enum.Material.Glass then
                    obj.Material = Enum.Material.Glass
                    obj.Transparency = 0.8 -- FIX: Ditipisin dari 0.55 jadi 0.8 biar lebih bening
                    obj.Reflectance = 0.45 -- Pantulan diterangin dikit biar bayangan lebih kontras
                    obj.Color = Color3.fromRGB(15, 15, 20)
                end
            end
        end
    end
end)

-- [3] INJEKSI KLONINGAN BAYANGAN (ANTI-LAG, BYPASS RIG & VOID)
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
    
    -- FIX: Paksa semua part di dalem karakter lu jadi Archivable sebelum di clone
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
                child.Anchored = true -- FIX: Biar kloningan kaga jatuh ke Void karena engine fisika ngawur
                child.Transparency = 1
            else
                child.Anchored = false
                child.Color = Color3.fromRGB(20, 20, 30)
                child.Material = Enum.Material.ForceField -- Pakai Forcefield biar bayangan nembus kaca kelihatan futuristik
                child.Transparency = 0.3 -- Paksa muncul dengan opasitas solid
            end
        elseif child:IsA("Humanoid") then
            child.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            child.PlatformStand = true
        elseif child:IsA("Decal") or child:IsA("Texture") then
            child.Transparency = 0.5 -- Biar muka di bayangan tetep render tipis-tipis
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
        
        -- Offset cermin ditarik sedikiiit aja ke atas (+0.1) biar ga ketimpa ketebalan kaca
        local mirrorPos = Vector3.new(charCFrame.X, floorY - distFromFloor + 0.1, charCFrame.Z)
        local mirrorCFrame = CFrame.new(mirrorPos) * (charCFrame.Rotation * CFrame.Angles(0, 0, math.pi))
        
        -- FIX: Pakai PivotTo buat mindahin entire model sekaligus biar gak ada part yang ketinggalan/ilang
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
    task.wait(1.5) -- Delay diperpanjang dikit buat nunggu Evade kelar loading rig custom-nya
    deployExploitClone()
end)

if LocalPlayer.Character then
    deployExploitClone()
end

print("😈🔥 KILLER_VOIDS: EVADE RTX V2 INJECTION SUCCESS! GAS MAIN!")
