local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local oldGui = playerGui:FindFirstChild("PlayerTrackerGUI")
if oldGui then oldGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlayerTrackerGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.Enabled = true
screenGui.DisplayOrder = 998

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 70)
mainFrame.Position = UDim2.new(0.5, 0, 0.1, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 1

local dragHandle = Instance.new("TextButton")
dragHandle.Name = "DragHandle"
dragHandle.Size = UDim2.new(1, 0, 1, 0)
dragHandle.Text = ""
dragHandle.BackgroundTransparency = 1
dragHandle.BorderSizePixel = 0
dragHandle.AutoButtonColor = false
dragHandle.ZIndex = 2

local playerInfoFrame = Instance.new("Frame")
playerInfoFrame.Name = "PlayerInfoFrame"
playerInfoFrame.Size = UDim2.new(1, -10, 1, -10)
playerInfoFrame.Position = UDim2.new(0, 5, 0, 5)
playerInfoFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
playerInfoFrame.BackgroundTransparency = 0.4
playerInfoFrame.BorderSizePixel = 0
playerInfoFrame.ZIndex = 2

local avatarFrame = Instance.new("Frame")
avatarFrame.Name = "AvatarFrame"
avatarFrame.Size = UDim2.new(0, 35, 0, 35)
avatarFrame.Position = UDim2.new(0, 5, 0, 5)
avatarFrame.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
avatarFrame.BackgroundTransparency = 0.2
avatarFrame.BorderSizePixel = 0
avatarFrame.ZIndex = 3

local avatarImage = Instance.new("ImageLabel")
avatarImage.Name = "AvatarImage"
avatarImage.Size = UDim2.new(1, -4, 1, -4)
avatarImage.Position = UDim2.new(0, 2, 0, 2)
avatarImage.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
avatarImage.BorderSizePixel = 0
avatarImage.ZIndex = 4

local playerName = Instance.new("TextLabel")
playerName.Name = "PlayerName"
playerName.Size = UDim2.new(1, -45, 0, 18)
playerName.Position = UDim2.new(0, 45, 0, 5)
playerName.Text = "No Target"
playerName.TextColor3 = Color3.new(1, 1, 1)
playerName.TextSize = 11
playerName.Font = Enum.Font.GothamBold
playerName.BackgroundTransparency = 1
playerName.TextXAlignment = Enum.TextXAlignment.Left
playerName.ZIndex = 3

local healthText = Instance.new("TextLabel")
healthText.Name = "HealthText"
healthText.Size = UDim2.new(1, -45, 0, 14)
healthText.Position = UDim2.new(0, 45, 0, 23)
healthText.Text = "Health: 100/100"
healthText.TextColor3 = Color3.new(1, 1, 1)
healthText.TextSize = 9
healthText.Font = Enum.Font.Gotham
healthText.BackgroundTransparency = 1
healthText.TextXAlignment = Enum.TextXAlignment.Left
healthText.ZIndex = 3

local healthBarBackground = Instance.new("Frame")
healthBarBackground.Name = "HealthBarBackground"
healthBarBackground.Size = UDim2.new(1, -10, 0, 5)
healthBarBackground.Position = UDim2.new(0, 5, 1, -10)
healthBarBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
healthBarBackground.BorderSizePixel = 0
healthBarBackground.ZIndex = 3

local healthBar = Instance.new("Frame")
healthBar.Name = "HealthBar"
healthBar.Size = UDim2.new(1, 0, 1, 0)
healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
healthBar.BorderSizePixel = 0
healthBar.ZIndex = 4

local healthBarGradient = Instance.new("UIGradient")
healthBarGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 180, 50)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 255, 50)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(180, 255, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 255, 50))
})
healthBarGradient.Rotation = 0
healthBarGradient.Parent = healthBar

local targetFrameGui = Instance.new("ScreenGui")
targetFrameGui.Name = "TargetFrameGui"
targetFrameGui.Parent = playerGui
targetFrameGui.ResetOnSpawn = false
targetFrameGui.Enabled = true
targetFrameGui.DisplayOrder = 999

local targetFrame = Instance.new("Frame")
targetFrame.Name = "TargetFrame"
targetFrame.Size = UDim2.new(0, 120, 0, 120)
targetFrame.BackgroundTransparency = 1
targetFrame.Visible = false
targetFrame.ZIndex = 10

dragHandle.Parent = mainFrame
playerInfoFrame.Parent = mainFrame
avatarFrame.Parent = playerInfoFrame
avatarImage.Parent = avatarFrame
playerName.Parent = playerInfoFrame
healthText.Parent = playerInfoFrame
healthBarBackground.Parent = playerInfoFrame
healthBar.Parent = healthBarBackground
mainFrame.Parent = screenGui

