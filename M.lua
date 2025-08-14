--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.9) ~  Much Love, Ferib 

]]--

-- NitroHub.lua
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- โหลดพิกัดจากไฟล์ Nitro
local path = "Nitro/" .. player.Name .. ".nitro hub.json"
local data = { pos_sand = nil, pos_water = nil }

if isfile(path) then
    local content = readfile(path)
    local success, decoded = pcall(HttpService.JSONDecode, HttpService, content)
    if success and typeof(decoded) == "table" then
        data = decoded
    end
end

-- วาปฟังก์ชัน
local function teleportTo(pos)
    if pos then
        hrp.CFrame = CFrame.new(pos.x, pos.y, pos.z)
    end
end

-- ฟังก์ชันใช้งานเครื่องมือ
local function equipAndRunTool(tool)
    tool.Parent = player.Character
    tool.Scripts.ToggleShovelActive:FireServer(true)
    tool.Scripts.Collect:InvokeServer()
    ReplicatedStorage.Modules.Utility.TweenServicePlus.SyncedTime.DelayedRequestEvent:InvokeServer(1755038611.4846866)
    tool.Scripts.Collect:InvokeServer(1)
    tool.Scripts.ToggleShovelActive:FireServer(false)
end

local function isTargetTool(name)
    local n = string.lower(name)
    return string.find(n, "pan") or string.find(n, "worldshaker")
end

local function checkAndRunTools()
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character
    if not backpack or not character then return end

    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and isTargetTool(tool.Name) then
            equipAndRunTool(tool)
        end
    end

    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") and isTargetTool(tool.Name) then
            equipAndRunTool(tool)
        end
    end
end

-- เช็ค Pan
local playerGui = player:WaitForChild("PlayerGui")
local toolUi = playerGui:WaitForChild("ToolUI")
local fillingPan = toolUi:WaitForChild("FillingPan")
local fillTextObj = fillingPan:WaitForChild("FillText")

local function isPanFull()
    local current, total = string.match(fillTextObj.Text, "(%d+)%/(%d+)")
    if current and total then
        return tonumber(current) == tonumber(total)
    end
    return false
end

local function isPanEmpty()
    local current, _ = string.match(fillTextObj.Text, "(%d+)%/(%d+)")
    if current then
        return tonumber(current) == 0
    end
    return false
end

-- เปิด Shake ของ Pan/Worldshaker
local function activateShake()
    local character = player.Character
    if not character then return end

    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") and (string.find(tool.Name, "Pan") or string.find(tool.Name, "Worldshaker")) then
            local scriptsFolder = tool:FindFirstChild("Scripts")
            if scriptsFolder then
                local shake = scriptsFolder:FindFirstChild("Shake")
                if shake then
                    shake:FireServer()
                end
            end
        end
    end
end

-- Toggle
getgenv().Toggle = false
Main_1_left:toggle({
    name = "NitroHub Auto",
    def = false,
    callback = function(vu)
        getgenv().Toggle = vu
    end
})

-- Loop หลัก
while true do
    if getgenv().Toggle then
        -- วาปไป pos_sand
        teleportTo(data.pos_sand)
        task.wait(0.1)
        checkAndRunTools()

        -- ถ้า Pan เต็ม → วาป pos_water + Shake
        if isPanFull() then
            teleportTo(data.pos_water)
            task.wait(0.1)
            activateShake()
        end

        -- ถ้า Pan เหลือ 0 → กลับ pos_sand
        if isPanEmpty() then
            teleportTo(data.pos_sand)
            task.wait(0.1)
        end
    end
    task.wait(0.001)
end
