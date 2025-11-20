--====================================================--
--==================  UI CREATION  ===================--
--====================================================--

local player = game.Players.LocalPlayer
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
fpsLabel.Font = Enum.Font.SourceSansBold
fpsLabel.TextSize = 18
fpsLabel.Text = "FPS: ..."
fpsLabel.BackgroundTransparency = 0.5
fpsLabel.BackgroundColor3 = Color3.fromRGB(0,0,0)
fpsLabel.TextColor3 = Color3.fromRGB(0,255,0)
fpsLabel.TextScaled = true
fpsLabel.Parent = gui

--=================  MAIN FRAME  ===================--

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 520)
mainFrame.Position = UDim2.new(1, -310, 0, 90)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Visible = false
mainFrame.Parent = gui
mainFrame.Draggable = true
mainFrame.Active = true
mainFrame.Selectable = true

local corner = Instance.new("UICorner")
corner.Parent = mainFrame

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Craft Panel"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 26
title.Parent = mainFrame

--=====================  COUNT BOX  ==================

local countBox = Instance.new("TextBox")
countBox.Name = "count"
countBox.Size = UDim2.new(0, 250, 0, 40)
countBox.Position = UDim2.new(0, 25, 0, 50)
countBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
countBox.TextColor3 = Color3.new(1,1,1)
countBox.PlaceholderText = "Count"
countBox.Font = Enum.Font.SourceSans
countBox.TextSize = 20
countBox.Parent = mainFrame

--==================  COUNT ITEM BOX  ===============

local countItemLabel = Instance.new("TextLabel")
countItemLabel.Size = UDim2.new(0, 100, 0, 30)
countItemLabel.Position = UDim2.new(0, 25, 0, 110)
countItemLabel.BackgroundTransparency = 1
countItemLabel.Text = "Count item:"
countItemLabel.TextColor3 = Color3.new(1,1,1)
countItemLabel.Font = Enum.Font.SourceSans
countItemLabel.TextSize = 20
countItemLabel.Parent = mainFrame

local countItemBox = Instance.new("TextBox")
countItemBox.Size = UDim2.new(0, 150, 0, 30)
countItemBox.Position = UDim2.new(0, 130, 0, 110)
countItemBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
countItemBox.TextColor3 = Color3.new(1,1,1)
countItemBox.PlaceholderText = "Nhập số..."
countItemBox.Font = Enum.Font.SourceSans
countItemBox.TextSize = 18
countItemBox.Parent = mainFrame

local resultLabel = Instance.new("TextLabel")
resultLabel.Size = UDim2.new(0, 250, 0, 30)
resultLabel.Position = UDim2.new(0, 25, 0, 150)
resultLabel.BackgroundTransparency = 1
resultLabel.Text = "Kết quả: 0"
resultLabel.TextColor3 = Color3.new(1,1,1)
resultLabel.Font = Enum.Font.SourceSansBold
resultLabel.TextSize = 20
resultLabel.Parent = mainFrame

countItemBox:GetPropertyChangedSignal("Text"):Connect(function()
    local num = tonumber(countItemBox.Text)
    if num then
        resultLabel.Text = "Kết quả: " .. tostring(num / 50) .. "or" .. tostring(num / 25) .. "Mooncharm"
    end
end)

--===================  END CRAFT BTN  =================

local endCraftBtn = Instance.new("TextButton")
endCraftBtn.Size = UDim2.new(0, 250, 0, 40)
endCraftBtn.Position = UDim2.new(0, 25, 0, 200)
endCraftBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
endCraftBtn.TextColor3 = Color3.new(1,1,1)
endCraftBtn.Text = "End Craft"
endCraftBtn.Font = Enum.Font.SourceSansBold
endCraftBtn.TextSize = 22
endCraftBtn.Parent = mainFrame

--==================  SCROLL FRAME CHO NÚT CRAFT ==================

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0, 250, 0, 260)
scrollFrame.Position = UDim2.new(0, 25, 0, 250)
scrollFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 10
scrollFrame.Parent = mainFrame

local uiLayout = Instance.new("UIListLayout")
uiLayout.Padding = UDim.new(0,5)
uiLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiLayout.Parent = scrollFrame

--==================  CRAFT BUTTONS  ==================

local craftItems = {
    "BlueExtract","RedExtract","Oil","Enzymes","Glue",
    "Glitter","PurplePotion","SuperSmoothie","TropicalDrink",
    "StarJelly","Gumdrops"
}

local Event = game:GetService("ReplicatedStorage").Events.BlenderCommand

for i, recipeName in ipairs(craftItems) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35) -- full width ScrollFrame
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = "Craft "..recipeName
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 20
    btn.Parent = scrollFrame

    btn.MouseButton1Click:Connect(function()
        local count = tonumber(countBox.Text) or 1
        local args1 = "PlaceOrder"
        local args2 = {["Recipe"]=recipeName, ["Count"]=count}
        Event:InvokeServer(args1,args2)
    end)
end

-- Auto update CanvasSize
local function updateCanvasSize()
    local layout = scrollFrame:FindFirstChildOfClass("UIListLayout")
    if layout then
        scrollFrame.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)
    end
end

updateCanvasSize()
scrollFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateCanvasSize)

--==================  OPEN/CLOSE TOGGLE ==================

toggle.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    toggle.Text = mainFrame.Visible and "Close" or "Open"
end)

--====================  FPS TRACKER ==================

task.spawn(function()
    while true do
        local fps = math.floor(1 / game:GetService("RunService").RenderStepped:Wait())
        fpsLabel.Text = "FPS: "..fps
        task.wait(1)
    end
end)
