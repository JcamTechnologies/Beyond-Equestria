System_run("Scripts/GUI/PonyEditor/tables.lua", MainScene)
function onClick()
	local body = MainScene:getMetaData("PLAYER_GENDER")+1
	local uppermane = MainScene:getMetaData("PLAYER_UPPER_MANE")
	local lowermane = MainScene:getMetaData("PLAYER_LOWER_MANE")
	local tail = MainScene:getMetaData("PLAYER_TAIL")
	local bodyR = MainScene:getMetaData("PLAYER_BODY_COLOR_R")
	local bodyG = MainScene:getMetaData("PLAYER_BODY_COLOR_G")
	local bodyB = MainScene:getMetaData("PLAYER_BODY_COLOR_B")
	
	local umane1R = MainScene:getMetaData("PLAYER_UMANE1_COLOR_R")
	local umane1G = MainScene:getMetaData("PLAYER_UMANE1_COLOR_G")
	local umane1B = MainScene:getMetaData("PLAYER_UMANE1_COLOR_B")
	
	local umane2R = MainScene:getMetaData("PLAYER_UMANE2_COLOR_R")
	local umane2G = MainScene:getMetaData("PLAYER_UMANE2_COLOR_G")
	local umane2B = MainScene:getMetaData("PLAYER_UMANE2_COLOR_B")
	
	local race = MainScene:getMetaData("PLAYER_RACE")
	--BODY--
	if(MainScene:getMetaData("PLAYER_BODY_SPAWNED") == 1) then
		MainScene:removeObject(MainScene:getMetaData("PLAYER_BODY_ID"))
	end
	local curBody = MainScene:addBoneAnimatedMesh(bodyFiles[body], 0, 0, 0, 0, -90, 0, 0.2, 0.2, 0.2)
	MainScene:getObject(curBody):setMaterialFlag("normalize_normals", 1)
	MainScene:getObject(curBody):setMaterial("solid")
	MainScene:getBoneAnimatedMesh(curBody):addAnimation("idle","Assets/Levels/world/models/ponies/anims/idle.ms3d")
	MainScene:getBoneAnimatedMesh(curBody):setAnimation("idle")
	MainScene:getBoneAnimatedMesh(curBody):setSpeed(10)
	MainScene:getBoneAnimatedMesh(curBody):setFrameLoop(1, 200)
	MainScene:getBoneAnimatedMesh(curBody):addAnimation("walk","Assets/Levels/world/models/ponies/anims/walk_n.ms3d")
	MainScene:getBoneAnimatedMesh(curBody):addAnimation("trot","Assets/Levels/world/models/ponies/anims/trot_n.ms3d")
	MainScene:getBoneAnimatedMesh(curBody):addAnimation("lWalk","Assets/Levels/world/models/ponies/anims/straifLeft.ms3d")
	MainScene:getBoneAnimatedMesh(curBody):addAnimation("rWalk","Assets/Levels/world/models/ponies/anims/straifRight.ms3d")
	MainScene:getBoneAnimatedMesh(curBody):addAnimation("idle1","Assets/Levels/world/models/ponies/anims/idle1.ms3d")
	MainScene:getObject(curBody):attachTo(getObjectByName(MainScene, "PLAYERCAMTARGET"))
	MainScene:getObject(curBody):setMaterialData(0, "diffuse_color", 255, bodyR, bodyG, bodyB)
	MainScene:setMetaData("PLAYER_BODY_ID", curBody)
	MainScene:setMetaData("PLAYER_BODY_SPAWNED", 1)
	
	MainScene:getObject(curBody):setMaterialData(0, "texture", MainScene, 1, "Assets/Levels/world/textures/body.jpg")
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
	MainScene:getObject(curBody):setMaterialData(1, "diffuse_color", 0, 255, 255, 255)
	MainScene:getObject(curBody):setMaterialData(2, "diffuse_color", 0, 255, 255, 255)
	MainScene:getObject(curBody):setMaterialData(0, "specular_color", 0, 0, 0, 0)
	--MainScene:getObject(curBody):useShader(MainScene, "Shaders/bodyShader.xml")
	--RACE--
	if(MainScene:getMetaData("PLAYER_ACCESSORIES_SPAWNED") > 0) then
		for i=0, MainScene:getMetaData("PLAYER_ACCESSORIES_SPAWNED")-1 do
			MainScene:removeObject(MainScene:getMetaData("PLAYER_ACCESSORY_ID_"..i))
		end
	end
	local acc = 0
	if race == 1 then
		local horn = MainScene:addMesh(raceItemFilenames[1], 0, 0, 0, 0, 90, 0, 1, 1, 1)
		MainScene:getObject(horn):setMaterialData(0, "diffuse_color", 255, bodyR, bodyG, bodyB)
		MainScene:getObject(horn):setMaterialData(0, "specular_color", 0, 0, 0, 0)
		MainScene:setMetaData("PLAYER_ACCESSORY_ID_"..acc, horn)
		MainScene:getObject(horn):attachTo(MainScene:getObject(curBody))
		MainScene:getObject(horn):setMaterialData(0, "texture", MainScene, 1, "Assets/Levels/world/textures/horn.jpg")
		acc = acc + 1
	elseif race == 2 then
		local wings = MainScene:addMesh(raceItemFilenames[2], 0, 0, 0, 0, 90, 0, 1, 1, 1)
		MainScene:getObject(wings):setMaterialData(0, "diffuse_color", 255, bodyR, bodyG, bodyB)
		MainScene:getObject(wings):setMaterialData(0, "specular_color", 0, 0, 0, 0)
		MainScene:getObject(wings):attachTo(MainScene:getObject(curBody))
		MainScene:getObject(wings):setMaterialData(0, "texture", MainScene, 1, "Assets/Levels/world/textures/wings.jpg")
		MainScene:setMetaData("PLAYER_ACCESSORY_ID_"..acc, wings)
		acc = acc + 1
	end
	MainScene:setMetaData("PLAYER_ACCESSORIES_SPAWNED", acc)
	--MANE--
	if(MainScene:getMetaData("PLAYER_UPPER_MANE_SPAWNED") == 1) then
		MainScene:removeObject(MainScene:getMetaData("PLAYER_UPPER_MANE_ID"))
	end
	if uppermane ~= 0 then
		local curUMane = MainScene:addBoneAnimatedMesh(upperManeFiles[uppermane], 0, 0, 0, 0, 0, 0, 1, 1, 1)
		--MainScene:getBoneAnimatedMesh(curBody):attachToBone(MainScene:getObject(curUMane), "LrigNeck3")
		MainScene:getObject(curUMane):attachTo(MainScene:getObject(curBody))
		MainScene:getObject(curUMane):useShader(MainScene, "Shaders/bodyShader.xml")
		MainScene:setMetaData("PLAYER_UPPER_MANE_ID", curUMane)
		MainScene:setMetaData("PLAYER_UPPER_MANE_SPAWNED", 1) 
		MainScene:getObject(curUMane):setMaterialData(0, "diffuse_color", 255, umane1R, umane1G, umane1B)
		MainScene:getObject(curUMane):setMaterialData(1, "diffuse_color", 255, umane2R, umane2G, umane2B)
		MainScene:getBoneAnimatedMesh(curUMane):addAnimation("idle","Assets/Levels/world/models/ponies/anims/idle.ms3d")
		MainScene:getBoneAnimatedMesh(curUMane):setAnimation("idle")
		MainScene:getBoneAnimatedMesh(curUMane):setSpeed(10)
		MainScene:getBoneAnimatedMesh(curUMane):setFrameLoop(1, 200)
		MainScene:getBoneAnimatedMesh(curUMane):addAnimation("walk","Assets/Levels/world/models/ponies/anims/walk_n.ms3d")
		MainScene:getBoneAnimatedMesh(curUMane):addAnimation("trot","Assets/Levels/world/models/ponies/anims/trot_n.ms3d")
		MainScene:getBoneAnimatedMesh(curUMane):addAnimation("lWalk","Assets/Levels/world/models/ponies/anims/straifLeft.ms3d")
		MainScene:getBoneAnimatedMesh(curUMane):addAnimation("rWalk","Assets/Levels/world/models/ponies/anims/straifRight.ms3d")
		MainScene:getBoneAnimatedMesh(curUMane):addAnimation("idle1","Assets/Levels/world/models/ponies/anims/idle1.ms3d")
	else
		MainScene:setMetaData("PLAYER_UPPER_MANE_SPAWNED", 0)
	end
	
	
	if(MainScene:getMetaData("PLAYER_LOWER_MANE_SPAWNED") == 1) then
		MainScene:removeObject(MainScene:getMetaData("PLAYER_LOWER_MANE_ID"))
	end
	if lowermane ~= 0 then
		local curLMane = MainScene:addBoneAnimatedMesh(lowerManeFiles[lowermane], 0, 0, 0, 0, 0, 0, 1, 1, 1)
		MainScene:getObject(curLMane):attachTo(MainScene:getObject(curBody))
		MainScene:getObject(curLMane):useShader(MainScene, "Shaders/bodyShader.xml")
		MainScene:setMetaData("PLAYER_LOWER_MANE_ID", curLMane)
		MainScene:setMetaData("PLAYER_LOWER_MANE_SPAWNED", 1)
		MainScene:getObject(curLMane):setMaterialData(0, "diffuse_color", 255, umane1R, umane1G, umane1B)
		MainScene:getObject(curLMane):setMaterialData(1, "diffuse_color", 255, umane2R, umane2G, umane2B)
		MainScene:getBoneAnimatedMesh(curLMane):addAnimation("idle","Assets/Levels/world/models/ponies/anims/idle.ms3d")
		MainScene:getBoneAnimatedMesh(curLMane):setAnimation("idle")
		MainScene:getBoneAnimatedMesh(curLMane):setSpeed(10)
		MainScene:getBoneAnimatedMesh(curLMane):setFrameLoop(1, 200)
		
		MainScene:getBoneAnimatedMesh(curLMane):addAnimation("walk","Assets/Levels/world/models/ponies/anims/walk_n.ms3d")
		MainScene:getBoneAnimatedMesh(curLMane):addAnimation("trot","Assets/Levels/world/models/ponies/anims/trot_n.ms3d")
		MainScene:getBoneAnimatedMesh(curLMane):addAnimation("lWalk","Assets/Levels/world/models/ponies/anims/straifLeft.ms3d")
		MainScene:getBoneAnimatedMesh(curLMane):addAnimation("rWalk","Assets/Levels/world/models/ponies/anims/straifRight.ms3d")
		MainScene:getBoneAnimatedMesh(curLMane):addAnimation("idle1","Assets/Levels/world/models/ponies/anims/idle1.ms3d")
	else
		MainScene:setMetaData("PLAYER_LOWER_MANE_SPAWNED", 0)
	end
	--TAIL--
	if(MainScene:getMetaData("PLAYER_TAIL_SPAWNED") == 1) then
		MainScene:removeObject(MainScene:getMetaData("PLAYER_TAIL_ID"))
	end
	if tail ~= 0 then
		local curTail = MainScene:addBoneAnimatedMesh(tailFiles[tail], 0, 0, 0, 0, 90, 0, 1, 1, 1)
		MainScene:getObject(curTail):attachTo(MainScene:getObject(curBody))
		MainScene:getObject(curTail):useShader(MainScene, "Shaders/bodyShader.xml")
		MainScene:setMetaData("PLAYER_TAIL_ID", curTail)
		MainScene:setMetaData("PLAYER_TAIL_SPAWNED", 1)
		MainScene:getObject(curTail):setMaterialData(0, "diffuse_color", 255, umane1R, umane1G, umane1B)
		MainScene:getObject(curTail):setMaterialData(1, "diffuse_color", 255, umane2R, umane2G, umane2B)
		MainScene:getBoneAnimatedMesh(curTail):addAnimation("idle","Assets/Levels/world/models/ponies/anims/idle.ms3d")
		MainScene:getBoneAnimatedMesh(curTail):setAnimation("idle")
		MainScene:getBoneAnimatedMesh(curTail):setSpeed(10)
		MainScene:getBoneAnimatedMesh(curTail):setFrameLoop(1, 200)
		
		MainScene:getBoneAnimatedMesh(curTail):addAnimation("walk","Assets/Levels/world/models/ponies/anims/walk_n.ms3d")
		MainScene:getBoneAnimatedMesh(curTail):addAnimation("trot","Assets/Levels/world/models/ponies/anims/trot_n.ms3d")
		MainScene:getBoneAnimatedMesh(curTail):addAnimation("lWalk","Assets/Levels/world/models/ponies/anims/straifLeft.ms3d")
		MainScene:getBoneAnimatedMesh(curTail):addAnimation("rWalk","Assets/Levels/world/models/ponies/anims/straifRight.ms3d")
		MainScene:getBoneAnimatedMesh(curTail):addAnimation("idle1","Assets/Levels/world/models/ponies/anims/idle1.ms3d")
	else
		MainScene:setMetaData("PLAYER_TAIL_SPAWNED", 0)
	end
end

function getObjectByName(scene, name)
	for i = 0, scene:Objects(), 1 do
		if scene:getObject(i) then
			if scene:getObject(i):getName() == name then
				return scene:getObject(i)
			end
		end
	end
	return nil
end