-- [[ AR2: DUAL SLIDER EDITION - AIMBOT & ESP ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- 1. GLOBAL SETTINGS
_G.Aimbot = false
_G.ESP = false
_G.ShowName = false
_G.ShowBox = false
_G.ShowHealth = false
_G.MaxDistESP = 1500 -- Default ESP Distance
_G.MaxDistAim = 400   -- Default Aimbot Distance

local AimPart = "Head"
local Sensitivity = 0.80 

-- 2. UI MENU
local ScreenGui = LP.PlayerGui:FindFirstChild("AR2_MouseUI")
if ScreenGui then ScreenGui:Destroy() end

ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
ScreenGui.Name = "AR2_MouseUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 240, 0, 420) 
MainFrame.Position = UDim2.new(0.02, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 16, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "     AR2 SETTINGS"
Title.TextColor3 = Color3.fromRGB(180, 180, 180)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left

-- TOGGLE CREATOR
local function createToggle(text, pos, varName)
    local frame = Instance.new("Frame", MainFrame)
    frame.Size = UDim2.new(0.9, 0, 0, 35)
    frame.Position = UDim2.new(0.05, 0, 0, pos)
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left

    local switchBg = Instance.new("TextButton", frame)
    switchBg.Size = UDim2.new(0, 38, 0, 20)
    switchBg.Position = UDim2.new(0.8, 0, 0.2, 0)
    switchBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    switchBg.Text = ""
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame", switchBg)
    dot.Size = UDim2.new(0, 16, 0, 16)
    dot.Position = UDim2.new(0.1, 0, 0.1, 0)
    dot.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    switchBg.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        if _G[varName] then
            switchBg.BackgroundColor3 = Color3.fromRGB(75, 125, 255)
            dot:TweenPosition(UDim2.new(0.5, 0, 0.1, 0), "Out", "Quad", 0.15)
        else
            switchBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            dot:TweenPosition(UDim2.new(0.1, 0, 0.1, 0), "Out", "Quad", 0.15)
        end
    end)
end

-- SLIDER CREATOR
local function createSlider(text, pos, min, max, varName)
    local frame = Instance.new("Frame", MainFrame)
    frame.Size = UDim2.new(0.9, 0, 0, 45)
    frame.Position = UDim2.new(0.05, 0, 0, pos)
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 15)
    label.Text = text .. ": " .. _G[varName]
    label.TextColor3 = Color3.fromRGB(150, 150, 150)
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left

    local sliderBg = Instance.new("Frame", frame)
    sliderBg.Size = UDim2.new(1, 0, 0, 4)
    sliderBg.Position = UDim2.new(0, 0, 0.7, 0)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    sliderBg.BorderSizePixel = 0

    local sliderFill = Instance.new("Frame", sliderBg)
    sliderFill.Size = UDim2.new((_G[varName] - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(75, 125, 255)
    sliderFill.BorderSizePixel = 0

    local btn = Instance.new("TextButton", sliderBg)
    btn.Size = UDim2.new(0, 12, 0, 12)
    btn.Position = UDim2.new((_G[varName] - min) / (max - min), -6, 0.5, -6)
    btn.Text = ""
    btn.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local function update()
        local percent = math.clamp((UIS:GetMouseLocation().X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * percent)
        _G[varName] = val
        label.Text = text .. ": " .. val
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        btn.Position = UDim2.new(percent, -6, 0.5, -6)
    end

    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update() end
    end)
end

-- BUTTON LAYOUT
createToggle("Enable Aimbot", 45, "Aimbot")
createToggle("Enable Player ESP", 85, "ESP")
createToggle("Show Name", 125, "ShowName")
createToggle("Show Box", 165, "ShowBox")
createToggle("Show Health Bar", 205, "ShowHealth")

createSlider("Max Aimbot Dist", 255, 10, 1000, "MaxDistAim")
createSlider("Max ESP Dist", 315, 10, 5000, "MaxDistESP")

-- 3. UPDATED LOGIC (Using Sliders)
local function getClosest()
    local target, dist = nil, math.huge
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild(AimPart) then
            local d = (LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if d <= _G.MaxDistAim then -- SLIDER CHECK
                local pos, vis = Camera:WorldToViewportPoint(p.Character[AimPart].Position)
                if vis then
                    local mag = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if mag < dist then target = p.Character[AimPart]; dist = mag end
                end
            end
        end
    end
    return target
end

RS.RenderStepped:Connect(function()
    if not LP.Character then return end
    
    -- ESP LOOP
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local root = p.Character.HumanoidRootPart
            local hum = p.Character:FindFirstChild("Humanoid")
            local pos, vis = Camera:WorldToViewportPoint(root.Position)
            local dist = (LP.Character.HumanoidRootPart.Position - root.Position).Magnitude

            local gui = p.Character:FindFirstChild("AR2_Premium_ESP")
            if _G.ESP and vis and dist <= _G.MaxDistESP then -- SLIDER CHECK
                if not gui then
                    gui = Instance.new("BillboardGui", p.Character)
                    gui.Name = "AR2_Premium_ESP"
                    gui.AlwaysOnTop = true
                    gui.Size = UDim2.new(4, 0, 5.5, 0)
                    local b = Instance.new("Frame", gui); b.Name = "Box"; b.Size = UDim2.new(1,0,1,0); b.BackgroundTransparency = 1; b.BorderColor3 = Color3.new(1,1,1); b.BorderSizePixel = 1
                    local h = Instance.new("Frame", gui); h.Name = "H"; h.Size = UDim2.new(0.05,0,1,0); h.Position = UDim2.new(-0.15,0,0,0); h.BorderSizePixel = 0
                    local i = Instance.new("TextLabel", gui); i.Name = "I"; i.Size = UDim2.new(1,0,0,20); i.Position = UDim2.new(0,0,-0.3,0); i.BackgroundTransparency = 1; i.TextColor3 = Color3.new(1,1,1); i.Font = "GothamBold"; i.TextSize = 11
                end
                gui.Enabled = true
                gui.Box.Visible = _G.ShowBox
                gui.H.Visible = _G.ShowHealth
                if hum then 
                    gui.H.Size = UDim2.new(0.05, 0, hum.Health/hum.MaxHealth, 0)
                    gui.H.BackgroundColor3 = Color3.fromHSV(hum.Health/hum.MaxHealth * 0.3, 1, 1)
                end
                gui.I.Text = (_G.ShowName and p.Name or "") .. " (" .. math.floor(dist) .. "m)"
            else
                if gui then gui.Enabled = false end
            end
        end
    end

    -- AIMBOT (Using Slider Range)
    if _G.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local t = getClosest()
        if t then
            local screenPos = Camera:WorldToViewportPoint(t.Position)
            local mousePos = UIS:GetMouseLocation()
            mousemoverel((screenPos.X - mousePos.X) * Sensitivity, (screenPos.Y - mousePos.Y) * Sensitivity)
        end
    end
end)
