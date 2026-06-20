local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--------------------------------------------------
-- SETTINGS
--------------------------------------------------
local AutoBalloonReset = false
local ResetKey = Enum.KeyCode.R
local WaitingForKey = false

--------------------------------------------------
-- GUI
--------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OceanHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 300, 0, 150)
Main.Position = UDim2.new(1, -320, 0, 20)
Main.BackgroundColor3 = Color3.fromRGB(25, 100, 255)
Main.BackgroundTransparency = 0.6
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = Main

--------------------------------------------------
-- SMOOTH BLUE ↔ BLACK OUTLINE
--------------------------------------------------
local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 3
Stroke.Parent = Main

RunService.RenderStepped:Connect(function()
	local t = (math.sin(os.clock() * 2) + 1) / 2
	local blue = Color3.fromRGB(0, 140, 255)
	local black = Color3.fromRGB(0, 0, 0)
	Stroke.Color = black:Lerp(blue, t)
end)

--------------------------------------------------
-- DRAGGING
--------------------------------------------------
local dragging = false
local dragStart
local startPos

Main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart

		Main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

--------------------------------------------------
-- TITLE
--------------------------------------------------
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "🎈Ocean Hub Auto Balloon Reset"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.Parent = Main

--------------------------------------------------
-- LABEL
--------------------------------------------------
local ResetLabel = Instance.new("TextLabel")
ResetLabel.Size = UDim2.new(0, 180, 0, 30)
ResetLabel.Position = UDim2.new(0, 10, 0, 50)
ResetLabel.BackgroundTransparency = 1
ResetLabel.Text = "Auto Balloon Reset"
ResetLabel.TextColor3 = Color3.new(1,1,1)
ResetLabel.Font = Enum.Font.Gotham
ResetLabel.TextScaled = true
ResetLabel.TextXAlignment = Enum.TextXAlignment.Left
ResetLabel.Parent = Main

--------------------------------------------------
-- DARK BLUE TOGGLE SWITCH
--------------------------------------------------
local ToggleBack = Instance.new("Frame")
ToggleBack.Size = UDim2.new(0, 60, 0, 28)
ToggleBack.Position = UDim2.new(1, -80, 0, 55)
ToggleBack.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ToggleBack.Parent = Main

local ToggleBackCorner = Instance.new("UICorner")
ToggleBackCorner.CornerRadius = UDim.new(1, 0)
ToggleBackCorner.Parent = ToggleBack

local ToggleKnob = Instance.new("Frame")
ToggleKnob.Size = UDim2.new(0, 24, 0, 24)
ToggleKnob.Position = UDim2.new(0, 2, 0.5, -12)
ToggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleKnob.Parent = ToggleBack

local KnobCorner = Instance.new("UICorner")
KnobCorner.CornerRadius = UDim.new(1, 0)
KnobCorner.Parent = ToggleKnob

--------------------------------------------------
-- TOGGLE FUNCTION (DARK BLUE STYLE)
--------------------------------------------------
local function SetAutoBalloon(state)
	AutoBalloonReset = state

	if AutoBalloonReset then
		-- ON = dark blue glow
		ToggleBack.BackgroundColor3 = Color3.fromRGB(0, 70, 140)
		ToggleKnob:TweenPosition(
			UDim2.new(1, -26, 0.5, -12),
			"Out",
			"Quad",
			0.18,
			true
		)
	else
		-- OFF = dark gray
		ToggleBack.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		ToggleKnob:TweenPosition(
			UDim2.new(0, 2, 0.5, -12),
			"Out",
			"Quad",
			0.18,
			true
		)
	end
end

SetAutoBalloon(false)

ToggleBack.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		SetAutoBalloon(not AutoBalloonReset)
	end
end)

--------------------------------------------------
-- KEYBIND UI
--------------------------------------------------
local KeybindLabel = Instance.new("TextLabel")
KeybindLabel.Size = UDim2.new(0, 180, 0, 30)
KeybindLabel.Position = UDim2.new(0, 10, 0, 95)
KeybindLabel.BackgroundTransparency = 1
KeybindLabel.Text = "Reset Keybind"
KeybindLabel.TextColor3 = Color3.new(1,1,1)
KeybindLabel.Font = Enum.Font.Gotham
KeybindLabel.TextScaled = true
KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
KeybindLabel.Parent = Main

local KeybindBox = Instance.new("TextButton")
KeybindBox.Size = UDim2.new(0, 70, 0, 30)
KeybindBox.Position = UDim2.new(1, -80, 0, 95)
KeybindBox.Text = ResetKey.Name
KeybindBox.TextColor3 = Color3.new(1,1,1)
KeybindBox.Font = Enum.Font.GothamBold
KeybindBox.TextScaled = true
KeybindBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
KeybindBox.Parent = Main

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0,8)
BoxCorner.Parent = KeybindBox

KeybindBox.MouseButton2Click:Connect(function()
	WaitingForKey = true
	KeybindBox.Text = "..."
end)

--------------------------------------------------
-- FUNCTIONS
--------------------------------------------------
local function ResetCharacter()
	local character = Player.Character
	if character and character:FindFirstChild("Humanoid") then
		character.Humanoid.Health = 0
	end
end

local function CheckText(text)
	if not AutoBalloonReset then return end
	if type(text) ~= "string" then return end

	text = string.lower(text)

	if text:find("balloon") and text:find("on you") then
		print("Balloon detected! Resetting...")
		ResetCharacter()
	end
end

local function WatchObject(obj)
	if obj:IsA("TextLabel") or obj:IsA("TextButton") then
		CheckText(obj.Text)

		obj:GetPropertyChangedSignal("Text"):Connect(function()
			CheckText(obj.Text)
		end)
	end
end

local function WatchGui(gui)
	for _, obj in ipairs(gui:GetDescendants()) do
		WatchObject(obj)
	end

	gui.DescendantAdded:Connect(function(obj)
		WatchObject(obj)
	end)
end

for _, gui in ipairs(PlayerGui:GetChildren()) do
	WatchGui(gui)
end

PlayerGui.ChildAdded:Connect(function(gui)
	task.wait(0.1)
	WatchGui(gui)
end)

--------------------------------------------------
-- INPUT HANDLER
--------------------------------------------------
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end

	if WaitingForKey and input.KeyCode ~= Enum.KeyCode.Unknown then
		ResetKey = input.KeyCode
		KeybindBox.Text = ResetKey.Name
		WaitingForKey = false
		return
	end

	if input.KeyCode == ResetKey then
		print("RESET KEY PRESSED")
		ResetCharacter()
	end
end)