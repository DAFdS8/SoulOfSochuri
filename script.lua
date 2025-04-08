-- SoulOfSochuri (Versão Nezur Friendly)
-- GUI com WalkSpeed, FlySpeed, Kill Aura simples, e mais

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SochuriGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Draggable = true
frame.Active = true
frame.Visible = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "SoulOfSochuri"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

-- Função para criar input
local function createInput(labelText, posY, callback)
    local label = Instance.new("TextLabel", frame)
    label.Text = labelText
    label.Position = UDim2.new(0, 10, 0, posY)
    label.Size = UDim2.new(0, 100, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14

    local input = Instance.new("TextBox", frame)
    input.PlaceholderText = "Ex: 50"
    input.Position = UDim2.new(0, 120, 0, posY)
    input.Size = UDim2.new(0, 100, 0, 20)
    input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.Font = Enum.Font.Gotham
    input.TextSize = 14

    input.FocusLost:Connect(function()
        local val = tonumber(input.Text)
        if val then callback(val) end
    end)
end

-- WalkSpeed
createInput("WalkSpeed", 40, function(val)
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = val
    end
end)

-- FlySpeed
createInput("FlySpeed", 70, function(val)
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyLinearVelocity = root.CFrame.LookVector * val
    end
end)

-- Kill Aura (simples)
createInput("KillAura Range", 100, function(range)
    RunService.RenderStepped:Connect(function()
        for _,v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") then
                local target = v.Character:FindFirstChild("HumanoidRootPart")
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if target and myRoot and (target.Position - myRoot.Position).Magnitude < range then
                    local args = {
                        [1] = "Attack",
                        [2] = v.Character
                    }
                    game:GetService("ReplicatedStorage").Remotes.Combat:FireServer(unpack(args))
                end
            end
        end
    end)
end)

-- Toggle com L
UIS.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.L and not gameProcessed then
        frame.Visible = not frame.Visible
    end
end)
