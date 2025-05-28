-- UI On/Off
local gui = Instance.new("ScreenGui", game.CoreGui)
local toggle = Instance.new("TextLabel", gui)
toggle.Size = UDim2.new(0, 140, 0, 40)
toggle.Position = UDim2.new(0, 20, 0, 100)
toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
toggle.TextColor3 = Color3.fromRGB(0, 255, 0)
toggle.Font = Enum.Font.GothamBold
toggle.Text = "Auto Drive: OFF"
toggle.TextSize = 16

-- ตัวแปรการทำงาน
local autoDrive = false
local goingForward = true
local START_POS = Vector3.new(0, 5, 0) -- จุดกลางที่โล่ง
local Z_MAX = 1500
local Z_MIN = -1500

-- คีย์ลัดเปิด/ปิด (กด R)
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
	if input.KeyCode == Enum.KeyCode.R and not processed then
		autoDrive = not autoDrive
		toggle.Text = "Auto Drive: " .. (autoDrive and "ON" or "OFF")
		toggle.TextColor3 = autoDrive and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)

		if autoDrive then
			task.spawn(function()
				local plr = game.Players.LocalPlayer
				local char = plr.Character or plr.CharacterAdded:Wait()
				local seat = char:FindFirstChildWhichIsA("VehicleSeat", true)
				if not seat then return end

				local car = seat:FindFirstAncestorWhichIsA("Model")
				if not car then return end

				-- วาร์ปไปจุดกลาง
				car:MoveTo(START_POS)
				wait(1)

				while autoDrive and seat and seat.Parent do
					seat.Throttle = goingForward and 1 or -1
					seat.Steer = 0

					local z = seat.Position.Z
					if goingForward and z >= Z_MAX then
						goingForward = false
					elseif not goingForward and z <= Z_MIN then
						goingForward = true
					end
					wait(0.1)
				end

				if seat then seat.Throttle = 0 end
			end)
		end
	end
end)
