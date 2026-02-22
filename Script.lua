-- BUILD AND STEAL - UNIVERSAL TWEEN BYPASS (FEV 2026)
local LP = game.Players.LocalPlayer
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local Remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")

_G.StealActive = true

-- 1. NOCLIP TOTAL (Para não bugar em paredes/tectos)
RS.Stepped:Connect(function()
    if _G.StealActive and LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- 2. FUNÇÃO DE MOVIMENTO SEGURO (Impede o "Back-TP")
local function safeMove(targetCF)
    local hrp = LP.Character:WaitForChild("HumanoidRootPart")
    local distance = (hrp.Position - targetCF.Position).Magnitude
    local speed = 120 -- Velocidade que o servidor de 2026 aceita sem dar kick
    
    local info = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
    local tween = TS:Create(hrp, info, {CFrame = targetCF})
    tween:Play()
    tween.Completed:Wait()
end

-- 3. LOGICA DE ROUBO
local function steal(item)
    if not item:IsA("Model") then return end
    
    -- Vai por cima (Sky-walk) para evitar detecção de altura
    local targetPos = item:GetPivot()
    safeMove(CFrame.new(targetPos.X, 120, targetPos.Z)) 
    task.wait(0.1)
    LP.Character.HumanoidRootPart.CFrame = targetPos * CFrame.new(0, 3, 0)
    
    task.wait(0.5) -- Delay para o Delta processar a posição

    -- Dispara o Remote (ID 16777216 que confirmaste)
    Remote:FireServer("grabpet", 16777216, item, LP.Character.HumanoidRootPart.CFrame)
    
    -- Bypass de ProximityPrompt (Caso o Remote falhe)
    local p = item:FindFirstChildWhichIsA("ProximityPrompt", true)
    if p then fireproximityprompt(p) end
    
    task.wait(1.2)
end

-- 4. LOOP DE VARREDURA DO MAPA
task.spawn(function()
    while _G.StealActive do
        local plots = workspace:FindFirstChild("Plots")
        if plots then
            for _, plot in pairs(plots:GetChildren()) do
                if plot.Name ~= LP.Name then
                    local builds = plot:FindFirstChild("Builds")
                    if builds then
                        for _, item in pairs(builds:GetChildren()) do
                            if not _G.StealActive then break end
                            steal(item)
                        end
                    end
                end
            end
        end
        task.wait(5)
    end
end)

print("SCRIPT CARREGADO COM SUCESSO DO GITHUB!")
