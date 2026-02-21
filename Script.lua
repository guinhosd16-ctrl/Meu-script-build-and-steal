-- Script de Magnet para Build and Steal
while wait(0.5) do
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v.Name == "Brainrot" or v:FindFirstChild("TouchInterest") then
            v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end
