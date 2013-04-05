local AnimationState = {}

function AnimationState.new(animationStateData)
	if not animationStateData then error("animationStateData cannot be nil", 2) end

	local self = {
		animationStateData = animationStateData,
		current = nil,
		previous = nil,
		currentTime = 0,
		previousTime = 0,
		currentLoop = false,
		previousLoop = false,
		mixTime = 0,
		mixDuration = 0
	}

	function self:update(delta)
		self.currentTime = self.currentTime + delta
		self.previousTime = self.previousTime + delta
		self.mixTime = self.mixTime + delta
	end

	function self:apply(skeleton)
		if self.current then
			if self.previous then
				self.previous:apply(skeleton, self.previousTime, self.previousLoop)
				local alpha = self.mixTime / self.mixDuration
				if alpha >= 1 then
					alpha = 1
					self.previous = nil
				end
				self.current:mix(skeleton, self.currentTime, self.currentLoop, alpha)
			else
				self.current:apply(skeleton, self.currentTime, self.currentLoop)
			end
		end
	end

	function self:setAnimation(animationName, loop)
		local animation = self.animationStateData.skeletonData:findAnimation(animationName)
		if not animation then error("Animation not found: " + animationName, 2) end
		
		self.previous = nil
		if animation and self.current then
			self.mixDuration = self.animationStateData:getMix(self.current.name, animationName)
			if self.mixDuration > 0 then
				self.mixTime = 0
				self.previous = self.current
				self.previousTime = self.currentTime
				self.previousLoop = self.currentLoop
			end
		end
		self.current = animation
		self.currentLoop = loop
		self.currentTime = 0
	end

	return self
end

return AnimationState
