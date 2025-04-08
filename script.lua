--[[
🔥 SoulOfSochuri Script 🔥
- Funciona em Creatures of Sonaria
- Bypass Anti-Cheat
- GUI Completo com controles de WalkSpeed, FlySpeed, Kill Aura, Breath Attack, Bite Cooldown
- Toggle com letra "L"
--]]

-- SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- BYPASS (Hook básico anti-anticheat)
do
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__newindex

    mt.__newindex = function(t, k, v)
        if tostring(t) == "Humanoid" and (k == "WalkSpeed" or k == "JumpPower") then
            return -- bloqueia tentativa do jogo de resetar valores
        end
        return old(t, k, v)
    end
end

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "SochuriGUI"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 600)
Frame.Position = UDim2.new(0.5, -150, 0.5, -300)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Visible = true

-- Título
local Title = Instance.new("TextLabel", Frame)
Title.Text = "🌀 SoulOfSochuri"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

local function createInput(labelText, posY, callback)
    local Label = Instance.new("TextLabel", Frame)
    Label.Text = labelText
    Label.Position = UDim2.new(0, 10, 0, posY)
    Label.Size = UDim2.new(0, 100, 0, 20)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14

    local Input = Instance.new("TextBox", Frame)
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
createInput("WalkSpeed", 40, function(val)
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = val
    end
end)

-- FlySpeed
createInput("FlySpeed", 70, function(val)
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        local dir = root.CFrame.lookVector
        root.Velocity = dir * val
    end
end)

-- Bite Cooldown
createInput("Bite Cooldown (ms)", 100, function(val)
    for i,v in pairs(getgc(true)) do
        if typeof(v) == "function" and getinfo(v).name == "Bite" then
            hookfunction(v, function(...)
                task.wait(val/1000)
                return v(...)
            end)
            break
        end
    end
end)

-- Kill Aura
createInput("KillAura Range", 130, function(range)
    RunService.RenderStepped:Connect(function()
        for _,v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") then
                local hrp = v.Character:FindFirstChild("HumanoidRootPart")
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp and myRoot and (myRoot.Position - hrp.Position).Magnitude <= range then
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

-- Breath Attack
createInput("Breath Cooldown (ms)", 160, function(val)
    local found = false
    for i,v in pairs(getgc(true)) do
        if typeof(v) == "function" and getinfo(v).name == "BreathAttack" then
            hookfunction(v, function(...)
                task.wait(val/1000)
                return v(...)
            end)
            found = true
            break
        end
    end
    if not found then warn("BreathAttack function não encontrada.") end
end)

-- Toggle GUI com letra L
UIS.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.L and not gameProcessed then
        Frame.Visible = not Frame.Visible
    end
end)

print("✅ SoulOfSochuri Script com Kill Aura e Breath Attack!")
