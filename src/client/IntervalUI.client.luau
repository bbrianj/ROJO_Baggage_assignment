--Player
local plr = game.Players.LocalPlayer
local gui = plr.PlayerGui

--MAIN
local repStore = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

--GUI
local screenGui = gui.intervalUI
local sliderBG = screenGui.Bag
local slider = sliderBG.Slider
local intervalText = screenGui.IntervalText



--Remotes
local remotesFolder = repStore.Remotes
local intervalUIEvent = remotesFolder.IntervalController

intervalUIEvent.OnClientEvent:Connect(function()
    screenGui.Enabled = true
end)


function updateScroll(input)
    local sliderBGPosX = sliderBG.AbsolutePosition.X
    local sliderBGSizeX = sliderBG.AbsoluteSize.X

    local x = math.clamp(input.Position.X - sliderBGPosX, 0, sliderBGSizeX)
    if x < 0 then
        x = 0
    elseif x > 350 then
        x = 350
    end

    slider.Positon = UDim2.new(0, x, 0,0)

    local intervalValue = (x+1)*10/sliderBGSizeX --interval can be set between 1 and 11

    
    intervalUIEvent:FireServer(intervalValue)
end