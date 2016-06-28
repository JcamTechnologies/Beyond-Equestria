function spawnStatic()
	for i=0, 1000 do
		local t = MainScene:addMesh("Assets/Levels/world/models/debugChain.dae", 0, 0, 0, 0, i, i/100, 1,1, 1)
		MainScene:getMesh(t):makeStatic()
	end
end

function spawnCmesh()
	local c = CMESH.new(MainScene, 2000)
	for i=0, 1000 do
		local t = MainScene:addMesh("Assets/Levels/world/models/debugChain.dae", 0, 0, 0, 0, i, i/100, 1,1, 1)
		c:addMesh(MainScene:getMesh(t))
	end
	MainScene:addCMesh(c, 0, 0, 0, 0, 0, 0, 1, 1, 1)
end