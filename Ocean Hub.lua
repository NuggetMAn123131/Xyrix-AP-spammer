local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

---------------------------------------------------
-- FOV
---------------------------------------------------
Camera.FieldOfView = 120

---------------------------------------------------
-- GUI
---------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OceanHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,180,0,300)
Main.Position = UDim2.new(0.5,-90,0.5,-150)
Main.BackgroundColor3 = Color3.fromRGB(18,18,35)
Main.BackgroundTransparency = 0.25
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0,18)
MainCorner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0,170,255)
Stroke.Thickness = 2
Stroke.Transparency = 0.2
Stroke.Parent = Main

---------------------------------------------------
-- TITLE
---------------------------------------------------
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,35)
Title.BackgroundTransparency = 1
Title.Text = "🌊 OCEAN HUB"
Title.TextColor3 = Color3.fromRGB(0,200,255)
Title.Font = Enum.Font.GothamBlack
Title.TextScaled = true
Title.Parent = Main

---------------------------------------------------
-- STATUS
---------------------------------------------------
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1,0,0,18)
Status.Position = UDim2.new(0,0,0,32)
Status.BackgroundTransparency = 1
Status.Text = "● Status - OFF"
Status.TextColor3 = Color3.fromRGB(255,80,80)
Status.Font = Enum.Font.GothamBold
Status.TextScaled = true
Status.Parent = Main

---------------------------------------------------
-- SUBTITLE
---------------------------------------------------
local Sub = Instance.new("TextLabel")
Sub.Size = UDim2.new(1,0,0,20)
Sub.Position = UDim2.new(0,0,0,50)
Sub.BackgroundTransparency = 1
Sub.Text = "FLASH TP"
Sub.TextColor3 = Color3.fromRGB(255,255,255)
Sub.Font = Enum.Font.GothamBold
Sub.TextScaled = true
Sub.Parent = Main

---------------------------------------------------
-- FLASH TP SYSTEM
---------------------------------------------------
local FlashTPEnabled = false

local function EquipFlashTeleportAndClick()
	local Character = Player.Character
	if not Character then return end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	if not Humanoid then return end

	local Tool =
		Player.Backpack:FindFirstChild("Flash Teleport")
		or Character:FindFirstChild("Flash Teleport")

	if not Tool then return end

	if Tool.Parent ~= Character then
		Humanoid:EquipTool(Tool)
	end

	task.wait(0.05)

	pcall(function()
		Tool:Activate()
	end)
end

---------------------------------------------------
-- PROMPT HOOK (0.05s AFTER FINISH)
---------------------------------------------------
local function HookPrompt(Prompt)
	if not Prompt:IsA("ProximityPrompt") then
		return
	end

	Prompt.PromptButtonHoldEnded:Connect(function()
		if not FlashTPEnabled then
			return
		end

		task.delay(0.04, function()
			if FlashTPEnabled then
				EquipFlashTeleportAndClick()
			end
		end)
	end)
end

for _, Obj in ipairs(workspace:GetDescendants()) do
	HookPrompt(Obj)
end

workspace.DescendantAdded:Connect(HookPrompt)

---------------------------------------------------
-- TOGGLE UI
---------------------------------------------------
local ToggleFrame = Instance.new("Frame")
ToggleFrame.Size = UDim2.new(0.9,0,0,40)
ToggleFrame.Position = UDim2.new(0.05,0,0,80)
ToggleFrame.BackgroundColor3 = Color3.fromRGB(35,35,60)
ToggleFrame.BackgroundTransparency = 0.15
ToggleFrame.BorderSizePixel = 0
ToggleFrame.Parent = Main

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0,12)
ToggleCorner.Parent = ToggleFrame

local ToggleText = Instance.new("TextLabel")
ToggleText.Size = UDim2.new(0.6,0,1,0)
ToggleText.BackgroundTransparency = 1
ToggleText.Text = "FLASH TP"
ToggleText.TextColor3 = Color3.new(1,1,1)
ToggleText.Font = Enum.Font.GothamBold
ToggleText.TextScaled = true
ToggleText.Parent = ToggleFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0,50,0,24)
ToggleButton.Position = UDim2.new(1,-60,0.5,-12)
ToggleButton.Text = ""
ToggleButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
ToggleButton.Parent = ToggleFrame

local ToggleButtonCorner = Instance.new("UICorner")
ToggleButtonCorner.CornerRadius = UDim.new(1,0)
ToggleButtonCorner.Parent = ToggleButton

local Knob = Instance.new("Frame")
Knob.Size = UDim2.new(0,20,0,20)
Knob.Position = UDim2.new(0,2,0.5,-10)
Knob.BackgroundColor3 = Color3.new(1,1,1)
Knob.Parent = ToggleButton

local KnobCorner = Instance.new("UICorner")
KnobCorner.CornerRadius = UDim.new(1,0)
KnobCorner.Parent = Knob

ToggleButton.MouseButton1Click:Connect(function()
	FlashTPEnabled = not FlashTPEnabled

	if FlashTPEnabled then
		TweenService:Create(Knob, TweenInfo.new(0.25), {
			Position = UDim2.new(1,-22,0.5,-10)
		}):Play()

		TweenService:Create(ToggleButton, TweenInfo.new(0.25), {
			BackgroundColor3 = Color3.fromRGB(0,170,255)
		}):Play()

		Status.Text = "● Status - ON"
		Status.TextColor3 = Color3.fromRGB(0,255,0)
	else
		TweenService:Create(Knob, TweenInfo.new(0.25), {
			Position = UDim2.new(0,2,0.5,-10)
		}):Play()

		TweenService:Create(ToggleButton, TweenInfo.new(0.25), {
			BackgroundColor3 = Color3.fromRGB(70,70,70)
		}):Play()

		Status.Text = "● Status - OFF"
		Status.TextColor3 = Color3.fromRGB(255,80,80)
	end
end)




---------------------------------------------------
-- DRAGGING
---------------------------------------------------
local Dragging = false
local DragStart
local StartPos

Title.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 then
		Dragging = true
		DragStart = Input.Position
		StartPos = Main.Position
	end
end)

UserInputService.InputChanged:Connect(function(Input)
	if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
		local Delta = Input.Position - DragStart

		Main.Position = UDim2.new(
			StartPos.X.Scale,
			StartPos.X.Offset + Delta.X,
			StartPos.Y.Scale,
			StartPos.Y.Offset + Delta.Y
		)
	end
end)

UserInputService.InputEnded:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 then
		Dragging = false
	end
end)