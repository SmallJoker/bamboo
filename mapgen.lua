function make_bamboo(pos, size)
	for y=0, size-1 do
		local p = {x=pos.x, y=pos.y+y, z=pos.z}
		local node = minetest.get_node(p).name
		if node == "air" then
			minetest.set_node(p, {name="bamboo:bamboo"})
		elseif node == "default:dirt" or name == "default:dirt_with_grass" then
			return
		else
			break
		end
	end
end

minetest.register_on_generated(function(minp, maxp, seed)
	if minp.y < -35 or maxp.y > 50 then
		return
	end
	if math.random(1, 4) ~= 2 then
		-- Making rare...
		return
	end
	
	for px = minp.x+2, maxp.x-2 do
	for pz = minp.z+2, maxp.z-2 do
		local pos = {x=px, y=1, z=pz}
		local node = minetest.get_node(pos).name
		if node == "default:desert_sand" then
			-- AAH! Too hot!
			return
		end
		if node == "default:dirt_with_grass" and math.random(1, 12) == 2 then
			if minetest.find_node_near(pos, 3, "default:water_source") then
				pos.y = pos.y + 1
				make_bamboo(pos, math.random(3, 6))
			end
		end
	end
	end
end)
