--[[
🔥 SoulOfSochuri Script 🔥
- Funciona em Creatures of Sonaria
- Bypass Anti-Cheat Avançado
- GUI Completa e Interativa:
  - Movível
  - Minimizável
  - Toggle com tecla "L"
- Controles para:
  - WalkSpeed
  - FlySpeed
  - Bite Cooldown
  - Breath Attack
  - Kill Aura com raio configurável
--]]

-- SERVIÇOS
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- BYPASS ANTI-CHEAT
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldIndex = mt.__index
local oldNewIndex = mt.__newindex

mt.__index = function(t, k)
    if tostring(t) == "Humanoid" and (k == "WalkSpeed" or k == "JumpPower") then
        return 16 -- Valor padrão para evitar detecção
    end
    return oldIndex(t, k)
end

mt.__newindex = function(t, k, v)
    if tostring(t) == "Humanoid" and (k == "WalkSpeed" or k == "JumpPower") then
        return -- Impede que o jogo resete os valores
    end
    return oldNewIndex(t, k, v)
end

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "SochuriGUI"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0.5, -150, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Active = true

-- Título
local Title = Instance.new("TextLabel", Frame)
Title.Text = "🌀 SoulOfSochuri"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

-- Botão de Minimizar
local MinimizeButton = Instance.new("TextButton", Frame)
MinimizeButton.Text = "-"
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -30, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 20

-- Área de Conteúdo
local ContentFrame = Instance.new("Frame", Frame)
ContentFrame.Size = UDim2.new(1, 0, 1, -30)
ContentFrame.Position = UDim2.new(0, 0, 0, 30)
ContentFrame.BackgroundTransparency = 1

-- Função para criar entradas de controle
local function createInput(labelText, posY, callback)
    local Label = Instance.new("TextLabel", ContentFrame)
    Label.Text = labelText
    Label.Position = UDim2.new(0, 10, 0, posY)
    Label.Size = UDim2.new(0, 100, 0, 20)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14

    local Input = Instance.new("TextBox", ContentFrame)
    Input.PlaceholderText = "Ex: 50"
    Input.Position = UDim2.new(0, 120, 0, posY)
    Input.Size = UDim2.new(0, 100, 0, 20)
    Input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Input.TextColor3 = Color3.fromRGB(255, 255, 255)
    Input.Font = Enum.Font.Gotham
    Input.TextSize = 14

    Input.FocusLost:Connect(function()
        local val = tonumber(Input.Text)
        if val then callback(val) end
    end)
end

-- WalkSpeed
createInput("WalkSpeed", 10, function(val)
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = val
    end
end)

-- FlySpeed
createInput("FlySpeed", 40, function(val)
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.JumpPower = val
    end
end)

-- Bite Cooldown
createInput("Bite Cooldown (ms)", 70, function(val)
    for i, v in pairs(getgc(true)) do
        if typeof(v) == "function" and getinfo(v).name == "Bite" then
            hookfunction(v, function(...)
                task.wait(val / 1000)
                return v(...)
            end)
            break
        end
    end
end)

-- Breath Attack
createInput("Breath Multiplier", 100, function(val)
    for i, v in pairs(getgc(true)) do
        if typeof(v) == "function" and getinfo(v).name == "BreathAttack" then
            hookfunction(v, function(...)
                for _ = 1, val do
                    v(...)
                end
            end)
            break
        end
    end
end)

-- Kill Aura
createInput("KillAura Range", 130, function(range)
    RunService.RenderStepped:Connect(function()
        for _, v in pairs(Players:GetPlayers()) do
            if
::contentReference[oaicite:7]{index=7}
 
