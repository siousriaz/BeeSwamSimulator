local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local feeding = false

--================= GUI =================--

local gui = Instance.new("ScreenGui")
gui.Name = "CraftUI"
gui.Parent = playerGui
gui.ResetOnSpawn = false

--================= TOGGLE =================--

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0,200,0,40)
toggle.Position = UDim2.new(1,-210,0,10)
toggle.Text = "Open"
toggle.Font = Enum.Font.SourceSansBold
toggle.TextSize = 22
toggle.TextColor3 = Color3.new(1,1,1)
toggle.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggle.Parent = gui

--================= MAIN FRAME =================--

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,800,0,460)
mainFrame.Position = UDim2.new(1,-820,0,80)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui
Instance.new("UICorner", mainFrame)

--================= 🔥 UI SCALE (2/3 + AUTO) =================--

local uiScale = Instance.new("UIScale")
uiScale.Scale = 0.66
uiScale.Parent = mainFrame

local camera = workspace.CurrentCamera
local function updateScale()
	local w = camera.ViewportSize.X
	if w < 1000 then
		uiScale.Scale = 1
	elseif w < 1400 then
		uiScale.Scale = 1
	else
		uiScale.Scale = 1
	end
end

updateScale()
camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)

--================= TWEEN COLUMN =================--

local tweenFrame = Instance.new("Frame")
tweenFrame.Size = UDim2.new(0,170,1,-20)
tweenFrame.Position = UDim2.new(0,10,0,10)
tweenFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
tweenFrame.Parent = mainFrame
Instance.new("UICorner", tweenFrame)

local tweenLayout = Instance.new("UIListLayout", tweenFrame)
tweenLayout.Padding = UDim.new(0,6)

local function tweenBtn(text,color,func)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-10,0,34)
	b.BackgroundColor3 = color
	b.TextColor3 = Color3.new(1,1,1)
	b.Text = text
	b.Font = Enum.Font.SourceSansBold
	b.TextSize = 15
	b.Parent = tweenFrame
	b.MouseButton1Click:Connect(func)
end

--================= CENTER PANEL =================--

local centerPanel = Instance.new("Frame")
centerPanel.Size = UDim2.new(0,300,1,-20)
centerPanel.Position = UDim2.new(0,190,0,10)
centerPanel.BackgroundTransparency = 1
centerPanel.Parent = mainFrame

--================= TITLE =================--

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.Text = "Craft Panel"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 26
title.BackgroundTransparency = 1
title.Parent = cen--================= COUNT UI ===========
local countBox = Instance.new("TextBox")
countBox.Size = UDim2.new(0,260,0,38)
countBox.Position = UDim2.new(0,20,0,50)
countBox.PlaceholderText = "Count"
countBox.TextColor3 = Color3.new(1,1,1)
countBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
countBox.Parent = centerPanel

local countItemLabel = Instance.new("TextLabel")
countItemLabel.Size = UDim2.new(0,100,0,30)
countItemLabel.Position = UDim2.new(0,20,0,95)
countItemLabel.Text = "Count item:"
countItemLabel.TextColor3 = Color3.new(1,1,1)
countItemLabel.BackgroundTransparency = 1
countItemLabel.Parent = centerPanel

local countItemBox = Instance.new("TextBox")
countItemBox.Size = UDim2.new(0,150,0,30)
countItemBox.Position = UDim2.new(0,130,0,95)
countItemBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
countItemBox.TextColor3 = Color3.new(1,1,1)
countItemBox.Parent = centerPanel

local resultLabel = Instance.new("TextLabel")
resultLabel.Size = UDim2.new(0,260,0,28)
resultLabel.Position = UDim2.new(0,20,0,130)
resultLabel.Text = "Kết quả: 0"
resultLabel.TextColor3 = Color3.new(1,1,1)
resultLabel.BackgroundTransparency = 1
resultLabel.Parent = centerPanel

countItemBox:GetPropertyChangedSignal("Text"):Connect(function()
	local n = tonumber(countItemBox.Text)
	if n then
		resultLabel.Text = "Kết quả: "..(n/50).." or "..(n/25).." Mooncharm"
	end
end)

