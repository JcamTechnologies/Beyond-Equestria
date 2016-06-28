System_run("scripts/LevelScripts/World/Generator/terrain.lua", MainScene)
System_run("Scripts/LevelScripts/World/Generator/genBuildings.lua", MainScene)
System_run("Scripts/LevelScripts/World/Generator/cityNames.lua", MainScene)
lastChunkx = 0
lastChunky = 0
function updateChunks(posx, posy, chunksize, terrainScale)
	MainScene:setMetaData("CHUNKSIZE", chunksize)
	MainScene:setMetaData("TERRAINSCALE", terrainScale)
	local chunkx = math.floor(posx/chunksize)
	local chunky = math.floor(posy/chunksize)
	local half = (chunksize/2)
	local quarter = (chunksize/4)
	
	if MainScene:getMetaData("CHUNK"..chunkx.."_"..chunky) ~= 1 then
		for x=-1, 1 do
			for y=-1, 1 do
				local c = createChunk(chunkx+x, chunky+y, chunksize, terrainScale)
				--[[local waterPlane = MainScene:addMesh("Assets/Levels/world/models/plane.dae", (chunkx+x)*(chunksize*terrainScale), -100, (chunky+y)*(chunksize*terrainScale), 0, 0, 0, terrainScale*8, 1, terrainScale*8)				
				MainScene:getObject(waterPlane):setMaterialData(0, "texture", MainScene, 0, "Assets/Levels/world/textures/water.jpg")
				MainScene:getObject(waterPlane):setMaterialData(0, "texture", MainScene, 1, "Assets/Levels/world/textures/skybox/hills_up.tga")
				MainScene:getObject(waterPlane):setMaterialData(0, "scale_texture",0,5,5)
				--MainScene:getObject(waterPlane):useShader(MainScene, "Shaders/waterShader.xml")
				MainScene:getObject(waterPlane):setMaterialType("transparent_alpha_fast", 0)
				MainScene:setMetaData("Water"..chunkx+x.."_"..chunky+y, waterPlane)]]--
			end
		end
		--updateChunk(t)
	end
	
	--CHANGED CHUNK
	if chunkx ~= lastChunkx or chunky ~= lastChunky then
		for x=-1, 1 do
			for y=-1, 1 do
				if math.abs(chunky - (lastChunky+y)) >= 2 then
					removeChunk(lastChunkx+x, lastChunky+y)
				end
				if math.abs(chunkx - (lastChunkx+x)) >= 2 then
					removeChunk(lastChunkx+x, lastChunky+y)
				end
			end
		end
		for x=-1, 1 do
			for y=-1, 1 do
				local c = createChunk(chunkx+x, chunky+y, chunksize, terrainScale)
				if c ~= nil then
					--[[local waterPlane = MainScene:addMesh("Assets/Levels/world/models/plane.dae", (chunkx+x)*(chunksize*terrainScale), -100, (chunky+y)*(chunksize*terrainScale), 0, 0, 0, terrainScale, 1, terrainScale)	
					MainScene:getObject(waterPlane):setMaterialData(0, "texture", MainScene, 0, "Assets/Levels/world/textures/water.jpg")
					MainScene:getObject(waterPlane):setMaterialData(0, "texture", MainScene, 1, "Assets/Levels/world/textures/skybox/hills_up.tga")
					MainScene:getObject(waterPlane):setMaterialData(0, "scale_texture", 0, 5, 5)
					--MainScene:getObject(waterPlane):useShader(MainScene, "Shaders/waterShader.xml")
					MainScene:getObject(waterPlane):setMaterialType("transparent_add", 0)
					MainScene:setMetaData("Water"..chunkx+x.."_"..chunky+y, waterPlane)]]--
				end
			end
		end
	end
	--LOAD HIGH-RES CHUNK
	-- +X
	if posx - (chunkx*chunksize) > half+quarter then
	
	end
	-- -X
	if posx - (chunkx*chunksize) < quarter then
	
	end
	-- +Y
	if posy - (chunky*chunksize) > half+quarter then
	
	end
	-- -Y
	if posy - (chunky*chunksize) < quarter then
	
	end
	
	lastChunkx = chunkx
	lastChunky = chunky
