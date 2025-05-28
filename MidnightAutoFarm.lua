-- ปุ่มกด UI ค้างไว้เหมือนเดิม
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
                    local char = plr.Character or plr.CharacterAdded:Wait()
                    local seat = char:FindFirstChildWhichIsA("VehicleSeat", true)

                    if seat then
                        seat.Throttle = 1
                        seat.Steer = 0
                        
                        -- ยิง AddCash ถ้ามี
                        local rs = game:GetService("ReplicatedStorage")
                        local reward = rs:FindFirstChild("AddCash")
                        if reward then
                            reward:FireServer(10)
                        end
                    end
                    wait(0.8)
                end
                running = false
            end)
        end
    else
        button.Text = "Start Auto Farm"
        button.BackgroundColor3 = Color3.fromRGB(40, 140, 80)
    end
end)
