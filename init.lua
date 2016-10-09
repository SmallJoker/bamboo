-- [bamboo] mod by Krock
-- License for everything: WTFPL
-- Bamboo max high: 10

minetest.register_node("bamboo:bamboo",{
	description = "Bamboo",
	tiles = {"bamboo_bamboo.png"},
	drawtype = "nodebox",
	paramtype = "light",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=3},
	sounds = default.node_sound_wood_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{0.1875, -0.5, -0.125, 0.4125, 0.5, 0.0625},
			{-0.125, -0.5, 0.125, -0.3125, 0.5, 0.3125},
			{-0.25, -0.5, -0.3125, 0, 0.5,-0.125},
		}
	},
})

minetest.register_node("bamboo:block",{
	description = "Bamboo block",
	tiles = {"bamboo_bottom.png", "bamboo_bottom.png", "bamboo_block.png"},
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1},
	sounds = default.node_sound_wood_defaults(),
})


dofile(minetest.get_modpath("bamboo").."/mapgen.lua")


minetest.register_node("bamboo:block_h",{
	description = "Bamboo block",
	tiles = {"bamboo_block.png",
		"bamboo_block.png",
		"bamboo_block.png^[transformR90",
		"bamboo_block.png^[transformR90",
		"bamboo_bottom.png",
		"bamboo_bottom.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2,oddly_breakable_by_hand=2,flammable=2,wood=1},
	sounds = default.node_sound_wood_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		}
	}
})

minetest.register_node("bamboo:slab_h",{
	description = "Bamboo slab",
	tiles = {"bamboo_block.png",
		"bamboo_block.png",
		"bamboo_block.png^[transformR90",
		"bamboo_block.png^[transformR90",
		"bamboo_bottom.png",
		"bamboo_bottom.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2,oddly_breakable_by_hand=2,flammable=2},
	sounds = default.node_sound_wood_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
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
			{-0.5, -0.5, -0.5, 0.5, 0.5, 0},
		}
	}
})

-- Craftings

minetest.register_craft({
	output = "bamboo:block",
	recipe = {
		{"bamboo:bamboo", "bamboo:bamboo", "bamboo:bamboo"},
	}
})

minetest.register_craft({
	output = "bamboo:block 2",
	recipe = {
		{"bamboo:block_h"},
		{""},
		{"bamboo:block_h"},
	}
})

minetest.register_craft({
	output = "bamboo:block_h 2",
	recipe = {
		{"bamboo:block", "", "bamboo:block"},
	}
})

minetest.register_craft({
	output = "bamboo:slab_h 6",
	recipe = {
		{"bamboo:block", "bamboo:block", "bamboo:block"},
	}
})

minetest.register_craft({
	output = "bamboo:slab_v 6",
	recipe = {
		{"bamboo:block"},
		{"bamboo:block"},
		{"bamboo:block"}
	}
})

minetest.register_craft({
	output = "bamboo:slab_v",
	recipe = {
		{"bamboo:slab_h"},
	}
})

minetest.register_craft({
	output = "bamboo:slab_h",
	recipe = {
		{"bamboo:slab_v"},
	}
})

minetest.register_craft({
	output = "bamboo:block",
	recipe = {
		{"bamboo:slab_v", "bamboo:slab_v"},
	}
})

minetest.register_craft({
	output = "bamboo:block",
	recipe = {
		{"bamboo:slab_h"},
		{"bamboo:slab_h"},
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

if minetest.get_modpath("moreblocks") then
	register_stair_slab_panel_micro(
		"bamboo",
		"block",
		"bamboo:block",
		{choppy=2, oddly_breakable_by_hand=2, flammable=2},
		{
			"bamboo_block.png",
			"bamboo_block.png",
			"bamboo_bottom.png",
			"bamboo_bottom.png",
			"bamboo_block.png",
			"bamboo_block.png"
		},
		"Bamboo",
		"block",
		0
	)
	table.insert(circular_saw.known_stairs, "bamboo:block")
end

--ABMs

minetest.register_abm({
	nodenames = {"bamboo:bamboo"},
	interval = 50,
	chance = 50,
	action = function(pos, node)
		if minetest.get_node_light(pos) < 8 then
			return
		end
		if not minetest.find_node_near(p_pos, 5, {"group:water", "default:water_source"}) then
			return
		end
		local found_soil = false
		for py = -1, -6, -1 do
			local name = minetest.get_node({x=pos.x, y=pos.y+py, z=pos.z}).name
			if minetest.get_item_group(name, "soil") ~= 0 then
				found_soil = true
				break
			elseif name ~= "bamboo:bamboo" then
				break
			end
		end
		if not found_soil then
			return
		end
		for py = 1, 4 do
			local npos = {x=pos.x,y=pos.y+py,z=pos.z}
			local name = minetest.get_node(npos).name
			if name == "air" then
				minetest.set_node(npos, {name="bamboo:bamboo"})
				break
			elseif name ~= "bamboo:bamboo" then
				break
			end
		end
	end,
})