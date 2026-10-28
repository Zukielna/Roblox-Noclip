
--// ALL-IN-ONE MOBILE MENU
--// Dành cho Roblox Studio
--// Đặt LocalScript trong StarterPlayerScripts

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local flying = false
local noclip = false
local flySpeed = 50
local walkSpeed = 16
local savedCFrame
local flyConn, noclipConn
local flyAttachment, flyVelocity
local upHeld, downHeld = false, false

local gui = Instance.new("ScreenGui")
gui.Name = "MobileMovementMenu"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local function round(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end

local function getCharacter()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if hum and root then return char, hum, root end
end

local function makeButton(parent, text, size, position, color)
    local b = Instance.new("TextButton")
    b.Size = size
    b.Position = position
    b.BackgroundColor3 = color or Color3.fromRGB(55, 60, 75)
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 14
    b.Font = Enum.Font.GothamBold
    b.Parent = parent
    round(b, 8)
    return b
end

-- Floating icon
local icon = makeButton(
    gui, "👻", UDim2.fromOffset(54, 54),
    UDim2.new(0, 15, 0.4, 0),
    Color3.fromRGB(40, 40, 55)
)
icon.TextSize = 26

-- Main window
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0.88, 0, 0.75, 0)
menu.Position = UDim2.new(0.06, 0, 0.12, 0)
menu.BackgroundColor3 = Color3.fromRGB(23, 23, 30)
menu.Visible = false
menu.Parent = gui
round(menu, 12)

local sizeLimit = Instance.new("UISizeConstraint")
sizeLimit.MaxSize = Vector2.new(360, 620)
sizeLimit.MinSize = Vector2.new(280, 350)
sizeLimit.Parent = menu

local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, -48, 0, 42)
header.Position = UDim2.fromOffset(12, 0)
header.BackgroundTransparency = 1
header.Text = "👻 MOVEMENT MENU"
header.TextColor3 = Color3.new(1, 1, 1)
header.TextSize = 17
header.Font = Enum.Font.GothamBold
header.TextXAlignment = Enum.TextXAlignment.Left
header.Parent = menu

local close = makeButton(
    menu, "X", UDim2.fromOffset(32, 32),
    UDim2.new(1, -38, 0, 5),
    Color3.fromRGB(170, 45, 45)
)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -12, 1, -50)
scroll.Position = UDim2.fromOffset(6, 44)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.new()
scroll.Parent = menu

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 10)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = scroll

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 5)
padding.PaddingBottom = UDim.new(0, 12)
padding.PaddingLeft = UDim.new(0, 4)
padding.PaddingRight = UDim.new(0, 4)
padding.Parent = scroll

local function makeSection(title, height)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, height)
    frame.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
    frame.Parent = scroll
    frame.LayoutOrder = #scroll:GetChildren()
    round(frame, 10)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -16, 0, 30)
    label.Position = UDim2.fromOffset(8, 2)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 15
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    return frame
end

local green = Color3.fromRGB(35, 145, 80)
local red = Color3.fromRGB(170, 50, 50)
local blue = Color3.fromRGB(55, 95, 160)

local function addPair(parent, y, leftText, rightText, leftFn, rightFn)
    local left = makeButton(
        parent, leftText, UDim2.new(0.47, 0, 0, 36),
        UDim2.new(0.02, 0, 0, y), green
    )
    local right = makeButton(
        parent, rightText, UDim2.new(0.47, 0, 0, 36),
        UDim2.new(0.51, 0, 0, y), red
    )
    left.Activated:Connect(leftFn)
    right.Activated:Connect(rightFn)
    return left, right
end

-- FLY SECTION
local flyFrame = makeSection("✈  FLY", 164)
local flyOn, flyOff = addPair(
    flyFrame, 34, "ON FLY", "OFF FLY",
    function()
        if flying then return end
        local _, hum, root = getCharacter()
        if not hum or not root then return end

        flying = true
        flyAttachment = Instance.new("Attachment")
        flyAttachment.Parent = root

        flyVelocity = Instance.new("LinearVelocity")
        flyVelocity.Attachment0 = flyAttachment
        flyVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
        flyVelocity.VelocityConstraintMode =
            Enum.VelocityConstraintMode.Vector
        flyVelocity.MaxForce = 1000000
        flyVelocity.VectorVelocity = Vector3.zero
        flyVelocity.Parent = root

        hum.PlatformStand = true

        flyConn = RunService.RenderStepped:Connect(function()
            if not flying or not root.Parent then return end
            local direction = hum.MoveDirection
            local vertical = (upHeld and 1 or 0) -
                (downHeld and 1 or 0)

            flyVelocity.VectorVelocity =
                direction * flySpeed +
                Vector3.new(0, vertical * flySpeed, 0)
        end)
    end,
    function()
        flying = false
        upHeld, downHeld = false, false

        if flyConn then flyConn:Disconnect(); flyConn = nil end
        if flyVelocity then flyVelocity:Destroy(); flyVelocity = nil end
        if flyAttachment then
            flyAttachment:Destroy()
            flyAttachment = nil
        end

        local _, hum = getCharacter()
        if hum then hum.PlatformStand = false end
    end
)

