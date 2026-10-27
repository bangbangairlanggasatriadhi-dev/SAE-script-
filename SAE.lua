-- ============================================================
--  AUTOEXEC INSTALLER MODULE
--  Pakai dengan cara: panggil AutoExec.Install() saat user
--  klik tombol "Install Auto-Exec" di UI kamu. JANGAN jalanin
--  otomatis tanpa persetujuan user.
-- ============================================================

local AutoExec = {}

-- ============ CONFIG ============
local HUB_URL    = "https://raw.githubusercontent.com/bangbangairlanggasatriadhi-dev/SAE-script-/refs/heads/main/Smap.lua"
local LOADER_NAME = "Security"
local HEADER     = "-- Security, don't change anything"
-- ============ DETECT EXECUTOR ============
local function detectExecutor()
    local name = "Unknown"
    pcall(function()
        if identifyexecutor then
            local n, v = identifyexecutor()
            name = tostring(n)
            if v and tostring(v) ~= "" then name = name .. " " .. tostring(v) end
        elseif syn then name = "Synapse X"
        elseif fluxus then name = "Fluxus"
        elseif delta then name = "Delta"
        elseif solara then name = "Solara"
        elseif hydrogen then name = "Hydrogen"
        elseif codex then name = "Codex"
        elseif wave then name = "Wave"
        elseif arceus then name = "Arceus X"
        end
    end)
    return name
end

-- ============ PATH AUTOEXEC ============
-- Kebanyakan executor: workspace ada di folder "workspace",
-- autoexec ada di sibling folder "../autoexec/".
-- Beberapa executor beda, kita coba beberapa kandidat.
local AUTOEXEC_CANDIDATES = {
    "../autoexec/",
    "autoexec/",
    "../../autoexec/",
}

local function findAutoexecPath()
    if not isfile or not writefile then return nil end
    for _, candidate in ipairs(AUTOEXEC_CANDIDATES) do
        local testFile = candidate .. ".ae_test_" .. os.time() .. ".txt"
        local ok = pcall(function()
            writefile(testFile, "test")
            if isfile(testFile) then
                delfile(testFile)
            end
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

-- Cek apakah autoexec support di executor ini
function AutoExec.IsSupported()
    return findAutoexecPath() ~= nil
end

-- Cek apakah sudah terinstall
function AutoExec.IsInstalled()
    local path = getLoaderPath()
    if not path then return false end
    local ok, exists = pcall(function() return isfile(path) end)
    return ok and exists == true
end

-- Install loader ke autoexec (HARUS dipanggil setelah user klik tombol)
-- Return: success (bool), message (string)
function AutoExec.Install()
    if not writefile then
        return false, "Executor tidak support writefile"
    end
    local path = getLoaderPath()
    if not path then
        return false, "Tidak bisa menemukan folder autoexec (executor tidak support)"
    end
    local ok, err = pcall(function()
        writefile(path, buildLoaderContent())
    end)
    if not ok then
        return false, "Gagal menulis file: " .. tostring(err)
    end
    -- Verifikasi
    local verifyOk, exists = pcall(function() return isfile(path) end)
    if verifyOk and exists then
        return true, "Berhasil! AutoExec terinstall di: " .. path
    else
        return false, "File tertulis tapi tidak terverifikasi"
    end
een

return AutoExec
