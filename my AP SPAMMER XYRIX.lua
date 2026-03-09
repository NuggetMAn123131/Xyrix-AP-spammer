-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- MESSAGES
local messages = {
	";rocket ",
	";ragdoll ",
	";balloon ",
	";inverse ",
	";jail ",
	";tiny ",
	";jumpscare ",
	";morph "
}
local index = 1
local spamCooldown = false
local cooldownTime = 0.1

-- SEND CHAT FUNCTION
local function sendChatMessage(msg)
	local chatEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
	if chatEvent then
		chatEvent:WaitForChild("SayMessageRequest"):FireServer(msg,"All")
	end
	local textChat = game:GetService("TextChatService")
	if textChat then
		local channels = textChat:FindFirstChild("TextChannels")
		if channels and channels:FindFirstChild("RBXGeneral") then
			channels.RBXGeneral:SendAsync(msg)
		end
	end
end

-- DRAGGING VARIABLES
local dragging, dragInput, dragStart, startPos = false

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "RedSlikGUI"
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,400,0,250)
mainFrame.Position = UDim2.new(0.5,-200,0.5,-125)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,0,0)
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5,0.5)
mainFrame.Parent = gui

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0,16)
uicorner.Parent = mainFrame

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-20,0,40)
title.Position = UDim2.new(0,10,0,10)
title.BackgroundTransparency = 1
title.Text = "Xyrix Spammer"
title.TextColor3 = Color3.fromRGB(255,0,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

-- DRAGGING
local function update(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

mainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- PLAYER LIST
local playerListFrame = Instance.new("ScrollingFrame")
playerListFrame.Size = UDim2.new(1,-20,1,-80)
playerListFrame.Position = UDim2.new(0,10,0,50)
playerListFrame.BackgroundTransparency = 1
playerListFrame.BorderSizePixel = 0
playerListFrame.CanvasSize = UDim2.new(0,0,0,0)
playerListFrame.ScrollBarThickness = 6
playerListFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0,5)
listLayout.Parent = playerListFrame

local selectedPlayerName = nil

local function createPlayerButton(plr)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1,-10,0,30)
	button.BackgroundColor3 = Color3.fromRGB(50,0,0)
	button.TextColor3 = Color3.fromRGB(255,0,0)
	button.Text = plr.Name
	button.Font = Enum.Font.GothamBold
	button.TextSize = 18
	button.Parent = playerListFrame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0,6)
	corner.Parent = button

	button.MouseEnter:Connect(function()
		if selectedPlayerName ~= plr.Name then
			button.BackgroundColor3 = Color3.fromRGB(80,0,0)
		end
	end)
	button.MouseLeave:Connect(function()
		if selectedPlayerName ~= plr.Name then
			button.BackgroundColor3 = Color3.fromRGB(50,0,0)
		end
	end)

	button.MouseButton1Click:Connect(function()
		selectedPlayerName = plr.Name
		for _,btn in pairs(playerListFrame:GetChildren()) do
			if btn:IsA("TextButton") then
				if btn.Text == plr.Name then
					btn.BackgroundColor3 = Color3.fromRGB(255,100,100)
				else
					btn.BackgroundColor3 = Color3.fromRGB(50,0,0)
				end
			end
		end
	end)
end

for _,plr in pairs(Players:GetPlayers()) do
	createPlayerButton(plr)
end

Players.PlayerAdded:Connect(function(plr)
	createPlayerButton(plr)
end)

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	playerListFrame.CanvasSize = UDim2.new(0,0,0,listLayout.AbsoluteContentSize.Y)
end)

-- SPAM BUTTON
local spamButton = Instance.new("TextButton")
spamButton.Size = UDim2.new(0,80,0,30)
spamButton.Position = UDim2.new(1,-90,0,10)
spamButton.BackgroundColor3 = Color3.fromRGB(50,0,0)
spamButton.TextColor3 = Color3.fromRGB(255,0,0)
spamButton.Text = "Spam"
spamButton.Font = Enum.Font.GothamBold
spamButton.TextSize = 18
spamButton.Parent = mainFrame

local spamCorner = Instance.new("UICorner")
spamCorner.CornerRadius = UDim.new(0,6)
spamCorner.Parent = spamButton

spamButton.MouseEnter:Connect(function()
	spamButton.BackgroundColor3 = Color3.fromRGB(80,0,0)
	spamButton.TextColor3 = Color3.fromRGB(255,100,100)
end)
spamButton.MouseLeave:Connect(function()
	spamButton.BackgroundColor3 = Color3.fromRGB(50,0,0)
	spamButton.TextColor3 = Color3.fromRGB(255,0,0)
end)

-- DO SPAM
local function doSpam()
	if spamCooldown then return end
	spamCooldown = true

	local msg
	if selectedPlayerName then
		msg = messages[index].." "..selectedPlayerName
	else
		msg = messages[index]
	end
	sendChatMessage(msg)

	index = index + 1
	if index > #messages then
		index = 1
	end

	task.wait(cooldownTime)
	spamCooldown = false
end

spamButton.MouseButton1Click:Connect(doSpam)

-- CTRL TO OPEN/CLOSE
local isMinimized = false
UIS.InputBegan:Connect(function(input, typing)
	if typing then return end
	if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
		if isMinimized then
			mainFrame.Size = UDim2.new(0,400,0,250)
			playerListFrame.Visible = true
			spamButton.Visible = true
			isMinimized = false
		else
			mainFrame.Size = UDim2.new(0,400,0,40) -- tiny bar
			playerListFrame.Visible = false
			spamButton.Visible = false
			isMinimized = true
		end
	end
end)