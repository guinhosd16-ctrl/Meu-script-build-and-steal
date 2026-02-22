-- CONFIGURAÇÕES
local SPEED = 100 -- Velocidade segura para não dar kick (0-150)
local HEIGHT = 100 -- Sobe para o céu para evitar paredes

local LP = game.Players.LocalPlayer
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local Remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")

_G.StealActive = true

-- 1. NOCLIP AUTOMÁTICO (Para não bugar em paredes)
RS.Stepped:Connect(function()
    if _G.StealActive and LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- 2. FUNÇÃO DE MOVIMENTO SUAVE (O Segredo para não voltar atrás)
local function tweenTo(targetCF)
    local hrp = LP.Character:WaitForChild("HumanoidRootPart")
    local distance = (hrp.Position - targetCF.Position).Magnitude
    local info = TweenInfo.new(distance / SPEED, Enum.EasingStyle.Linear)
    
    local tween = TS:Create(hrp, info, {CFrame = targetCF})
    tween:Play()
    tween.Completed:Wait()
end

-- 3. LOGICA DE ROUBO PRECISO
local function steal(item)
    if not item:IsA("Model") then return end
    local targetPos = item:GetPivot()

    -- Voo por cima (Sky-Walk) para evitar detecção
    tweenTo(CFrame.new(targetPos.X, HEIGHT, targetPos.Z))
    task.wait(0.1)
    LP.Character.HumanoidRootPart.CFrame = targetPos * CFrame.new(0, 3, 0)
    
    task.wait(0.6) -- Tempo para o Delta processar a posição real

    -- Dispara o Roubo (ID 16777216)
    Remote:FireServer("grabpet", 16777216, item, LP.Character.HumanoidRootPart.CFrame)
    
    -- Bypass de ProximityPrompt
    local p = item:FindFirstChildWhichIsA("ProximityPrompt", true)
    if p then fireproximityprompt(p) end
    
    task.wait(1.5)
end

-- 4. LOOP DE VARREDURA
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
