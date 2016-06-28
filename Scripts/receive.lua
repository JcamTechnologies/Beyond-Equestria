System_run("scripts/GUI/PonyEditor/util.lua", MainScene)
NULL = 0
CONNECTION = 1
DISCONNECT = 2
CHARACTER_POSITION = 3
CHARACTER_DATA = 4
CHARACTER_ID = 5
CREATE_CHARACTER = 6
CHARACTER_ROTATION = 7
CHAT_MESSAGE = 8
CHARACTER_ANIMATION = 9
LEVEL_OPTIONS = 10
LEVEL_REQUEST = 11

function onReceive(pack, ip)
	local type = pack:readNumber()
	if type == DISCONNECT then
		local id = pack:readNumber()
		MainScene:SNLog("Player has disconnected", id)
		if MainScene:getMetaData("PLAYER_"..id.."_NAMETAG") ~= 0 then
			MainScene:removeObject(MainScene:getMetaData("PLAYER_"..id.."_NAMETAG"))
		end
		if(MainScene:getMetaData("PLAYER_"..id.."_BODY_SPAWNED") == 1) then
			if MainScene:getMetaData("PLAYER_"..id.."_BODY_ID") ~= 0 then
				MainScene:removeObject(MainScene:getMetaData("PLAYER_"..id.."_BODY_ID"))
				MainScene:setMetaData("PLAYER_"..id.."_BODY_SPAWNED", 0) 
			end
		end
		if(MainScene:getMetaData("PLAYER_"..id.."_UPPER_MANE_SPAWNED") == 1) then
			if MainScene:getMetaData("PLAYER_"..id.."_UPPER_MANE_ID") ~= 0 then
				MainScene:removeObject(MainScene:getMetaData("PLAYER_"..id.."_UPPER_MANE_ID"))
				MainScene:setMetaData("PLAYER_"..id.."_UPPER_MANE_SPAWNED", 0)
			end
		end
		if(MainScene:getMetaData("PLAYER_"..id.."_LOWER_MANE_SPAWNED") == 1) then
			if MainScene:getMetaData("PLAYER_"..id.."_LOWER_MANE_ID") ~= 0 then
				MainScene:removeObject(MainScene:getMetaData("PLAYER_"..id.."_LOWER_MANE_ID"))
				MainScene:setMetaData("PLAYER_"..id.."_LOWER_MANE_SPAWNED", 0)
			end
		end
		if(MainScene:getMetaData("PLAYER_"..id.."_TAIL_SPAWNED") == 1) then
			if MainScene:getMetaData("PLAYER_"..id.."_TAIL_ID") ~= 0 then
				MainScene:removeObject(MainScene:getMetaData("PLAYER_"..id.."_TAIL_ID"))
				MainScene:setMetaData("PLAYER_"..id.."_TAIL_SPAWNED", 0)
			end
		end
		if(MainScene:getMetaData("PLAYER_"..id.."_ACCESSORIES_SPAWNED") > 0) then
			for i=0, MainScene:getMetaData("PLAYER_"..id.."_ACCESSORIES_SPAWNED")-1 do
				if MainScene:getMetaData("PLAYER_"..id.."_ACCESSORY_ID_"..i) ~= 0 then
					MainScene:removeObject(MainScene:getMetaData("PLAYER_"..id.."_ACCESSORY_ID_"..i))
				end
			end
		end
		if MainScene:getMetaData("PLAYER_"..id.."_BASE_ID") == 0 then
			return
		end
		MainScene:removeObject(MainScene:getMetaData("PLAYER_"..id.."_BASE_ID"))
	end
	if type == CHARACTER_ID then
		local id = pack:readNumber()
		MainScene:setMetaData("PLAYER_ID", id)
		MainScene:SNLog("ID", id)
	end
	if type == CREATE_CHARACTER then
		local tmpId = pack:readNumber()
		if tmpId == MainScene:getMetaData("PLAYER_ID") then
			return
		end
		local id = tmpId
		local name = pack:readString()
		local body = pack:readNumber()
		local uppermane = pack:readNumber()
		local lowermane = pack:readNumber()
		local tail = pack:readNumber()
		local bodyR = pack:readNumber()
		local bodyG = pack:readNumber()
		local bodyB = pack:readNumber()
		
		local umane1R = pack:readNumber()
		local umane1G = pack:readNumber()
		local umane1B = pack:readNumber()
		
		local umane2R = pack:readNumber()
		local umane2G = pack:readNumber()
		local umane2B = pack:readNumber()
		local race = pack:readNumber()
		
		MainScene:setMetaString("PLAYER_"..id.."_NAME", name)
		MainScene:setMetaData("PLAYER_"..id.."_GENDER", body)
		MainScene:setMetaData("PLAYER_"..id.."_UPPER_MANE", uppermane)
		MainScene:setMetaData("PLAYER_"..id.."_LOWER_MANE", lowermane)
		MainScene:setMetaData("PLAYER_"..id.."_TAIL", tail)
		MainScene:setMetaData("PLAYER_"..id.."_BODY_COLOR_R", bodyR)
		MainScene:setMetaData("PLAYER_"..id.."_BODY_COLOR_G", bodyG)
		MainScene:setMetaData("PLAYER_"..id.."_BODY_COLOR_B", bodyB)
		
		MainScene:setMetaData("PLAYER_"..id.."_UMANE1_COLOR_R", umane1R)
		MainScene:setMetaData("PLAYER_"..id.."_UMANE1_COLOR_G", umane1G)
		MainScene:setMetaData("PLAYER_"..id.."_UMANE1_COLOR_B", umane1B)
		
		MainScene:setMetaData("PLAYER_"..id.."_UMANE2_COLOR_R", umane2R)
		MainScene:setMetaData("PLAYER_"..id.."_UMANE2_COLOR_G", umane2G)
		MainScene:setMetaData("PLAYER_"..id.."_UMANE2_COLOR_B", umane2B)
		MainScene:setMetaData("PLAYER_"..id.."_RACE", race)
		local player = MainScene:addEmpty(0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2)
		MainScene:setMetaData("PLAYER_"..id.."_BASE_ID", player)
		local nameTag = MainScene:add3DText(name, 5, 2, 0, 30, 0)
		MainScene:setMetaData("PLAYER_"..id.."_NAMETAG", nameTag)
		MainScene:getObject(nameTag):attachTo(MainScene:getObject(player))
		generateCharacter(id)
	end
	if type == CHARACTER_POSITION then
		local id = pack:readNumber()
		if id == MainScene:getMetaData("PLAYER_ID") then
			return
		end
		local x, y, z
		x = pack:readNumber()
		y = pack:readNumber()
		z = pack:readNumber()
		if(MainScene:getMetaData("PLAYER_"..id.."_BASE_ID") == 0) then
			return
		end
		MainScene:getObject(MainScene:getMetaData("PLAYER_"..id.."_BASE_ID")):setPosition(x, y+1,z)
	end
	if type == CHARACTER_ANIMATION then
		local id = pack:readNumber()
		local anim = pack:readString()
		local frame1 = pack:readNumber()
		local frame2 = pack:readNumber()
		local framerate = pack:readNumber()
		if MainScene:getObject(MainScene:getMetaData("PLAYER_"..id.."_BASE_ID")) == nil then
			MainScene:SLog("FAILED TO FIND PLAYER: "..id)
			return
		end
		MainScene:SLog("SET ANIM TO: "..anim.." for "..id)
		if id ~= MainScene:getMetaData("PLAYER_ID") then
			setCharacterAnim(id, anim, framerate, frame1, frame2)
		end
	end
	if type == CHARACTER_ROTATION then
		local id = pack:readNumber()
		if id == MainScene:getMetaData("PLAYER_ID") then
			return
		end
		local x, y, z
		x = pack:readNumber()
		y = pack:readNumber()
		z = pack:readNumber()
		if(MainScene:getMetaData("PLAYER_"..id.."_BASE_ID") <= 0) then
			return
		end
		if MainScene:getObject(MainScene:getMetaData("PLAYER_"..id.."_BASE_ID")):getName() == nil then
			return
		end
		MainScene:getObject(MainScene:getMetaData("PLAYER_"..id.."_BASE_ID")):setRotation(x, y ,z)
	end
	if type == CHAT_MESSAGE then
		local message = pack:readString()
		local tmp = MainScene:addListItem(message, MainScene:getMetaData("CHATMESSAGEBOX"))
		MainScene:setMetaString("CHAT_MESSAGE_GUI_"..tmp, message)
	end
	if type == LEVEL_OPTIONS then
		local debug = pack:readNumber()
		if debug == 1 then
			MainScene:setMetaData("WORLDDEBUG", 1)
		else
			MainScene:setMetaData("WORLDDEBUG", 0)
		end
		MainScene:setMetaData("CONNECTED_TO_SERVER", 1)
	end
