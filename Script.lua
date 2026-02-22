-- BUILD AND STEAL 2026 - MOBILE GUI EDITION
local LP = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local Remote = RS:WaitForChild("RemoteEvent")
local _G_SERVER_ID = nil 

-- 1. CAPTURADOR DE ID (Hook para o Delta 2026)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if self == Remote and method == "FireServer" and args[1] == "grabpet" then
        if not _G_SERVER_ID then
            _G_SERVER_ID = args[2] -- Captura o ID que muda (ex: 16777216)
            print("ID CAPTURADO: " .. tostring(_G_SERVER_ID))
        end
    end
    return oldNamecall(self, ...)
end)

-- 2. CRIAÇÃO DO BOTÃO NO ECRÃ
local sg = Instance.new("ScreenGui", game.CoreGui)
local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 150, 0, 50)
btn.Position = UDim2.new(0.1, 0, 0.5, 0)
btn.Text = "ROUBAR TUDO"
btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
btn.Draggable = true -- Podes mover o botão no telemóvel

-- 3. FUNÇÃO DE ROUBO SUAVE (SEM VOLTAR ATRÁS)
local function stealAll()
    if not _G_SERVER_ID then
        btn.Text = "ERRO: PEGA 1 ITEM À MÃO"
        task.wait(2)
        btn.Text = "ROUBAR TUDO"
        return
    end

    btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    for _, plot in pairs(workspace.Plots:GetChildren()) do
        if plot.Name ~= LP.Name then
            local builds = plot:FindFirstChild("Builds")
            if builds then
                for _, item in pairs(builds:GetChildren()) do
                    local hrp = LP.Character:WaitForChild("HumanoidRootPart")
                    
                    -- Move-se por cima para não bugar na parede
                    hrp.CFrame = item:GetPivot() * CFrame.new(0, 5, 0)
                    task.wait(0.6) -- Delay para o servidor aceitar a posição [1.2]

                    -- Usa o ID capturado automaticamente
                    Remote:FireServer("grabpet", _G_SERVER_ID, item, hrp.CFrame)
                    
                    -- Bypass de ProximityPrompt
                    local p = item:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if p then fireproximityprompt(p) end
                    
                    task.wait(1.5) -- Espera para não dar rubberband [1.4]
                end
            end
        end
    end
    btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
end

btn.MouseButton1Click:Connect(stealAll)
