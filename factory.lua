factory = {}
factory.images = {}
factory.batches = {}
factory.sounds = {}

function factory:getImage(file)
	if self.images[file] == nil then
		self.images[file] = self:loadImage(file)
	end

	return self.images[file]
end

function factory:loadImage(file)
	return love.graphics.newImage(file)
end

function factory:createBatch(file)
	return love.graphics.newSpriteBatch(self:getImage(file))
end

function factory:getBatch(file)
	if self.batches[file] == nil then
		self.batches[file] = self:createBatch(file)
	end

	return self.batches[file]
end

function factory:getSound(file)
	if self.sounds[file] == nil then
		self.sounds[file] = self:createSound(file)
	end

	return self.sounds[file]
end

function factory:createSound(file)
	return love.sound.newSoundData(file)
end