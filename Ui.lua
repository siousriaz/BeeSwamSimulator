--====================================================--
--==================  UI CREATION  ===================--
--====================================================--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "CraftUI"
gui.Parent = playerGui
gui.ResetOnSpawn = false

--=================  Toggle Button  ===================--

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0, 200, 0, 40)
toggle.Position = UDim2.new(1, -210, 0, 10)
toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.SourceSansBold
toggle.TextSize = 22
toggle.Text = "Open"
toggle.Parent = gui

--=================  FPS LABEL  ===================--

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0, 200, 0, 25)
fpsLabel.Position = UDim2.new(1, -210, 0, 55)
fpsLabel.BackgroundTransparency = 0.5
fpsLabel.BackgroundColor3 = Color3.fromRGB(0,0,0)
fpsLabel.TextColor3 = Color3.fromRGB(0,255,0)
fpsLabel.Font = Enum.Font.SourceSansBold
fpsLabel.TextScaled = true
fpsLabel.Text = "FPS: ..."
fpsLabel.Parent = gui

--=================  MAIN FRAME (HORIZONTAL) ===================--

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 650, 0, 450)
mainFrame.Position = UDim2.new(1, -660, 0, 90)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

Instance.new("UICorner", mainFrame)

--=================  LEFT PANEL ===================--

local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0, 300, 1, 0)
leftPanel.BackgroundTransparency = 1
leftPanel.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Craft Panel"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 26
title.Parent = leftPanel

-- Count box
local countBox = Instance.new("TextBox")
countBox.Size = UDim2.new(0, 250, 0, 40)
countBox.Position = UDim2.new(0, 25, 0, 50)
countBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
countBox.TextColor3 = Color3.new(1,1,1)
countBox.PlaceholderText = "Count"
countBox.Font = Enum.Font.SourceSans
countBox.TextSize = 20
countBox.Parent = leftPanel

-- Count item
local countItemLabel = Instance.new("TextLabel")
countItemLabel.Size = UDim2.new(0, 100, 0, 30)
countItemLabel.Position = UDim2.new(0, 25, 0, 100)
countItemLabel.BackgroundTransparency = 1
countItemLabel.Text = "Count item:"
countItemLabel.TextColor3 = Color3.new(1,1,1)
countItemLabel.Font = Enum.Font.SourceSans
countItemLabel.TextSize = 18
countItemLabel.Parent = leftPanel

local countItemBox = Instance.new("TextBox")
countItemBox.Size = UDim2.new(0, 150, 0, 30)
countItemBox.Position = UDim2.new(0, 130, 0, 100)
countItemBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
countItemBox.TextColor3 = Color3.new(1,1,1)
countItemBox.PlaceholderText = "Nhập số..."
countItemBox.Font = Enum.Font.SourceSans
countItemBox.TextSize = 18
countItemBox.Parent = leftPanel

local resultLabel = Instance.new("TextLabel")
resultLabel.Size = UDim2.new(0, 250, 0, 30)
resultLabel.Position = UDim2.new(0, 25, 0, 135)
resultLabel.BackgroundTransparency = 1
resultLabel.Text = "Kết quả: 0"
resultLabel.TextColor3 = Color3.new(1,1,1)
resultLabel.Font = Enum.Font.SourceSansBold
resultLabel.TextSize = 18
resultLabel.Parent = leftPanel

countItemBox:GetPropertyChangedSignal("Text"):Connect(function()
    local num = tonumber(countItemBox.Text)
    if num then
        resultLabel.Text = "Kết quả: "..(num/50).." or "..(num/25).." Mooncharm"
    end
end)

-- Buttons helper
local function createBtn(text, y, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 250, 0, 36)
    btn.Position = UDim2.new(0, 25, 0, y)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 20
    btn.Parent = leftPanel
    return btn
end

local endCraftBtn = createBtn("End Craft", 175, Color3.fromRGB(120,0,0))
endCraftBtn.MouseButton1Click:Connect(function()
    ReplicatedStorage.Events.BlenderCommand:InvokeServer("StopOrder")
end)

local endByTicketBtn = createBtn("End by Tickets", 215, Color3.fromRGB(0,150,0))
endByTicketBtn.MouseButton1Click:Connect(function()
    ReplicatedStorage.Events.BlenderCommand:InvokeServer("SpeedUpOrder")
end)

--=================  TWEEN FUNCTION ===================--

local function tweenTo(targetCFrame)
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local speed = 70
    local time = distance / speed

    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})

    hrp.Anchored = true
    tween:Play()
    tween.Completed:Wait()
    hrp.Anchored = false
end

local blenderBtn = createBtn("Blender", 255, Color3.fromRGB(70,130,180))
blenderBtn.MouseButton1Click:Connect(function()
    tweenTo(CFrame.new(-424, 69, 37))
end)

local diamondBtn = createBtn("DiamondMask", 295, Color3.fromRGB(0,180,180))
diamondBtn.MouseButton1Click:Connect(function()
    tweenTo(CFrame.new(-334, 132, -392))
end)

--=================  RIGHT PANEL (CRAFT) ===================--

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0, 320, 0, 390)
scrollFrame.Position = UDim2.new(0, 315, 0, 40)
scrollFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 10
scrollFrame.Parent = mainFrame

local uiLayout = Instance.new("UIListLayout")
uiLayout.Padding = UDim.new(0,5)
uiLayout.Parent = scrollFrame

local craftItems = {
    "BlueExtract","RedExtract","Oil","Enzymes","Gumdrops","Glue",
    "Glitter","StarJelly","TropicalDrink","PurplePotion","SuperSmoothie"
}

local Event = ReplicatedStorage.Events.BlenderCommand

for _, recipeName in ipairs(craftItems) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = "Craft "..recipeName
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 20
    btn.Parent = scrollFrame

    btn.MouseButton1Click:Connect(function()
        local count = tonumber(countBox.Text) or 1
        Event:InvokeServer("PlaceOrder", {Recipe = recipeName, Count = count})
    end)
end

scrollFrame.CanvasSize = UDim2.new(0,0,0,uiLayout.AbsoluteContentSize.Y)

--==================  OPEN / CLOSE ==================

toggle.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    toggle.Text = mainFrame.Visible and "Close" or "Open"
end)

--====================  FPS TRACKER ==================

task.spawn(function()
    while true do
        fpsLabel.Text = "FPS: "..math.floor(1 / RunService.RenderStepped:Wait())
        task.wait(1)
    end
end)
