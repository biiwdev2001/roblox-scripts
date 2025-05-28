-- 📦 UI Setup
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

-- 📌 ระบบวาร์ป+เดินหน้าแบบ MoveTo
local autoDrive = false
local forward = true

-- กำหนดค่าที่ใช้ในแมพ
local START_POS = Vector3.new(0, 5, 0) -- จุดเริ่ม
local MOVE_DISTANCE = 30 -- ระยะเลื่อนแต่ละที
local MAX_DISTANCE = 1000
local MIN_DISTANCE = -1000
local currentZ = START_POS.Z

button.MouseButton1Click:Connect(function()
	autoDrive = not autoDrive
	button.Text = autoDrive and "Stop Auto Drive" or "Start Auto Drive"
	button.BackgroundColor3 = autoDrive and Color3.fromRGB(200, 80, 80) or Color3.fromRGB(40, 140, 80)

	if autoDrive then
		task.spawn(function()
			local plr = game.Players.LocalPlayer
			local char = plr.Character or plr.CharacterAdded:Wait()
			local seat = char:FindFirstChildWhichIsA("VehicleSeat", true)

			if not seat then warn("🚫 คุณยังไม่นั่งรถ") return end
			local car = seat:FindFirstAncestorWhichIsA("Model")
			if not car or not car.PrimaryPart then warn("🚫 รถไม่มี PrimaryPart") return end

			-- วาร์ปไปจุดเริ่ม
			car:SetPrimaryPartCFrame(CFrame.new(START_POS))
			currentZ = START_POS.Z
			wait(1)

			while autoDrive do
				local direction = forward and 1 or -1
				currentZ += MOVE_DISTANCE * direction

				-- วนกลับเมื่อถึงสุดทาง
				if currentZ >= MAX_DISTANCE then
					forward = false
				elseif currentZ <= MIN_DISTANCE then
					forward = true
				end

				local newPos = Vector3.new(car.PrimaryPart.Position.X, car.PrimaryPart.Position.Y, currentZ)
				car:SetPrimaryPartCFrame(CFrame.new(newPos))
				wait(0.15)
			end
		end)
	end
end)
