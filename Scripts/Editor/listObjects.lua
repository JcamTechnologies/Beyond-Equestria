function onSelect(selection)
	local objects = MainScene:Objects()
	for i=0, MainScene:Objects() do
		if MainScene:getObject(i) then
			if MainScene:getObject(i):getMetaData("GUIKEY") == selection and MainScene:getMetaData("LAST_SELECTION_GUI") == -1 then
				if MainScene:getObject(i):getType() == "MESH" or MainScene:getObject(i):getType() == "ANIMATEDMESH" or MainScene:getObject(i):getType() == "EMPTYOBJECT" or MainScene:getObject(i):getType() == "BILLBOARD" then
					MainScene:setMetaData("LAST_SELECTION_GUI", i)
					createMeshEditor(i)
				end
				if MainScene:getObject(i):getType() == "LIGHT" then
					MainScene:setMetaData("LAST_SELECTION_GUI", i)
					createLightEditor(i)
				end
				if MainScene:getObject(i):getType() == "PARTICLE" then
					MainScene:setMetaData("LAST_SELECTION_GUI", i)
					createParticleEditor(i)
				end
			end
		end
	end
end
function onChange()
	
end
function createMeshEditor(selection)
	local x, y, z = MainScene:getObject(selection):getPosition()
	local rx, ry, rz = MainScene:getObject(selection):getRotation()
	local sx, sy, sz = MainScene:getObject(selection):getScale()
	local window = MainScene:addWindow(MainScene:getObject(selection):getName().." ID:"..selection, 100, 100, 300, 400, 0, "scripts/editor/closeObjectWindow.lua")
	local t1 = MainScene:addText("Name", 100, 20, 170, 30, window)
	local namebox = MainScene:addEditBox(MainScene:getObject(selection):getName(), 100, 30, 170, 50, 1, window, "scripts/editor/modifyName.lua")
	local t1 = MainScene:addText("Position", 20, 20, 90, 30, window)
	local boxx = MainScene:addEditBox(x, 20, 30, 90, 50, 1, window, "scripts/editor/modifyX.lua")
	local boxy = MainScene:addEditBox(y, 20, 50, 90, 70, 1, window, "scripts/editor/modifyY.lua")
	local boxz = MainScene:addEditBox(z, 20, 70, 90, 90, 1, window, "scripts/editor/modifyZ.lua")
	local t2 = MainScene:addText("Rotation", 20, 90, 90, 100, window)
	local boxrx = MainScene:addEditBox(rx, 20, 100, 90, 120, 1, window, "scripts/editor/modifyRX.lua")
	local boxry = MainScene:addEditBox(ry, 20, 120, 90, 140, 1, window, "scripts/editor/modifyRY.lua")
	local boxrz = MainScene:addEditBox(rz, 20, 140, 90, 160, 1, window, "scripts/editor/modifyRZ.lua")
	local t3 = MainScene:addText("Scale", 100, 90, 170, 100, window)
	local boxsx = MainScene:addEditBox(sx, 100, 100, 170, 120, 1, window, "scripts/editor/modifySX.lua")
	local boxsy = MainScene:addEditBox(sy, 100, 120, 170, 140, 1, window, "scripts/editor/modifySY.lua")
	local boxsz = MainScene:addEditBox(sz, 100, 140, 170, 160, 1, window, "scripts/editor/modifySZ.lua")
