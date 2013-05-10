text = {}

function text:handle() 
	local texts = entitymgr:getEntitiesByComponent(cText.name)

	for i, v in ipairs(texts) do
		local pos = entitymgr:getComponent(v.uid, cPos.name)
		local txt = entitymgr:getComponent(v.uid, cText.name)

		if pos ~= nil and txt ~= nil then
			love.graphics.setColor(txt.color.r, txt.color.g, txt.color.b)
			love.graphics.setFont(txt.font)
			love.graphics.printf(txt.str, pos.x, pos.y, txt.width, txt.align)
		end
	end
end