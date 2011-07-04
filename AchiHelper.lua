AchiHelper = LibStub("AceAddon-3.0"):NewAddon("AchiHelper", "AceConsole-3.0", "AceHook-3.0", "AceEvent-3.0")

-- Time until raid table cleanup in seconds
AchiHelper.CleanupTime = 60

-- Achievement priority list
AchiHelper.Regex = {

	-- Firelands
	[{"fl", "fire", "firelands"}] = {
		5802,	-- Firelands
		5806,	-- Herioc: Shannox
		5807,	-- Heroic: Beth'tilac
		5808,	-- Heroic: Lord Rhyolith
		5805,	-- Heroic: Baleroc
		5809,	-- Heroic: Alysrazor
		5804,	-- Heroic: Majordomo Fandral Staghelm
		5803,	-- Heroic: Ragnaros
		5828,	-- Glory of the Firelands Raider
	},

	-- Blackwing Descent
	["bwd"] = {
		4842,	-- Blackwing Descent
		5115,	-- Heroic: Chimaeron
		5109,	-- Heroic: Atramedes
		5108,	-- Heroic: Maloriak
		5094,	-- Heroic: Magmaw
		5107,	-- Heroic: Omnotron Defense System
		5116, 	-- Heroic: Nefarian
	},
	
	-- Bastion of Twilight
	["bot"] = {
		4850,	-- The Bastion of Twilight
		5118, 	-- Heroic: Halfus Wyrmbreaker
		5117, 	-- Heroic: Valiona and Theralion
		5120,	-- Heroic: Cho'gall
		5119,	-- Heroic: Ascendant Council
		5121,	-- Heroic: Sinestra
		5313,	-- I Can't Hear You Over the Sound of How Awesome I Am
	},
	
	-- Throne of the Four Winds
	[{"totfw", "tot4w", "tofu"}] = {
		4851,	-- Throne of the Four Winds
		5122,	-- Heroic: Conclave of Wind
		5123,	-- Heroic: Al'Akir
	},
	
	-- Baradin Hold	
	["bh"] = {
		5416,	-- Pit Lord Argaloth
				-- Occu'thar
	},
	
}

AchiHelper.ShouldInsertAchievement = false
AchiHelper.Raids = { }

function AchiHelper:OnEnable()
	-- Events
	self:RegisterEvent("CHAT_MSG_CHANNEL")
	
	-- Hooks for handling chat input
	self:SecureHook("ChatEdit_UpdateHeader")
	self:RawHook("ChatFrame_SendTell", true)
end

function AchiHelper:CHAT_MSG_CHANNEL(event, msg, author, language, channel, target, flag, zoneID, nChannel, channelName, lineID, guID)
	local msg = string.lower(msg)
	if (nChannel == 2 or nChannel == 4 or true) then
		if (string.find(msg, "lfg") == nil) then
			local bestAchievement = 0

			--[[for regex,achids in pairs(self.Regex) do
				if (string.find(msg, regex) ~= nil) then
					for _,ids in pairs(achids) do
						local _, _, _, completed_10 = GetAchievementInfo(ids[1])
						local _, _, _, completed_25 = GetAchievementInfo(ids[2])
						
						if (completed_10) then
							bestAchievement = ids[1]
						end
						
						if (completed_25) then
							bestAchievement = ids[2]
						end
					end

					
					--break;
				end
			end]]--
			
			for regex,achids in pairs(self.Regex) do
				local matched = false
				if (type(regex) == "table") then
					for k,v in pairs(regex) do
						if (string.find(msg, v) ~= nil) then
							matched = true
							break
						end
					end
				else
					if (string.find(msg, regex) ~= nil) then
						matched = true
					end	
				end
				
				if (matched) then
					for _,id in pairs(achids) do
						-- Did we complete the achievement?
						local _, _, _, completed = GetAchievementInfo(id)
						
						-- See how many criteria we've completed
						local completedCriteria = 0
						for i=1,GetAchievementNumCriteria(id) do
							local _, _, crit_completed = GetAchievementCriteriaInfo(id, i)
							if (crit_completed) then
								completedCriteria = completedCriteria + 1
							end
						end
						
						if (completed or completedCriteria > 0) then
							bestAchievement = id
						end
					end
				end
			end
			
			if (bestAchievement ~= 0) then
				self.Raids[author] = {}
				self.Raids[author]["achid"] = bestAchievement
				self.Raids[author]["time"] = GetTime()
			end
			--[[if (not string.find(msg, "lfg") and string.find(msg, "icc%s*10")) then
				self:Print("Found ICC run: " .. author .. " - " .. msg)
			end]]
		end
	end
	
	-- Clean up the raid table
	for k,v in pairs(self.Raids) do
		if (v ~= nil and v["time"] + self.CleanupTime <= GetTime()) then
			--self:Print("Cleaning up after " .. k)
			self.Raids[k] = nil
		end
	end
end

function AchiHelper:ChatEdit_UpdateHeader(editBox)
	DEFAULT_CHAT_FRAME.editBox:SetCursorPosition(0)
end

-- Modified blizzard ChatFrame_SendTell
function AchiHelper:ChatFrame_SendTell(name, chatFrame)
	local editBox = ChatEdit_ChooseBoxForSend(chatFrame);
	
	
	-- Prepare the achievement
	local achievement = ""
	if (self.Raids[name] ~= nil) then
		achievement = " " .. GetAchievementLink(self.Raids[name]["achid"])
	end
	
	local text = SLASH_WHISPER1 .. " " .. name .. " " .. achievement
	
	if ( editBox ~= ChatEdit_GetActiveWindow() ) then
		ChatFrame_OpenChat(text, chatFrame);
	else
		editBox:SetText(text);
	end
	ChatEdit_ParseText(editBox, 0);
	
	editBox:SetCursorPosition(0)
	--self:Print("Reply to " .. name)
end