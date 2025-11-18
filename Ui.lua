-- Lấy PlayerGui
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "CraftUI"
gui.Parent = playerGui
gui.ResetOnSpawn = false

-- Toggle Button
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0,200,0,40)
toggle.Position = UDim2.new(1,-210,0,10)
toggle.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.SourceSansBold
toggle.TextSize = 22
toggle.Text = "Open"
toggle.Parent = gui

-- FPS Label
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0,200,0,25)
fpsLabel.Position = UDim2.new(1,-210,0,55)
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextColor3 = Color3.new(1,1,1)
fpsLabel.Font = Enum.Font.SourceSansBold
fpsLabel.TextSize = 18
fpsLabel.Text = "FPS: ..."
fpsLabel.Parent = gui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,350,0,520)
mainFrame.Position = UDim2.new(1,-370,0,90)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.Visible = false
mainFrame.Parent = gui

local corner = Instance.new("UICorner")
corner.Parent = mainFrame

-- Drag frame đơn giản
mainFrame.Active = true
mainFrame.Draggable = true

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "Craft Panel"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 26
title.Parent = mainFrame

-- ===== COUNT BOX =====
local countBox = Instance.new("TextBox")
countBox.Name = "count"
countBox.Size = UDim2.new(0,300,0,40)
countBox.Position = UDim2.new(0,25,0,50)
countBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
countBox.TextColor3 = Color3.new(1,1,1)
countBox.PlaceholderText = "Count"
countBox.Font = Enum.Font.SourceSans
countBox.TextSize = 20
countBox.Parent = mainFrame

-- ===== Count Item =====
local countItemLabel = Instance.new("TextLabel")
countItemLabel.Size = UDim2.new(0,100,0,30)
countItemLabel.Position = UDim2.new(0,25,0,110)
countItemLabel.BackgroundTransparency = 1
countItemLabel.Text = "Count item:"
countItemLabel.TextColor3 = Color3.new(1,1,1)
countItemLabel.Font = Enum.Font.SourceSans
countItemLabel.TextSize = 20
countItemLabel.Parent = mainFrame

local countItemBox = Instance.new("TextBox")
countItemBox.Size = UDim2.new(0,150,0,30)
countItemBox.Position = UDim2.new(0,130,0,110)
countItemBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
countItemBox.TextColor3 = Color3.new(1,1,1)
countItemBox.PlaceholderText = "Nhập số..."
countItemBox.Font = Enum.Font.SourceSans
countItemBox.TextSize = 18
countItemBox.Parent = mainFrame

local resultLabel = Instance.new("TextLabel")
resultLabel.Size = UDim2.new(0,300,0,30)
resultLabel.Position = UDim2.new(0,25,0,150)
resultLabel.BackgroundTransparency = 1
resultLabel.Text = "Kết quả: 0"
resultLabel.TextColor3 = Color3.new(1,1,1)
resultLabel.Font = Enum.Font.SourceSansBold
resultLabel.TextSize = 20
resultLabel.Parent = mainFrame

countItemBox:GetPropertyChangedSignal("Text"):Connect(function()
	local num = tonumber(countItemBox.Text)
	if num then
		resultLabel.Text = "Kết quả: "..tostring(num/50)
	end
end)

-- ===== End Craft Button =====
local endCraftBtn = Instance.new("TextButton")
endCraftBtn.Size = UDim2.new(0,300,0,40)
endCraftBtn.Position = UDim2.new(0,25,0,200)
endCraftBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
endCraftBtn.TextColor3 = Color3.new(1,1,1)
endCraftBtn.Text = "End Craft"
endCraftBtn.Font = Enum.Font.SourceSansBold
endCraftBtn.TextSize = 22
endCraftBtn.Parent = mainFrame

-- ===== Scroll Frame cho Craft Buttons =====
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(0,300,0,250)
scroll.Position = UDim2.new(0,25,0,250)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 10
scroll.BackgroundColor3 = Color3.fromRGB(50,50,50)
scroll.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Parent = scroll
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0,5)

-- Craft Items
local craftItems = {
	"BlueExtract","RedExtract","Oil","Enzymes","Glue","Glitter",
	"PurplePotion","SuperSmoothie","TropicalDrink","StarJelly","Gumdrops"
}

local Event = game:GetService("ReplicatedStorage").Events.BlenderCommand

for _, recipeName in ipairs(craftItems) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,0,0,35)
	btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Text = "Craft "..recipeName
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 20
	btn.Parent = scroll

	btn.MouseButton1Click:Connect(function()
		local count = tonumber(countBox.Text) or 1
		Event:InvokeServer("PlaceOrder",{["Recipe"]=recipeName,["Count"]=count})
	end)
end

-- Auto update CanvasSize để scroll hoạt động
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)
end)

-- ===== Toggle Open/Close =====
toggle.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
	toggle.Text = mainFrame.Visible and "Close" or "Open"
end)

