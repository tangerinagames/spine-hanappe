local BaseSkeleton = require "spine.Skeleton"
local AttachmentLoader = require "spine.AttachmentLoader"
local Skeleton = {}

function Skeleton.new(skeletonData)
	local self = BaseSkeleton.new(skeletonData, {})

	function self:updateWorldTransform()
		for i,bone in ipairs(self.bones) do
			bone:updateWorldTransform(self.flipX, self.flipY)
		end

		for i,slot in ipairs(self.drawOrder) do
			local attachment = slot.attachment
			if attachment then
				local image = self.images[attachment]
				if not image then
					image = self.data.attachmentLoader:createImage(attachment)
					if image then
						image:setSize(attachment.width, attachment.height)
						image:setPriority(i)
						function image:removeSelf() image:setVisible(false) end
					else
						print("Error creating image: " .. attachment.name)
						image = AttachmentLoader.failed
					end
					self.images[attachment] = image
				end
				if image ~= AttachmentLoader.failed then
					local x, y, rotation, xScale, yScale = self:getAttachmentTransform(slot, attachment)
					image:setPos(x, y)
					image:setRot(0, 0, rotation)
					image:setScl(xScale, yScale)
				end
			end
		end

		if self.debug then
			for i,bone in ipairs(self.bones) do
				if not bone.line then
					bone.line = Graphics:new{width = bone.data.length, height = 1, layer = self.debugLayer}
					bone.line:setPenColor(1, 0, 0, 1):fillRect(0, 0, bone.data.length, 1)
					bone.line:setPiv(0, 0, 0)
				end

				local x, y = bone.worldX + self.x, -bone.worldY + self.y
				local rotation = bone.worldRotation
				local yScale, xScale = 1, 1

				if self.flipX then
					xScale = -1
					rotation = -rotation
				end
				if self.flipY then
					yScale = -1
					rotation = -rotation
				end

				bone.line:setScl(xScale, yScale)
				bone.line:setPos(x, y)
				bone.line:setRot(0, 0, -rotation)

				if not bone.circle then
					bone.circle = Graphics:new{width = 6, height = 6, layer = self.debugLayer}
					bone.circle:setPenColor(0, 1, 0, 1):fillCircle()
				end
				bone.circle:setPos(x - 3, y - 3)
			end
		end
	end

	function self:getAttachmentTransform(slot, attachment)
		local x = slot.bone.worldX + attachment.x * slot.bone.m00 + attachment.y * slot.bone.m01
		local y = -(slot.bone.worldY + attachment.x * slot.bone.m10 + attachment.y * slot.bone.m11)
		local rotation = slot.bone.worldRotation + attachment.rotation
		local xScale = slot.bone.worldScaleX + attachment.scaleX - 1
		local yScale = slot.bone.worldScaleY + attachment.scaleY - 1
		if self.flipX then
			xScale = -xScale
			rotation = -rotation
		end
		if self.flipY then
			yScale = -yScale
			rotation = -rotation
		end
		return x + self.x - attachment.width / 2, y + self.y - attachment.height / 2, -rotation, xScale, yScale
	end

	return self
end

return Skeleton
