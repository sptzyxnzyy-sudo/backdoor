local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- // CONFIGURATION // --
local UI_TITLE = "PHANTOM ULTIMATE - DONATION"
local ACCENT_COLOR = Color3.fromRGB(0, 255, 255) -- Cyan
local BG_COLOR = Color3.fromRGB(15, 15, 15)

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
ScreenGui.Name = "PhantomDonationGui"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
MainFrame.BackgroundColor3 = BG_COLOR
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 6)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 2
UIStroke.Color = ACCENT_COLOR
UIStroke.Transparency = 0.5

-- Header
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Header.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = UI_TITLE
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18

makeDraggable(MainFrame, Header)

-- Container (Scrolling List)
local ScrollFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollFrame.Size = UDim2.new(1, -20, 1, -55)
ScrollFrame.Position = UDim2.new(0, 10, 0, 45)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 2
ScrollFrame.ScrollBarImageColor3 = ACCENT_COLOR

local UIList = Instance.new("UIListLayout", ScrollFrame)
UIList.Padding = UDim.new(0, 5)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

-- // LOGIKA: TAMPILKAN GAMEPASS // --
local function showGamepasses(targetPlayer)
    -- Clear current list
    for _, child in pairs(ScrollFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") then child:Destroy() end
    end
    
    Title.Text = "Donate to: " .. targetPlayer.DisplayName
    
    -- Simulasi fetch gamepass (Ganti dengan logika API Anda)
    -- Catatan: Secara teknis di client-side kita hanya bisa melakukan prompt purchase.
    -- Di sini kita buat tombol beli sederhana untuk testing.
    local examplePasses = {
        {Name = "Small Tip", Price = 10, ID = 123456},
        {Name = "Big Support", Price = 100, ID = 654321},
    }
    
    for _, gp in pairs(examplePasses) do
        local btn = Instance.new("TextButton", ScrollFrame)
        btn.Size = UDim2.new(1, -5, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.Text = "  " .. gp.Name .. " - " .. gp.Price .. " Robux"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
        
        btn.MouseButton1Click:Connect(function()
            MarketplaceService:PromptGamePassPurchase(LocalPlayer, gp.ID)
        end)
    end
    
    local BackBtn = Instance.new("TextButton", ScrollFrame)
    BackBtn.Size = UDim2.new(1, -5, 0, 30)
    BackBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    BackBtn.Text = "Back to Player List"
    BackBtn.TextColor3 = Color3.white
    BackBtn.Font = Enum.Font.GothamBold
    BackBtn.LayoutOrder = 999
    
    BackBtn.MouseButton1Click:Connect(function()
        refreshPlayerList()
    end)
end

-- // LOGIKA: REFRESH PLAYER LIST // --
function refreshPlayerList()
    for _, child in pairs(ScrollFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") then child:Destroy() end
    end
    Title.Text = UI_TITLE
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local pFrame = Instance.new("Frame", ScrollFrame)
            pFrame.Size = UDim2.new(1, -5, 0, 50)
            pFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            
            local UICorner_P = Instance.new("UICorner", pFrame)
            UICorner_P.CornerRadius = UDim.new(0, 4)
            
            local AvatarImg = Instance.new("ImageLabel", pFrame)
            AvatarImg.Size = UDim2.new(0, 40, 0, 40)
            AvatarImg.Position = UDim2.new(0, 5, 0.5, -20)
            AvatarImg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            AvatarImg.Image = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
            Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)
            
            local NameLabel = Instance.new("TextLabel", pFrame)
            NameLabel.Size = UDim2.new(1, -100, 1, 0)
            NameLabel.Position = UDim2.new(0, 55, 0, 0)
            NameLabel.BackgroundTransparency = 1
            NameLabel.Text = p.DisplayName .. "\n(@" .. p.Name .. ")"
            NameLabel.TextColor3 = Color3.white
            NameLabel.Font = Enum.Font.Gotham
            NameLabel.TextSize = 12
            NameLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local SelectBtn = Instance.new("TextButton", pFrame)
            SelectBtn.Size = UDim2.new(0, 70, 0, 30)
            SelectBtn.Position = UDim2.new(1, -75, 0.5, -15)
            SelectBtn.BackgroundColor3 = ACCENT_COLOR
            SelectBtn.Text = "Select"
            SelectBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            SelectBtn.Font = Enum.Font.GothamBold
            SelectBtn.TextSize = 12
            Instance.new("UICorner", SelectBtn).CornerRadius = UDim.new(0, 4)
            
            SelectBtn.MouseButton1Click:Connect(function()
                showGamepasses(p)
            end)
        end
    end
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 10)
end

-- // TOGGLE UI // --
local isOpen = true
CloseBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    MainFrame.Visible = isOpen
end)

-- Initial Load
refreshPlayerList()

-- Update list jika player masuk/keluar
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)
