version = "0.1.0"
System_run("scripts/Editor/editor.lua", MainScene)
System_run("scripts/defs.lua", MainScene)
System_run("scripts/LevelScripts/World/Generator/terrain.lua", MainScene)
System_run("scripts/LevelScripts/World/Generator/terrainManager.lua", MainScene)
System_run("scripts/LevelScripts/Menu/menu.lua", MainScene)
System_run("scripts/LevelScripts/Menu/connectionState.lua", MainScene)
System_run("scripts/LevelScripts/World/game.lua", MainScene)
System_run("scripts/GUI/PonyEditor/util.lua", MainScene)
System_run("scripts/GUI/pause.lua", MainScene)
MainScene:setDebug(2)
MainScene:setPhysicsDebug(0)

chunksize = 64
terrainScale = 32
playerCam = 0
testx = 0
testy = 0

GameState = 0

postFX = 0
mInit = 0
function init()
	MainScene:SLog("Launching Beyond Equestria "..version)
	MainScene:setMetaString("SERVERIP", "71.175.69.32")
	MainScene:setMetaData("SERVERPORT", 7777)
	MainScene:setMetaString("SERVERCOMBINEDIP", "71.175.69.32|7777")
	MainScene:addCamera(1)
	--menuInit()
	local width = MainScene:getConfigValue("width")
	local height = MainScene:getConfigValue("height")
	MainScene:setGUIFont("Assets/Levels/menu/textures/ponyFont.xml")
	MainScene:setGUIColor("window", 200, 0, 0, 0)
	MainScene:setGUIColor("editable", 200, 32, 0, 128)
	MainScene:setGUIColor("editable_selected", 200, 64, 0, 128)
	MainScene:setGUITextColor(255, 255, 255, 255)
	MainScene:addImage(0, 0, width, height, "Assets/Levels/menu/textures/copyright.png", 0)
	MainScene:addText("THIS GAME IS NOT COMPLETE! CURRENT GAMEPLAY MAY NOT BE REPRESENTITIVE OF THE FINAL PRODUCT. EVERYTHING SUBJECT TO CHANGE.", (width/2)-400, (height/2)+200, (width/2)+400, (height/2)+400, 0)
	MainScene:setMetaData("GAMESTATE", GameState)
	postFX = MainScene:getConfigValue("postfx")
	MainScene:setMetaData("GAMESTATECHANGED", 0)
	MainScene:setMetaData("NETRUNNING", 0)
	MainScene:setMetaData("NETWORKERROR", 0)
	MainScene:setMetaData("CONNECTED_TO_SERVER", 0)
	MainScene:setMetaData("WORLDDEBUG", 1)
end

function update()
	if MainScene:getMetaData("NETRUNNING") == 1 then
		MainScene:updateNet()
	end
	if(MainScene:getKey(KEY_OEM_3) == 1) then
		promptEditor()
	end
	GameState = MainScene:getMetaData("GAMESTATE")
	postFX = MainScene:getConfigValue("postfx")
	if MainScene:getMetaData("GAMESTATECHANGED") == 1 then
		if GameState == 0 then
			if mInit == 0 then
				menuInit()
				mInit = 1
			end
		elseif GameState == 1 then
			gameInit()
			mInit=0
		elseif GameState == 2 then
			initConnectionState()
			mInit=0
		end
		MainScene:setMetaData("GAMESTATECHANGED", 0)
	end
	if GameState == 0 then
		if mInit == 1 then
			menuUpdate()
		else
			MainScene:setMetaData("GAMESTATECHANGED", 1)
		end
	elseif GameState == 1 then
		gameUpdate()
	elseif GameState == 2 then
		updateConnectionState()
	end
end
function render()
	
	if GameState == 0 then
		menuRender()
	end
	if GameState == 1 then
		gameRender()
	end
	if postFX == 1 then
		if MainScene:getConfigValue("bloom") == 1 then
			MainScene:RenderEffect(5)
		end
		
	end
end