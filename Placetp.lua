
-- Place Teleport Hub UI
-- Client-side UI prototype
-- Paste into a compatible Lua environment.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Replace these examples with actual place IDs.
local PLACES = {
    {name = "Main Lobby", id = 1234567890},
    {name = "Map 2",       id = 2345678901},
    {name = "Map 3",       id = 3456789012},
}

local old = playerGui:FindFirstChild("PlaceTeleportHub")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "PlaceTeleportHub"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(330, 400)
frame.Position = UDim2.new(0.5, -165, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(25, 28, 40)
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius =
    UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -45, 0, 42)
title.Position = UDim2.fromOffset(12, 0)
title.BackgroundTransparency = 1
title.Text = "PLACE TELEPORT HUB"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 17
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(32, 32)
close.Position = UDim2.new(1, -38, 0, 5)
close.Text = "X"
close.Parent = frame
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local search = Instance.new("TextBox")
search.Size = UDim2.new(1, -20, 0, 36)
search.Position = UDim2.fromOffset(10, 48)
search.PlaceholderText = "Search places..."
search.Text = ""
search.ClearTextOnFocus = false
search.Font = Enum.Font.Gotham
search.TextSize = 14
search.Parent = frame

local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(1, -20, 1, -100)
list.Position = UDim2.fromOffset(10, 92)
list.BackgroundColor3 = Color3.fromRGB(35, 39, 54)
list.BorderSizePixel = 0
list.ScrollBarThickness = 5
list.AutomaticCanvasSize = Enum.AutomaticSize.Y
list.CanvasSize = UDim2.new()
list.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = list

local function refresh()
    for _, item in ipairs(list:GetChildren()) do
        if item:IsA("TextButton") or
           item:IsA("TextLabel") then
            item:Destroy()
        end
    end

    local count = 0
    for _, place in ipairs(PLACES) do
        if string.find(
            string.lower(place.name),
            string.lower(search.Text),
            1, true
        ) then
            count += 1

            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, -10, 0, 48)
            button.BackgroundColor3 =
                Color3.fromRGB(65, 78, 115)
            button.TextColor3 = Color3.new(1, 1, 1)
            button.Font = Enum.Font.Gotham
            button.TextSize = 14
            button.Text = place.name .. "  |  ID: " .. place.id
            button.LayoutOrder = count
            button.Parent = list

            Instance.new("UICorner", button).CornerRadius =
                UDim.new(0, 7)

            button.MouseButton1Click:Connect(function()
                local message = Instance.new("TextLabel")
                message.Size = UDim2.new(1, -10, 0, 28)
                message.BackgroundTransparency = 1
                message.TextColor3 = Color3.new(1, 1, 1)
                message.TextSize = 12
                message.Font = Enum.Font.Gotham
                message.Text = "Selected: " .. place.name ..
                    " (teleport requires server support)"
                message.Parent = list
                message.LayoutOrder = count + 1
            end)
        end
    end

    if count == 0 then
        local empty = Instance.new("TextLabel")
        empty.Size = UDim2.new(1, -10, 0, 40)
        empty.BackgroundTransparency = 1
        empty.Text = "No matching places found"
        empty.TextColor3 = Color3.new(1, 1, 1)
        empty.Parent = list
    end
end

search:GetPropertyChangedSignal("Text"):Connect(refresh)
refresh()
