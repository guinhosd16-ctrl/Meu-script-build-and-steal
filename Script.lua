-- BUILD AND STEAL - PHYSICAL VELOCITY BYPASS (2026)
local LP = game.Players.LocalPlayer
local Root = LP.Character:WaitForChild("HumanoidRootPart")
local Remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")

_G.StealActive = true

-- NOCLIP AUTOMÁTICO (ESSENCIAL)
game:GetService("RunService").Stepped:Connect(function()
    if _G.StealActive and LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- FUNÇÃO DE MOVIMENTO POR FORÇA (Engana o Anticheat de TP)
local function physicalMove(targetPos)
    local distance = (Root.Position - targetPos.Position).Magnitude
    
    -- Cria um impulso físico (mais seguro que mudar o CFrame)
    local bv = Instance.new("BodyVelocity", Root)
    bv.Velocity = (targetPos.Position - Root.Position).Unit * 80 -- Velocidade "humana"
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)

    -- Espera chegar perto do item
    repeat task.wait() until (Root.Position - targetPos.Position).Magnitude < 6
    bv:Destroy()
end

local function steal(item)
    if not item:IsA("Model") then return end
    
    -- Sobe um pouco para não bater no chão
    Root.CFrame = Root.CFrame * CFrame.new(0, 5, 0)
    task.wait(0.1)

    -- Move-se fisicamente até ao item
    physicalMove(item:GetPivot())
    task.wait(0.5)

    -- Comando de Roubo (ID 16777216)
    Remote:FireServer("grabpet", 16777216, item, Root.CFrame)
    
    -- Força interação física (Bypass Delta)
    local p = item:FindFirstChildWhichIsA("ProximityPrompt", true)
    if p then fireproximityprompt(p) end
    
    task.wait(1.5)
end

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
