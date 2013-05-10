sound = {}
sound.sources = {}

function sound:handle(dt)
	local sounds = entitymgr:getEntitiesByComponent(cSound.name)

	for i, v in ipairs(sounds) do
		local snd = entitymgr:getComponent(v.uid, cSound.name)

		if snd then
			if self.sources[snd.file] == nil then
				local s = factory:getSound(snd.file)
				self.sources[snd.file] = love.audio.newSource(s)
				if snd.loop then self.sources[snd.file]:setLooping(true) end
				self.sources[snd.file]:play()
			else
				self.sources[snd.file]:rewind() 
				self.sources[snd.file]:play()
			end

			entitymgr:remove(v.uid)
		end
	end
end