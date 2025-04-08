--[[
SoulOfSochuri GUI Script for Creatures of Sonaria
By: DAFdS8 & ChatGPT
--]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Mouse = LocalPlayer:GetMouse()

-- Config
local walkSpeed = 20
local flySpeed = 100
local biteCooldown = 2
local attackRange = 15
local killAuraActive = false
local espActive = false

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "SoulOfSochuriGUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Position = UDim2.new(0.05, 0, 0.2, 0)
Frame.Size = UDim2.new(0, 250, 0, 350)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.BackgroundTransparency = 0.2

-- Utility function to create buttons
local function createButton(name, position, text, callback)
    local button = Instance.new("TextButton", Frame)
    button.Name = name
    button.Position = position
    button.Size = UDim2.new(0, 230, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 16
    button.Text = text
    button.MouseButton1Click:Connect(callback)
    return button
end

-- ESP
local function toggleESP()
    espActive = not espActive
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and not player.Character:FindFirstChild("ESP") then
            local billboard = Instance.new("BillboardGui", player.Character)
            billboard.Name = "ESP"
            billboard.Adornee = player.Character:FindFirstChild("Head")
            billboard.Size = UDim2.new(0, 100, 0, 40)
            billboard.AlwaysOnTop = true
            local label = Instance.new("TextLabel", billboard)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = player.Name
            label.TextColor3 = Color3.new(1, 0, 0)
            label.TextStrokeTransparency = 0
            label.TextScaled = true
        elseif not espActive and player.Character:FindFirstChild("ESP") then
            player.Character.ESP:Destroy()
        end
    end
end

-- WalkSpeed
createButton("SpeedBtn", UDim2.new(0, 10, 0, 10), "Set WalkSpeed ("..walkSpeed..")", function()
    Character.Humanoid.WalkSpeed = walkSpeed
end)

-- FlySpeed (Impulse Style)
createButton("FlyBtn", UDim2.new(0, 10, 0, 50), "Fly Forward", function()
    Character:FindFirstChild("HumanoidRootPart").Velocity = Character.HumanoidRootPart.CFrame.LookVector * flySpeed
end)

-- Toggle ESP
createButton("ESPBtn", UDim2.new(0, 10, 0, 90), "Toggle ESP", toggleESP)

-- Toggle Kill Aura
createButton("KillAuraBtn", UDim2.new(0, 10, 0, 130), "Toggle Kill Aura", function()
    killAuraActive = not killAuraActive
end)

-- Bite Cooldown Down
createButton("CooldownDown", UDim2.new(0, 10, 0, 170), "Cooldown -", function()
    biteCooldown = math.max(0.1, biteCooldown - 0.1)
end)

-- Bite Cooldown Up
createButton("CooldownUp", UDim2.new(0, 10, 0, 210), "Cooldown +", function()
    biteCooldown = biteCooldown + 0.1
end)

-- Breath Attack
createButton("BreathBtn", UDim2.new(0, 10, 0, 250), "Breath Attack", function()
    local remotes = Character:FindFirstChild("Remotes")
    if remotes and remotes:FindFirstChild("Breath") then
        remotes.Breath:FireServer(true)
    end
end)

-- Multiplayer Breath Attack
createButton("BreathAllBtn", UDim2.new(0, 10, 0, 290), "Breath Multiplayer", function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Remotes") then
            p.Character.Remotes.Breath:FireServer(true)
        end
    end
end)

-- Kill Aura Loop
spawn(function()
    while true do
        if killAuraActive and Character and Character:FindFirstChild("Remotes") then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and (p.Character:FindFirstChild("HumanoidRootPart")) then
                    local dist = (Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if dist <= attackRange then
                        local bite = Character.Remotes:FindFirstChild("Bite")
                        if bite then bite:FireServer(true) end
                    end
                end
            end
        end
        wait(biteCooldown)
    end
end)

print("SoulOfSochuri GUI loaded!")