--================= FEED AMOUNT =================--

local feedAmountBox = Instance.new("TextBox")
feedAmountBox.Size = UDim2.new(0,260,0,38)
feedAmountBox.Position = UDim2.new(0,20,0,165)
feedAmountBox.Text = "500"
feedAmountBox.TextColor3 = Color3.new(1,1,1)
feedAmountBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
feedAmountBox.Parent = centerPanel

--================= FPS COUNTER (UNDER TOGGLE) =================--

local fpsFrame = Instance.new("Frame")
fpsFrame.Size = UDim2.new(0,200,0,26)
fpsFrame.Position = UDim2.new(1,-210,0,55) -- ngay dưới nút Open/Close
fpsFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
fpsFrame.BorderSizePixel = 0
fpsFrame.Parent = gui
Instance.new("UICorner", fpsFrame)

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1,0,1,0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: 0"
fpsLabel.Font = Enum.Font.SourceSansBold
fpsLabel.TextSize = 16
fpsLabel.TextColor3 = Color3.fromRGB(0,255,120)
fpsLabel.Parent = fpsFrame

-- FPS logic (ổn định)
local frames = 0
local last = os.clock()

RunService.RenderStepped:Connect(function()
	frames += 1
	local now = os.clock()
	if now - last >= 1 then
		fpsLabel.Text = "FPS: "..frames
		frames = 0
		last = now
	end
end)
--================= AUTO FONT BUNGEE (FontFace) =================--


--================= BUTTONS =================--

local function fixedBtn(text,y,color,func)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0,260,0,36)
	b.Position = UDim2.new(0,20,0,y)
	b.Text = text
	b.Font = Enum.Font.SourceSansBold
	b.TextSize = 18
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = color
	b.Parent = centerPanel
	b.MouseButton1Click:Connect(func)
end

fixedBtn("End Craft",210,Color3.fromRGB(120,0,0),function()
	ReplicatedStorage.Events.BlenderCommand:InvokeServer("StopOrder")
end)

fixedBtn("End by Tickets",250,Color3.fromRGB(0,150,0),function()
	ReplicatedStorage.Events.BlenderCommand:InvokeServer("SpeedUpOrder")
end)

--================= FEED LOGIC =================--

local function feedAllBees(amount)
	if feeding then return end
	feeding = true
	task.spawn(function()
		local r,t = 1,1
		while feeding do
			ReplicatedStorage.Events.ConstructHiveCellFromEgg
				:InvokeServer(r,t,"Treat",amount,false)
			if r == 5 and t == 10 then break end
			r += 1
			if r > 5 then r = 1 t += 1 end
			task.wait(0.1)
		end
		feeding = false
	end)
end

fixedBtn("Feed All Bees",290,Color3.fromRGB(255,170,0),function()
	local a = tonumber(feedAmountBox.Text)
	if a and a > 0 then feedAllBees(a) end
end)

fixedBtn("Stop Feed",330,Color3.fromRGB(150,60,60),function()
	feeding = false
end)

--================= RIGHT PANEL =================--

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0,280,1,-20)
scrollFrame.Position = UDim2.new(1,-290,0,10)
scrollFrame.ScrollBarThickness = 8
scrollFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
scrollFrame.Parent = mainFrame

local uiLayout = Instance.new("UIListLayout", scrollFrame)
uiLayout.Padding = UDim.new(0,5)

local craftItems = {
	"BlueExtract","RedExtract","Oil","Enzymes","Gumdrops","Glue",
	"Glitter","StarJelly","TropicalDrink","PurplePotion","SuperSmoothie"
}

for _,recipe in ipairs(craftItems) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-10,0,34)
	b.Text = "Craft "..recipe
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.SourceSansBold
	b.TextSize = 18
	b.BackgroundColor3 = Color3.fromRGB(60,60,60)
	b.Parent = scrollFrame
	b.MouseButton1Click:Connect(function()
		ReplicatedStorage.Events.BlenderCommand:InvokeServer("PlaceOrder",{
			Recipe = recipe,
			Count = tonumber(countBox.Text) or 1
		})
	end)
end

