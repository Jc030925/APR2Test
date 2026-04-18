-- [[ APOCALYPSE RISING 2: ADVANCED UI + ESP & AIMBOT ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- SETTINGS (GLOBAL PARA SA UI)
_G.Aimbot = false
_G.ESP_Enabled = false
_G.ShowNames = true
_G.ShowBoxes = true
_G.ShowHealth = true
_G.ShowDistance = true
_G.MaxDistance = 1500

local AimPart = "Head"
local Sensitivity = 0.5 -- Baguhin kung masyadong mabilis

-- 1. MODERN UI GENERATION
local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
ScreenGui.Name = "AR2_PremiumUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 320)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = TooltipService -- Standard 8px

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "AR2 INTERNAL"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

-- Toggle Helper Function
local function createToggle(text, yPos, globalVar)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    btn.Text = "  " .. text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    
    local corner = Instance.new("UICorner", btn)
    local indicator = Instance.new("Frame", btn)
    indicator.Size = UDim2.new(0, 10, 0, 10)
    indicator.Position = UDim2.new(0.85, 0, 0.35, 0)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

    btn.MouseButton1Click:Connect(function()
        _G[globalVar] = not _G[globalVar]
        indicator.BackgroundColor3 = _G[globalVar] and Color3.fromRGB(50, 255, 100) or Color3.fromRGB(255, 50, 50)
    end)
end

createToggle("Enable Aimbot", 50, "Aimbot")
createToggle("Show Player ESP", 95, "ESP_Enabled")
createToggle("Show Box", 140, "ShowBoxes")
createToggle("Show Health", 185, "ShowHealth")
createToggle("Show Name/Dist", 230, "ShowNames")

-- 2. ESP SYSTEM (DRAWING API)
local cache = {}

local function createESP(plr)
    local drawings = {
        box = Drawing.new("Square"),
        name = Drawing.new("Text"),
        healthBar = Drawing.new("Line"),
        healthOutline = Drawing.new("Line")
    }
    cache[plr] = drawings
end

local function updateESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr == LP then continue end
        if not cache[plr] then createESP(plr) end
        
        local d = cache[plr]
        local char = plr.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        
        if _G.ESP_Enabled and root and hum and hum.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
            local dist = (LP.Character.HumanoidRootPart.Position - root.Position).Magnitude

            if onScreen and dist <= _G.MaxDistance then
                local sizeX = 2000 / pos.Z
                local sizeY = 3000 / pos.Z
                local x = pos.X - sizeX / 2
                local y = pos.Y - sizeY / 2

                -- Box
                d.box.Visible = _G.ShowBoxes
                d.box.Size = Vector2.new(sizeX, sizeY)
                d.box.Position = Vector2.new(x, y)
                d.box.Color = Color3.new(1, 1, 1)
                d.box.Thickness = 1

                -- Name & Distance
                d.name.Visible = _G.ShowNames
                d.name.Text = string.format("%s [%d]", plr.Name, math.floor(dist))
                d.name.Position = Vector2.new(x + sizeX / 2, y - 20)
                d.name.Center = true
                d.name.Outline = true
                d.name.Size = 16
                d.name.Color = Color3.new(1, 1, 1)

                -- Health Bar
                d.healthBar.Visible = _G.ShowHealth
                local healthHeight = (hum.Health / hum.MaxHealth) * sizeY
                d.healthBar.From = Vector2.new(x - 5, y + sizeY)
                d.healthBar.To = Vector2.new(x - 5, y + sizeY - healthHeight)
                d.healthBar.Color = Color3.fromHSV(hum.Health/100 * 0.3, 1, 1)
                d.healthBar.Thickness = 2
                
                continue
            end
        end
        -- Hide if not visible
        d.box.Visible = false
        d.name.Visible = false
        d.healthBar.Visible = false
    end
end

-- 3. AIMBOT LOGIC
local function getClosest()
    local target, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild(AimPart) then
            local pos, vis = Camera:WorldToViewportPoint(p.Character[AimPart].Position)
            if vis then
                local mag = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                if mag < dist and mag < 200 then -- 200 is FOV circle size
                    target = p.Character[AimPart]
                    dist = mag
                end
            end
        end
    end
    return target
end

-- 4. LOOP
RS.RenderStepped:Connect(function()
    updateESP()
    
    if _G.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local t = getClosest()
        if t then
            local screenPos = Camera:WorldToViewportPoint(t.Position)
            local mousePos = UIS:GetMouseLocation()
            mousemoverel((screenPos.X - mousePos.X) * Sensitivity, (screenPos.Y - mousePos.Y) * Sensitivity)
        end
    end
end)