end

function onConnectFailed(ip)
	MainScene:setMetaData("NETWORKERROR", 1)
	MainScene:setMetaData("GAMESTATE", 0)
	MainScene:setMetaData("GAMESTATECHANGED", 1)
	MainScene:setMetaData("MENUCAMERATRACK", 1)
end

function onServerFull(ip)
	MainScene:setMetaData("NETWORKERROR", 2)
	MainScene:setMetaData("GAMESTATE", 0)
	MainScene:setMetaData("GAMESTATECHANGED", 1)
	MainScene:setMetaData("MENUCAMERATRACK", 1)
end

function onConnected(ip)
	local l = MainScene:createPacket()
	l:writeNumber(LEVEL_REQUEST)
	MainScene:sendPacket(l, ip)
end

function setCharacterAnim(id, anim, speed, frame1, frame2)
	if MainScene:getMetaData("PLAYER_"..id.."_BODY_ID") ~= 0 then
		MainScene:getBoneAnimatedMesh(MainScene:getMetaData("PLAYER_"..id.."_BODY_ID")):setAnimation(anim)
		MainScene:getBoneAnimatedMesh(MainScene:getMetaData("PLAYER_"..id.."_BODY_ID")):setSpeed(speed)
		MainScene:getBoneAnimatedMesh(MainScene:getMetaData("PLAYER_"..id.."_BODY_ID")):setFrameLoop(frame1, frame2)
	end
	if(MainScene:getMetaData("PLAYER_"..id.."_UPPER_MANE_SPAWNED") == 1) and MainScene:getMetaData("PLAYER_"..id.."_UPPER_MANE_ID") ~= 0 then
		MainScene:getBoneAnimatedMesh(MainScene:getMetaData("PLAYER_"..id.."_UPPER_MANE_ID")):setAnimation(anim)
		MainScene:getBoneAnimatedMesh(MainScene:getMetaData("PLAYER_"..id.."_UPPER_MANE_ID")):setSpeed(speed)
		MainScene:getBoneAnimatedMesh(MainScene:getMetaData("PLAYER_"..id.."_UPPER_MANE_ID")):setFrameLoop(frame1, frame2)
	end
	if(MainScene:getMetaData("PLAYER_"..id.."_LOWER_MANE_SPAWNED") == 1) and MainScene:getMetaData("PLAYER_"..id.."_LOWER_MANE_ID") ~= 0 then
		MainScene:getBoneAnimatedMesh(MainScene:getMetaData("PLAYER_"..id.."_LOWER_MANE_ID")):setAnimation(anim)
		MainScene:getBoneAnimatedMesh(MainScene:getMetaData("PLAYER_"..id.."_LOWER_MANE_ID")):setSpeed(speed)
		MainScene:getBoneAnimatedMesh(MainScene:getMetaData("PLAYER_"..id.."_LOWER_MANE_ID")):setFrameLoop(frame1, frame2)
	end
	--[[if(MainScene:getMetaData("PLAYER_"..id.."_TAIL_SPAWNED") == 1) then
		MainScene:getBoneAnimatedMesh(MainScene:getMetaData("PLAYER_"..id.."_TAIL_ID")):setAnimation(anim)
		MainScene:getBoneAnimatedMesh(MainScene:getMetaData("PLAYER_"..id.."_TAIL_ID")):setSpeed(speed)
		MainScene:getBoneAnimatedMesh(MainScene:getMetaData("PLAYER_"..id.."_TAIL_ID")):setFrameLoop(frame1, frame2)
	end]]--
end