end
function createLightEditor(selection)
	local x, y, z = MainScene:getObject(selection):getPosition()
	local rx, ry, rz = MainScene:getObject(selection):getRotation()
	local sx, sy, sz = MainScene:getObject(selection):getScale()
	local r, g, b = MainScene:getLight(selection):getColor()
	local window = MainScene:addWindow(MainScene:getObject(selection):getName().." ID:"..selection, 100, 100, 300, 400, 0, "scripts/editor/closeObjectWindow.lua")
	local t1 = MainScene:addText("Name", 20, 170, 90, 190, window)
	local namebox = MainScene:addEditBox(MainScene:getObject(selection):getName(), 20, 190, 90, 210, 1, window, "scripts/editor/modifyName.lua")
	local t1 = MainScene:addText("Position", 20, 20, 90, 30, window)
	local boxx = MainScene:addEditBox(x, 20, 30, 90, 50, 1, window, "scripts/editor/modifyX.lua")
	local boxy = MainScene:addEditBox(y, 20, 50, 90, 70, 1, window, "scripts/editor/modifyY.lua")
	local boxz = MainScene:addEditBox(z, 20, 70, 90, 90, 1, window, "scripts/editor/modifyZ.lua")
	
	local t2 = MainScene:addText("Rotation", 20, 90, 90, 100, window)
	local boxrx = MainScene:addEditBox(rx, 20, 100, 90, 120, 1, window, "scripts/editor/modifyRX.lua")
	local boxry = MainScene:addEditBox(ry, 20, 120, 90, 140, 1, window, "scripts/editor/modifyRY.lua")
	local boxrz = MainScene:addEditBox(rz, 20, 140, 90, 160, 1, window, "scripts/editor/modifyRZ.lua")
	
	local t3 = MainScene:addText("Scale", 100, 90, 170, 100, window)
	local boxsx = MainScene:addEditBox(sx, 100, 100, 170, 120, 1, window, "scripts/editor/modifySX.lua")
	local boxsy = MainScene:addEditBox(sy, 100, 120, 170, 140, 1, window, "scripts/editor/modifySY.lua")
	local boxsz = MainScene:addEditBox(sz, 100, 140, 170, 160, 1, window, "scripts/editor/modifySZ.lua")
	
	local t1 = MainScene:addText("Color", 100, 20, 170, 30, window)
	local boxx = MainScene:addEditBox(r, 100, 30, 170, 50, 1, window, "scripts/editor/modifyR.lua")
	local boxy = MainScene:addEditBox(g, 100, 50, 170, 70, 1, window, "scripts/editor/modifyG.lua")
	local boxz = MainScene:addEditBox(b, 100, 70, 170, 90, 1, window, "scripts/editor/modifyB.lua")
end
function createParticleEditor(selection)
	local x, y, z = MainScene:getObject(selection):getPosition()
	local rx, ry, rz = MainScene:getObject(selection):getRotation()
	local sx, sy, sz = MainScene:getObject(selection):getScale()
	local window = MainScene:addWindow(MainScene:getObject(selection):getName().." ID:"..selection, 100, 100, 300, 400, 0, "scripts/editor/closeObjectWindow.lua")
	local t1 = MainScene:addText("Name", 100, 20, 170, 30, window)
	local namebox = MainScene:addEditBox(MainScene:getObject(selection):getName(), 100, 30, 170, 50, 1, window, "scripts/editor/modifyName.lua")
	local t1 = MainScene:addText("Position", 20, 20, 90, 30, window)
	local boxx = MainScene:addEditBox(x, 20, 30, 90, 50, 1, window, "scripts/editor/modifyX.lua")
	local boxy = MainScene:addEditBox(y, 20, 50, 90, 70, 1, window, "scripts/editor/modifyY.lua")
	local boxz = MainScene:addEditBox(z, 20, 70, 90, 90, 1, window, "scripts/editor/modifyZ.lua")
	
	local t2 = MainScene:addText("Rotation", 20, 90, 90, 100, window)
	local boxrx = MainScene:addEditBox(rx, 20, 100, 90, 120, 1, window, "scripts/editor/modifyRX.lua")
	local boxry = MainScene:addEditBox(ry, 20, 120, 90, 140, 1, window, "scripts/editor/modifyRY.lua")
	local boxrz = MainScene:addEditBox(rz, 20, 140, 90, 160, 1, window, "scripts/editor/modifyRZ.lua")
	
	local t3 = MainScene:addText("Scale", 100, 90, 170, 100, window)
	local boxsx = MainScene:addEditBox(sx, 100, 100, 170, 120, 1, window, "scripts/editor/modifySX.lua")
	local boxsy = MainScene:addEditBox(sy, 100, 120, 170, 140, 1, window, "scripts/editor/modifySY.lua")
	local boxsz = MainScene:addEditBox(sz, 100, 140, 170, 160, 1, window, "scripts/editor/modifySZ.lua")
end