scrollFrame.CanvasSize = UDim2.new(0,0,0,uiLayout.AbsoluteContentSize.Y)
--================= FLOAT PAD (AUTO DURING TWEEN) =================--

local float = false

local floatpad = Instance.new("Part")
floatpad.Name = "FloatPad"
floatpad.Size = Vector3.new(6, 1, 6)
floatpad.Anchored = true
floatpad.CanCollide = false
floatpad.Transparency = 1
floatpad.Parent = workspace

RunService.Heartbeat:Connect(function()
	if not float then
		floatpad.CanCollide = false
		return
	end

	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		local hrp = char.HumanoidRootPart
		floatpad.CanCollide = true
		floatpad.CFrame = hrp.CFrame * CFrame.new(0, -3.75, 0)
	end
end)

--================= TWEEN LOGIC =================--

local function tweenTo(cf)
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")

	local distance = (hrp.Position - cf.Position).Magnitude
	local time = distance / 100

	-- bật float
	float = true
	floatpad.CanCollide = true

	hrp.Anchored = true

	local tw = TweenService:Create(
		hrp,
		TweenInfo.new(time, Enum.EasingStyle.Linear),
		{CFrame = cf}
	)

	tw:Play()

	-- ⏱️ TẮT FLOAT PAD TRƯỚC KHI TWEEN KẾT THÚC
	task.delay(math.max(time - 0.05, 0), function()
		float = false
		floatpad.CanCollide = false
	end)

	tw.Completed:Wait()

	-- unanchor sau khi float đã tắt
	hrp.Anchored = false
end


tweenBtn("Blender",Color3.fromRGB(70,130,180),function()
	tweenTo(CFrame.new(-424,69,37))
end)

tweenBtn("Diamond Mask",Color3.fromRGB(0,180,180),function()
	tweenTo(CFrame.new(-334,132,-392))
end)

tweenBtn("Royal Jelly Shop",Color3.fromRGB(180,120,0),function()
	tweenTo(CFrame.new(-293.1046,52.2116,68.242))
end)

tweenBtn("Petal Shop",Color3.fromRGB(255,120,200),function()
	tweenTo(CFrame.new(-500.5889,51.5681,466.1004))
end)

tweenBtn("Nectar Conserver",Color3.fromRGB(120,255,120),function()
	tweenTo(CFrame.new(-415.5715,101.0204,343.2695))
end)
tweenBtn("Dapper Shop",Color3.fromRGB(15, 97, 0),function()
	tweenTo(CFrame.new(535.4567260742188, 137.8612823486328, -319.6371765136719))
end)
tweenBtn("Star Amulet",Color3.fromRGB(0, 245, 16),function()
	tweenTo(CFrame.new(169.3165283203125, 72.26011657714844, 358.0343933105469))
end)
tweenBtn("Sticker Printer",Color3.fromRGB(166, 0, 255),function()
	tweenTo(CFrame.new(205.68353271484375, 161.73097229003906, -194.668212890625))
end)
tweenBtn("Gifted Bucko Bee",Color3.fromRGB(64, 0, 255),function()
	tweenTo(CFrame.new(298.5751037597656, 61.452880859375, 107.14179229736328))
end)

--================= TOGGLE =================--

toggle.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
	toggle.Text = mainFrame.Visible and "Close" or "Open"
end)
--================= FORCE BUNGEE FONT (FIX) =================--

local BUNGEE_FONT = Font.new(
	"rbxassetid://12187365364",
	Enum.FontWeight.Bold,
	Enum.FontStyle.Normal
)

local function apply(ui)
	if ui:IsA("TextLabel") or ui:IsA("TextButton") or ui:IsA("TextBox") then
		ui.TextScaled = false -- ⚠️ BẮT BUỘC
		ui.FontFace = BUNGEE_FONT
		ui.TextSize = math.max(ui.TextSize, 18)
	end
end

-- áp dụng cho toàn bộ UI hiện có
for _,ui in ipairs(gui:GetDescendants()) do
	apply(ui)
end

-- áp dụng cho UI sinh ra sau này
gui.DescendantAdded:Connect(function(ui)
	task.wait()
	apply(ui)
end)
