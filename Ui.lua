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

--=================  TOGGLE ===================--

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0,200,0,40)
toggle.Position = UDim2.new(1,-210,0,10)
toggle.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Font = Enum.Font.SourceSansBold
toggle.TextSize = 22
toggle.Text = "Open"
toggle.Parent = gui

--=================  FPS ===================--

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0,200,0,25)
fpsLabel.Position = UDim2.new(1,-210,0,55)
fpsLabel.BackgroundTransparency = 0.5
fpsLabel.BackgroundColor3 = Color3.fromRGB(0,0,0)
fpsLabel.TextColor3 = Color3.fromRGB(0,255,0)
fpsLabel.Font = Enum.Font.SourceSansBold
fpsLabel.TextScaled = true
fpsLabel.Text = "FPS: ..."
fpsLabel.Parent = gui

--=================  MAIN FRAME ===================--

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,650,0,450)
mainFrame.Position = UDim2.new(1,-660,0,90)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui
Instance.new("UICorner", mainFrame)

--=================  LEFT PANEL ===================--

local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0,300,1,0)
leftPanel.BackgroundTransparency = 1
leftPanel.Parent = mainFrame

--=================  TITLE ===================--

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "Craft Panel"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 26
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = leftPanel

--=================  COUNT ===================--

local countBox = Instance.new("TextBox")
countBox.Size = UDim2.new(0,250,0,40)
countBox.Position = UDim2.new(0,25,0,50)
countBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
countBox.TextColor3 = Color3.new(1,1,1)
countBox.PlaceholderText = "Count"
countBox.Font = Enum.Font.SourceSans
countBox.TextSize = 20
countBox.Parent = leftPanel

local countItemLabel = Instance.new("TextLabel")
countItemLabel.Size = UDim2.new(0,100,0,30)
countItemLabel.Position = UDim2.new(0,25,0,100)
countItemLabel.BackgroundTransparency = 1
countItemLabel.Text = "Count item:"
countItemLabel.TextColor3 = Color3.new(1,1,1)
countItemLabel.Font = Enum.Font.SourceSans
countItemLabel.TextSize = 18
countItemLabel.Parent = leftPanel

local countItemBox = Instance.new("TextBox")
countItemBox.Size = UDim2.new(0,150,0,30)
countItemBox.Position = UDim2.new(0,130,0,100)
countItemBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
countItemBox.TextColor3 = Color3.new(1,1,1)
countItemBox.PlaceholderText = "Nhập số..."
countItemBox.Font = Enum.Font.SourceSans
countItemBox.TextSize = 18
countItemBox.Parent = leftPanel

local resultLabel = Instance.new("TextLabel")
resultLabel.Size = UDim2.new(0,250,0,30)
resultLabel.Position = UDim2.new(0,25,0,135)
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

--=================  END BUTTONS ===================--

local function fixedBtn(text,y,color,func)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0,250,0,36)
	b.Position = UDim2.new(0,25,0,y)
	b.BackgroundColor3 = color
	b.TextColor3 = Color3.new(1,1,1)
	b.Text = text
	b.Font = Enum.Font.SourceSansBold
	b.TextSize = 20
	b.Parent = leftPanel
	b.MouseButton1Click:Connect(func)
end

fixedBtn("End Craft",175,Color3.fromRGB(120,0,0),function()
	ReplicatedStorage.Events.BlenderCommand:InvokeServer("StopOrder")
end)

fixedBtn("End by Tickets",215,Color3.fromRGB(0,150,0),function()
	ReplicatedStorage.Events.BlenderCommand:InvokeServer("SpeedUpOrder")
end)

--=================  TWEEN ===================--

local function tweenTo(cf)
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local time = (hrp.Position - cf.Position).Magnitude / 100
	hrp.Anchored = true
	local tw = TweenService:Create(hrp,TweenInfo.new(time,Enum.EasingStyle.Linear),{CFrame = cf})
	tw:Play()
	tw.Completed:Wait()
	hrp.Anchored = false
end

--=================  ACTION SCROLL ===================--

local actionScroll = Instance.new("ScrollingFrame")
actionScroll.Size = UDim2.new(0,250,1,-265)
actionScroll.Position = UDim2.new(0,25,0,255)
actionScroll.BackgroundColor3 = Color3.fromRGB(32,32,32)
actionScroll.ScrollBarThickness = 6
actionScroll.BorderSizePixel = 0
actionScroll.Parent = leftPanel
Instance.new("UICorner", actionScroll)
local function resetCharacter()
	local char = player.Character
	if char and char:FindFirstChild("Humanoid") then
		char.Humanoid.Health = 0
	end
