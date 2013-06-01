AchiHelper = LibStub("AceAddon-3.0"):NewAddon("AchiHelper", "AceConsole-3.0", "AceHook-3.0", "AceEvent-3.0")

-- Time until raid table cleanup in seconds
AchiHelper.CleanupTime = 60

-- Achievement priority list
AchiHelper.Regex = {
	--[[
		Happy Panda Land
	]]--
	
	-- Rated Battleground
	["rbg"] = {
		-- Horde
		5345,	-- Scout
		5346,	-- Grunt
		5347,	-- Sergeant
		5348,	-- Senior Sergeant
		5349,	-- First Sergeant
		5350,	-- Stone Guard
		5351, 	-- Blood Guard
		5352,	-- Legionnaire
		5338,	-- Centurion
		5353,	-- Champion
		5354,	-- Lieutenant General
		5355,	-- General
		5342,	-- Warlord
		5356,	-- High Warlord
		6941,	-- Hero of the Horde
		
		-- Alliance
		5330,	-- Private
		5331,	-- Corporal
		5332,	-- Sergeant
		5333,	-- Master Sergeant
		5334,	-- Sergeant Major
		5335,	-- Knight
		5336, 	-- Knight-Lieutenant
		5337,	-- Knight-Captain
		5338,	-- Knight-Champion
		5339,	-- Lieutenant Commander
		5340,	-- Commander
		5341,	-- Marshal
		5357,	-- Field Marshal
		5343,	-- Grand Marshal
		6942,	-- Hero of the Alliance
	},
	
	-- Terrace of Endless Spring
	[{"terrace of endless spring", "terrace", "toes", "tes"}] = {
		6689,	-- Terrace of Endless Spring
		6731,	-- Heroic: Protectors of the Endless
		6733, 	-- Heroic: Lei Shi
		6732, 	-- Heroic: Tsulong
		6734,	-- Heroic: Sha of Fear
		7487,	-- Cutting Edge: Sha of Fear
		6678,	-- Realm First! Sha of Fear
	},
	
	-- Heart of Fear
	[{"heart of fear", "hof", "hf"}] = {
		6718,	-- The Dread Approach
		6845, 	-- Nightmare of Shek'zeer
		6669,	-- Heart of Fear Guild Run
		6725, 	-- Heroic: Imperial Vizier Zor'lok
		6726,	-- Heroic: Blade Lord Ta'yak
		6727,	-- Heroic: Garalon
		6728,	-- Heroic: Wind Lord Mel'jarak
		6729, 	-- Heroic: Amber-Shaper Un'sok
		6730,	-- Heroic: Grand Empress Shek'zeer
		7486, 	-- Cutting Edge: Grand Empress Shek'zeer
		6679,	-- Realm First! Grand Empress Shek'zeer
	},
	
	-- Mogu'shan Vaults
	[{"mogu'shan vaults", "mogushan vaults", "mv", "msv", "mgsv"}] = {
		6458,	-- Guardians of Mogu'shan
		6844,	-- The Vault of Mysteries
		6668, 	-- Mogu'shan Vaults Guild Run
		6719,	-- Heroic: Stone Guard
		6720,	-- Heroic: Feng the Accursed
		6721,	-- Heroic: Gara'jal the Spiritbinder
		6722,	-- Heroic: Four Kings
		6723,	-- Heroic: Elegon
		6724,	-- Heroic: Will of the Emperor	
		7485,	-- Cutting Edge: Will of the Emperor
		6680,	-- Realm First! Will of the Emperor
	},
	
	-- World Boss: Salyis's Warband (Galleon)
	[{"galleon"}] = {
		6517, 	-- Extinction Event
	},
	
	-- World Boss: Sha of Anger
	[{"sha of anger"}] = {
		6480, 	-- Settle Down, Bro
	},	
	
	--[[
		Cataslysm
	]]--
	-- Dragon Soul
	[{"ds", "dragon soul", "dragons soul", "DS10", "DS25"}] = {
		6107, -- Fall of Deathwing
		6177, -- Destroyer's End
		6109, -- Heroic: Morchok
		6111, -- Heroic: Yor'sahj the Unsleeping
		6113, -- Heroic: Ultraxion
		6112, -- Heroic: Hagara the Stormbinder
		6110, -- Heroic: Warlord Zon'ozz
		6114, -- Heroic: Warmaster Blackhorn
		6115, -- Heroic: Spine of Deathwing
		6116, -- Heroic: Madness of Deathwing
	},
	
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
			
			for regex,achids in pairs(self.Regex) do
				if (type(regex) ~= "table") then
					regex = {regex}
				end
				
				local matched = false
				for k,v in pairs(regex) do
					-- Beginning of string
					if (string.find(msg, "^" .. v .. "%s?%d*%s+") ~= nil) then
						matched = true
						break
					end	
					-- Middle of string
					if (string.find(msg, ".+%s" .. v .. "%s?%d*%s+") ~= nil) then
						matched = true
						break
					end
					-- End of string
					if (string.find(msg, ".+%s" .. v .. "%s?%d*$") ~= nil) then
						matched = true
						break
					end
				end
				
				if (matched) then
					self.Raids[author] = {}
					
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
					
					self.Raids[author]["achid"] = bestAchievement
					self.Raids[author]["time"] = GetTime()
				end
			end
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
	local editBox = ChatEdit_ChooseBoxForSend(chatFrame)
	
	local text
	if (self.Raids[name] ~= nil) then
		local class, lclass = UnitClass("player")
		local id, spec_name, description, icon, background, role = GetSpecializationInfo(GetSpecialization())

		local ilvl_total, ilvl_equipped = GetAverageItemLevel()
		ilvl_total = floor(ilvl_total + .5)
		ilvl_equipped = floor(ilvl_equipped + .5)
		
		text = SLASH_WHISPER1 .. " " .. name .. " " .. ilvl_equipped .. " " .. spec_name .. " " .. class
	
		-- Prepare the achievement
		if (self.Raids[name]["achid"] ~= 0) then
			local achievement = " " .. GetAchievementLink(self.Raids[name]["achid"])
			text = text .. achievement
		end		
	else
		text = SLASH_WHISPER1 .. " " .. name .. " "
	end
	
	if (editBox ~= ChatEdit_GetActiveWindow()) then
		ChatFrame_OpenChat(text, chatFrame)
	else
		editBox:SetText(text)
	end
	ChatEdit_ParseText(editBox, 0)
	editBox:SetCursorPosition(editBox:GetNumLetters())
	
end