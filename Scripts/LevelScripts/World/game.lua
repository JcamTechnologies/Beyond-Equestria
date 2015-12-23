GENTERRAIN = 1
function gameInit()
	GENTERRAIN = MainScene:getMetaData("WORLDDEBUG")
	--MainScene:addCamera(2)
	MainScene:addCamera(1)
	MainScene:getCamera():setClipping(1, MainScene:getConfigValue("Clipping"))
	--MainScene:createCharacter( 2, 5, 3)
	--MainScene:modifyCharacter("warp", 500, 10, 500)
	MainScene:load("Empty.xml")
	if GENTERRAIN == 1 then
		MainScene:load("debug.xml")
	end
	playerCam = MainScene:addEmpty(0, -0.7, 0, 0, 0, 0, 0.2, 0.1, 0.1)
	if GENTERRAIN == 0 then
		playerCollider = MainScene:addEmpty(4600, 10, 1530, 0, 0, 0, 1, 2, 2)
	else
		playerCollider = MainScene:addEmpty(0, 10, 0, 0, 0, 0, 1, 2, 2)
	end
	--MainScene:getObject(0):attachTo(MainScene:getObject(playerCollider))
	--MainScene:getObject(0):setPosition(0, 10, 50)
	MainScene:getEmpty(playerCollider):addCollider(MainScene, "SPHERE", 50)
	
	MainScene:getObject(playerCollider):getCollider():setFriction(200)
	MainScene:getObject(playerCollider):getCollider():setDamping(0.1, 5)
	MainScene:getObject(playerCollider):getCollider():setLocal(1)
	MainScene:getObject(playerCam):attachTo(MainScene:getObject(playerCollider))
	MainScene:getObject(playerCam):setName("PLAYERCAMTARGET")
	MainScene:getObject(playerCollider):setName("PLAYERCOLLIDER")
	MainScene:getCamera():setTarget(MainScene:getObject(playerCollider))
	--MainScene:getCamera():setOffset(0, 2, 0)
	MainScene:getCamera():setOffset(1.2, 5, -2)
	generatePlayer()
	local t = MainScene:getMetaData("PLAYER_BODY_ID")
	--MainScene:modifyCharacter("jumpheight", 5)
	--MainScene:modifyCharacter("jumpforce", 30)
	--MainScene:modifyCharacter("fallspeed", 20)
	MainScene:clearGUI()
	local win = createWindow("Chat", 0, 0, 300, 210, 0, "Scripts/GUI/Chat/chatWindow.lua")
	local mes = MainScene:addListBox(10, 30, 290, 160, win, "Scripts/GUI/Chat/messageBox.lua")
	MainScene:getGUIObject(mes):setAutoscroll(1)
	MainScene:setMetaData("CHATMESSAGEBOX", mes)
	MainScene:addEditBox("", 10, 160, 290, 180, 1, win, "Scripts/GUI/Chat/sendMessage.lua")
end
anim = 0
lastAnim = 0
updateCycle = 0
updateOn = 1000
firstRun = 0
curTime = 500
packBuffer = 0

IDLE1 = 6
IDLE = 0
WALK = 1
SPRINT = 2
BWALK = 3
LWALK = 4
RWALK = 5

