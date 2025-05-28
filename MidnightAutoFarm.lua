-- สร้าง UI
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 180, 0, 70)
frame.Position = UDim2.new(0, 20, 0, 180)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0.4, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "🚗 Midnight Auto Drive"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.9, 0, 0.4, 0)
button.Position = UDim2.new(0.05, 0, 0.5, 0)
button.BackgroundColor3 = Color3.fromRGB(40, 140, 80)
button.Font = Enum.Font.GothamBold
button.Text = "Start Auto Drive"
button.TextColor3 = Color3.new(1, 1, 1)
button.TextSize = 16

-- ตัวแปรระบบ
local autoDrive = false
local goingForward = true

-- ปรับจุดเริ่มต้นตรงนี้ (ให้วาร์ปไปที่โล่ง)
local START_POS = Vector3.new(0, 5, 0)
local Z_MAX = 1000
local Z_MIN = -1000

-- ปุ่มเปิด/ปิด
button.MouseButton1Click:Connect(function()
	autoDrive = not autoDrive
	button.Text = autoDrive and "Stop Auto Drive" or "Start Auto Drive"
	button.BackgroundColor3 = autoDrive and Color3.fromRGB(200, 80, 80) or Color3.fromRGB(40, 140, 80)

	if autoDrive then
		task.spawn(function()
			local plr = game.Players.LocalPlayer
			local char = plr.Character or plr.CharacterAdded:Wait()
			local seat = char:FindFirstChildWhichIsA("VehicleSeat", true)

			if not seat then
				warn("🚫 ไม่ได้นั่งรถ!")
				return
			end

			local car = seat:FindFirstAncestorWhichIsA("Model")
			if not car then
				warn("🚫 ไม่พบ Model ของรถ")
				return
			end

			-- วาร์ปไปเริ่ม
			car:MoveTo(START_POS)
			wait(1)

			-- วนขับไปเรื่อย ๆ
			while autoDrive and seat and seat.Parent do
				seat.Throttle = goingForward and 1 or -1
				seat.Steer = 0

				local z = seat.Position.Z
				if goingForward and z >= Z_MAX then
					goingForward = false
				elseif not goingForward and z <= Z_MIN then
					goingForward = true
				end
				wait(0.2)
			end

			if seat then seat.Throttle = 0 end
		end)
	end
end)
