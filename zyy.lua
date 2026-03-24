-- [[ PHANTOM ULTIMATE V8 - SEAMLESS EDITION ]] --
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local AuraRemote = ReplicatedStorage:WaitForChild("AuraEvent")

-- // CONFIGURATION // --
local UI_TITLE = "PHANTOM ULTIMATE V8"
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
ScreenGui.Name = "PhantomUltimateGui"
ScreenGui.ResetOnSpawn = false

-- Floating Button (Open/Close)
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0, 10, 0.4, 0)
ToggleBtn.BackgroundColor3 = BG_COLOR
ToggleBtn.Text = "P"
ToggleBtn.TextColor3 = ACCENT_COLOR
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 18
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
local BTNStroke = Instance.new("UIStroke", ToggleBtn)
BTNStroke.Color = ACCENT_COLOR
BTNStroke.Thickness = 1.5

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 380, 0, 320)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -160)
MainFrame.BackgroundColor3 = BG_COLOR
MainFrame.BackgroundTransparency = 0.1
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 4)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = ACCENT_COLOR
MainStroke.Transparency = 0.5

-- Header
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = UI_TITLE
Title.TextColor3 = Color3.white
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
makeDraggable(MainFrame, Header)

-- Tabs Sidebar
local TabSide = Instance.new("Frame", MainFrame)
TabSide.Size = UDim2.new(0, 100, 1, -35)
TabSide.Position = UDim2.new(0, 0, 0, 35)
TabSide.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1, -105, 1, -40)
Content.Position = UDim2.new(0, 105, 0, 40)
Content.BackgroundTransparency = 1

local ScrollFrame = Instance.new("ScrollingFrame", Content)
ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 2
local UIList = Instance.new("UIListLayout", ScrollFrame)
UIList.Padding = UDim.new(0, 5)

local AuraPage = Instance.new("Frame", Content)
AuraPage.Size = UDim2.new(1, 0, 1, 0)
AuraPage.BackgroundTransparency = 1
AuraPage.Visible = false

-- // SEAMLESS AURA LOGIC // --
local function triggerAura()
    if _G.AuraLoop then
        AuraRemote:FireServer("Preview", "Aura_sultanRobux")
    end
end

local AuraToggle = Instance.new("TextButton", AuraPage)
AuraToggle.Size = UDim2.new(1, -10, 0, 45)
AuraToggle.Position = UDim2.new(0, 5, 0, 10)
AuraToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AuraToggle.Text = "AUTO AURA: OFF"
AuraToggle.TextColor3 = Color3.fromRGB(255, 80, 80)
AuraToggle.Font = Enum.Font.GothamBold
Instance.new("UICorner", AuraToggle).CornerRadius = UDim.new(0, 4)

AuraToggle.MouseButton1Click:Connect(function()
    _G.AuraLoop = not _G.AuraLoop
    if _G.AuraLoop then
        AuraToggle.Text = "AUTO AURA: ACTIVE"
        AuraToggle.TextColor3 = Color3.fromRGB(80, 255, 80)
        
        task.spawn(function()
            while _G.AuraLoop do
                triggerAura()
                -- Jeda 10 detik agar animasi server tidak terputus (Seamless)
                task.wait(10) 
            end
        end)
    else
        AuraToggle.Text = "AUTO AURA: OFF"
        AuraToggle.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
end)

-- Auto Re-Aura saat mati/respawn
LocalPlayer.CharacterAdded:Connect(function()
    if _G.AuraLoop then
        task.wait(2) -- Tunggu karakter load sempurna
        triggerAura()
    end
end)

-- // DONASI SYSTEM // --
function refreshPlayerList()
    for _, v in pairs(ScrollFrame:GetChildren()) do if v:IsA("Frame") or v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local pBtn = Instance.new("TextButton", ScrollFrame)
            pBtn.Size = UDim2.new(1, -5, 0, 40)
            pBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            pBtn.Text = "  " .. p.DisplayName
            pBtn.TextColor3 = Color3.white
            pBtn.Font = Enum.Font.Gotham
            pBtn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 4)
            
            pBtn.MouseButton1Click:Connect(function()
                -- Logika Buy Gamepass (Contoh ID)
                MarketplaceService:PromptGamePassPurchase(LocalPlayer, 12345678) -- Ganti ID
            end)
        end
    end
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y)
end

-- // TAB NAVIGATION // --
local DonBtn = Instance.new("TextButton", TabSide)
DonBtn.Size = UDim2.new(1, 0, 0, 40)
DonBtn.Text = "DONASI"
DonBtn.TextColor3 = Color3.white
DonBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
DonBtn.Font = Enum.Font.GothamBold

local AurBtn = Instance.new("TextButton", TabSide)
AurBtn.Size = UDim2.new(1, 0, 0, 40)
AurBtn.Position = UDim2.new(0, 0, 0, 40)
AurBtn.Text = "AURA"
AurBtn.TextColor3 = Color3.white
AurBtn.BackgroundTransparency = 1
AurBtn.Font = Enum.Font.GothamBold

DonBtn.MouseButton1Click:Connect(function()
    ScrollFrame.Visible = true; AuraPage.Visible = false
    DonBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); DonBtn.BackgroundTransparency = 0
    AurBtn.BackgroundTransparency = 1
    refreshPlayerList()
end)

AurBtn.MouseButton1Click:Connect(function()
    ScrollFrame.Visible = false; AuraPage.Visible = true
    AurBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); AurBtn.BackgroundTransparency = 0
    DonBtn.BackgroundTransparency = 1
end)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

refreshPlayerList()
