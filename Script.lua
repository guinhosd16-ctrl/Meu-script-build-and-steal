-- BUILD AND STEAL 2026 - TWEEN BYPASS EDITION
local LP = game.Players.LocalPlayer
local TS = game:GetService("TweenService")
local Remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")
local _G_SERVER_ID = nil

-- 1. CAPTURADOR AUTOMÁTICO DE ID (ESSENCIAL)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if self == Remote and method == "FireServer" and args[1] == "grabpet" then
        if not _G_SERVER_ID then
            _G_SERVER_ID = args[2]
            print("ID CAPTURADO: " .. tostring(_G_SERVER_ID))
        end
    end
    return oldNamecall(self, ...)
end)

-- 2. FUNÇÃO DE MOVIMENTO SUAVE (O Segredo para não voltar atrás)
local function smoothMove(targetCF)
    local hrp = LP.Character:WaitForChild("HumanoidRootPart")
    local distance = (hrp.Position - targetCF.Position).Magnitude
    local speed = 100 -- Velocidade segura para evitar detecção (0-150)
    
    local info = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
    local tween = TS:Create(hrp, info, {CFrame = targetCF})
    tween:Play()
    tween.Completed:Wait()
end

-- 3. CRIAÇÃO DO BOTÃO NO ECRÃ
local sg = Instance.new("ScreenGui", game.CoreGui)
local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 150, 0, 50)
btn.Position = UDim2.new(0.1, 0, 0.4, 0)
btn.Text = "ROUBAR TUDO"
btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
btn.Draggable = true

btn.MouseButton1Click:Connect(function()
    if not _G_SERVER_ID then
        btn.Text = "PEGA 1 ITEM À MÃO!"
        task.wait(2)
        btn.Text = "ROUBAR TUDO"
        return
    end

    btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    local plots = workspace:FindFirstChild("Plots")
    if plots then
        for _, plot in pairs(plots:GetChildren()) do
            if plot.Name ~= LP.Name then
                local builds = plot:FindFirstChild("Builds")
                if builds then
                    for _, item in pairs(builds:GetChildren()) do
                        -- MOVE-SE SUAVEMENTE ATÉ AO ITEM
                        smoothMove(item:GetPivot() * CFrame.new(0, 3, 0))
                        task.wait(0.3)

                        -- DISPARA O ROUBO COM O ID CAPTURADO
                        Remote:FireServer("grabpet", _G_SERVER_ID, item, LP.Character.HumanoidRootPart.CFrame)
                        
                        -- BYPASS DE PROXIMITYPROMPT (DELTA)
                        local p = item:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if p then fireproximityprompt(p) end
                        
                        task.wait(1.2) -- Delay para o servidor processar [1.4]
                    end
                end
            end
        end
    end
    btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
end)

