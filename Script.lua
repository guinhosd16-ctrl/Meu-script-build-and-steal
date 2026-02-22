-- FUNÇÃO ROUBAR TUDO (STEAL ALL)
local function stealAll()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end

    for _, plot in pairs(plots:GetChildren()) do
        -- Verifica se o Plot não é o teu
        if plot.Name ~= game.Players.LocalPlayer.Name then
            local builds = plot:FindFirstChild("Builds")
            if builds then
                for _, item in pairs(builds:GetChildren()) do
                    -- Move o teu boneco suavemente até ao item
                    -- (Usa a função de Tween que configurámos antes para não bugar)
                    tweenTo(item:GetPivot() * CFrame.new(0, 3, 0))
                    task.wait(0.5)

                    -- Dispara o Remote de roubo com o ID do servidor
                    local Remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")
                    Remote:FireServer("grabpet", 16777216, item, game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
                    
                    task.wait(1.5) -- Espera para o anticheat não te expulsar
                end
            end
        end
    end
end

-- Podes chamar esta função no final do teu script ou ligar a um botão
stealAll()
