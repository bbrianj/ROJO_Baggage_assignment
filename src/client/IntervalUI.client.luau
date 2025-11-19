--Player
local plr = game.Players.LocalPlayer
local gui = plr.PlayerGui

--MAIN
local repStore = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

--GUI
local screenGui = gui:WaitForChild("IntervalUI", 10)
local sliderBG = screenGui.BG
local slider = sliderBG.Slider
local intervalText = screenGui.IntervalText



--Remotes
local remotesFolder = repStore.Remotes
local intervalUIEvent = remotesFolder.IntervalController

intervalUIEvent.OnClientEvent:Connect(function()
    screenGui.Enabled = true
end)
-----

local dragging = false

function updateSlide(input)
    if dragging then
        local sliderBGPosX = sliderBG.AbsolutePosition.X
        local sliderBGSizeX = sliderBG.AbsoluteSize.X

        local x = math.clamp(input.Position.X - sliderBGPosX, 0, sliderBGSizeX)
        if x < 0 then
            x = 0
        elseif x > 350 then
            x = 350
        end

        slider.Position = UDim2.new(0, x, 0,0)

        local intervalValue = tonumber((x+1)*10/sliderBGSizeX) --interval can be set between 1 and 11
        intervalText.Text = "Interval: ".. intervalValue
        
        intervalUIEvent:FireServer(intervalValue)
    end
end

slider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
    end
end)
slider.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSlide(input)
    end
end)