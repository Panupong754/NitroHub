local module = {}

function module.run()
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    local diamondPan

    for _, child in ipairs(character:GetChildren()) do
        if child.Name:find("Pan") then
            diamondPan = child
            break
        end
    end

    if not diamondPan then
        error("ไม่พบวัตถุที่มีชื่อ 'Pan' ในตัวละคร")
    end

    local scriptsFolder = diamondPan:WaitForChild("Scripts")

    local function fireToggleShovel(state)
        local toggleShovel = scriptsFolder:WaitForChild("ToggleShovelActive")
        toggleShovel:FireServer(state)
    end

    local function invokeCollect(value)
        local collectFunc = scriptsFolder:WaitForChild("Collect")
        return collectFunc:InvokeServer(value)
    end

    local function invokeDelayedRequest(value)
        local delayedRequest = ReplicatedStorage:WaitForChild("Modules")
            :WaitForChild("Utility"):WaitForChild("TweenServicePlus")
            :WaitForChild("SyncedTime"):WaitForChild("DelayedRequestEvent")
        return delayedRequest:InvokeServer(value)
    end

    while getgenv().Toggle do
        fireToggleShovel(true)
        task.wait(0.2)

        invokeCollect(1)
        task.wait(0.1)

        invokeCollect(1)
        task.wait(0.1)

        invokeDelayedRequest(1754775137.844376)
        task.wait(0.1)

        fireToggleShovel(false)
        task.wait(0.5)
    end
end

return module
