System_run("Scripts/GUI/PonyEditor/tables.lua", MainScene)
bil=0
function menuInit()
	MainScene:clearGUI()
	MainScene:setMetaData("MENUCAMERATRACK", 1)
	local centerX = MainScene:getConfigValue("width")/2
	local centerY = MainScene:getConfigValue("height")/2
	local width = MainScene:getConfigValue("width")
	local height = MainScene:getConfigValue("height")
	MainScene:load("MenuLevel.xml")
	MainScene:getObject(1):setMaterialFlag("mip_maps", 0)
	MainScene:getObject(3):setMaterialFlag("mip_maps", 0)
	MainScene:getObject(4):setMaterialFlag("mip_maps", 0)
	MainScene:addCamera(1)
	MainScene:getCamera():setPosition(0, 5, -7)
	math.randomseed(1)

	MainScene:setMetaData("PLAYER_BODY_SPAWNED", 0)
	MainScene:setMetaData("PLAYER_MANE_SPAWNED", 0)
	MainScene:setMetaData("PLAYER_TAIL_SPAWNED", 0)
	MainScene:setMetaData("PLAYER_HORN_SPAWNED", 0)
	MainScene:setMetaData("PLAYER_BODY_ID", 0)
	MainScene:setMetaData("PLAYER_MANE_ID", 0)
	MainScene:setMetaData("PLAYER_TAIL_ID", 0)
	MainScene:setMetaData("PLAYER_HORN_ID", 0)
	MainScene:setMetaData("PLAYER_ID", -1)
	MainScene:setGUIFont("Assets/Levels/menu/textures/ponyFont.xml")
	MainScene:setGUIColor("window", 200, 0, 0, 0)
	MainScene:setGUIColor("editable", 200, 32, 0, 128)
	MainScene:setGUIColor("editable_selected", 200, 64, 0, 128)
	MainScene:setGUITextColor(255, 255, 255, 255)
	--MainScene:addImage(0, 0, width, height, "Assets/Levels/world/textures/background.jpg", 0)
	local startbut = MainScene:addButton("", "Starts the game", centerX - 70, centerY - 100, centerX + 70, centerY - 40, 0, "Scripts/GUI/Menu/start.lua")
	--MainScene:getGUIObject(startbut):setImage(MainScene, "Assets/Levels/menu/textures/button.jpg", 0, 0, 100, 20)
	MainScene:addImage(0, 0, 140, 40, "Assets/Levels/menu/textures/button.jpg", startbut)
	MainScene:addImage(0, 10, 140, 40, "Assets/Levels/menu/textures/start.png", startbut)
	MainScene:getGUIObject(startbut):drawBorder(0)
	--MainScene:addButton("Open Pony Editor", "Opens Pony Editor", centerX - 50, centerY - 60, centerX + 50, centerY - 40, 0, "Scripts/GUI/PonyEditor/editor.lua")
	local opbut = MainScene:addButton("", "Opens options window", centerX - 50, centerY - 30, centerX + 50, centerY, 0, "Scripts/GUI/Menu/optionsbutton.lua")
	MainScene:addImage(0, 0, 100, 30, "Assets/Levels/menu/textures/button.jpg", opbut)
	MainScene:addImage(0, 10, 100, 30, "Assets/Levels/menu/textures/options.png", opbut)
	MainScene:getGUIObject(opbut):drawBorder(0)
	local quitbut = MainScene:addButton("", "Exits the game", centerX - 50, centerY, centerX + 50, centerY + 30, 0, "Scripts/GUI/Menu/quit.lua")
	MainScene:addImage(0, 0, 100, 30, "Assets/Levels/menu/textures/button.jpg", quitbut)
	MainScene:addImage(0, 10, 100, 30, "Assets/Levels/menu/textures/quit.png", quitbut)
	MainScene:getGUIObject(quitbut):drawBorder(0)
	MainScene:addImage(0, 0, 80, 80, "Assets/Levels/menu/textures/jcamlogo.png", 0)
	MainScene:addImage(width - 200, 0, width, 80, "Assets/Levels/menu/textures/foxclawlogo.png", 0)
	MainScene:addImage(centerX - 284, 50, centerX+284, 219, "Assets/Levels/menu/textures/logo.png", 0)
	if MainScene:getMetaData("NETWORKERROR") > 0 then
		local errorWindow = createWindow("", centerX-100, centerY-30, centerX+100, centerY+30, 0, "Scripts/Editor/emptyWindow.lua")
		if MainScene:getMetaData("NETWORKERROR") == 1 then
			MainScene:addText("Failed to Connect", 10, 20, 190, 50, errorWindow)
		elseif MainScene:getMetaData("NETWORKERROR") == 2 then
			MainScene:addText("Server Full", 10, 20, 190, 50, errorWindow)
		elseif MainScene:getMetaData("NETWORKERROR") == 3 then
			MainScene:addText("Lost connection to server", 10, 20, 190, 50, errorWindow)
		elseif MainScene:getMetaData("NETWORKERROR") == 4 then
			MainScene:addText("Invalid Account", 10, 20, 190, 50, errorWindow)
		end
		MainScene:setMetaData("NETWORKERROR", 0)
	end
	cx, cy, cz = MainScene:getCamera():getPosition()
	s = MainScene:addSound("Assets/Levels/menu/music/atop the trees.wav", cx, cy, cz, 0)
	MainScene:getSound(s):setVolume(MainScene:getConfigValue("music_volume"))
	MainScene:setMetaData("MENUMUSICID", s)
	
	bil = MainScene:addBillboard("Assets/Levels/menu/textures/flame/1.png", 5.9, 3.8, 3.4)
	MainScene:setMetaData("CANDLEID", bil)
	MainScene:getBillboard(bil):setSize(2, 5)
	
