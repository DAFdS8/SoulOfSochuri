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
