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

-- ⚙️ System Variables
local autoDrive = false
local goingForward = true

-- 🌍 ตำแหน่งถนน (แก้ให้เหมาะกับแมพของคุณ)
local START_POS = Vector3.new(0, 5, 0) -- จุดกลางถนนโล่ง
local Z_MAX = 1200 -- ปลายทาง
local Z_MIN = -1200 -- ต้นทาง
local MOVE_STEP = 40
local MOVE_DELAY = 0.15

button.MouseButton1Click:Connect(function()
	autoDrive = not autoDrive
	button.Text = autoDrive and "Stop Auto Drive" or "Start Auto Drive"
	button.BackgroundColor3 = autoDrive and Color3.fromRGB(200, 80, 80) or Color3.fromRGB(40, 140, 80)

	if autoDrive then
		task.spawn(function()
			local plr = game.Players.LocalPlayer
			local char = plr.Character or plr.CharacterAdded:Wait()
			local seat = char:FindFirstChildWhichIsA("VehicleSeat", true)
			if not seat then warn("❌ คุณยังไม่นั่งในรถ") return end

			local car = seat:FindFirstAncestorWhichIsA("Model")
			if not car then warn("❌ ไม่พบ Model รถ") return end

			-- กำหนด PrimaryPart ถ้ายังไม่มี
			if not car.PrimaryPart then
				car.PrimaryPart = seat
			end

			-- วาร์ปไปเริ่ม
			car:SetPrimaryPartCFrame(CFrame.new(START_POS))
			local zPos = START_POS.Z
			wait(1)

			while autoDrive and car.PrimaryPart do
				local direction = goingForward and 1 or -1
				zPos += MOVE_STEP * direction

				if zPos >= Z_MAX then goingForward = false end
				if zPos <= Z_MIN then goingForward = true end

				local newPos = Vector3.new(car.PrimaryPart.Position.X, car.PrimaryPart.Position.Y, zPos)
				car:SetPrimaryPartCFrame(CFrame.new(newPos))

				wait(MOVE_DELAY)
			end
		end)
	end
end)