end
function createChunk(chunkx, chunky, chunksize, terrainScale)
	if MainScene:getMetaData("CHUNK"..chunkx.."_"..chunky) == 1 then return end
	MainScene:SLog("Loading chunk: "..chunkx.."_"..chunky)
	local terrain = MainScene:addTerrain(chunkx*(chunksize*terrainScale), 0, chunky*(chunksize*terrainScale), 0, 0, 0, terrainScale, terrainScale, terrainScale)
	MainScene:getTerrain(terrain):empty(chunksize+1, chunksize+1, 1)
	MainScene:setMetaData("CHUNK"..chunkx.."_"..chunky, 1)
	MainScene:setMetaData("CHUNKID"..chunkx.."_"..chunky, terrain)
	generateChunk(MainScene:getTerrain(terrain), chunkx, chunky, chunksize, 1)
	MainScene:getTerrain(terrain):rebuild()
	addChunkCollider(MainScene:getTerrain(terrain))
	MainScene:getObject(terrain):setMaterialFlag("normalize_normals", 1)
	
	

	--MainScene:getObject(terrain):setMaterialFlag("lighting", 0)
	MainScene:getObject(terrain):useShader(MainScene,"Shaders/terrain.xml")
	--MainScene:getObject(terrain):setMaterial("solid")
	MainScene:getObject(terrain):setMaterialFlag("gouraud_shading", 1)
	--MainScene:getObject(terrain):setMaterialFlag("mip_maps", 0)
	MainScene:getObject(terrain):setMaterialTexture(MainScene, 0, "Assets/Levels/world/textures/terrainMap.jpg")
	MainScene:getObject(terrain):setMaterialTexture(MainScene, 1, "Assets/Levels/world/textures/grass.png")
	MainScene:getObject(terrain):setMaterialTexture(MainScene, 2, "Assets/Levels/world/textures/rock.png")
	MainScene:getObject(terrain):setMaterialTexture(MainScene, 3, "Assets/Levels/world/textures/sand.jpg")
	MainScene:getObject(terrain):setMaterialFlag("trilinear", 1)
	generateTrees(MainScene:getTerrain(terrain), chunkx, chunky, chunksize, terrainScale)
	
	
	MainScene:getTerrain(terrain):makeStatic()
	return terrain
end

function removeChunk(chunkx, chunky)
	if MainScene:getMetaData("CHUNK"..chunkx.."_"..chunky) == 1 then
		MainScene:removeObject(MainScene:getMetaData("CHUNKID"..chunkx.."_"..chunky))
		MainScene:setMetaData("CHUNK"..chunkx.."_"..chunky, 0)
		if (MainScene:getMetaData("Water"..chunkx.."_"..chunky) ~= 0) then
		MainScene:removeObject(MainScene:getMetaData("Water"..chunkx.."_"..chunky))
		end
		removeTrees(chunkx, chunky)
	end
end

function updateChunk(terrain)
	MainScene:getObject(terrain):setMaterialFlag("normalize_normals", 1)
	--MainScene:getObject(terrain):setMaterialTexture(MainScene, 0, "Assets/Levels/World/textures/grass.jpg")
end
function addChunkCollider(terrain)
	terrain:addCollider(MainScene, "MESH_GIMPACT", 0)
	MainScene:getObject(terrain:getID()):getCollider():setFriction(100.0)