end

local layout = Instance.new("UIListLayout", actionScroll)
layout.Padding = UDim.new(0,6)

local function starJellyTween()
	local positions = {
		CFrame.new(-412.1661071777344, 17.16798210144043, 466.94390869140625),
		CFrame.new(-436.7828369140625, 93.25753784179688, 49.242652893066406),
		CFrame.new(-482.6617126464844, 69.3868179321289, -0.30026334524154663),
		CFrame.new(16.145164489746094, 92.19210052490234, 490)
	}

	for _, cf in ipairs(positions) do
		tweenTo(cf)
		wait(1)
	end

	ReplicatedStorage.Events.PlayerActivesCommand:FireServer({
		Name = "Gumdrops"
	})
wait(1.5)
	tweenTo(CFrame.new(271.8910217285156, 25292.791015625, -873.340576171875))
	wait(0.5)
	resetCharacter()
end

local function actionBtn(text,color,func)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-10,0,36)
	b.BackgroundColor3 = color
	b.TextColor3 = Color3.new(1,1,1)
	b.Text = text
	b.Font = Enum.Font.SourceSansBold
	b.TextSize = 18
	b.Parent = actionScroll
	b.MouseButton1Click:Connect(func)
end

actionBtn("Blender",Color3.fromRGB(70,130,180),function()
	tweenTo(CFrame.new(-424,69,37))
end)

actionBtn("Diamond Mask",Color3.fromRGB(0,180,180),function()
	tweenTo(CFrame.new(-334,132,-392))
end)

actionBtn("Royal Jelly Shop",Color3.fromRGB(180,120,0),function()
	tweenTo(CFrame.new(-293.1046,52.2116,68.242))
end)

actionBtn("Petal Shop",Color3.fromRGB(255,120,200),function()
	tweenTo(CFrame.new(-500.5889,51.5681,466.1004))
end)

actionBtn("Nectar Conserver",Color3.fromRGB(120,255,120),function()
	tweenTo(CFrame.new(-415.5715,101.0204,343.2695))
end)

actionBtn("Star Jelly", Color3.fromRGB(255,215,0), starJellyTween)

actionBtn("Diamond Egg", Color3.fromRGB(0,200,255), function()
	tweenTo(CFrame.new(41.6182,150.6023,-528))
end)

actionBtn("Wind Shrine",Color3.fromRGB(150,150,255),function()
	tweenTo(CFrame.new(-478.0487,141.5075,411.1997))
end)

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	actionScroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+6)
end)

--=================  RIGHT PANEL (CRAFT) ===================--

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0,320,0,390)
scrollFrame.Position = UDim2.new(0,315,0,40)
scrollFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 10
scrollFrame.Parent = mainFrame

local uiLayout = Instance.new("UIListLayout", scrollFrame)
uiLayout.Padding = UDim.new(0,5)

local craftItems = {
	"BlueExtract","RedExtract","Oil","Enzymes","Gumdrops","Glue",
	"Glitter","StarJelly","TropicalDrink","PurplePotion","SuperSmoothie"
}

for _,recipe in ipairs(craftItems) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-10,0,35)
	b.BackgroundColor3 = Color3.fromRGB(60,60,60)
	b.TextColor3 = Color3.new(1,1,1)
	b.Text = "Craft "..recipe
	b.Font = Enum.Font.SourceSansBold
	b.TextSize = 20
	b.Parent = scrollFrame
	b.MouseButton1Click:Connect(function()
		ReplicatedStorage.Events.BlenderCommand:InvokeServer("PlaceOrder",{
			Recipe = recipe,
			Count = tonumber(countBox.Text) or 1
		})
	end)
end

scrollFrame.CanvasSize = UDim2.new(0,0,0,uiLayout.AbsoluteContentSize.Y)

--=================  TOGGLE ===================--

toggle.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
	toggle.Text = mainFrame.Visible and "Close" or "Open"
end)

task.spawn(function()
	while true do
		fpsLabel.Text = "FPS: "..math.floor(1 / RunService.RenderStepped:Wait())
		task.wait(1)
	end
end)
