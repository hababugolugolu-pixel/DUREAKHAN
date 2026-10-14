
-- Dureakhan👑 | Green & Red Mobile UI
-- LocalScript ใน StarterPlayerScripts

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local flying = false
local speed = 50
local vertical = 0
local flightConnection

local gui = Instance.new("ScreenGui")
gui.Name = "Dureakhan👑"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Name = "Main"
frame.Size = UDim2.fromOffset(250, 255)
frame.Position = UDim2.new(0, 20, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(5, 35, 15)
frame.BorderSizePixel = 0
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius =
    UDim.new(0, 14)

local border = Instance.new("UIStroke")
border.Color = Color3.fromRGB(255, 35, 35)
border.Thickness = 2
border.Parent = frame

local function makeButton(text, pos, size)
    local b = Instance.new("TextButton")
    b.Text = text
    b.Position = pos
    b.Size = size
    b.BackgroundColor3 = Color3.fromRGB(18, 100, 42)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 16
    b.BorderSizePixel = 0
    b.Parent = frame

    Instance.new("UICorner", b).CornerRadius =
        UDim.new(0, 8)

    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(255, 35, 35)
    s.Thickness = 1
    s.Parent = b

    return b
end

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 38)
title.Position = UDim2.fromOffset(10, 5)
title.BackgroundTransparency = 1
title.Text = "Dureakhan👑"
title.TextColor3 = Color3.fromRGB(75, 255, 115)
title.Font = Enum.Font.GothamBlack
title.TextSize = 21
title.Parent = frame

local toggle = makeButton(
    "FLY : OFF",
    UDim2.fromOffset(10, 48),
    UDim2.new(1, -20, 0, 40)
)

local up = makeButton(
    "▲ UP",
    UDim2.fromOffset(10, 98),
    UDim2.new(0.5, -15, 0, 38)
)

local down = makeButton(
    "▼ DOWN",
    UDim2.new(0.5, 5, 0, 98),
    UDim2.new(0.5, -15, 0, 38)
)

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 25)
speedLabel.Position = UDim2.fromOffset(10, 145)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "SPEED: 50"
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 15
speedLabel.Parent = frame

local slower = makeButton(
    "SLOWER -",
    UDim2.fromOffset(10, 175),
    UDim2.new(0.5, -15, 0, 35)
)

local faster = makeButton(
    "FASTER +",
    UDim2.new(0.5, 5, 0, 175),
    UDim2.new(0.5, -15, 0, 35)
)

local close = makeButton(
    "CLOSE",
    UDim2.fromOffset(10, 218),
    UDim2.new(1, -20, 0, 27)
)

local function stopFlight()
    flying = false
    vertical = 0

    if flightConnection then
        flightConnection:Disconnect()
        flightConnection = nil
    end

    local character = player.Character
    local humanoid = character and
        character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid.PlatformStand = false
        humanoid.AutoRotate = true
        humanoid:ChangeState(
            Enum.HumanoidStateType.GettingUp
        )
    end

    toggle.Text = "FLY : OFF"
end

local function startFlight()
    local character = player.Character
    local humanoid = character and
        character:FindFirstChildOfClass("Humanoid")
    local root = character and
        character:FindFirstChild("HumanoidRootPart")

    if not humanoid or not root or flying then
        return
    end

    flying = true
    toggle.Text = "FLY : ON"
    humanoid.PlatformStand = true

    flightConnection = RunService.Heartbeat:Connect(function()
        if not flying or not root.Parent then
            stopFlight()
            return
        end

        local camera = workspace.CurrentCamera
        local direction = Vector3.zero

        if UIS:IsKeyDown(Enum.KeyCode.W) then
            direction += camera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            direction -= camera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            direction -= camera.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            direction += camera.CFrame.RightVector
        end

        if direction.Magnitude > 0 then
            direction = direction.Unit
        end

        root.AssemblyLinearVelocity =
            direction * speed + Vector3.new(0, vertical * speed, 0)
    end)
end

toggle.Activated:Connect(function()
    if flying then
        stopFlight()
    else
        startFlight()
    end
end)

local function bindVertical(btn, value)
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            vertical = value
        end
    end)

    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            if vertical == value then
                vertical = 0
            end
        end
    end)
end

bindVertical(up, 1)
bindVertical(down, -1)

faster.Activated:Connect(function()
    speed = math.min(speed + 10, 200)
    speedLabel.Text = "SPEED: " .. speed
end)

slower.Activated:Connect(function()
    speed = math.max(speed - 10, 10)
    speedLabel.Text = "SPEED: " .. speed
end)

close.Activated:Connect(function()
    stopFlight()
    gui:Destroy()
end)

player.CharacterAdded:Connect(function()
    stopFlight()
end)
