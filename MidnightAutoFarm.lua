local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 70)
frame.Position = UDim2.new(0, 20, 0, 180)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0.4, 0)
title.Text = "🚗 Midnight Auto Drive"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.9, 0, 0.45, 0)
button.Position = UDim2.new(0.05, 0, 0.5, 0)
button.BackgroundColor3 = Color3.fromRGB(40, 140, 80)
button.Font = Enum.Font.GothamBold
button.Text = "Start Auto Drive"
button.TextColor3 = Color3.new(1, 1, 1)
button.TextSize = 16

local autoDrive = false
local goingForward = true

-- ตำแหน่งถนนโล่ง
local START_POS = Vector3.new(0, 5, 0)
local Z_MAX = 1000
local Z_MIN = -1000
local MOVE_STEP = 50
local MOVE_DELAY = 0.15
local zPos = START_POS.Z

button.MouseButton1Click:Connect(function()
	autoDrive = not autoDrive
	button.Text = autoDrive and "Stop Auto Drive" or "Start Auto Drive"
	button.BackgroundColor3 = autoDrive and Color3.fromRGB(200, 80, 80) or Color3.fromRGB(40, 140, 80)

	if autoDrive then
		task.spawn(function()
			local plr = game.Players.LocalPlayer
			local char = plr.Character or plr.CharacterAdded:Wait()
			local seat = char:FindFirstChildWhichIsA("VehicleSeat", true)
			if not seat then warn("❌ ยังไม่นั่งรถ") return end

			local car = seat:FindFirstAncestorWhichIsA("Model")
			if not car then warn("❌ ไม่พบรถ") return end

			-- วาร์ปไปจุดเริ่ม
			zPos = START_POS.Z
			car:MoveTo(Vector3.new(START_POS.X, START_POS.Y, zPos))
			wait(1)

			while autoDrive do
				local dir = goingForward and 1 or -1
				zPos += MOVE_STEP * dir

				if zPos >= Z_MAX then goingForward = false end
				if zPos <= Z_MIN then goingForward = true end

				car:MoveTo(Vector3.new(car:GetModelCFrame().X, car:GetModelCFrame().Y, zPos))
				wait(MOVE_DELAY)
			end
		end)
	end
end)
