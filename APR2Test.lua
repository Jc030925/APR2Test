-- [[ AR2: MOUSE-MOVE AIM + ADVANCED ESP ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- 1. SETTINGS (Pinagsama ang luma at bago)
_G.Aimbot = false
_G.ESP = false
_G.ShowBox = false
_G.ShowName = false
_G.MaxDist = 1000

local RANGE = 1000 
local AimPart = "Head"
local Sensitivity = 0.80 

-- 2. MODERN UI MENU (Custom styled)
local ScreenGui = LP.PlayerGui:FindFirstChild("AR2_MouseUI")
if ScreenGui then ScreenGui:Destroy() end

ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
ScreenGui.Name = "AR2_MouseUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 280)
MainFrame.Position = UDim2.new(0.02, 0, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 16, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "PLAYER ESP"
Title.TextColor3 = Color3.fromRGB(180, 180, 180)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0.05, 0, 0, 0)

-- Toggle Switch Function (Kamukha ng screenshot)
local function createToggle(text, pos, varName)
    local frame = Instance.new("Frame", MainFrame)
    frame.Size = UDim2.new(0.9, 0, 0, 35)
    frame.Position = UDim2.new(0.05, 0, 0, pos)
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1

    local switchBg = Instance.new("TextButton", frame)
    switchBg.Size = UDim2.new(0, 35, 0, 18)
    switchBg.Position = UDim2.new(0.8, 0, 0.25, 0)
    switchBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    switchBg.Text = ""
    local sbCorner = Instance.new("UICorner", switchBg)
    sbCorner.CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame", switchBg)
    dot.Size = UDim2.new(0, 14, 0, 14)
    dot.Position = UDim2.new(0.1, 0, 0.1, 0)
    dot.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    switchBg.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        if _G[varName] then
            switchBg.BackgroundColor3 = Color3.fromRGB(70, 120, 255)
            dot:TweenPosition(UDim2.new(0.55, 0, 0.1, 0), "Out", "Quad", 0.15)
        else
            switchBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            dot:TweenPosition(UDim2.new(0.1, 0, 0.1, 0), "Out", "Quad", 0.15)
        end
    end)
end

createToggle("Enable Smooth Aim", 45, "Aimbot")
createToggle("Enable Player ESP", 85, "ESP")
createToggle("Show Name", 125, "ShowName")
createToggle("Show Box", 165, "ShowBox")

-- 3. ORIGINAL AIMBOT LOGIC (Walang binago sa logic mo)
local function getClosest()
    local target, dist = nil, math.huge
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild(AimPart) then
            local d = (LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if d <= RANGE then
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

-- 4. ESP & AIMBOT LOOP
RS.RenderStepped:Connect(function()
    if not LP.Character then return end

    -- ESP SYSTEM
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local root = p.Character.HumanoidRootPart
            local pos, vis = Camera:WorldToViewportPoint(root.Position)
            local dist = (LP.Character.HumanoidRootPart.Position - root.Position).Magnitude

            -- Highlight (Original mo)
            local hl = p.Character:FindFirstChild("AR2_ESP") or Instance.new("Highlight", p.Character)
            hl.Name = "AR2_ESP"
            hl.Enabled = _G.ESP and (dist <= RANGE)
            hl.FillColor = Color3.fromRGB(255, 0, 0)
            hl.FillTransparency = 0.5

            -- Box & Name (BillboardGui para stable sa AR2)
            local gui = p.Character:FindFirstChild("ESP_Gui")
            if _G.ESP and vis and dist <= RANGE then
                if not gui then
                    gui = Instance.new("BillboardGui", p.Character)
                    gui.Name = "ESP_Gui"
                    gui.AlwaysOnTop = true
                    gui.Size = UDim2.new(4, 0, 5.5, 0)
                    
                    local box = Instance.new("Frame", gui)
                    box.Name = "Box"
                    box.Size = UDim2.new(1, 0, 1, 0)
                    box.BackgroundTransparency = 1
                    box.BorderColor3 = Color3.new(1, 1, 1)
                    box.BorderSizePixel = 1

                    local nameTag = Instance.new("TextLabel", gui)
                    nameTag.Name = "Tag"
                    nameTag.Size = UDim2.new(1, 0, 0, 20)
                    nameTag.Position = UDim2.new(0, 0, -0.3, 0)
                    nameTag.BackgroundTransparency = 1
                    nameTag.TextColor3 = Color3.new(1, 1, 1)
                    nameTag.Font = Enum.Font.GothamBold
                    nameTag.TextSize = 12
                end
                gui.Enabled = true
                gui.Tag.Text = (_G.ShowName and p.Name or "") .. " (" .. math.floor(dist) .. "m)"
                gui.Box.Visible = _G.ShowBox
            else
                if gui then gui.Enabled = false end
            end
        end
    end

    -- AIMBOT (Original logic mo gamit ang Right Click)
    if _G.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local t = getClosest()
        if t then
            local screenPos, onScreen = Camera:WorldToViewportPoint(t.Position)
            if onScreen then
                local mousePos = UIS:GetMouseLocation()
                mousemoverel((screenPos.X - mousePos.X) * Sensitivity, (screenPos.Y - mousePos.Y) * Sensitivity)
            end
        end
    end
end)
