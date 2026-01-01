settings().Rendering.QualityLevel = "Level01"
UserSettings().GameSettings.MasterVolume = 0

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--================= FONT (GIỐNG UI TRÊN) =================--

local BUNGEE_FONT = Font.new(
	"rbxassetid://12187365364",
	Enum.FontWeight.Bold,
	Enum.FontStyle.Normal
)

--================= GUI =================--

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "OnlineIndexUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

--================= LABEL FRAME (STYLE FPS) =================--

local labelFrame = Instance.new("Frame")
labelFrame.Size = UDim2.new(0,200,0,26)
labelFrame.Position = UDim2.new(1,-210,0,85) -- dưới FPS
labelFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
labelFrame.BorderSizePixel = 0
labelFrame.Parent = screenGui
Instance.new("UICorner", labelFrame)

--================= LABEL =================--

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1,0,1,0)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(0,255,120)
label.FontFace = BUNGEE_FONT
label.TextSize = 16
label.TextScaled = false
label.Text = "Online: 0"
label.Parent = labelFrame

-- Đường dẫn file usernames.txt
local filePath = "usernames.txt" -- hoặc Delta/workspace/usernames.txt

-- Tìm fileIndex theo username
local fileIndex = nil
if isfile(filePath) then
    local content = readfile(filePath)
    local lines = string.split(content, "\n")
    for i, line in ipairs(lines) do
        if line == player.Name then
            fileIndex = i
            break
        end
    end
end

if fileIndex ~= nil then
    -- Cập nhật label Online: X
    label.Text = player.Name .. ": " .. fileIndex

    -- Vòng autorejoin
    local update = true
    game:GetService("GuiService").ErrorMessageChanged:Connect(function()
        update = false
    end)
    while update do
        writefile("autorejoin" .. fileIndex .. ".txt", tostring(os.time()))
        task.wait(1)
    end
else
    label.Text = "Online: 0"
end
