module(..., package.seeall)

function onCreate(params)
    layer = Layer:new{scene = scene}

    local attachmentLoader = spine.AttachmentLoader.new()
    function attachmentLoader:createImage(attachment)
        local texture = "data/" .. attachment.name .. ".png"
        return Sprite:new{texture = texture, layer = layer}
    end

    local json = spine.SkeletonJson.new(attachmentLoader)
    json.scale = 0.5
    local skeletonData = json:readSkeletonDataFile("data/spineboy-skeleton.json")
    walkAnimation = json:readAnimationFile(skeletonData, "data/spineboy-walk.json")

    -- Optional second parameter can be the group for the Skeleton to use. Eg, could be an image group.
    skeleton = spine.Skeleton.new(skeletonData)
    skeleton.x = 240
    skeleton.y = 200
    skeleton.flipX = false
    skeleton.flipY = false
    skeleton.debug = true -- Omit or set to false to not draw debug lines on top of the images.
    skeleton.debugLayer = layer
    skeleton:setToBindPose()
    
    animationTime = 0
end

function onEnterFrame()
  animationTime = animationTime + MOAISim.getStep()
  
  walkAnimation:apply(skeleton, animationTime, true)
  skeleton:updateWorldTransform()
end
