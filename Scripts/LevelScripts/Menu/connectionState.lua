function initConnectionState()
	local messages = {"Meeting other horses...", "Leaving Equestria...", "Reticulating Splines...", "Removing humans...", "Inserting Equines...", }
	local messageQuant = 5
	MainScene:clearGUI()
	local centerX = MainScene:getConfigValue("width")/2
	local centerY = MainScene:getConfigValue("height")/2
	local width = MainScene:getConfigValue("width")
	local height = MainScene:getConfigValue("height")
	--MainScene:addImage(0, 0, width, height, "Assets/Levels/world/textures/background.jpg", 0)
	--MainScene:addImage(centerX - 379, 50, centerX+379, 292, "Assets/Levels/menu/textures/logo.png", 0)
	local tmp = createWindow("", centerX-100, centerY-30, centerX+100, centerY+30, 0, "Scripts/Editor/emptyWindow.lua")
	MainScene:addText(messages[math.random(1, 5)], 10, 20, 190, 50, tmp)
end

function updateConnectionState()
	if MainScene:getMetaData("CONNECTED_TO_SERVER") == 1 then
		MainScene:setMetaData("GAMESTATE", 1)
		MainScene:setMetaData("GAMESTATECHANGED", 1)
	end
	if MainScene:getMetaData("ACCOUNT_AUTH_FAILED") == 1 then
		MainScene:setMetaData("NETWORKERROR", 4)
		MainScene:setMetaData("GAMESTATE", 1)
		MainScene:setMetaData("GAMESTATECHANGED", 1)
		MainScene:setMetaData("MENUCAMERATRACK", 1)
	end
end

function renderConnectionState()

end