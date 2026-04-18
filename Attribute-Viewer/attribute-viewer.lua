--[[

Attribute Viewer by Ben Roffey

A lightweight mod that enables you to view Joker attributes in the collection.

Hover over cards in the collection to see a list of their attributes
Or use the "." key to print them to console

]]

local print_attributes
print_attributes = function()
	if not G.CONTROLLER.hovering.target then return end
	local target = G.CONTROLLER.hovering.target
	if target:is(Card) then
		local attributes = target.config.center.attributes
        local modded = false
		for k, v in ipairs(attributes) do
            print(v) 
            modded = true
		end
        if not modded then
            for k, v in pairs(attributes) do
			    if k then 
                    print(k)
                end
		    end
        end
	end
end

SMODS.Keybind{
	key_pressed = ".",
	action = function(self)
		print_attributes()
	end,
	event = "pressed"
}

local Attribute_Viewer

function overlay_attribute(text_rows)
    local t = {}
    if type(text_rows) ~= 'table' then text_rows = {"NONE"} end
    for k, v in ipairs(text_rows) do
        t[#t+1] = {n=G.UIT.R, config={align = "cm"}, nodes={
            {n=G.UIT.T, config={text = v, colour = G.C.UI.TEXT_LIGHT, scale = 0.3, juice = true, shadow = true}}
        }}
    end
    if #t == 0 then
        print(inspect(text_rows))
        for k, v in pairs(text_rows) do
            if v == true then
                t[#t+1] = {n=G.UIT.R, config={align = "cm"}, nodes={
                    {n=G.UIT.T, config={text = k, colour = G.C.UI.TEXT_LIGHT, scale = 0.3, juice = true, shadow = true}}
                }}
            end
        end
    end
    return {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR, padding = 0.1}, nodes=t}
  end

function create_UIBox_attribute_viewer(attributes)
    if G.OVERLAY_MENU then
    local _infotip_object = G.OVERLAY_MENU:get_UIE_by_ID('overlay_menu_infotip')
    if _infotip_object then 
        _infotip_object.config.object:remove() 
        _infotip_object.config.object = UIBox{
        definition = overlay_attribute(attributes),
        config = {offset = {x=-9,y=-10}, align = 'bm', parent = _infotip_object}
        }
    end
    end
    return true
end

local gen_ref = Card.generate_UIBox_ability_table
function Card.generate_UIBox_ability_table(self)
	local ret = gen_ref(self) --vanilla function called on loc_vars, then write attributes to the attribute viewer menu

	local attributes = self.config.center.attributes
    if not attributes then return ret end
	Attribute_Viewer = create_UIBox_attribute_viewer(attributes)

	return ret
end