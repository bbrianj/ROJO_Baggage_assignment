--MAIN
local players = game:GetService("Players")
local repStore = game:GetService("ReplicatedStorage")

--REMOTES
local remotesFolder = repStore.Remotes
local intervalUIEvent = remotesFolder.IntervalController


--IntervalController
local interval = 1
local intervalController = nil
local intervalControllerAdded = false

players.PlayerAdded:Connect(function(plr)
    if not intervalControllerAdded then
        intervalControllerAdded = true
        intervalController = plr
        intervalUIEvent:FireClient(plr)
    end
end)


players.PlayerRemoving:Connect(function(plr)
    if plr == intervalController then
        intervalController = players:FindFirstChildOfClass("Player")
    end  
end)