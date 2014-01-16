-- [bamboo] mod by Krock
-- License for everything: WTFPL
-- Bamboo max high: 10

minetest.register_node("bamboo:bamboo",{
        description = "Bamboo",
        tiles = {"bamboo_bamboo.png"},
        drawtype = "nodebox",
        paramtype = "light",
        groups = {choppy=2,oddly_breakable_by_hand=2,flammable=3},
        sounds = default.node_sound_wood_defaults(),
        node_box = {
                type = "fixed",
                fixed = {
                        {0.1875,-0.5,-0.125,0.4125,0.5,0.0625}, --NodeBox1
                        {-0.125,-0.5,0.125,-0.3125,0.5,0.3125}, --NodeBox2
                        {-0.25,-0.5,-0.3125,0,0.5,-0.125}, --NodeBox3
                }
        },
})

minetest.register_node("bamboo:block",{
        description = "Bamboo block",
        tiles = {"bamboo_bottom.png", "bamboo_bottom.png", "bamboo_block.png"},
        groups = {choppy=2,oddly_breakable_by_hand=2,flammable=2,wood=1},
        sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("bamboo:block_h",{
        description = "Bamboo block",
        tiles = {
                "bamboo_block.png", 
                "bamboo_block.png", 
                "bamboo_bottom.png", 
                "bamboo_bottom.png", 
                "bamboo_block.png", 
                "bamboo_block.png"},
        drawtype = "nodebox",
        paramtype = "light",
        paramtype2 = "facedir",
        groups = {choppy=2,oddly_breakable_by_hand=2,flammable=2,wood=1},
        sounds = default.node_sound_wood_defaults(),
        node_box = {
                type = "fixed",
                fixed = {
                        {-0.5,-0.5,-0.5,0.5,0.5,0.5}, --NodeBox1
                }
        }
})

minetest.register_node("bamboo:slab_h",{
        description = "Bamboo slab",
        tiles = {
                "bamboo_block.png", 
                "bamboo_block.png", 
                "bamboo_bottom.png", 
                "bamboo_bottom.png", 
                "bamboo_block.png", 
                "bamboo_block.png"},
        drawtype = "nodebox",
        paramtype = "light",
        paramtype2 = "facedir",
        groups = {choppy=2,oddly_breakable_by_hand=2,flammable=2},
        sounds = default.node_sound_wood_defaults(),
        node_box = {
                type = "fixed",
                fixed = {
                        {-0.5,-0.5,-0.5,0.5,0.0,0.5}, --NodeBox1
                }
        }
})

minetest.register_node("bamboo:slab_v",{
        description = "Bamboo slab",
        tiles = {"bamboo_bottom.png", "bamboo_bottom.png", "bamboo_block.png"},
        drawtype = "nodebox",
        paramtype = "light",
        paramtype2 = "facedir",
        groups = {choppy=2,oddly_breakable_by_hand=2,flammable=2},
        sounds = default.node_sound_wood_defaults(),
        node_box = {
                type = "fixed",
                fixed = {
                        {-0.5,-0.5,-0.5,0.5,0.5,0}, --NodeBox1
                }
        }
})

-- Craftings

minetest.register_craft({
        output = 'bamboo:block',
        recipe = {
                {'bamboo:bamboo', 'bamboo:bamboo', 'bamboo:bamboo'},
        }
})

minetest.register_craft({
        output = 'bamboo:block 2',
        recipe = {
                {'bamboo:block_h'},
                {''},
                {'bamboo:block_h'},
        }
})

minetest.register_craft({
        output = 'bamboo:block_h 2',
        recipe = {
                {'bamboo:block', '', 'bamboo:block'},
        }
})

minetest.register_craft({
        output = 'bamboo:slab_h 4',
        recipe = {
                {'bamboo:block', 'bamboo:block'},
        }
})

minetest.register_craft({
        output = 'bamboo:slab_v 4',
        recipe = {
                {'bamboo:block'},
                {'bamboo:block'},
        }
})

minetest.register_craft({
        output = 'bamboo:slab_v',
        recipe = {
                {'bamboo:slab_h'},
        }
})

minetest.register_craft({
        output = 'bamboo:slab_h',
        recipe = {
                {'bamboo:slab_v'},
        }
})

minetest.register_craft({
        output = 'bamboo:block',
        recipe = {
                {'bamboo:slab_h', 'bamboo:slab_h'},
        }
})

minetest.register_craft({
        output = 'bamboo:block',
        recipe = {
                {'bamboo:slab_v'},
                {'bamboo:slab_v'},
        }
})

-- Fuels

minetest.register_craft({
        type = "fuel",
        recipe = "bamboo:bamboo",
        burntime = 15,
})

minetest.register_craft({
        type = "fuel",
        recipe = "bamboo:block",
        burntime = 50,
})

minetest.register_craft({
        type = "fuel",
        recipe = "bamboo:block_h",
        burntime = 50,
})

--ABMs

minetest.register_abm({
        nodenames = {"bamboo:bamboo"},
        interval = 50,
        chance = 25,
        action = function(pos, node)
                if(minetest.get_node_light(pos) < 8) then
                        return
                end
                local found_soil = false
                for py = -1, -6, -1 do
                        local name = minetest.get_node({x=pos.x,y=pos.y+py,z=pos.z}).name
                        if(minetest.get_item_group(name, "soil") ~= 0) then
                                found_soil = true
                                break
                        elseif(name ~= "bamboo:bamboo") then
                                break
                        end
                end
                if (not found_soil) then
                        return
                end
                for py = 1, 4 do
                        local npos = {x=pos.x,y=pos.y+py,z=pos.z}
                        local name = minetest.get_node(npos).name
                        if(name == "air" or name == "default:water_flowing") then
                                if(minetest.get_node_light(npos) < 8) then
                                        break
                                end
                                minetest.set_node(npos, {name="bamboo:bamboo"})
                                break
                        elseif(name ~= "bamboo:bamboo") then
                                break
                        end
                end
        end,
})

--Mapgen Stuff
function make_bamboo(pos, size)
	for y=0,size-1 do
		local p = {x=pos.x, y=pos.y+y, z=pos.z}
		local nn = minetest.get_node(p).name
		if minetest.registered_nodes[nn] and
			minetest.registered_nodes[nn].buildable_to then
			minetest.set_node(p, {name="bamboo:bamboo"})
		else
			return
		end
	end
end

minetest.register_on_generated(function(minp, maxp, seed)
	if maxp.y >= 2 and minp.y <= 0 then
		-- Generate Bamboo
		local perlin1 = minetest.get_perlin(354, 3, 0.7, 100)
		-- Assume X and Z lengths are equal
		local divlen = 8
		local divs = (maxp.x-minp.x)/divlen+1;
		for divx=0,divs-1 do
		for divz=0,divs-1 do
			local x0 = minp.x + math.floor((divx+0)*divlen)
			local z0 = minp.z + math.floor((divz+0)*divlen)
			local x1 = minp.x + math.floor((divx+1)*divlen)
			local z1 = minp.z + math.floor((divz+1)*divlen)
			-- Determine bamboo amount from perlin noise
			local bamboo_amount = math.floor(perlin1:get2d({x=x0, y=z0}) * 45 - 20)
			-- Find random positions for Bamboo based on this random
			local pr = PseudoRandom(seed+1)
			for i=0,bamboo_amount do
				local x = pr:next(x0, x1)
				local z = pr:next(z0, z1)
				if minetest.get_node({x=x,y=1,z=z}).name == "default:dirt_with_grass" and
						minetest.find_node_near({x=x,y=1,z=z}, 1, "default:water_source") then
					make_bamboo({x=x,y=2,z=z}, pr:next(2, 4))
				end
			end
		end
		end
	end
end)
