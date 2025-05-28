-- ✅ UI Setup
local gui = Instance.new("ScreenGui")
local main = Instance.new("Frame")
local title = Instance.new("TextLabel")
local button = Instance.new("TextButton")

gui.Name = "MidnightAutoFarmUI"
gui.Parent = game.CoreGui

main.Name = "Main"
main.Parent = gui
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
main.BorderSizePixel = 0
main.Position = UDim2.new(0, 20, 0, 180)
main.Size = UDim2.new(0, 180, 0, 80)
main.Active = true
main.Draggable = true
main.BackgroundTransparency = 0.1

title.Name = "Title"
title.Parent = main
title.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
title.BorderSizePixel = 0
title.Size = UDim2.new(1, 0, 0.4, 0)
title.Font = Enum.Font.GothamBold
title.Text = "🚗 Midnight Auto Farm"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14

button.Name = "Toggle"
button.Parent = main
button.BackgroundColor3 = Color3.fromRGB(40, 140, 80)
button.BorderSizePixel = 0
button.Position = UDim2.new(0.1, 0, 0.5, 0)
button.Size = UDim2.new(0.8, 0, 0.4, 0)
button.Font = Enum.Font.GothamBold
button.Text = "Start Auto Farm"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 16

-- ✅ Auto Farm Logic
local autofarm = false
local running = false

button.MouseButton1Click:Connect(function()
    autofarm = not autofarm
    if autofarm then
        button.Text = "Stop Auto Farm"
        button.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
        if not running then
            running = true
            task.spawn(function()
                while autofarm do
                    local plr = game.Players.LocalPlayer
                    local car = workspace:FindFirstChild(plr.Name .. "'s Car")
                    if car and car:FindFirstChild("VehicleSeat") then
                        car.VehicleSeat.Throttle = 1
                        car.VehicleSeat.Steer = 0
                        
                        local rs = game:GetService("ReplicatedStorage")
                        local reward = rs:FindFirstChild("AddCash")
                        if reward then
                            reward:FireServer(10) -- ปรับค่านี้ได้
                        end
                    end
                    wait(0.9) -- หน่วงเพื่อลดความเสี่ยงโดนแบน
                end
                running = false
            end)
        end
    else
        button.Text = "Start Auto Farm"
        button.BackgroundColor3 = Color3.fromRGB(40, 140, 80)
    end
end)

-- ✅ Anti-AFK
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)