end
local overlay = 0

local CTrackLX = {0, 0, 0, -3}
local CTrackLY = {5, 6, 4, 4}
local CTrackLZ = {-7, -4, 3, -2}

local CTargetLX = {0, 0, 0, -6}
local CTargetLY = {0.5, 0.5, 3, 1}
local CTargetLZ = {0, 0, 5, 3}

local rotModX = math.random()/1000
local rotModZ = math.random()/1000
local curTime = 0
local updateTime = 0.1
curFrame = 1
function menuUpdate()
	local cTrack = MainScene:getMetaData("MENUCAMERATRACK")
	local width = MainScene:getConfigValue("width")
	local height = MainScene:getConfigValue("height")
	local mx, my = MainScene:getMousePosition()
	MainScene:getCamera():setTargetPos(CTargetLX[cTrack]+(mx-(width/2))/width, CTargetLY[cTrack]+(my+(height/2))/height, CTargetLZ[cTrack])
	if mx > width-200 and mx < width then
		if my > 0 and my < 80 then
			if overlay == 0 then
				MainScene:addImage(width - 200, 0, width, 80, "Assets/Levels/menu/textures/overlay.png", 0)
				overlay = 1
			end
		end
	end
	s = MainScene:getMetaData("MENUMUSICID")
	MainScene:getSound(s):setVolume(MainScene:getConfigValue("music_volume"))
	local cx, cy, cz = MainScene:getCamera():getPosition()
	local dx = (CTrackLX[cTrack] - cx)*0.05
	local dy = (CTrackLY[cTrack] - cy)*0.05
	local dz = (CTrackLZ[cTrack] - cz)*0.05
	MainScene:getCamera():setPosition(cx+dx, cy+dy, cz+dz)
	MainScene:getObject(s):setPosition(cx, cy, cz)
	if cTrack == 3 then
		if math.abs(dx) < 0.01 and math.abs(dy) < 0.01 and math.abs(dz) < 0.01 then
			MainScene:setMetaData("GAMESTATE", 2)
			MainScene:setMetaData("GAMESTATECHANGED", 1)
		end
	end
	if curTime >= updateTime then
		curTime = 0
		curFrame = curFrame+1
		if curFrame > 10 then
			curFrame = 1
		end
		MainScene:getBillboard(MainScene:getMetaData("CANDLEID")):setTexture(MainScene, "Assets/Levels/menu/textures/flame/"..curFrame..".png")
	else
		curTime = curTime + (MainScene:deltaTime()/1000)
	end
end

function menuRender()
	MainScene:RenderEffect(4)
end

