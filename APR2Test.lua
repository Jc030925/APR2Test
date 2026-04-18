-- [[ AR2: MOUSE-MOVE AIM + ESP + TRUE WALLBANG ]] --
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
_G.ShowDist = false
_G.Wallbang = false 
_G.MaxDistESP = 1500
_G.MaxDistAim = 400

local AimPart = "Head"
local Sensitivity = 0.80 

-- 2. UI MENU SETUP
local ScreenGui = LP.PlayerGui:FindFirstChild("AR2_MouseUI")
if ScreenGui then ScreenGui:Destroy() end

ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
ScreenGui.Name = "AR2_MouseUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 240, 0, 460) 
MainFrame.Position = UDim2.new(0.02, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 16, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "     AR2 SETTINGS (RShift)"
Title.TextColor3 = Color3.fromRGB(180, 180, 180)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- UI COMPONENTS
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

local function createSlider(text, pos, min, max, varName)
    local frame = Instance.new("Frame", MainFrame)
    frame.Size = UDim2.new(0.9, 0, 0, 45)
    frame.Position = UDim2.new(0.05, 0, 0, pos)
    frame.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", frame); label.Size = UDim2.new(1,0,0,15); label.Text = text .. ": " .. _G[varName]; label.TextColor3 = Color3.fromRGB(150,150,150); label.Font = "Gotham"; label.TextSize = 11; label.BackgroundTransparency = 1; label.TextXAlignment = "Left"
    local sBg = Instance.new("Frame", frame); sBg.Size = UDim2.new(1,0,0,4); sBg.Position = UDim2.new(0,0,0.7,0); sBg.BackgroundColor3 = Color3.fromRGB(50,50,60); sBg.BorderSizePixel = 0
    local sFill = Instance.new("Frame", sBg); sFill.Size = UDim2.new((_G[varName]-min)/(max-min),0,1,0); sFill.BackgroundColor3 = Color3.fromRGB(75,125,255); sFill.BorderSizePixel = 0
    local btn = Instance.new("TextButton", sBg); btn.Size = UDim2.new(0,12,0,12); btn.Position = UDim2.new((_G[varName]-min)/(max-min),-6,0.5,-6); btn.Text = ""; btn.BackgroundColor3 = Color3.new(1,1,1); Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)
    local drag = false
    local function update()
        local p = math.clamp((UIS:GetMouseLocation().X - sBg.AbsolutePosition.X) / sBg.AbsoluteSize.X, 0, 1)
        local v = math.floor(min + (max - min) * p)
        _G[varName] = v; label.Text = text .. ": " .. v; sFill.Size = UDim2.new(p,0,1,0); btn.Position = UDim2.new(p,-6,0.5,-6)
    end
    btn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
    UIS.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then update() end end)
end

createToggle("Enable Aimbot", 45, "Aimbot")
createToggle("Enable Player ESP", 85, "ESP")
createToggle("Show Name", 125, "ShowName")
createToggle("Show Distance", 165, "ShowDist")
createToggle("Show Box (Highlight)", 205, "ShowBox")
createToggle("TRUE Wallbang", 245, "Wallbang") 

createSlider("Max Aimbot Dist", 295, 10, 1000, "MaxDistAim")
createSlider("Max ESP Dist", 355, 10, 5000, "MaxDistESP")

-- 3. LOGIC (TRUE WALLBANG EXPLOIT)
-- Nilalampas ang bala sa Map geometry at niloloko ang Raycast engine
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if _G.Wallbang and method == "Raycast" and not checkcaller() then
        -- Hahanapin ang RaycastParams sa args
        for _, arg in pairs(args) do
            if typeof(arg) == "RaycastParams" then
                -- Pinipilit ang raycast na huwag pansinin ang static objects/pader
                arg.FilterType = Enum.RaycastFilterType.Include
                arg.FilterDescendantsInstances = {workspace:FindFirstChild("Characters"), workspace:FindFirstChild("Zombies")}
            end
        end
    end
    return oldNamecall(self, unpack(args))
end)

local function getClosest()
    local target, dist = nil, math.huge
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild(AimPart) then
            local d = (LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if d <= _G.MaxDistAim then
                local pos, vis = Camera:WorldToViewportPoint(p.Character[AimPart].Position)
                -- Kung naka-Wallbang, mag-a-aimbot kahit hindi nakikita ng camera
                if vis or _G.Wallbang then
                    local mag = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if mag < dist then target = p.Character[AimPart]; dist = mag end
                end
            end
        end
    end
    return target
end

-- 4. MAIN LOOP
RS.RenderStepped:Connect(function()
    if not LP.Character then return end
    
    -- Player ESP
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local char = p.Character
            local root = char.HumanoidRootPart
            local dist = (LP.Character.HumanoidRootPart.Position - root.Position).Magnitude
            
            local hl = char:FindFirstChild("AR2_Highlight")
            if _G.ESP and _G.ShowBox and dist <= _G.MaxDistESP then
                if not hl then
                    hl = Instance.new("Highlight", char); hl.Name = "AR2_Highlight"; hl.FillColor = Color3.fromRGB(255, 0, 0); hl.FillTransparency = 0.5
                end
                hl.Enabled = true
            elseif hl then hl.Enabled = false end

            local gui = char:FindFirstChild("AR2_Text_ESP")
            local pos, vis = Camera:WorldToViewportPoint(root.Position)
            if _G.ESP and (vis or _G.Wallbang) and dist <= _G.MaxDistESP then
                if not gui then
                    gui = Instance.new("BillboardGui", char); gui.Name = "AR2_Text_ESP"; gui.AlwaysOnTop = true; gui.Size = UDim2.new(4,0,5,0)
                    local t = Instance.new("TextLabel", gui); t.Name = "L"; t.Size = UDim2.new(1,0,0,40); t.Position = UDim2.new(0,0,-0.4,0); t.BackgroundTransparency = 1; t.TextColor3 = Color3.new(1,1,1); t.Font = "GothamBold"; t.TextSize = 11
                end
                gui.Enabled = true
                local display = ""
                if _G.ShowName then display = display .. p.Name .. "\n" end
                if _G.ShowDist then display = display .. "[" .. math.floor(dist) .. "m]" end
                gui.L.Text = display
            elseif gui then gui.Enabled = false end
        end
    end

    -- Aimbot (Right Click)
    if _G.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local t = getClosest()
        if t then
            local sp = Camera:WorldToViewportPoint(t.Position)
            local mp = UIS:GetMouseLocation()
            mousemoverel((sp.X - mp.X) * Sensitivity, (sp.Y - mp.Y) * Sensitivity)
        end
    end
end)
