-- [[ 7SINS MASTER LOADER ]]
local TARGET_GAME_ID = 10156435104 -- Drill Blocks for Brainrots ID

-- 1. Ensure game replication is completely ready on your computer
if not game:IsLoaded() then 
    game.Loaded:Wait()
end

-- 2. Environmental Verification Filter
if game.GameId ~= TARGET_GAME_ID then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "7sins Hub Error",
        Text = "We do not support this game. Please join the correct game to use 7sins Hub.",
        Duration = 5
    })
    return -- Kills the execution immediately if you are in the wrong game
end

-- 3. Fetch and compile your UI code directly from the internet
-- (Replace the link below with your raw Pastebin or GitHub Gist link)
local RAW_SCRIPT_URL = "https://raw.githubusercontent.com/pryence/7sins-loader/refs/heads/main/Test-ui.luau"

local success, scriptBody = pcall(game.HttpGet, game, RAW_SCRIPT_URL)
if success and scriptBody then
    local compiledFunction = loadstring(scriptBody)
    if compiledFunction then
        task.spawn(compiledFunction) -- Bootstraps your layout directly into CoreGui
    else
        warn("Failed to compile script text.")
    end
else
    warn("Failed to download script from the hosted link.")
end
