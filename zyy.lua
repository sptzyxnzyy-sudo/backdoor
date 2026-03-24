-- [[ PHANTOM ULTIMATE V8 - AURA ONLY EDITION ]] --
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local AuraRemote = ReplicatedStorage:WaitForChild("AuraEvent")

-- // CONFIGURATION // --
local UI_TITLE = "PHANTOM AURA SULTAN"
local ACCENT_COLOR = Color3.fromRGB(0, 255, 255) 
local BG_COLOR = Color3.fromRGB(15, 15, 15)
_G.AuraLoop = false 

-- // DRAG SYSTEM // --
local function makeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- // UI SETUP // --
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "PhantomAuraGui"
ScreenGui.ResetOnSpawn = false

-- Floating Toggle Button
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0.5, 0)
ToggleBtn.BackgroundColor3 = BG_COLOR
ToggleBtn.Text = "AURA"
ToggleBtn.TextColor3 = ACCENT_COLOR
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 12
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", ToggleBtn).Color = ACCENT_COLOR

-- Main Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 120)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -60)
MainFrame.BackgroundColor3 = BG_COLOR
MainFrame.BackgroundTransparency = 0.1
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 2
MainStroke.Color = ACCENT_COLOR

-- Header
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = UI_TITLE
Title.TextColor3 = Color3.white
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
makeDraggable(MainFrame, Header)

-- Aura Toggle Button
local AuraToggle = Instance.new("TextButton", MainFrame)
AuraToggle.Size = UDim2.new(0, 220, 0, 45)
AuraToggle.Position = UDim2.new(0.5, -110, 0, 55)
AuraToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AuraToggle.Text = "STATUS: OFF"
AuraToggle.TextColor3 = Color3.fromRGB(255, 80, 80)
AuraToggle.Font = Enum.Font.GothamBold
Instance.new("UICorner", AuraToggle).CornerRadius = UDim.new(0, 4)

-- // LOGIKA AURA // --
local function fireAura()
    if _G.AuraLoop and AuraRemote then
        AuraRemote:FireServer("Preview", "Aura_sultanRobux")
    end
end

AuraToggle.MouseButton1Click:Connect(function()
    _G.AuraLoop = not _G.AuraLoop
    if _G.AuraLoop then
        AuraToggle.Text = "STATUS: ACTIVE"
        AuraToggle.TextColor3 = Color3.fromRGB(80, 255, 80)
        task.spawn(function()
            while _G.AuraLoop do
                fireAura()
                task.wait(10) -- Seamless interval
            end
        end)
    else
        AuraToggle.Text = "STATUS: OFF"
        AuraToggle.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
end)

-- Auto Re-Aura on Respawn
LocalPlayer.CharacterAdded:Connect(function()
    if _G.AuraLoop then
        task.wait(3)
        fireAura()
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

print("Phantom Aura Sultan Loaded!")
