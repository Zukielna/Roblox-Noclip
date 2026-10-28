
--// NOCLIP MENU - MOBILE
--// LocalScript

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local noclip = false
local menuOpen = false
local connection

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "NoclipMenu"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Icon mở menu
local icon = Instance.new("TextButton")
icon.Name = "OpenButton"
icon.Size = UDim2.fromOffset(55, 55)
icon.Position = UDim2.new(0, 20, 0.5, -27)
icon.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
icon.Text = "👻"
icon.TextSize = 28
icon.TextColor3 = Color3.new(1, 1, 1)
icon.Parent = gui

Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)

-- Menu chính
local menu = Instance.new("Frame")
menu.Size = UDim2.fromOffset(230, 155)
menu.Position = UDim2.new(0.5, -115, 0.5, -77)
menu.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
menu.Visible = false
menu.Parent = gui

Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 12)

-- Tiêu đề
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.fromOffset(10, 0)
title.BackgroundTransparency = 1
title.Text = "👻 NOCLIP MENU"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = menu

-- Nút đóng
local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(30, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.BackgroundColor3 = Color3.fromRGB(170, 45, 45)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.Parent = menu

Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)

-- Nút bật/tắt
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -20, 0, 45)
toggle.Position = UDim2.fromOffset(10, 55)
toggle.BackgroundColor3 = Color3.fromRGB(170, 45, 45)
toggle.Text = "Noclip: OFF"
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.TextSize = 16
toggle.Font = Enum.Font.GothamBold
toggle.Parent = menu

Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 8)

local function updateCharacter()
    local character = player.Character
    if not character then return end

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not noclip
        end
    end
end

local function setNoclip(state)
    noclip = state
    toggle.Text = noclip and "Noclip: ON" or "Noclip: OFF"
    toggle.BackgroundColor3 = noclip
        and Color3.fromRGB(35, 160, 85)
        or Color3.fromRGB(170, 45, 45)

    if connection then
        connection:Disconnect()
        connection = nil
    end

    if noclip then
        connection = RunService.Stepped:Connect(function()
            local character = player.Character
            if not character then return end

            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        updateCharacter()
    end
end

icon.Activated:Connect(function()
    menuOpen = not menuOpen
    menu.Visible = menuOpen
end)

close.Activated:Connect(function()
    menuOpen = false
    menu.Visible = false
end)

toggle.Activated:Connect(function()
    setNoclip(not noclip)
end)

player.CharacterAdded:Connect(function()
    task.wait(1)
    if noclip then
        setNoclip(true)
    end
end)

-- Kéo icon bằng chuột hoặc cảm ứng
local dragging = false
local dragStart, startPos

icon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = icon.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        icon.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
