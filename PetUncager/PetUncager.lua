-- Define the addon namespace
local PetUncager = CreateFrame("Frame")
local MAX_PETS = 3

-- Keybinding header and name
BINDING_HEADER_PETUNCAGER = "Pet Uncager"
BINDING_NAME_CLICK_UncageButton_LeftButton = "Uncage Pets Button"

-- Utility function to safely extract speciesID from item link
local function GetSpeciesIDFromItemLink(link)
    if not link then return nil end
    local speciesID = string.match(link, "battlepet:(%d+)")
    return tonumber(speciesID)
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

-- Function to create a secure macro text for uncaging
function CreateUncageMacroText()
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
                        -- Create a macro to use the item in the next available slot
                        local macroText = string.format("/use %d %d", bag, slot)
                        return macroText
                    end
                end
            end
        end
    end

    -- If no pets are found
    local _, threeOfAKindCount = CountPets()
    local petWord = (threeOfAKindCount == 1) and "pet" or "pets"
    print("|cffffa500No further eligible pets found - " .. threeOfAKindCount .. " remaining 3/3 " .. petWord .. " in bags.|r")
    return nil
end

-- Global function for keybinding to uncage pets
function UncagePetsAction()
    local macroText = CreateUncageMacroText()
    if macroText then
        UncageButton:SetAttribute("macrotext", macroText)
        UncageButton:Click() -- Simulate a button click
    else
        print("|cffffa500No eligible pets to uncage.|r")
    end
end

-- Create a frame for the interface window
local PetUncagerFrame = CreateFrame("Frame", "PetUncagerFrame", UIParent, "BasicFrameTemplateWithInset")
PetUncagerFrame:SetSize(300, 150)
PetUncagerFrame:SetPoint("CENTER", UIParent, "CENTER")
PetUncagerFrame:Hide()

-- Create a title for the window
PetUncagerFrame.title = PetUncagerFrame:CreateFontString(nil, "OVERLAY")
PetUncagerFrame.title:SetFontObject("GameFontHighlight")
PetUncagerFrame.title:SetPoint("LEFT", PetUncagerFrame.TitleBg, "LEFT", 5, 0)
PetUncagerFrame.title:SetText("Pet Uncager")

-- Create a secure action button within the frame
local UncageButton = CreateFrame("Button", "UncageButton", PetUncagerFrame, "SecureActionButtonTemplate, UIPanelButtonTemplate")
UncageButton:SetSize(220, 40)
UncageButton:SetPoint("CENTER", PetUncagerFrame, "CENTER", 0, 10)
UncageButton:SetText("Uncage Pets – Spam me")
UncageButton:SetNormalFontObject("GameFontNormal")
UncageButton:SetAttribute("type", "macro")

-- Create a label for the current keybind
local KeybindLabel = PetUncagerFrame:CreateFontString(nil, "OVERLAY")
KeybindLabel:SetFontObject("GameFontHighlightSmall")
KeybindLabel:SetPoint("TOP", UncageButton, "BOTTOM", 0, -10)
KeybindLabel:SetText("Current Keybind – Not Set")

-- Update keybind text when the frame is shown
UncageButton:SetScript("OnShow", function(self)
    local keybind = GetBindingKey("CLICK UncageButton:LeftButton") or "Not Set"
    KeybindLabel:SetText("Current Keybind – " .. keybind)
end)

UncageButton:SetScript("PreClick", function(self)
    local macroText = CreateUncageMacroText()
    if macroText then
        self:SetAttribute("macrotext", macroText)
    else
        self:SetAttribute("macrotext", "")
    end
end)

UncageButton:SetScript("PostClick", function(self)
    -- Reset the macrotext to ensure it updates next time
    self:SetAttribute("macrotext", "")
end)

-- Slash command to open the Pet Uncager UI
SLASH_PETUNCAGER1 = "/uncager"
SlashCmdList["PETUNCAGER"] = function()
    if PetUncagerFrame:IsShown() then
        PetUncagerFrame:Hide()
    else
        PetUncagerFrame:Show()
        local keybind = GetBindingKey("CLICK UncageButton:LeftButton") or "Not Set"
        KeybindLabel:SetText("Current Keybind – " .. keybind)
    end
end

-- Set up event handlers
PetUncager:RegisterEvent("PLAYER_LOGIN")
PetUncager:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        local uncageableCount, threeOfAKindCount = CountPets()
        local petWord = (threeOfAKindCount == 1) and "pet" or "pets"
        -- Print a concise initial summary
        print("|cffffa500PetUncager stats:|r")
        print("|cffffa500" .. uncageableCount .. " pets can be added to your journal.|r")
        print("|cffffa500" .. threeOfAKindCount .. " " .. petWord .. " are already at 3/3 in bags.|r")
        print("|cffffa500Use /uncager to open the Pet Uncager UI.|r")
    end
end)
