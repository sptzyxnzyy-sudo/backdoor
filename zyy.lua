local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- // CONFIGURATION // --
local UI_TITLE = "PHANTOM ULTIMATE V8"
local ACCENT_COLOR = Color3.fromRGB(0, 255, 255) -- Cyan Neon
local BG_COLOR = Color3.fromRGB(15, 15, 15)
_G.AuraLoop = false -- Default mati

-- // UTILS: DRAG SYSTEM // --
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

-- // MAIN UI CREATION // --
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "PhantomUltimateGui"
ScreenGui.ResetOnSpawn = false

-- Tombol Open/Close (Floating Button)
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0.5, 0)
ToggleBtn.BackgroundColor3 = BG_COLOR
ToggleBtn.Text = "P"
ToggleBtn.TextColor3 = ACCENT_COLOR
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 20
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", ToggleBtn).Color = ACCENT_COLOR

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 380, 0, 320)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -160)
MainFrame.BackgroundColor3 = BG_COLOR
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 4)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 2
UIStroke.Color = ACCENT_COLOR

-- Header
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Header.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = UI_TITLE
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

makeDraggable(MainFrame, Header)

-- Tab Buttons
local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(0, 100, 1, -40)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TabContainer.BorderSizePixel = 0

local function createTabBtn(name, pos)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, pos)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    return btn
end

local DonateTabBtn = createTabBtn("DONASI", 0)
local AuraTabBtn = createTabBtn("AURA", 40)

-- Content Area
local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1, -110, 1, -50)
Content.Position = UDim2.new(0, 105, 0, 45)
Content.BackgroundTransparency = 1

-- Scrolling Frame for Players
local ScrollFrame = Instance.new("ScrollingFrame", Content)
ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 2
ScrollFrame.Visible = true

local UIList = Instance.new("UIListLayout", ScrollFrame)
UIList.Padding = UDim.new(0, 5)

-- Aura Page
local AuraPage = Instance.new("Frame", Content)
AuraPage.Size = UDim2.new(1, 0, 1, 0)
AuraPage.BackgroundTransparency = 1
AuraPage.Visible = false

local AuraToggle = Instance.new("TextButton", AuraPage)
AuraToggle.Size = UDim2.new(1, -10, 0, 50)
AuraToggle.Position = UDim2.new(0, 5, 0, 10)
AuraToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AuraToggle.Text = "AUTO AURA SULTAN: OFF"
AuraToggle.TextColor3 = Color3.fromRGB(255, 80, 80)
AuraToggle.Font = Enum.Font.GothamBold
Instance.new("UICorner", AuraToggle).CornerRadius = UDim.new(0, 4)

-- // LOGIKA: AURA LOOP // --
AuraToggle.MouseButton1Click:Connect(function()
    _G.AuraLoop = not _G.AuraLoop
    if _G.AuraLoop then
        AuraToggle.Text = "AUTO AURA SULTAN: ON"
        AuraToggle.TextColor3 = Color3.fromRGB(80, 255, 80)
        task.spawn(function()
            while _G.AuraLoop do
                local remote = ReplicatedStorage:FindFirstChild("AuraEvent")
                if remote then
                    remote:FireServer("Preview", "Aura_sultanRobux")
                end
                task.wait(0.5)
            end
        end)
    else
        AuraToggle.Text = "AUTO AURA SULTAN: OFF"
        AuraToggle.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
end)

-- // LOGIKA: LIST PLAYER & DONASI // --
local function showGamepasses(p)
    for _, v in pairs(ScrollFrame:GetChildren()) do if v:IsA("Frame") or v:IsA("TextButton") then v:Destroy() end end
    
    local txt = Instance.new("TextLabel", ScrollFrame)
    txt.Size = UDim2.new(1, 0, 0, 30)
    txt.Text = "Pilih Gamepass: " .. p.DisplayName
    txt.TextColor3 = Color3.white
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.GothamBold

    -- List Gamepass (Contoh ID)
    local passes = { {n="Small Tip (10)", id=123}, {n="Mega Donasi (500)", id=456} }
    for _, gp in pairs(passes) do
        local b = Instance.new("TextButton", ScrollFrame)
        b.Size = UDim2.new(1, 0, 0, 35)
        b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        b.Text = gp.n
        b.TextColor3 = ACCENT_COLOR
        b.Font = Enum.Font.Gotham
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
        b.MouseButton1Click:Connect(function() MarketplaceService:PromptGamePassPurchase(LocalPlayer, gp.id) end)
    end

    local back = Instance.new("TextButton", ScrollFrame)
    back.Size = UDim2.new(1, 0, 0, 30)
    back.Text = "< Kembali"
    back.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    back.TextColor3 = Color3.white
    back.MouseButton1Click:Connect(refreshList)
end

function refreshList()
    for _, v in pairs(ScrollFrame:GetChildren()) do if v:IsA("Frame") or v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local f = Instance.new("TextButton", ScrollFrame)
            f.Size = UDim2.new(1, 0, 0, 45)
            f.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            f.Text = "   " .. p.DisplayName
            f.TextColor3 = Color3.white
            f.Font = Enum.Font.Gotham
            f.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)
            f.MouseButton1Click:Connect(function() showGamepasses(p) end)
        end
    end
    ScrollFrame.CanvasSize = UDim2.new(0,0,0, UIList.AbsoluteContentSize.Y)
end

-- // TAB NAVIGATION // --
DonateTabBtn.MouseButton1Click:Connect(function()
    ScrollFrame.Visible = true
    AuraPage.Visible = false
    refreshList()
end)

AuraTabBtn.MouseButton1Click:Connect(function()
    ScrollFrame.Visible = false
    AuraPage.Visible = true
end)

-- Toggle UI
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

refreshList()
