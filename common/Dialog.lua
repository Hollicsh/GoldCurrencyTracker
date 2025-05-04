local _, GCT = ...

local L =  GCT.localization
local Utils = GCT.utils

local Dialog = {}

local copyAddressDialog
local resetOptionsDialog

---------------------
--- Main Funtions ---
---------------------

function Dialog:ShowCopyAddressDialog(address)
    if not copyAddressDialog then
        copyAddressDialog = CreateFrame("Frame", "GCT_CopyAddressDialog", UIParent, "TranslucentFrameTemplate")
        copyAddressDialog:SetSize(400, 10)
        copyAddressDialog:SetPoint("CENTER", 0, 200)

        copyAddressDialog:SetFrameStrata("DIALOG")
        copyAddressDialog:SetFrameLevel(1000)
        copyAddressDialog:SetClampedToScreen(true)

        tinsert(UISpecialFrames, copyAddressDialog:GetName())

        local text = copyAddressDialog:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        text:SetPoint("TOPLEFT", copyAddressDialog, "TOPLEFT", 20, -20)
        text:SetPoint("TOPRIGHT", copyAddressDialog, "TOPRIGHT",  -20, -20)
        text:SetJustifyH("CENTER")
        text:SetWordWrap(true)
        text:SetText(L["dialog.copy-address.text"])

        local editBox = CreateFrame("EditBox", nil, copyAddressDialog, "InputBoxTemplate")
        editBox:SetPoint("TOP", text, "BOTTOM", 0, -10)
        editBox:SetSize(340, 20)
        editBox:SetAutoFocus(false)
        editBox:SetScript("OnEnterPressed", function(self)
            self:ClearFocus()
        end)
        copyAddressDialog.editBox = editBox

        local buttonClose = CreateFrame("Button", nil, copyAddressDialog, "UIPanelButtonTemplate")
        buttonClose:SetSize(100, 22)
        buttonClose:SetPoint("TOP", editBox, "BOTTOM", 0, -10)
        buttonClose:SetText(CLOSE)
        buttonClose:SetScript("OnClick", function()
            copyAddressDialog:Hide()
        end)

        local totalHeight = copyAddressDialog:GetTop() - buttonClose:GetBottom() + 20
        copyAddressDialog:SetHeight(totalHeight)
    end

    copyAddressDialog.editBox:SetText(address or "")
    copyAddressDialog.editBox:HighlightText()
    copyAddressDialog:Show()
end

function Dialog:ShowResetOptionsDialog()
    if not resetOptionsDialog then
        resetOptionsDialog = CreateFrame("Frame", "GCT_ResetOptionsDialog", UIParent, "TranslucentFrameTemplate")
        resetOptionsDialog:SetSize(350, 10)
        resetOptionsDialog:SetPoint("CENTER", 0, 200)

        resetOptionsDialog:SetFrameStrata("DIALOG")
        resetOptionsDialog:SetFrameLevel(1000)
        resetOptionsDialog:SetClampedToScreen(true)

        tinsert(UISpecialFrames, resetOptionsDialog:GetName())

        local text = resetOptionsDialog:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        text:SetPoint("TOPLEFT", resetOptionsDialog, "TOPLEFT", 20, -20)
        text:SetPoint("TOPRIGHT", resetOptionsDialog, "TOPRIGHT",  -20, -20)
        text:SetWordWrap(true)
        text:SetJustifyH("CENTER")
        text:SetText(L["dialog.reset-options.text"])

        local buttonYes = CreateFrame("Button", nil, resetOptionsDialog, "UIPanelButtonTemplate")
        buttonYes:SetPoint("TOP", text, "BOTTOM", -75, -10)
        buttonYes:SetSize(100, 22)
        buttonYes:SetText(YES)
        buttonYes:SetScript("OnClick", function()
            local options = GCT.data.options
            options["open-on-login"] = false
            options["minimap-button-hide"] = false
            options["minimap-button-position"] = 250
            options["debug-mode"] = false

            local zone = {
                hide = options["minimap-button-hide"],
                minimapPos = options["minimap-button-position"],
            }

            Utils.minimapButton:Refresh("GoldCurrencyTracker", zone)
            Utils.minimapButton:Lock("GoldCurrencyTracker")

            GCT.utils:PrintMessage(L["chat.reset-options.success"])
            resetOptionsDialog:Hide()
        end)

        local buttonNo = CreateFrame("Button", nil, resetOptionsDialog, "UIPanelButtonTemplate")
        buttonNo:SetPoint("TOP", text, "BOTTOM", 75, -10)
        buttonNo:SetSize(100, 22)
        buttonNo:SetText(CANCEL)
        buttonNo:SetScript("OnClick", function()
            resetOptionsDialog:Hide()
        end)

        local totalHeight = resetOptionsDialog:GetTop() - buttonNo:GetBottom() + 20
        resetOptionsDialog:SetHeight(totalHeight)
    end

    resetOptionsDialog:Show()
end

GCT.dialog = Dialog