local addonName, GCT = ...

local L = GCT.localization
local Utils = GCT.utils
local Dialog = GCT.dialog

local Options = {}

----------------------
--- Local Funtions ---
----------------------

local minimapProxy = setmetatable({}, {
    __index = function(_, key)
        if key == "minimap-button-hide" then
            return not GCT.data.options["minimap-button-hide"]
        else
            return GCT.data.options[key]
        end
    end,
    __newindex = function(_, key, value)
        if key == "minimap-button-hide" then
            GCT.data.options["minimap-button-hide"] = not value

            if value then
                Utils.minimapButton:Show("GoldCurrencyTracker")
            else
                Utils.minimapButton:Hide("GoldCurrencyTracker")
            end
        elseif key == "minimap-button-position" then
            GCT.data.options["minimap-button-position"] = value

            local zone = {
                hide = GCT.data.options["minimap-button-hide"],
                minimapPos = GCT.data.options["minimap-button-position"],
            }

            Utils.minimapButton:Refresh("GoldCurrencyTracker", zone)
            Utils.minimapButton:Lock("GoldCurrencyTracker")
        else
            GCT.data.options[key] = value
        end
    end,
})

---------------------
--- Main Funtions ---
---------------------

function Options:Initialize()
    local offsetY = -20
    local spacing = 30

    local backdrop = {
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Friendsframe\\UI-Toast-Border",
        tileEdge = true,
        edgeSize = 8,
    }

    local canvasFrame = CreateFrame("Frame", nil, UIParent)

    local header = canvasFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightHuge")
    header:SetPoint("TOPLEFT", canvasFrame, 7, -22)
    header:SetText(L["addon.name"])

    local scrollFrame = CreateFrame("ScrollFrame", nil, canvasFrame, "QuestScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", canvasFrame, "TOPLEFT", 0, -54)
    scrollFrame:SetPoint("BOTTOMRIGHT", canvasFrame, "BOTTOMRIGHT", -29, 0)

    local scrollView = CreateFrame("Frame")
    scrollView:SetSize(1, 1)
    scrollFrame:SetScrollChild(scrollView)

    do
        local descriptionFrame = CreateFrame("Frame", nil, scrollView, "BackdropTemplate")
        descriptionFrame:ClearAllPoints()
        descriptionFrame:SetPoint("TOPLEFT", scrollView, "TOPLEFT", 10, offsetY)
        descriptionFrame:SetWidth(615)
        descriptionFrame:SetBackdrop(backdrop)
        descriptionFrame:SetBackdropColor(0,0,0,0.2)

        descriptionFrame.title = descriptionFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        descriptionFrame.title:SetPoint("TOPLEFT", 8, 15)
        descriptionFrame.title:SetText(L["info.description"])

        local text = descriptionFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        text:SetPoint("TOPLEFT", descriptionFrame, "TOPLEFT", 15, -15)
        text:SetPoint("TOPRIGHT", descriptionFrame, "TOPRIGHT",  -15, -15)
        text:SetWidth(descriptionFrame:GetWidth() - 30)
        text:SetJustifyH("LEFT")
        text:SetSpacing(2)
        text:SetWordWrap(true)
        text:SetText(L["info.description.text"])

        local totalHeight = text:GetHeight() + 30
        descriptionFrame:SetHeight(totalHeight)

        offsetY = offsetY - descriptionFrame:GetHeight() - spacing
    end

    do
        local helpFrame = CreateFrame("Frame", nil, scrollView, "BackdropTemplate")
        helpFrame:ClearAllPoints()
        helpFrame:SetPoint("TOPLEFT", scrollView, "TOPLEFT", 10, offsetY)
        helpFrame:SetWidth(615)
        helpFrame:SetBackdrop(backdrop)
        helpFrame:SetBackdropColor(0,0,0,0.2)

        helpFrame.title = helpFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        helpFrame.title:SetPoint("TOPLEFT", 8, 15)
        helpFrame.title:SetText(L["info.help"])

        local text = helpFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        text:SetPoint("TOPLEFT", helpFrame, "TOPLEFT", 15, -15)
        text:SetPoint("TOPRIGHT", helpFrame, "TOPRIGHT",  -15, -15)
        text:SetWidth(helpFrame:GetWidth() - 30)
        text:SetJustifyH("LEFT")
        text:SetSpacing(2)
        text:SetWordWrap(true)
        text:SetText(L["info.help.text"])

        local divider = helpFrame:CreateTexture(nil, "BACKGROUND")
        divider:SetPoint("TOP", text, "BOTTOM", 0, -10)
        divider:SetSize(550, 6)
        divider:SetAtlas("thewarwithin-scenario-line-top-glowing")
        divider:SetDesaturated(true)
        divider:SetVertexColor(Utils:HexToRGB("ffB9B9B9"))

        local buttonReset = CreateFrame("Button", nil, helpFrame, "UIPanelButtonTemplate")
        buttonReset:SetPoint("TOP", divider, "BOTTOM", 0, -10)
        buttonReset:SetSize(200, 22)
        buttonReset:SetText(L["info.help.reset-button.name"])
        buttonReset:SetScript("OnClick", function(self)
            Dialog:ShowResetOptionsDialog()
        end)
        buttonReset:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
            GameTooltip:SetText(L["info.help.reset-button.name"], 1, 1, 1, true)
            GameTooltip:AddLine(L["info.help.reset-button.desc"], true)
            GameTooltip:Show()
        end)
        buttonReset:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)

        local totalHeight = text:GetHeight() + 48 + 30
        helpFrame:SetHeight(totalHeight)

        offsetY = offsetY - helpFrame:GetHeight() - spacing
    end

    do
        local aboutFrame = CreateFrame("Frame", nil, scrollView, "BackdropTemplate")
        aboutFrame:ClearAllPoints()
        aboutFrame:SetPoint("TOPLEFT", scrollView, "TOPLEFT", 10, offsetY)
        aboutFrame:SetWidth(615)
        aboutFrame:SetBackdrop(backdrop)
        aboutFrame:SetBackdropColor(0,0,0,0.2)

        aboutFrame.title = aboutFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        aboutFrame.title:SetPoint("TOPLEFT", 8, 15)
        aboutFrame.title:SetText(L["info.about"])

        local text = aboutFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        text:SetPoint("TOPLEFT", aboutFrame, "TOPLEFT", 15, -15)
        text:SetPoint("TOPRIGHT", aboutFrame, "TOPRIGHT",  -15, -15)
        text:SetWidth(aboutFrame:GetWidth() - 30)
        text:SetJustifyH("LEFT")
        text:SetSpacing(2)
        text:SetWordWrap(true)
        text:SetText(L["info.about.text"]:format(GCT.GOLD_FONT_COLOR, GCT.GAME_VERSION .. " (" .. GCT.GAME_FLAVOR .. ")", GCT.GOLD_FONT_COLOR, GCT.ADDON_VERSION .. " (" .. GCT.ADDON_BUILD_DATE .. ")", GCT.GOLD_FONT_COLOR, GCT.ADDON_AUTHOR))

        local divider = aboutFrame:CreateTexture(nil, "BACKGROUND")
        divider:SetPoint("TOP", text, "BOTTOM", 0, -10)
        divider:SetSize(550, 6)
        divider:SetAtlas("thewarwithin-scenario-line-top-glowing")
        divider:SetDesaturated(true)
        divider:SetVertexColor(Utils:HexToRGB("ffB9B9B9"))

        local buttonGithub = CreateFrame("Button", nil, aboutFrame, "UIPanelButtonTemplate")
        buttonGithub:SetPoint("TOP", divider, "BOTTOM", -100, -10)
        buttonGithub:SetSize(150, 22)
        buttonGithub:SetText(L["info.help.github-button.name"])
        buttonGithub:SetScript("OnClick", function(self)
            Dialog:ShowCopyAddressDialog(GCT.LINK_GITHUB)
        end)
        buttonGithub:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
            GameTooltip:SetText(L["info.help.github-button.name"], 1, 1, 1, true)
            GameTooltip:AddLine(L["info.help.github-button.desc"], true)
            GameTooltip:Show()
        end)
        buttonGithub:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)

        local buttonCurseforge = CreateFrame("Button", nil, aboutFrame, "UIPanelButtonTemplate")
        buttonCurseforge:SetPoint("TOP", divider, "BOTTOM", 100, -10)
        buttonCurseforge:SetSize(150, 22)
        buttonCurseforge:SetText(L["info.help.curseforge-button.name"])
        buttonCurseforge:SetScript("OnClick", function(self)
            Dialog:ShowCopyAddressDialog(GCT.LINK_CURSEFORGE)
        end)
        buttonCurseforge:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
            GameTooltip:SetText(L["info.help.curseforge-button.name"], 1, 1, 1, true)
            GameTooltip:AddLine(L["info.help.curseforge-button.desc"], true)
            GameTooltip:SetWidth(200)
            GameTooltip:SetHeight(200)
            GameTooltip:Show()
        end)
        buttonCurseforge:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)

        local totalHeight = text:GetHeight() + 48 + 30
        aboutFrame:SetHeight(totalHeight)

        local lastLine = aboutFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        lastLine:SetPoint("TOPLEFT", aboutFrame, "BOTTOMLEFT", 0, -10)
    end

    local mainCategory = Settings.RegisterCanvasLayoutCategory(canvasFrame, L["addon.name"])
    mainCategory.ID = L["addon.name"]

    local variableTable = GCT.data.options
    local category, layout = Settings.RegisterVerticalLayoutSubcategory(mainCategory, L["options"])

    local parentSettingMinimapButton

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L["options.general"]))

    do
        local name = L["options.open-on-login.name"]
        local tooltip = L["options.open-on-login.tooltip"]
        local variable = "open-on-login"
        local defaultValue = false

        local setting = Settings.RegisterAddOnSetting(category, addonName .. "_" .. variable, variable, variableTable, Settings.VarType.Boolean, name, defaultValue)
        Settings.CreateCheckbox(category, setting, tooltip)
    end

    do
        local name = L["options.minimap-button-hide.name"]
        local tooltip = L["options.minimap-button-hide.tooltip"]
        local variable = "minimap-button-hide"
        local defaultValue = false

        local setting = Settings.RegisterAddOnSetting(category, addonName .. "_" .. variable, variable, minimapProxy, Settings.VarType.Boolean, name, not defaultValue)
        parentSettingMinimapButton = Settings.CreateCheckbox(category, setting, tooltip)
    end

    do
        local name = L["options.minimap-button-position.name"]
        local tooltip = L["options.minimap-button-position.tooltip"]
        local variable = "minimap-button-position"
        local defaultValue = 250

        local minValue = 0
        local maxValue = 360
        local step = 1

        local setting = Settings.RegisterAddOnSetting(category, addonName .. "_" .. variable, variable, minimapProxy, Settings.VarType.Number, name, defaultValue)
        local options = Settings.CreateSliderOptions(minValue, maxValue, step)

        options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
        local subSetting = Settings.CreateSlider(category, setting, options, tooltip)

        subSetting:SetParentInitializer(parentSettingMinimapButton, function() return not GCT.data.options["minimap-button-hide"] end)
    end

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L["options.other"]))

    do
        local name = L["options.debug-mode.name"]
        local tooltip = L["options.debug-mode.tooltip"]
        local variable = "debug-mode"
        local defaultValue = false

        local setting = Settings.RegisterAddOnSetting(category, addonName .. "_" .. variable, variable, variableTable, Settings.VarType.Boolean, name, defaultValue)
        Settings.CreateCheckbox(category, setting, tooltip)
    end

    Settings.RegisterAddOnCategory(mainCategory)
end

GCT.options = Options
