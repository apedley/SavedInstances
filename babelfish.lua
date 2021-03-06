#!/usr/bin/lua

-- Prefix to all files if this script is run from a subdir, for example
local filePrefix = ""

-- luacheck: globals io

-- find . -name "*.lua" | grep -v Localization-
local fileList = {
    SavedInstances_Main = {
        "SavedInstances/SavedInstances.lua",
        "SavedInstances/Core.lua",
        "SavedInstances/BonusRoll.lua",
        "SavedInstances/Currency.lua",
        "SavedInstances/Emissary.lua",
        "SavedInstances/LFR.lua",
        "SavedInstances/MythicPlus.lua",
        "SavedInstances/Paragon.lua",
        "SavedInstances/Progress.lua",
        "SavedInstances/Quests.lua",
        "SavedInstances/Tradeskills.lua",
        "SavedInstances/Warfront.lua",
        "SavedInstances/WorldBosses.lua",
        "SavedInstances/config.lua"
    },
}

local ordered = {
    "SavedInstances_Main",
}

local function parseFile(filename)
    local strings = {}
    local file = assert(io.open(string.format("%s%s", filePrefix or "", filename), "r"), "Could not open " .. filename)
    local text = file:read("*all")
    file:close()

    for match in string.gmatch(text, "L%[\"(.-)\"%]") do
        strings[match] = true
    end
    return strings
end

-- extract data from specified lua files
for _, namespace in ipairs(ordered) do
    print(namespace)
    local ns_file = assert(io.open(namespace .. ".lua", "w"), "Error opening file")
    for _, file in ipairs(fileList[namespace]) do
        local strings = parseFile(file)

        local sorted = {}
        for k in next, strings do
            table.insert(sorted, k)
        end
        table.sort(sorted)
        if #sorted > 0 then
            for _, v in ipairs(sorted) do
                ns_file:write(string.format("L[\"%s\"] = true\n", v))
            end
        end
        print("  (" .. #sorted .. ") " .. file)
    end
    ns_file:close()
end
