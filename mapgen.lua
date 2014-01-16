function make_bamboo(pos, size)
	for y=0,size-1 do
		local p = {x=pos.x, y=pos.y+y, z=pos.z}
		local nn = minetest.get_node(p).name
		if nn == "air" then
			minetest.set_node(p, {name="bamboo:bamboo"})
		elseif (nn == "default:dirt" or nn == "default:dirt_with_grass") then
			return
		else
			break
		end
	end
end

minetest.register_on_generated(function(minp, maxp, seed)
	if(minp.y < -35 or maxp.y > 50) then
		return
	end
	if(math.random(1,8) ~= 2) then
		-- Making rare...
		return
	end
	local stop = false
	for px=minp.x+2,maxp.x-2 do
	for pz=minp.z+2,maxp.z-2 do
		local cname = minetest.get_node({x=px,y=1,z=pz}).name
		if(cname == "default:desert_sand") then
			-- AAH! Too hot!
			stop = true
			break
		end
		if(cname == "default:dirt_with_grass" and math.random(1,15) == 2) then
			if minetest.find_node_near({x=px,y=1,z=pz}, 2, "default:water_source") then
				make_bamboo({x=px,y=2,z=pz}, math.random(3, 6))
			end
		end
	end
		if(stop) then
			break
		end
	end
end)
