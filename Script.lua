-- BUILD AND STEAL - BYPASS TOTAL 2026
local LP = game.Players.LocalPlayer
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local Remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")

_G.StealActive = true

-- 1. NOCLIP PERMANENTE (Evita bugar em paredes e rubberband)
RS.Stepped:Connect(function()
    if _G.StealActive and LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- 2. MOVIMENTO SUAVE (Engana o Anticheat de Teleporte)
local function safeMove(targetCF)
    local hrp = LP.Character:WaitForChild("HumanoidRootPart")
    local distance = (hrp.Position - targetCF.Position).Magnitude
    local speed = 80 -- Velocidade segura para 2026
    
    local info = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
    local tween = TS:Create(hrp, info, {CFrame = targetCF})
    tween:Play()
    tween.Completed:Wait()
end

-- 3. INTERFACE COM BOTÃO "STEAL ALL"
local sg = Instance.new("ScreenGui", game.CoreGui)
local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 150, 0, 50)
btn.Position = UDim2.new(0.1, 0, 0.5, 0)
btn.Text = "ROUBAR TUDO"
btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
btn.Draggable = true

btn.MouseButton1Click:Connect(function()
    btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    for _, plot in pairs(workspace.Plots:GetChildren()) do
        if plot.Name ~= LP.Name then
            local builds = plot:FindFirstChild("Builds")
            if builds then
                for _, item in pairs(builds:GetChildren()) do
                    -- Move e Rouba
                    safeMove(item:GetPivot() * CFrame.new(0, 3, 0))
                    task.wait(0.5)
                    Remote:FireServer("grabpet", 16777216, item, LP.Character.HumanoidRootPart.CFrame)
                    task.wait(1.5)
                end
            end
        end
    end
    btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
end)
