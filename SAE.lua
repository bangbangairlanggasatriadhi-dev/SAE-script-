-- ============ CONFIG ============
local HUB_URL     = "https://raw.githubusercontent.com/bangbangairlanggasatriadhi-dev/SAE-script-/refs/heads/main/Smap.lua"
local LOADER_NAME = "Security.lua"
local HEADER      = "-- Security, dont change anything"
local OVERWRITE   = true
-- ================================

local AutoExec = {}

-- ============ DETECT EXECUTOR ============
local function detectExecutor()
    local name = "Unknown"
    pcall(function()
        if identifyexecutor then
            local n, v = identifyexecutor()
            name = tostring(n or "Unknown")
            if v and tostring(v) ~= "" then name = name .. " " .. tostring(v) end
        elseif syn      then name = "Synapse X"
        elseif fluxus   then name = "Fluxus"
        elseif delta    then name = "Delta"
        elseif solara   then name = "Solara"
        elseif hydrogen then name = "Hydrogen"
        elseif codex    then name = "Codex"
        elseif wave     then name = "Wave"
        elseif arceus   then name = "Arceus X"
        end
    end)
    return name
end

-- ============ CARI FOLDER AUTOEXEC ============
local AUTOEXEC_CANDIDATES = {
    "../autoexec/",
    "autoexec/",
    "../../autoexec/",
}

local function findAutoexecPath()
    if not isfile or not writefile or not delfile then return nil end
    for _, candidate in ipairs(AUTOEXEC_CANDIDATES) do
        local testFile = candidate .. ".ae_test_" .. os.time() .. ".txt"
        local ok = pcall(function()
            writefile(testFile, "test")
            if isfile(testFile) then delfile(testFile) end
        end)
        if ok then return candidate end
    end
    return nil
end

-- ============ HELPERS ============
local function getLoaderPath()
    local dir = findAutoexecPath()
    if not dir then return nil end
    return dir .. LOADER_NAME
end

local function buildLoaderContent()
    return string.format(
        "%s\n-- Installed by: %s\n-- Date: %s\nloadstring(game:HttpGet(\"%s\"))()\n",
        HEADER,
        detectExecutor(),
        os.date("%Y-%m-%d %H:%M:%S"),
        HUB_URL
    )
end

-- ============ PUBLIC API ============
function AutoExec.IsSupported()
    return findAutoexecPath() ~= nil
end

function AutoExec.IsInstalled()
    local path = getLoaderPath()
    if not path then return false end
    local ok, exists = pcall(function() return isfile(path) end)
    return ok and exists == true
end

function AutoExec.Install()
    local path = getLoaderPath()
    if not path then
        warn("[AutoExec] GAGAL: folder autoexec tidak ditemukan / executor tidak support writefile.")
        return false
    end

    if not OVERWRITE and AutoExec.IsInstalled() then
        print("[AutoExec] Sudah terinstall -> " .. path)
        return true
    end

    local ok = pcall(function()
        writefile(path, buildLoaderContent())
    end)

    if ok and isfile(path) then
        print("[AutoExec] BERHASIL terinstall -> " .. path)
        return true
    else
        warn("[AutoExec] GAGAL menulis ke -> " .. path)
        return false
    end
end

AutoExec.Install()

return AutoExec
