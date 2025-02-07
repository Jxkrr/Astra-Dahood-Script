local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AikaV3rm/UiLib/master/Lib.lua"))()

local Window = Library:CreateWindow("Astra Da Hood Script") -- Creates the main GUI window

-- Aimlock Configuration
local AimlockEnabled = false
local AimlockStrength = 1.0 -- Adjust this to increase locking intensity
local AimbotRange = 200

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Function to get the nearest player to the crosshair
function GetNearestPlayerToCursor()
    local NearestPlayer = nil
    local ShortestDistance = AimbotRange

    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health > 0 then
            local Head = Player.Character:FindFirstChild("Head")
            if Head then
                local ScreenPoint = workspace.CurrentCamera:WorldToViewportPoint(Head.Position)
                local Distance = (Vector2.new(ScreenPoint.X, ScreenPoint.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if Distance < ShortestDistance then
                    NearestPlayer = Player
                    ShortestDistance = Distance
                end
            end
        end
    end

    return NearestPlayer
end

-- Aimlock Functionality
Mouse.KeyDown:Connect(function(Key)
    if Key == "q" then -- Toggle aimlock with "Q"
        AimlockEnabled = not AimlockEnabled
        Library:Notification("Aimlock", AimlockEnabled and "Enabled" or "Disabled", 2)
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if AimlockEnabled then
        local Target = GetNearestPlayerToCursor()
        if Target and Target.Character and Target.Character:FindFirstChild("Head") then
            local Head = Target.Character.Head
            local Camera = workspace.CurrentCamera

            -- Strong aimlock behavior
            local AimPosition = Camera:WorldToViewportPoint(Head.Position)
            mousemoverel((AimPosition.X - Mouse.X) * AimlockStrength, (AimPosition.Y - Mouse.Y) * AimlockStrength)
        end
    end
end)

-- Minimize, Reappear, and Close Buttons
Window:AddButton("Minimize", function()
    Window:Minimize()
end)

Window:AddButton("Reappear", function()
    Window:Reappear()
end)

Window:AddButton("Close", function()
    Window:Destroy()
end)

-- ESP with Hitboxes and Player Tags
local ESPEnabled = false

function ToggleESP()
    ESPEnabled = not ESPEnabled
    if ESPEnabled then
        for _, Player in pairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("Humanoid") then
                local Highlight = Instance.new("Highlight", Player.Character)
                Highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                Highlight.FillTransparency = 1 -- Only outlines
            end
        end
    else
        for _, Player in pairs(Players:GetPlayers()) do
            if Player.Character and Player.Character:FindFirstChild("Highlight") then
                Player.Character.Highlight:Destroy()
            end
        end
    end
end

Window:AddButton("Toggle ESP", function()
    ToggleESP()
    Library:Notification("ESP", ESPEnabled and "Enabled" or "Disabled", 2)
end)

-- Custom Aimbot Range Slider
Window:AddSlider("Aimbot Range", {min = 50, max = 200, default = 200}, function(Value)
    AimbotRange = Value
end)