idleTime = 0
function gameUpdate()
	lastAnim = anim
	--MainScene:getObject(playerCam):setPosition(MainScene:characterData("posX"), MainScene:characterData("posY")-2, MainScene:characterData("posZ"))
	if(MainScene:getKey(KEY_ESCAPE) == 1) then
		initPause()
	end
	local DirX = 0
	local DirZ = 0
	local sprint = 0
	if MainScene:getKey(KEY_KEY_W) == 1 then
		DirZ = -1.0
	end
	if MainScene:getKey(KEY_KEY_S) == 1 then
		DirZ = 1.0
	end
	if MainScene:getKey(KEY_KEY_A) == 1 then
		DirX = 1.0
	end
	if MainScene:getKey(KEY_KEY_D) == 1 then
		DirX = -1.0
	end
	if MainScene:getKey(KEY_LSHIFT) == 1 then
		sprint = 2
	end
	
	local ppx, ppy, ppz = MainScene:getObject(playerCollider):getPosition()
	local xx, yy, zz = MainScene:rayCast(ppx, ppy-1, ppz, ppx, ppy-500, ppz)
	
	if MainScene:getKey(KEY_SPACE) == 1 and (yy-ppy) < 2 and (yy-ppy) > -2 then
		MainScene:getObject(playerCollider):getCollider():setState("ACTIVE")
		MainScene:getObject(playerCollider):getCollider():addCentralForce(0, 3000, 0)
	end
	
	local cX, cY, cZ = MainScene:getCamera():getRotation()

	local x, y, z = MainScene:getObject(playerCollider):getPosition()
	if foijg then -- C "static" behavior.
		foijg = foijg + 5 -- 5 degrees per frame.
	else
		foijg = 0
	end
	MainScene:getCamera():setPosition(x, y+5, z-8)
	--MainScene:getCamera():setRotation(foijg, 0, 0) -- Does nothing, should rotate the camera

	if DirX ~= 0 or DirZ ~= 0 then
		MainScene:getObject(playerCollider):getCollider():setState("ACTIVE")
		--MainScene:getObject(playerCam):setRotation(0, cY-180, 0)
		if DirZ == -1 and DirX == 0 and sprint == 0 then
			anim = WALK
		end
		if DirZ == -1 and DirX == 0 and sprint ~= 0 then
			anim = SPRINT
		end
		if DirX == 1 then
			anim = LWALK
		end
		if DirX == -1 then
			anim = RWALK
		end
		if DirZ == 1 then
			anim = BWALK
		end
		MainScene:getObject(playerCollider):setRotation(0, cY-180, 0)
		local vx, vy, vz = MainScene:getObject(playerCollider):getCollider():getVelocity()
		MainScene:getObject(playerCollider):getCollider():setVelocity((DirX * (sprint+1))*4, vy, (DirZ * (sprint+1))*4)
	else
		if anim ~= IDLE and anim ~= IDLE1 then
			anim = IDLE
			MainScene:getObject(playerCollider):getCollider():setVelocity(0, 0, 0)
		end
		local trx, try, trz = MainScene:getObject(playerCollider):getRotation()
		MainScene:getObject(playerCollider):setRotation(0, try, 0)
	--MainScene:moveCharacter(DirX*(sprint+1), 0, DirZ*(sprint+1), 0, cY - 180, 0, 0.1)
	end

	--MainScene:getObject(playerCollider):setRotation(0, foijg, 0) -- you spin me right round round, (test of rotation on player)

	curTime = curTime + MainScene:deltaTime()
	if curTime > 500 then
		tx, ty, tz = MainScene:getObject(playerCollider):getPosition()
		if GENTERRAIN == 0 then updateChunks(tx/terrainScale, tz/terrainScale, chunksize, terrainScale) end
		curTime = 0
	end
	local vx, vy, vz = MainScene:getObject(playerCollider):getCollider():getVelocity()
	packBuffer = packBuffer + 1
	if (vx ~= 0 or vy ~= 0 or vz ~= 0) and packBuffer > 10 then
		packBuffer = 0
		local p = MainScene:createPacket()
		p:writeNumber(3)
		p:writeNumber(MainScene:getMetaData("PLAYER_ID"))
		local px, py, pz = MainScene:getObject(playerCollider):getPosition()
		p:writeNumber(px)
		p:writeNumber(py-2)
		p:writeNumber(pz)
		MainScene:sendPacket(p, MainScene:getMetaString("SERVERCOMBINEDIP"))
		
		local pa = MainScene:createPacket()
		pa:writeNumber(7)
		pa:writeNumber(MainScene:getMetaData("PLAYER_ID"))
		local prx, pry, prz = MainScene:getObject(playerCollider):getRotation()
		pa:writeNumber(prx)
		pa:writeNumber(pry)
		pa:writeNumber(prz)
		MainScene:sendPacket(pa, MainScene:getMetaString("SERVERCOMBINEDIP"))
	end
	updateCycle =  updateCycle + MainScene:deltaTime()
	if updateCycle >= updateOn then
		updateCycle = 0
		
		local p = MainScene:createPacket()
		p:writeNumber(3)
		p:writeNumber(MainScene:getMetaData("PLAYER_ID"))
		local px, py, pz = MainScene:getObject(playerCollider):getPosition()
		p:writeNumber(px)
		p:writeNumber(py-2)
		p:writeNumber(pz)
		MainScene:sendPacket(p, MainScene:getMetaString("SERVERCOMBINEDIP"))
		
		local pa = MainScene:createPacket()
		pa:writeNumber(7)
		pa:writeNumber(MainScene:getMetaData("PLAYER_ID"))
		local prx, pry, prz = MainScene:getObject(playerCollider):getRotation()
		pa:writeNumber(prx)
		pa:writeNumber(pry)
		pa:writeNumber(prz)
		MainScene:sendPacket(pa, MainScene:getMetaString("SERVERCOMBINEDIP"))
	end
	if firstRun == 0 then
		local pack = MainScene:createPacket()
		pack:writeNumber(1)
		pack:writeString(MainScene:getMetaString("PLAYER_NAME"))
		MainScene:sendPacket(pack, MainScene:getMetaString("SERVERCOMBINEDIP"))
		local body = MainScene:getConfigValue("CharacterGender")
		local uppermane = MainScene:getConfigValue("CharacterUpperMane")
		local lowermane = MainScene:getConfigValue("CharacterLowerMane")
		local tail = MainScene:getConfigValue("CharacterTail")
		local bodyR = MainScene:getConfigValue("CharacterBodyR")
		local bodyG = MainScene:getConfigValue("CharacterBodyG")
		local bodyB = MainScene:getConfigValue("CharacterBodyB")
		
		local umane1R = MainScene:getConfigValue("CharacterManeR1")
		local umane1G = MainScene:getConfigValue("CharacterManeG1")
		local umane1B = MainScene:getConfigValue("CharacterManeB1")
		
		local umane2R = MainScene:getConfigValue("CharacterManeR2")
		local umane2G = MainScene:getConfigValue("CharacterManeG2")
		local umane2B = MainScene:getConfigValue("CharacterManeB2")
		local race = MainScene:getConfigValue("CharacterRace")
		local pack1 = MainScene:createPacket()
		pack1:writeNumber(4)
		pack1:writeNumber(-1)
		pack1:writeString(MainScene:getMetaString("PLAYER_NAME"))
		pack1:writeNumber(body)
		pack1:writeNumber(uppermane)
		pack1:writeNumber(lowermane)
		pack1:writeNumber(tail)
		pack1:writeNumber(bodyR)
		pack1:writeNumber(bodyG)
		pack1:writeNumber(bodyB)
		pack1:writeNumber(umane1R)
		pack1:writeNumber(umane1G)
		pack1:writeNumber(umane1B)
		pack1:writeNumber(umane2R)
		pack1:writeNumber(umane2G)
		pack1:writeNumber(umane2B)
		pack1:writeNumber(race)
		MainScene:sendPacket(pack1, MainScene:getMetaString("SERVERCOMBINEDIP"))
		
		firstRun = 1
	end
	
	if anim ~= IDLE then
		idleTime = 0
	else
		idleTime = idleTime + MainScene:deltaTime()
	end
	
	if idleTime >= 10000 then
		anim = IDLE1
		idleTime = 0
	end
	if anim == IDLE1 then
		local frame = MainScene:getBoneAnimatedMesh(MainScene:getMetaData("PLAYER_BODY_ID")):getFrame()
		if frame >= 75 then
			anim = IDLE
		end
	end
