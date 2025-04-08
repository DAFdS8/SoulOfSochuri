local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Config
local walkSpeed = 30
local flySpeed = 50
local flying = false
local flyDirection = Vector3.new()

-- Walkspeed Boost
Humanoid.WalkSpeed = walkSpeed

-- Fly Function
function startFly()
	if not flying then
		flying = true
		local bodyGyro = Instance.new("BodyGyro", Character.PrimaryPart)
		bodyGyro.P = 9e4
		bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		bodyGyro.CFrame = Character.PrimaryPart.CFrame

		local bodyVel = Instance.new("BodyVelocity", Character.PrimaryPart)
		bodyVel.Velocity = Vector3.new(0, 0.1, 0)
		bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)

		RunService:BindToRenderStep("FlyControl", Enum.RenderPriority.Input.Value, function()
			bodyGyro.CFrame = workspace.CurrentCamera.CFrame
			bodyVel.Velocity = flyDirection * flySpeed
		end)
	end
end

function stopFly()
	flying = false
	Character.PrimaryPart:FindFirstChildOfClass("BodyGyro"):Destroy()
	Character.PrimaryPart:FindFirstChildOfClass("BodyVelocity"):Destroy()
	RunService:UnbindFromRenderStep("FlyControl")
end

-- Input Handler
UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Z then
		if flying then
			stopFly()
		else
			startFly()
		end
	elseif input.KeyCode == Enum.KeyCode.X then
		flySpeed = flySpeed - 10
	elseif input.KeyCode == Enum.KeyCode.C then
		flySpeed = flySpeed + 10
	end
end)

-- Movement Direction
UIS.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.KeyCode then
		local cam = workspace.CurrentCamera
		flyDirection = cam.CFrame.lookVector
	end
end)

print("✅ Walkspeed e Fly ativados!")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- Remove ESP antigo
for _, v in pairs(workspace:GetDescendants()) do
	if v:IsA("BillboardGui") and v.Name == "ESP" then
		v:Destroy()
	end
end

-- Cria o ESP
local function createESP(target)
	if target:FindFirstChild("Head") and not target.Head:FindFirstChild("ESP") then
		local esp = Instance.new("BillboardGui", target.Head)
		esp.Name = "ESP"
		esp.Size = UDim2.new(0, 100, 0, 40)
		esp.AlwaysOnTop = true
		esp.StudsOffset = Vector3.new(0, 2, 0)

		local nameLabel = Instance.new("TextLabel", esp)
		nameLabel.Size = UDim2.new(1, 0, 1, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
		nameLabel.TextStrokeTransparency = 0.5
		nameLabel.TextScaled = true
		nameLabel.Font = Enum.Font.SourceSansBold
		nameLabel.Text = target.Name
	end
end

-- Atualiza ESP em novos players
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(char)
		wait(1)
		createESP(char)
	end)
end)

-- ESP nos já existentes
for _, player in pairs(Players:GetPlayers()) do
	if player ~= localPlayer and player.Character then
		createESP(player.Character)
	end
end

print("✅ ESP ativado")
local attackRange = 15 -- distância de ataque (studs)
local biteCooldown = 2 -- em segundos (pode mudar com teclas)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local attackRange = 15 -- distância de ataque
local biteCooldown = 2 -- segundos
local canAttack = true

-- Teclas para modificar cooldown
UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.J then
		biteCooldown = math.max(0.1, biteCooldown - 0.1)
		print("Novo Cooldown: " .. biteCooldown)
	elseif input.KeyCode == Enum.KeyCode.K then
		biteCooldown = biteCooldown + 0.1
		print("Novo Cooldown: " .. biteCooldown)
	end
end)

-- Função de ataque (ajuste para sua criatura se necessário)
local function bite(target)
	local char = LocalPlayer.Character
	if not char or not target then return end
	local attackEvent = char:FindFirstChildWhichIsA("RemoteEvent", true)
	if attackEvent then
		attackEvent:FireServer()
	end
end

-- Kill Aura Loop
RunService.RenderStepped:Connect(function()
	if not canAttack then return end
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end

	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local dist = (char.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
			if dist <= attackRange then
				canAttack = false
				bite(plr.Character)
				task.delay(biteCooldown, function()
					canAttack = true
				end)
			end
		end
	end
end)

print("✅ Kill Aura ativada. Use J/K pra diminuir/aumentar cooldown.")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Tecla para ativar
local breathKey = Enum.KeyCode.B -- aperte B pra atacar

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == breathKey then
		local char = LocalPlayer.Character
		if not char then return end

		-- Procura o RemoteEvent correto (nome pode variar)
		local foundEvent
		for _, obj in pairs(char:GetDescendants()) do
			if obj:IsA("RemoteEvent") and string.lower(obj.Name):find("breath") then
				foundEvent = obj
				break
			end
		end

		if foundEvent then
			foundEvent:FireServer(true)
			print("🔥 Breath Attack ativado!")
		else
			warn("❌ Nenhum RemoteEvent de Breath encontrado!")
		end
	end
end)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Configurações
local breathKey = Enum.KeyCode.N -- tecla para ativar multiplayer breath
local range = 80 -- distância para atingir inimigos (em studs)

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe or input.KeyCode ~= breathKey then return end

	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end

	-- Procura o RemoteEvent
	local foundEvent
	for _, obj in pairs(char:GetDescendants()) do
		if obj:IsA("RemoteEvent") and string.lower(obj.Name):find("breath") then
			foundEvent = obj
			break
		end
	end

	if not foundEvent then
		warn("❌ Nenhum RemoteEvent de Breath encontrado!")
		return
	end

	-- Ataca todos os jogadores no alcance
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local dist = (char.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
			if dist <= range then
				foundEvent:FireServer(true)
				wait(0.1)
			end
		end
	end

	print("💨 Breath Multiplayer executado contra todos os alvos próximos!")
end)
--[[ 
🔥 Soul of Sochuri Script 🔥
Sistema completo com:
✅ Walkspeed & Fly Speed (teclas I e O)
✅ ESP (ver jogadores)
✅ Kill Aura com cooldown ajustável (teclas J e K)
✅ Breath Attack (B)
✅ Breath Multiplayer (N)
--]]