end
function generateTrees(terrain, chunkx, chunky, chunksize, terrainScale)
	MainScene:setMetaData("TREES_IN_"..chunkx.."_"..chunky, 0)
	MainScene:setMetaData("LEAVES_IN_"..chunkx.."_"..chunky, 0)
		local trees = 0
		local leaves = 0
		local cmnum = 1
		local c = CMESH.new(MainScene, 1000)
		local cmeshs = {}
		startAmount = 4
		for x=1, chunksize-1, startAmount do
			for y=1, chunksize-1, startAmount do
				local modX = x+(chunksize*chunkx)
				local modY = y+(chunksize*chunky)
				local createTree = System_getPerlinNoise(8, 0.5, 1107, 0.008, modX, 0, modY)
				if createTree > 0.5 then
					startAmount = math.ceil((System_getPerlinNoise(2, 0.1, 1107, 0.08, modX, 0, modY)+1)*8)
					local rotation = System_getPerlinNoise(2, 0.8, 11072015, 0.8, modX, 0, modY)*180
					MainScene:SLog(rotation)
					local treeType = math.floor((System_getPerlinNoise(1, 0.4, 1107, 0.08, modX, 0, modY)*enviroObjects)+(enviroObjects/2))
					if treeType < 1 then
						treeType = 1
					end
					if treeType > enviroObjects then
						treeType = enviroObjects
					end
					local posX
					if chunkx < 0 then
						posX = (x*terrainScale)+(((chunksize*math.abs(chunkx))*(-1))*terrainScale)
					else
						posX = (x*terrainScale)+((chunksize*math.abs(chunkx))*terrainScale)
					end
					local posY
					if chunky < 0 then
						posY = (y*terrainScale)+(((chunksize*math.abs(chunky))*(-1))*terrainScale)
					else
						posY = (y*terrainScale)+((chunksize*math.abs(chunky))*terrainScale)
					end
					local offsetX = (rotation/180)*(terrainScale/2) * 4
					local offsetY = (rotation/180)*(terrainScale/2) * 4
					--posX = posX + offsetX
					--posY = posY + offsetY
					local treeID = MainScene:addMesh(enviroFilenames[treeType], posX, (terrain:getHeight(x, y)*6.2)-2, posY, 0, rotation, 0, 4, 4, 4)
					MainScene:getObject(treeID):setMaterialFlag("gouraud_shading", 1)
					MainScene:getObject(treeID):setMaterialFlag("mip_maps", 0)
					MainScene:getObject(treeID):setMaterialData(0, "texture", MainScene, 0, "Assets/Levels/world/textures/mane.jpg")
					MainScene:getObject(treeID):setMaterialData(1, "texture", MainScene, 0, "Assets/Levels/world/textures/mane.jpg")
					c:addMesh(MainScene:getMesh(treeID))
					cmeshs[cmnum] = treeID
					cmnum = cmnum + 1
					local e = MainScene:addEmpty(posX, terrain:getHeight(x, y)*6.2 + 5, posY, 0, 0, 0, 3,10, 3)
					MainScene:getMesh(e):addCollider(MainScene, "CUBE", 0)
					MainScene:setMetaData("TREES_ID_"..chunkx.."_"..chunky.."_"..trees, e)
					--MainScene:setMetaData("TREES_ID_"..chunkx.."_"..chunky.."_"..trees, treeID)
					trees = trees + 1
					
				elseif createTree < -0.9 then
					local rotation = System_getPerlinNoise(2, 0.9, 11072015, 0.00008, modX, 0, modY)*180
					MainScene:SLog(rotation)
					local treeType = math.floor((System_getPerlinNoise(1, 0.9, 1107, 0.008, modX, 0, modY)*rocks)+(rocks/2))
					if treeType < 1 then
						treeType = 1
					end
					if treeType > rocks then
						treeType = rocks
					end
					local posX
					if chunkx < 0 then
						posX = (x*terrainScale)+(((chunksize*math.abs(chunkx))*(-1))*terrainScale)
					else
						posX = (x*terrainScale)+((chunksize*math.abs(chunkx))*terrainScale)
					end
					local posY
					if chunky < 0 then
						posY = (y*terrainScale)+(((chunksize*math.abs(chunky))*(-1))*terrainScale)
					else
						posY = (y*terrainScale)+((chunksize*math.abs(chunky))*terrainScale)
					end
					local offsetX = (rotation/180)*(terrainScale/2)
					local offsetY = (rotation/180)*(terrainScale/2)
					posX = posX + offsetX
					posY = posY + offsetY
					local treeID = MainScene:addMesh(rockFilenames[treeType], posX, (terrain:getHeight(x, y)*5)-2, posY, 0, rotation, 0, 2,2, 2)
					MainScene:getObject(treeID):setMaterialFlag("gouraud_shading", 1)
					MainScene:getObject(treeID):setMaterialFlag("mip_maps", 0)
					MainScene:getObject(treeID):setMaterialData(0, "texture", MainScene, 0, "Assets/Levels/world/textures/mane.jpg")
					c:addMesh(MainScene:getMesh(treeID))
					cmeshs[cmnum] = treeID
					cmnum = cmnum + 1
					local e = MainScene:addEmpty(posX, (terrain:getHeight(x, y)*5) + 3, posY, 0, 0, 0, 3,3, 3)
					MainScene:getMesh(e):addCollider(MainScene, "CUBE", 0)
					MainScene:setMetaData("TREES_ID_"..chunkx.."_"..chunky.."_"..trees, e)
					trees = trees + 1
				end
			end
		end
		local posX = 0
		local posY = 0
		if cmnum == 1 then return end
			local cm = MainScene:addCMesh(c, posX, 0, posY, 0, 0, 0, 1, 1, 1)
			MainScene:getObject(cm):setMaterialFlag("normalize_normals", 1)
			MainScene:getMesh(cm):makeStatic()
		
		--MainScene:getObject(cm):setMaterialFlag("mip_maps", 1)
		--MainScene:getObject(cm):setMaterialFlag("ansiotropic", 1)
		--MainScene:getObject(cm):setMaterialData(0, "texture", MainScene, 0, "Assets/Levels/world/textures/mane.jpg")
		--MainScene:getObject(cm):setMaterialData(1, "texture", MainScene, 0, "Assets/Levels/world/textures/mane.jpg")
		--MainScene:getObject(cm):setMaterialData(2, "texture", MainScene, 0, "Assets/Levels/world/textures/mane.jpg")
		MainScene:getObject(cm):setMaterialFlag("gouraud_shading", 1)
		MainScene:getObject(cm):setMaterialFlag("bilinear", 1)
		for i=1, cmnum-1 do
			--MainScene:removeObject(cmeshs[i])
		end
		MainScene:setMetaData("TREES_ID_"..chunkx.."_"..chunky.."_"..trees, cm)
		MainScene:setMetaData("TREES_IN_"..chunkx.."_"..chunky, trees)
end

function removeTrees(chunkx, chunky)
	local tree = MainScene:getMetaData("TREES_IN_"..chunkx.."_"..chunky)
	if tree > 0 then
		for i=0, tree do
			MainScene:removeObject(MainScene:getMetaData("TREES_ID_"..chunkx.."_"..chunky.."_"..i))
		end
	end
	MainScene:setMetaData("TREES_IN_"..chunkx.."_"..chunky, 0)
end
