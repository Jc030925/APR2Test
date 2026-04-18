-- [[ APOCALYPSE RISING 2: FIXED UI ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- SETTINGS
_G.Aimbot = false
_G.ESP_Enabled = false
local AimPart = "Head"
local Sensitivity = 0.5

-- UI SETUP
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AR2_FixedUI"
ScreenGui.Parent = LP.PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "AR2 CONTROL"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold

-- Mismong Button logic na hindi mawawala
local function createBtn(text, yPos, globalVar)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.Name = text
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        _G[globalVar] = not _G[globalVar]
        btn.Text = text .. (_G[globalVar] and ": ON" or ": OFF")
        btn.BackgroundColor3 = _G[globalVar] and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(45, 45, 50)
    end)
end

createBtn("SMOOTH AIM", 40, "Aimbot")
createBtn("PLAYER ESP", 85, "ESP_Enabled")

-- SIMPLE HIGHLIGHT ESP PARA SIGURADONG GAGANA KAHIT WALANG DRAWING LIB
RS.RenderStepped:Connect(function()
    if _G.ESP_Enabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local hl = p.Character:FindFirstChild("AR2_Highlight")
                if not hl then
                    hl = Instance.new("Highlight", p.Character)
                    hl.Name = "AR2_Highlight"
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.OutlineColor = Color3.new(1, 1, 1)
                end
                hl.Enabled = true
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("AR2_Highlight") then
                p.Character.AR2_Highlight.Enabled = false
            end
        end
    end

    -- AIMBOT (Right Click)
    if _G.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        -- (Dito pa rin yung dati mong getClosest logic...)
    end
end)