-- ===== FPS Tracker =====
task.spawn(function()
	while true do
		local fps = math.floor(1/game:GetService("RunService").RenderStepped:Wait())
		fpsLabel.Text = "FPS: "..fps
		task.wait(1)
	end
end)mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.Visible = false
mainFrame.Parent = gui

local corner = Instance.new("UICorner")
corner.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "Craft Panel"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 26
title.Parent = mainFrame

-- ===== COUNT BOX =====
local countBox = Instance.new("TextBox")
countBox.Name = "count"
countBox.Size = UDim2.new(0,300,0,40)
countBox.Position = UDim2.new(0,25,0,50)
countBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
countBox.TextColor3 = Color3.new(1,1,1)
countBox.PlaceholderText = "Count"
countBox.Font = Enum.Font.SourceSans
countBox.TextSize = 20
countBox.Parent = mainFrame

-- ===== Count Item =====
local countItemLabel = Instance.new("TextLabel")
countItemLabel.Size = UDim2.new(0,100,0,30)
countItemLabel.Position = UDim2.new(0,25,0,110)
countItemLabel.BackgroundTransparency = 1
countItemLabel.Text = "Count item:"
countItemLabel.TextColor3 = Color3.new(1,1,1)
countItemLabel.Font = Enum.Font.SourceSans
countItemLabel.TextSize = 20
countItemLabel.Parent = mainFrame

local countItemBox = Instance.new("TextBox")
countItemBox.Size = UDim2.new(0,150,0,30)
countItemBox.Position = UDim2.new(0,130,0,110)
countItemBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
countItemBox.TextColor3 = Color3.new(1,1,1)
countItemBox.PlaceholderText = "Nhập số..."
countItemBox.Font = Enum.Font.SourceSans
countItemBox.TextSize = 18
countItemBox.Parent = mainFrame

local resultLabel = Instance.new("TextLabel")
resultLabel.Size = UDim2.new(0,300,0,30)
resultLabel.Position = UDim2.new(0,25,0,150)
resultLabel.BackgroundTransparency = 1
resultLabel.Text = "Kết quả: 0"
resultLabel.TextColor3 = Color3.new(1,1,1)
resultLabel.Font = Enum.Font.SourceSansBold
resultLabel.TextSize = 20
resultLabel.Parent = mainFrame

countItemBox:GetPropertyChangedSignal("Text"):Connect(function()
	local num = tonumber(countItemBox.Text)
	if num then
		resultLabel.Text = "Kết quả: "..tostring(num/50)
	end
end)

-- ===== End Craft Button =====
local endCraftBtn = Instance.new("TextButton")
endCraftBtn.Size = UDim2.new(0,300,0,40)
endCraftBtn.Position = UDim2.new(0,25,0,200)
endCraftBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
endCraftBtn.TextColor3 = Color3.new(1,1,1)
endCraftBtn.Text = "End Craft"
endCraftBtn.Font = Enum.Font.SourceSansBold
endCraftBtn.TextSize = 22
endCraftBtn.Parent = mainFrame

-- ===== Scrolling Frame for Craft Buttons =====
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(0,300,0,250)
scroll.Position = UDim2.new(0,25,0,250)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 10
scroll.BackgroundColor3 = Color3.fromRGB(50,50,50)
scroll.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Parent = scroll
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0,5)

-- Craft Items
local craftItems = {
	"BlueExtract","RedExtract","Oil","Enzymes","Glue","Glitter",
	"PurplePotion","SuperSmoothie","TropicalDrink","StarJelly","Gumdrops"
}

local Event = game:GetService("ReplicatedStorage").Events.BlenderCommand

for _, recipeName in ipairs(craftItems) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,0,0,35)
	btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Text = "Craft "..recipeName
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 20
	btn.Parent = scroll

	btn.MouseButton1Click:Connect(function()
		local count = tonumber(countBox.Text) or 1
		Event:InvokeServer("PlaceOrder",{["Recipe"]=recipeName,["Count"]=count})
	end)
end

-- Update CanvasSize
scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)
end)

-- ===== Toggle Open/Close =====
toggle.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
	toggle.Text = mainFrame.Visible and "Close" or "Open"
end)

-- ===== FPS Tracker =====
task.spawn(function()
	while true do
		local fps = math.floor(1/game:GetService("RunService").RenderStepped:Wait())
		fpsLabel.Text = "FPS: "..fps
		task.wait(1)
	end
end)

-- ===== Make Frame Draggable =====
local dragging=false
local dragInput,dragStart,startPos

local function update(input)
	local delta=input.Position-dragStart
	mainFrame.Position=UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 then
		dragging=true
		dragStart=input.Position
		startPos=mainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState==Enum.UserInputState.End then
				dragging=false
			end
		end)
	end
end)

mainFrame.InputChanged:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseMovement then
		dragInput=input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if dragging and input==dragInput then
		update(input)
	end
end)
