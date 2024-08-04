-- Define the addon namespace
local PetUncager = CreateFrame("Frame")
local MAX_PETS = 3

-- Utility function to safely extract speciesID from item link
local function GetSpeciesIDFromItemLink(link)
    if not link then return nil end
    local speciesID = string.match(link, "battlepet:(%d+)")
    return tonumber(speciesID)
end

-- Function to create a secure macro text for uncaging
local function CreateUncageMacroText()
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
                        print("|cffffa500Ready to uncage pet at bag " .. bag .. " slot " .. slot .. ".|r")
                        return macroText
                    end
                end
            end
        end
    end

    print("|cffffa500No eligible pets found to uncage.|r")
    return nil
end

-- Global function for keybinding to uncage pets
function UncagePetsAction()
    local macroText = CreateUncageMacroText()
    if macroText then
        UncageButton:SetAttribute("macrotext", macroText)
        UncageButton:Click()
    else
        print("|cffffa500No eligible pets to uncage.|r")
    end
end

-- Keybinding header and name
BINDING_HEADER_PETUNCAGER = "Pet Uncager"
BINDING_NAME_PETUNCAGER_UNCAGE_BUTTON = "Uncage Button"

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
local UncageButton = CreateFrame("Button", "PetUncagerButton", PetUncagerFrame, "SecureActionButtonTemplate, UIPanelButtonTemplate")
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
PetUncagerFrame:SetScript("OnShow", function(self)
    local keybind = GetBindingKey("PETUNCAGER_UNCAGE_BUTTON") or "Not Set"
    KeybindLabel:SetText("Current Keybind – " .. keybind)
end)

UncageButton:SetScript("PreClick", function(self)
    local macroText = CreateUncageMacroText()
    if macroText then
        -- Create or update the macro on the button securely
        self:SetAttribute("macrotext", macroText)
    else
        self:SetAttribute("macrotext", "")
    end
end)

-- Slash command to open the Pet Uncager UI
SLASH_PETUNCAGER1 = "/uncager"
SlashCmdList["PETUNCAGER"] = function()
    if PetUncagerFrame:IsShown() then
        PetUncagerFrame:Hide()
    else
        PetUncagerFrame:Show()
        local keybind = GetBindingKey("PETUNCAGER_UNCAGE_BUTTON") or "Not Set"
        KeybindLabel:SetText("Current Keybind – " .. keybind)
    end
end

-- Set up event handlers
PetUncager:RegisterEvent("PLAYER_LOGIN")
PetUncager:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        print("|cffffa500PetUncager loaded. Use /uncager to open the UI or set up a keybind in the Key Bindings menu.|r")
    end
end)

-- Only add this new function, keep the rest of the file as it was

-- Function to handle button click
local function OnButtonClick(self, button, down)
    if button == "LeftButton" and down then
        UncagePetsAction()
    end
end

-- Update the UncageButton creation
local UncageButton = CreateFrame("Button", "PetUncagerButton", PetUncagerFrame, "SecureActionButtonTemplate, UIPanelButtonTemplate")
UncageButton:SetSize(220, 40)
UncageButton:SetPoint("CENTER", PetUncagerFrame, "CENTER", 0, 10)
UncageButton:SetText("Uncage Pets – Spam me")
UncageButton:SetNormalFontObject("GameFontNormal")
UncageButton:SetAttribute("type", "click")
UncageButton:SetScript("OnClick", OnButtonClick)

-- Rest of the file remains the same