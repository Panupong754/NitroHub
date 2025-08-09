local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

while getgenv().Toggle do
    local character = player.Character or player.CharacterAdded:Wait()

    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:find("Pan") then
            local scripts = tool:FindFirstChild("Scripts")
            if scripts then
                local toggleShovelActive = scripts:FindFirstChild("ToggleShovelActive")
                local collect = scripts:FindFirstChild("Collect")
                if toggleShovelActive and collect then
                    toggleShovelActive:FireServer(true)
                    task.wait(0.5)

                    collect:InvokeServer(1)
                    task.wait(0.3)
                    collect:InvokeServer(1)
                    task.wait(0.3)

                    local modules = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utility"):WaitForChild("TweenServicePlus"):WaitForChild("SyncedTime")
                    local delayedRequestEvent = modules:FindFirstChild("DelayedRequestEvent")
                    if delayedRequestEvent then
                        delayedRequestEvent:InvokeServer(1754775137.844376)
                        task.wait(0.5)
                    end

                    toggleShovelActive:FireServer(false)
                end
            end
        end
    end

    task.wait(1)
end            :WaitForChild("Utility"):WaitForChild("TweenServicePlus")
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