local flyLabel = Instance.new("TextLabel")
flyLabel.Size = UDim2.new(0.45, 0, 0, 25)
flyLabel.Position = UDim2.new(0.03, 0, 0, 76)
flyLabel.BackgroundTransparency = 1
flyLabel.Text = "Fly Speed: 50"
flyLabel.TextColor3 = Color3.new(1, 1, 1)
flyLabel.TextSize = 13
flyLabel.Parent = flyFrame

local minus = makeButton(
    flyFrame, "−", UDim2.new(0.2, 0, 0, 30),
    UDim2.new(0.52, 0, 0, 74), blue
)
local plus = makeButton(
    flyFrame, "+", UDim2.new(0.2, 0, 0, 30),
    UDim2.new(0.76, 0, 0, 74), blue
)

minus.Activated:Connect(function()
    flySpeed = math.max(1, flySpeed - 10)
    flyLabel.Text = "Fly Speed: " .. flySpeed
end)
plus.Activated:Connect(function()
    flySpeed = math.min(1000000, flySpeed + 10)
    flyLabel.Text = "Fly Speed: " .. flySpeed
end)

local up = makeButton(
    flyFrame, "▲ BAY LÊN", UDim2.new(0.45, 0, 0, 30),
    UDim2.new(0.03, 0, 0, 119), blue
)
local down = makeButton(
    flyFrame, "▼ BAY XUỐNG", UDim2.new(0.45, 0, 0, 30),
    UDim2.new(0.52, 0, 0, 119), blue
)

up.Activated:Connect(function()
    upHeld = not upHeld
    up.Text = upHeld and "▲ ĐANG LÊN" or "▲ BAY LÊN"
end)
down.Activated:Connect(function()
    downHeld = not downHeld
    down.Text = downHeld and "▼ ĐANG XUỐNG" or "▼ BAY XUỐNG"
end)

-- NOCLIP SECTION
local noclipFrame = makeSection("👻  NOCLIP", 80)

local function turnOnNoclip()
    if noclip then return end
    noclip = true
    noclipConn = RunService.Stepped:Connect(function()
        local char = player.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function turnOffNoclip()
    noclip = false
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end

    local char = player.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

addPair(
    noclipFrame, 36, "ON NOCLIP", "OFF NOCLIP",
    turnOnNoclip, turnOffNoclip
)

-- TELEPORT SECTION
local teleFrame = makeSection("📍  TELEPORT", 84)

addPair(
    teleFrame, 36, "SAVE POSITION", "TELEPORT",
    function()
        local _, _, root = getCharacter()
        if root then savedCFrame = root.CFrame end
    end,
    function()
        local _, _, root = getCharacter()
        if root and savedCFrame then
            root.CFrame = savedCFrame + Vector3.new(0, 3, 0)
        end
    end
)

-- WALKSPEED SECTION
local speedFrame = makeSection("🏃  WALKSPEED", 118)

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.94, 0, 0, 34)
speedBox.Position = UDim2.new(0.03, 0, 0, 34)
speedBox.BackgroundColor3 = Color3.fromRGB(52, 52, 64)
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.PlaceholderText = "Nhập tốc độ (mặc định 16)"
speedBox.Text = "16"
speedBox.TextSize = 14
speedBox.ClearTextOnFocus = false
speedBox.Parent = speedFrame
round(speedBox, 8)

local applySpeed = makeButton(
    speedFrame, "APPLY SPEED", UDim2.new(0.94, 0, 0, 32),
    UDim2.new(0.03, 0, 0, 76), blue
)
applySpeed.Activated:Connect(function()
    local n = tonumber(speedBox.Text)
    if n and n >= 1 and n < math.huge then
        walkSpeed = n
        local _, hum = getCharacter()
        if hum then hum.WalkSpeed = walkSpeed end
    end
end)

-- OPEN / CLOSE
icon.Activated:Connect(function()
    menu.Visible = not menu.Visible
end)

close.Activated:Connect(function()
    menu.Visible = false
end)

-- DRAG ICON
local dragging = false
local dragStart, startPos

icon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = icon.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement
    ) then
        local delta = input.Position - dragStart
        icon.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

player.CharacterAdded:Connect(function()
    if flying then
        flying = false
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        if flyVelocity then flyVelocity:Destroy(); flyVelocity = nil end
        if flyAttachment then
            flyAttachment:Destroy()
            flyAttachment = nil
        end
    end

    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end
    noclip = false

    task.wait(0.3)
    local _, hum = getCharacter()
    if hum then hum.WalkSpeed = walkSpeed end
end)