function addRandomHorseModel(x, y, z, rx, ry, rz)
	
	local body = math.floor(math.random(1, 2))
	local bodyR = math.random(0, 1)
	local bodyG = math.random(0, 1)
	local bodyB = math.random(0, 1)
	local uppermane = math.ceil(math.random(0, upperManes))
	local umane1R = math.random(0, 1)
	local umane1G = math.random(0, 1)
	local umane1B = math.random(0, 1)
	local umane2R = math.random(0, 1)
	local umane2G = math.random(0, 1)
	local umane2B = math.random(0, 1)
	local lowermane = math.ceil(math.random(0, lowerManes))
	local tail = math.ceil(math.random(0, tails))
	local emptyBody = MainScene:addEmpty(x, y, z, rx, ry, rz, 0.02, 0.02, 0.02)
	local curBody = MainScene:addMesh(bodyFiles[body], 0, 0, 0, 0, 0, 0, 1, 1, 1)
	MainScene:getObject(curBody):attachTo(MainScene:getObject(emptyBody))
	MainScene:getObject(emptyBody):setName("RANDOMHORSEBODY")
	MainScene:getObject(curBody):setMaterialFlag("normalize_normals", 1)
	MainScene:getObject(curBody):setMaterialData(0, "diffuse_color", 255, bodyR, bodyG, bodyB)
	MainScene:getObject(curBody):setMaterialData(1, "texture", MainScene, 0, "Assets/Levels/world/textures/eye_l.jpg")
	MainScene:getObject(curBody):setMaterialData(2, "texture", MainScene, 0, "Assets/Levels/world/textures/eye_r.jpg")
	MainScene:getObject(curBody):setMaterialData(1, "scale_texture", 0, 1.5, 1.5)
	MainScene:getObject(curBody):setMaterialData(2, "scale_texture", 0, 1.5, 1.5)
	if body == 1 then
		MainScene:getObject(curBody):setMaterialData(2, "translate_texture", 0, 0.05, 0.05)
		MainScene:getObject(curBody):setMaterialData(1, "translate_texture", 0, 0.45,0.05)
	else
		MainScene:getObject(curBody):setMaterialData(2, "translate_texture", 0, 0.4, 0.5)
		MainScene:getObject(curBody):setMaterialData(1, "translate_texture", 0, 0.1, 0.5)
	end
	MainScene:getObject(curBody):setMaterialData(1, "diffuse_color", 0, 0, 0, 0)
	MainScene:getObject(curBody):setMaterialData(2, "diffuse_color", 0, 0, 0, 0)
	MainScene:getObject(curBody):setMaterialData(0, "specular_color", 0, 0, 0, 0)
	--MANE--
	if uppermane ~= 0 then
		local curUMane = MainScene:addMesh(upperManeFiles[uppermane], 0, 0, 0, 0, 0, 0, 1, 1, 1)
		MainScene:getObject(curUMane):attachTo(MainScene:getObject(curBody))
		MainScene:getObject(curUMane):setMaterialData(0, "diffuse_color", 255, umane1R, umane1G, umane1B)
		MainScene:getObject(curUMane):setMaterialData(1, "diffuse_color", 255, umane2R, umane2G, umane2B)
	end
	
	
	if lowermane ~= 0 then
		local curLMane = MainScene:addMesh(lowerManeFiles[lowermane], 0, 0, 0, 0, 90, 0, 1, 1, 1)
		MainScene:getObject(curLMane):attachTo(MainScene:getObject(curBody))
		MainScene:getObject(curLMane):setMaterialData(0, "diffuse_color", 255, umane1R, umane1G, umane1B)
		MainScene:getObject(curLMane):setMaterialData(1, "diffuse_color", 255, umane2R, umane2G, umane2B)
	end
	--TAIL--
	if tail ~= 0 then
		local curTail = MainScene:addMesh(tailFiles[tail], 0, 0, 0, 0,90, 0, 1, 1, 1)
		MainScene:getObject(curTail):attachTo(MainScene:getObject(curBody))
		MainScene:getObject(curTail):setMaterialData(0, "diffuse_color", 255, umane1R, umane1G, umane1B)
		MainScene:getObject(curTail):setMaterialData(1, "diffuse_color", 255, umane2R, umane2G, umane2B)
	end
	--MainScene:getCamera():setTarget(MainScene:getObject(curBody))
	--MainScene:getCamera():setOffset(0, 10, 0)
end	