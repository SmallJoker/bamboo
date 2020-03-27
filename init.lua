-- check for MineClone2
local mcl = minetest.get_modpath("mcl_core")

if mcl then
    sounditem = mcl_sounds.node_sound_wood_defaults()
    item1 = "mcl_core:water_source"
    stairs = mcl_stairs
else
    sounditem = default.node_sound_wood_defaults()
    item1 = "default:water_source"
end

-- [bamboo] mod by Krock
-- License for everything: WTFPL
-- Bamboo max high: 10

minetest.register_node("bamboo:bamboo",{
	description = "Bamboo",
	tiles = {"bamboo_bamboo.png"},
	drawtype = "nodebox",
	paramtype = "light",
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=3},
	sounds = sounditem,
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
	description = "Bamboo Block",
	tiles = {"bamboo_bottom.png", "bamboo_bottom.png", "bamboo_block.png"},
	groups = {choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1},
	sounds = sounditem,
	paramtype2 = "facedir",
	on_place = minetest.rotate_node
})

minetest.register_alias("bamboo:block_h", "bamboo:block")

dofile(minetest.get_modpath("bamboo").."/mapgen.lua")

stairs.register_stair_and_slab( -- creates crafting recipes
	"bamboo",
	"bamboo:block",
	{choppy=2, oddly_breakable_by_hand=2, flammable=2, wood=1},
	{"bamboo_bottom.png", "bamboo_bottom.png", "bamboo_block.png"},
	"Bamboo Stair",
	"Bamboo Slab",
	sounditem
)

minetest.register_node("bamboo:slab_v",{
	description = "Bamboo Slab",
	tiles = {"bamboo_bottom.png", "bamboo_bottom.png", "bamboo_block.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2,oddly_breakable_by_hand=2,flammable=2},
	sounds = sounditem,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.5, 0},
		}
	}
})

minetest.register_alias("bamboo:slab_h", "stairs:slab_bamboo")

-- Craftings

minetest.register_craft({
	output = "bamboo:block",
	recipe = {
		{"bamboo:bamboo", "bamboo:bamboo", "bamboo:bamboo"},
	}
})

minetest.register_craft({
	output = "bamboo:slab_h 6",
	recipe = {
		{"bamboo:block", "bamboo:block", "bamboo:block"},
	}
})

minetest.register_craft({
	output = "bamboo:slab_v",
	recipe = {
		{"stairs:slab_bamboo"},
	}
})

minetest.register_craft({
	output = "stairs:slab_bamboo",
	recipe = {
		{"bamboo:slab_v"},
	}
})

minetest.register_craft({
	output = "bamboo:block",
	recipe = {
		{"bamboo:slab"},
		{"bamboo:slab"},
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

if minetest.get_modpath("moreblocks") then
	register_stair_slab_panel_micro(
	"bamboo",
	"block",
	"bamboo:block",
	{choppy=2, oddly_breakable_by_hand=2, flammable=2}, {
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
		if not minetest.find_node_near(pos, 5, {"group:water", item1}) then
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
