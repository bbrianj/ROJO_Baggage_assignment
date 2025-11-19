--MAIN
local players = game:GetService("Players")
local repStore = game:GetService("ReplicatedStorage")
local httpService = game:GetService("HttpService")
local tweenService = game:GetService("TweenService")

--Workspace
local baggage = repStore.Bag
local startPart = workspace.StartPart
local endPart = workspace.EndPart

--REMOTES
local remotesFolder = repStore.Remotes
local intervalEvent = remotesFolder.IntervalController
local bagMoveEvent = remotesFolder.BaggageMove


--IntervalController----
local interval = 1
local intervalController = nil
local intervalControllerAdded = false

players.PlayerAdded:Connect(function(plr)
    if not intervalControllerAdded then
        intervalControllerAdded = true
        intervalController = plr
        intervalEvent:FireClient(plr)
    end
end)


players.PlayerRemoving:Connect(function(plr)
    if plr == intervalController then
        intervalController = players:FindFirstChildOfClass("Player")
    end  
end)

intervalEvent.OnServerEvent:Connect(function(plr, value)
    interval = value
end)
---------

bagMoveEvent.Event:Connect(function(bag, moveType)
    task.spawn(function()
        if moveType == "Spawn" then
            bag.CFrame = startPart.CFrame
            tweenService:Create(bag, TweenInfo.new(0.5, Enum.EasingStyle.Linear),{Transparency = 0}):Play() --anim
            tweenService:Create(bag, TweenInfo.new(10, Enum.EasingStyle.Linear),{CFrame = endPart.CFrame}):Play()
            task.wait(10)
            bagMoveEvent:Fire(bag, "Remove")
        elseif moveType == "Remove" then
            bag.CFrame = endPart.CFrame
            tweenService:Create(bag, TweenInfo.new(0.5, Enum.EasingStyle.Linear),{Transparency = 1}):Play() --anim
        end
    end)        
end)

while task.wait(interval) do
    local clone = baggage:Clone()
    local uniqueID = httpService:GenerateGUID(false)
    clone:SetAttribute("UniqueID", uniqueID)
    clone.Color = Color3.new(math.random(1,255),math.random(1,255),math.random(1,255)) --randomly changing colour
    clone.Parent = workspace
    bagMoveEvent:Fire(clone, "Spawn")
end
