--[[
SoulOfSochuri GUI Script for Creatures of Sonaria (Refeito)
By: DAFdS8 & ChatGPT 😈
--]]

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Criar GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SochuriGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 300, 0, 400)
Main.Position = UDim2.new(0.02, 0, 0.25, 0)
Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Main.BackgroundTransparency = 0.2
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = Main
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

function createLabel(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 16
    lbl.Text = text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = Main
    return lbl
end

function createInput(name, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 30)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Name = name
    frame.Parent = Main

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -10, 1, 0)
    input.Position = UDim2.new(0, 5, 0, 0)
    input.BackgroundTransparency = 1
    input.Text = tostring(default)
    input.Font = Enum.Font.SourceSans
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.TextSize = 16
    input.Parent = frame

    input.FocusLost:Connect(function()
        local num = tonumber(input.Text)
        if num then callback(num) end
    end)
end

function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Text = text
    btn.Parent = Main

    btn.MouseButton1Click:Connect(callback)
end

-- Variáveis
local walkSpeed = 20
local flySpeed = 100
local biteCooldown = 2
local killAuraEnabled = false
local espEnabled = false

-- Interface
createLabel("Walk Speed:")
createInput("WalkSpeedInput", walkSpeed, function(val)
    walkSpeed = val
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = walkSpeed
    end
end)

createLabel("Fly Speed:")
createInput("FlySpeedInput", flySpeed, function(val)
    flySpeed = val
end)

createLabel("Bite Cooldown:")
createInput("BiteCooldownInput", biteCooldown, function(val)
    biteCooldown = val
end)

createButton("Fly Forward", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.Velocity = char.HumanoidRootPart.CFrame.LookVector * flySpeed
    end
end)

createButton("Toggle ESP", function()
    espEnabled = not espEnabled
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            if espEnabled then
                if not p.Character:FindFirstChild("ESP") then
                    local esp = Instance.new("BillboardGui", p.Character)
                    esp.Name = "ESP"
                    esp.Adornee = p.Character.Head
                    esp.Size = UDim2.new(0, 100, 0, 40)
                    esp.AlwaysOnTop = true
                    local text = Instance.new("TextLabel", esp)
                    text.Size = UDim2.new(1, 0, 1, 0)
                    text.BackgroundTransparency = 1
                    text.Text = p.Name
                    text.TextColor3 = Color3.new(1, 0, 0)
                    text.TextScaled = true
                end
            else
                if p.Character:FindFirstChild("ESP") then
                    p.Character.ESP:Destroy()
                end
            end
        end
    end
end)

createButton("Toggle Kill Aura", function()
    killAuraEnabled = not killAuraEnabled
end)

createButton("Breath Attack", function()
    local char = LocalPlayer.Character
    local remote = char and char:FindFirstChild("Remotes") and char.Remotes:FindFirstChild("Breath")
    if remote then
        remote:FireServer(true)
    end
end)

createButton("Breath Multiplayer", function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Remotes") then
            local remote = p.Character.Remotes:FindFirstChild("Breath")
            if remote then remote:FireServer(true) end
        end
    end
end)

-- Kill Aura Loop
spawn(function()
    while true do
        if killAuraEnabled then
            local char = LocalPlayer.Character
            local bite = char and char:FindFirstChild("Remotes") and char.Remotes:FindFirstChild("Bite")
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if dist <= 15 and bite then
                        bite:FireServer(true)
                    end
                end
            end
        end
        wait(biteCooldown)
    end
end)

print("Sochuri GUI Loaded ✅")