local function applyRoundedCorners(parent, radius)
    radius = radius or 6
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

applyRoundedCorners(mainFrame, 8)
applyRoundedCorners(playerInfoFrame, 6)
applyRoundedCorners(avatarFrame, 4)
applyRoundedCorners(avatarImage, 2)
applyRoundedCorners(healthBarBackground, 3)
applyRoundedCorners(healthBar, 3)

local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 2
mainStroke.Color = Color3.fromRGB(173, 216, 230)
mainStroke.Transparency = 0.3
mainStroke.Parent = mainFrame

local function createCorner(name, baseRotation)
    local corner = Instance.new("Frame")
    corner.Name = name
    corner.Size = UDim2.new(0, 16, 0, 16)
    corner.AnchorPoint = Vector2.new(0.5, 0.5)
    corner.BackgroundTransparency = 1
    corner.BorderSizePixel = 0
    corner.ZIndex = 11
    corner.Rotation = baseRotation
    
    local horizontal = Instance.new("Frame")
    horizontal.Name = "Horizontal"
    horizontal.Size = UDim2.new(0, 8, 0, 2)
    horizontal.Position = UDim2.new(0, 0, 0, 7)
    horizontal.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    horizontal.BorderSizePixel = 0
    horizontal.ZIndex = 12
    
    local vertical = Instance.new("Frame")
    vertical.Name = "Vertical"
    vertical.Size = UDim2.new(0, 2, 0, 8)
    vertical.Position = UDim2.new(0, 7, 0, 0)
    vertical.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    vertical.BorderSizePixel = 0
    vertical.ZIndex = 12
    
    local horizontalGlow = Instance.new("UIStroke")
    horizontalGlow.Color = Color3.fromRGB(255, 255, 255)
    horizontalGlow.Thickness = 2
    horizontalGlow.Transparency = 0.1
    horizontalGlow.Parent = horizontal
    
    local verticalGlow = Instance.new("UIStroke")
    verticalGlow.Color = Color3.fromRGB(255, 255, 255)
    verticalGlow.Thickness = 2
    verticalGlow.Transparency = 0.1
    verticalGlow.Parent = vertical
    
    horizontal.Parent = corner
    vertical.Parent = corner
    
    return corner
end

local topLeftCorner = createCorner("TopLeftCorner", 0)
local topRightCorner = createCorner("TopRightCorner", 90)
local bottomLeftCorner = createCorner("BottomLeftCorner", 270)
local bottomRightCorner = createCorner("BottomRightCorner", 180)

topLeftCorner.Parent = targetFrame
topRightCorner.Parent = targetFrame
bottomLeftCorner.Parent = targetFrame
bottomRightCorner.Parent = targetFrame
targetFrame.Parent = targetFrameGui

local function animateHealthBar(healthPercent)
    if not healthBar or not healthBar.Parent then return end
    
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(healthBar, tweenInfo, {
        Size = UDim2.new(healthPercent, 0, 1, 0)
    })
    tween:Play()
end

local function updatePlayerInfo(targetPlayer)
    if not targetPlayer then
        playerName.Text = "No Target"
        healthText.Text = "Health: 0/0"
        animateHealthBar(0)
        return
    end
    
    local character = targetPlayer.Character
    if not character then return end
    
    playerName.Text = targetPlayer.Name
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local health = math.floor(humanoid.Health)
        local maxHealth = math.floor(humanoid.MaxHealth)
        local healthPercent = health / maxHealth
        
        healthText.Text = "Health: " .. health .. "/" .. maxHealth
        animateHealthBar(healthPercent)
    end
    
    pcall(function()
        local userId = targetPlayer.UserId
        local thumbType = Enum.ThumbnailType.HeadShot
        local thumbSize = Enum.ThumbnailSize.Size420x420
        local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
        avatarImage.Image = content
    end)
end

local function findNearestPlayer()
    local localCharacter = LocalPlayer.Character
    if not localCharacter then return nil end
    
    local localRoot = localCharacter:FindFirstChild("HumanoidRootPart")
    if not localRoot then return nil end
    
    local nearestPlayer = nil
    local shortestDistance = math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local character = player.Character
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local distance = (localRoot.Position - humanoidRootPart.Position).Magnitude
                if distance < shortestDistance and distance < 50 then
                    shortestDistance = distance
                    nearestPlayer = player
                end
            end
        end
    end
    
    return nearestPlayer
end

local function updateTargetFrame(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then
        targetFrame.Visible = false
        return
    end
    
    local character = targetPlayer.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
