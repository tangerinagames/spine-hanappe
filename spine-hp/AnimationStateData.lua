local AnimationStateData = {}

function AnimationStateData.new(skeletonData)
	if not skeletonData then error("skeletonData cannot be nil", 2) end

	local self = {
		skeletonData = skeletonData,
		animationToMixTime = {}
	}

	function self:setMix(fromName, toName, duration)
		local from = self.skeletonData:findAnimation(fromName);
		if not from then error("Animation not found: " + fromName, 2) end
		local to = self.skeletonData:findAnimation(toName);
		if not to then error("Animation not found: " + fromName, 2) end

		self.animationToMixTime[fromName .. "|" .. toName] = duration
	end

	function self:getMix(fromName, toName)
		return self.animationToMixTime[fromName .. "|" .. toName] or 0
	end

	return self
end

return AnimationStateData