-- 🛠️ Configurações iniciais:
local walkSpeed = 20
local flySpeed = 100
local attackRange = 15
local biteCooldown = 2

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ========================
-- 1. Walkspeed & Fly Speed
-- ========================
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("Humanoid") then return end

	if input.KeyCode == Enum.KeyCode.I then
		char.Humanoid.WalkSpeed = walkSpeed
		print("🚶 WalkSpeed ajustado para " .. walkSpeed)
	elseif input.KeyCode == Enum.KeyCode.O then
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.Velocity = hrp.CFrame.LookVector * flySpeed
			print("🚀 Fly Speed ativado")
		end
	end
end)

-- ============
-- 2. ESP
-- ============
for _, v in pairs(workspace:GetDescendants()) do
	if v:IsA("BillboardGui") and v.Name == "ESP" then
		v:Destroy()
	end
end

local function createESP(target)
	if target:FindFirstChild("Head") and not target.Head:FindFirstChild("ESP") then
		local esp = Instance.new("BillboardGui", target.Head)
		esp.Name = "ESP"
		esp.Size = UDim2.new(0, 100, 0, 40)
		esp.AlwaysOnTop = true
		esp.StudsOffset = Vector3.new(0, 2, 0)

		local nameLabel = Instance.new("TextLabel", esp)
		nameLabel.Size = UDim2.new(1, 0, 1, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
		nameLabel.TextStrokeTransparency = 0.5
		nameLabel.TextScaled = true
		nameLabel.Font = Enum.Font.SourceSansBold
		nameLabel.Text = target.Name
	end
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(char)
		wait(1)
		createESP(char)
	end)
end)

for _, player in pairs(Players:GetPlayers()) do
	if player ~= LocalPlayer and player.Character then
		createESP(player.Character)
	end
end

-- ====================
-- 3. Kill Aura + Cooldown
-- ====================
local canAttack = true

UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.J then
		biteCooldown = math.max(0.1, biteCooldown - 0.1)
		print("⏱️ Cooldown reduzido para: " .. biteCooldown)
	elseif input.KeyCode == Enum.KeyCode.K then
		biteCooldown = biteCooldown + 0.1
		print("⏱️ Cooldown aumentado para: " .. biteCooldown)
	end
end)

local function bite(target)
	local char = LocalPlayer.Character
	if not char or not target then return end
	local attackEvent = char:FindFirstChildWhichIsA("RemoteEvent", true)
	if attackEvent then
		attackEvent:FireServer()
	end
end

RunService.RenderStepped:Connect(function()
	if not canAttack then return end
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end

	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local dist = (char.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
			if dist <= attackRange then
				canAttack = false
				bite(plr.Character)
				task.delay(biteCooldown, function()
					canAttack = true
				end)
			end
		end
	end
end)

-- ========================
-- 4. Breath Attack (Individual)
-- ========================
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.B then
		local char = LocalPlayer.Character
		if not char then return end

		local foundEvent
		for _, obj in pairs(char:GetDescendants()) do
			if obj:IsA("RemoteEvent") and string.lower(obj.Name):find("breath") then
				foundEvent = obj
				break
			end
		end

		if foundEvent then
			foundEvent:FireServer(true)
			print("🔥 Breath Attack ativado!")
		else
			warn("❌ Nenhum RemoteEvent de Breath encontrado!")
		end
	end
end)

-- =============================
-- 5. Breath Attack Multiplayer
-- =============================
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe or input.KeyCode ~= Enum.KeyCode.N then return end

	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end

	local foundEvent
	for _, obj in pairs(char:GetDescendants()) do
		if obj:IsA("RemoteEvent") and string.lower(obj.Name):find("breath") then
			foundEvent = obj
			break
		end
	end

	if not foundEvent then
		warn("❌ Nenhum RemoteEvent de Breath encontrado!")
		return
	end

	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local dist = (char.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
			if dist <= 80 then
				foundEvent:FireServer(true)
				wait(0.1)
			end
		end
	end

	print("💨 Breath Multiplayer executado!")
end)
