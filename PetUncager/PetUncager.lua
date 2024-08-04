local MACRO_NAME = "PetUncagerMacro"
local MACRO_ICON = "INV_MISC_QUESTIONMARK"
local MAX_PETS = 3

-- Utility function to safely extract speciesID from item link
local function GetSpeciesIDFromItemLink(link)
    if not link then return nil end
    local speciesID = string.match(link, "battlepet:(%d+)")
    return tonumber(speciesID)
end

-- Function to ensure the macro is created
local function EnsureMacroExists()
    local macroIndex = GetMacroIndexByName(MACRO_NAME)
    if macroIndex == 0 then
        -- Try to create the macro
        local numGlobalMacros, numPerCharMacros = GetNumMacros()
        local macroCreated = false

        -- Check if there's space for a new macro
        if numPerCharMacros < 18 then
            macroCreated = CreateMacro(MACRO_NAME, MACRO_ICON, "/run PetUncager_Process()", nil)
        elseif numGlobalMacros < 120 then
            macroCreated = CreateMacro(MACRO_NAME, MACRO_ICON, "/run PetUncager_Process()", 1)
        end

        if macroCreated then
            print("|cffffa500PetUncager macro created successfully.|r")
        else
            print("|cffffa500Could not create PetUncager macro: Macro limit reached.|r")
        end
    else
        -- Update the existing macro to ensure it has the correct command
        EditMacro(macroIndex, MACRO_NAME, MACRO_ICON, "/run PetUncager_Process()", 1)
    end
end

-- Function to update the macro with a specific pet
local function UpdateMacroAndUse(petSlot)
    local macroIndex = GetMacroIndexByName(MACRO_NAME)
    if macroIndex == 0 then
        EnsureMacroExists()
        macroIndex = GetMacroIndexByName(MACRO_NAME)
    end

    if macroIndex ~= 0 then
        -- Update the macro to use the item immediately and prepare for next use
        local macroText = string.format("/use %s %s\n/run C_Timer.After(0.1, PetUncager_Process)", petSlot.bag, petSlot.slot)
        EditMacro(macroIndex, MACRO_NAME, MACRO_ICON, macroText, 1)
    end
end

-- Function to count uncageable and maxed-out pets
local function CountPets()
    local uncageableCount = 0
    local threeOfAKindCount = 0

    -- Check bags
    for bag = 0, 4 do
        local numSlots = C_Container.GetContainerNumSlots(bag)
        for slot = 1, numSlots do
            local itemInfo = C_Container.GetContainerItemInfo(bag, slot)
            if itemInfo and itemInfo.itemID == 82800 then
                local petLink = itemInfo.hyperlink
                local speciesID = GetSpeciesIDFromItemLink(petLink)
                if speciesID then
                    local numCollected = C_PetJournal.GetNumCollectedInfo(speciesID)
                    if numCollected then
                        if numCollected < MAX_PETS then
                            uncageableCount = uncageableCount + 1
                        elseif numCollected == MAX_PETS then
                            threeOfAKindCount = threeOfAKindCount + 1
                        end
                    end
                end
            end
        end
    end

    return uncageableCount, threeOfAKindCount
end

-- Main function to uncage pets
function PetUncager_Process()
    local petFound = false
    for bag = 0, 4 do
        local numSlots = C_Container.GetContainerNumSlots(bag)
        for slot = 1, numSlots do
            local itemInfo = C_Container.GetContainerItemInfo(bag, slot)
            if itemInfo and itemInfo.itemID == 82800 then
                local petLink = itemInfo.hyperlink
                local speciesID = GetSpeciesIDFromItemLink(petLink)
                
                if speciesID then
                    local numCollected = C_PetJournal.GetNumCollectedInfo(speciesID)
                    
                    if numCollected and numCollected < MAX_PETS then
                        UpdateMacroAndUse({ bag = bag, slot = slot })
                        petFound = true
                        return
                    end
                end
            end
        end
    end

    if not petFound then
        local _, threeOfAKindCount = CountPets()
        local petWord = (threeOfAKindCount == 1) and "pet" or "pets"
        print("|cffffa500No further eligible pets found - " .. threeOfAKindCount .. " remaining 3/3 " .. petWord .. " in bags.|r")
        -- Reset macro to not perform unnecessary actions
        local macroIndex = GetMacroIndexByName(MACRO_NAME)
        if macroIndex ~= 0 then
            EditMacro(macroIndex, MACRO_NAME, MACRO_ICON, "/run PetUncager_Process()", 1)
        end
    end
end

-- Slash command to run the uncager
SLASH_PETUNCAGER1 = "/petuncager"
SlashCmdList["PETUNCAGER"] = PetUncager_Process

-- Bind the function to key press
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
    EnsureMacroExists()  -- Ensure the macro is created on login
    local uncageableCount, threeOfAKindCount = CountPets()
    local petWord = (threeOfAKindCount == 1) and "pet" or "pets"
    -- Print a concise initial summary
    print("|cffffa500PetUncager stats:|r")
    print("|cffffa500" .. uncageableCount .. " pets can be added to your journal.|r")
    print("|cffffa500" .. threeOfAKindCount .. " " .. petWord .. " are already at 3/3 in bags.|r")
end)