end

function gameRender()
	if lastAnim ~= anim then
		if anim == IDLE then
			setPlayerAnim("idle", 10, 1, 200)
		elseif anim == WALK then
			setPlayerAnim("walk", 60, 1, 60)
		elseif anim == SPRINT then
			setPlayerAnim("trot", 120, 1, 60)
		elseif anim == BWALK then
			setPlayerAnim("walk", -60, 1, 60)
		elseif anim == LWALK then
			setPlayerAnim("lWalk", 60, 1, 60)
		elseif anim == RWALK then
			setPlayerAnim("rWalk", -60, 1, 60)
		elseif anim == IDLE1 then
			setPlayerAnim("idle1", 20, 1, 80)
		end
	end
end

function distance(x1, y1, x2, y2)
	local xd = x2-x1
	local yd = y2-y1
	return math.sqrt(xd*xd+yd*yd)
end

function setPlayerAnim(anim, speed, frame1, frame2)
	MainScene:getBoneAnimatedMesh(MainScene:getMetaData("PLAYER_BODY_ID")):setAnimation(anim)
	MainScene:getBoneAnimatedMesh(MainScene:getMetaData("PLAYER_BODY_ID")):setSpeed(speed)
	MainScene:getBoneAnimatedMesh(MainScene:getMetaData("PLAYER_BODY_ID")):setFrameLoop(frame1, frame2)
	if(MainScene:getMetaData("PLAYER_UPPER_MANE_SPAWNED") == 1) then
		MainScene:getBoneAnimatedMesh(MainScene:getMetaData("PLAYER_UPPER_MANE_ID")):setAnimation(anim)
		MainScene:getBoneAnimatedMesh(MainScene:getMetaData("PLAYER_UPPER_MANE_ID")):setSpeed(speed)
		MainScene:getBoneAnimatedMesh(MainScene:getMetaData("PLAYER_UPPER_MANE_ID")):setFrameLoop(frame1, frame2)
	end
	if(MainScene:getMetaData("PLAYER_LOWER_MANE_SPAWNED") == 1) then
		MainScene:getBoneAnimatedMesh(MainScene:getMetaData("PLAYER_LOWER_MANE_ID")):setAnimation(anim)
		MainScene:getBoneAnimatedMesh(MainScene:getMetaData("PLAYER_LOWER_MANE_ID")):setSpeed(speed)
		MainScene:getBoneAnimatedMesh(MainScene:getMetaData("PLAYER_LOWER_MANE_ID")):setFrameLoop(frame1, frame2)
	end
	if(MainScene:getMetaData("PLAYER_TAIL_SPAWNED") == 1) then
		MainScene:getBoneAnimatedMesh(MainScene:getMetaData("PLAYER_TAIL_ID")):setAnimation(anim)
		MainScene:getBoneAnimatedMesh(MainScene:getMetaData("PLAYER_TAIL_ID")):setSpeed(speed)
		MainScene:getBoneAnimatedMesh(MainScene:getMetaData("PLAYER_TAIL_ID")):setFrameLoop(frame1, frame2)
	end
end