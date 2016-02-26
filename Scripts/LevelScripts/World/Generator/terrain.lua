function generateChunk(terrain, cx, cy, size, scaling)
	local chunk = {}
	local temp = {}
	local humid = {}
	for x=0, size/scaling do
		chunk[x+1]={}
		temp[x+1]={}
		humid[x+1]={}
		for y=0, size/scaling do
			local worldx = (cx*size+(x*scaling))
			local worldy = (cy*size+(y*scaling))
			local height = System_getPerlinNoise(6, 0.2, 11071, 0.07, worldx, 0, worldy)+(System_getRidgedNoise(11, 11047, 0.003, worldx, 0, worldy))*50*System_getRidgedNoise(7, 11074, 0.002, worldx, 0, worldy)
			height = height-clamp(System_getRidgedNoise(1, 1107, 0.015, worldx, 0, worldy), 0, 1)*30
			chunk[x+1][y+1] = height
			temp[x+1][y+1] = clamp((System_getPerlinNoise(6, 0.9, 1107, 0.00008, worldx, 0, worldy)/2)+0.5, 0, 1)
			humid[x+1][y+1] = clamp((System_getPerlinNoise(6, 0.9, 1107,0.00007, worldx, 0, worldy)/2)+0.5, 0, 1)
			terrain:setHeightNoRebuild(x, y, chunk[x+1][y+1])
			terrain:setColor(x, y, temp[x+1][y+1], humid[x+1][y+1], 0, 1.0)
		end
	end
end

function distance ( x1, y1, x2, y2 )
  local dx = x1 - x2
  local dy = y1 - y2
  return math.sqrt ( dx * dx + dy * dy )
end

function clamp(value, low, high)
	if value <  low then return low end
	if value > high then return high end
	return value
end