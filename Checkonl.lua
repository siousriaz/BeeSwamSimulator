local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Tạo label hiển thị fileIndex (Online: X)
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = PlayerGui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 120, 0, 30)
label.Position = UDim2.new(1, -210, 0, 85) -- nằm dưới FPS (55 + 30)
label.BackgroundTransparency = 0.5
label.BackgroundColor3 = Color3.fromRGB(0,0,0)
label.TextColor3 = Color3.fromRGB(0,255,0)
label.TextScaled = true
label.Font = Enum.Font.SourceSansBold
label.Text = "Online: 0"
label.Parent = screenGui

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
    label.Text = "Online: " .. fileIndex

    -- Vòng autorejoin
    local update = true
    game:GetService("GuiService").ErrorMessageChanged:Connect(function()
        update = false
    end)

    repeat task.wait()
    until game:IsLoaded()
        and PlayerGui:FindFirstChild("ScreenGui")
        and PlayerGui.ScreenGui.LoadingMessage.Visible == false

    while update do
        writefile("autorejoin" .. fileIndex .. ".txt", tostring(os.time()))
        task.wait(1)
    end
else
    label.Text = "Online: 0"
end
