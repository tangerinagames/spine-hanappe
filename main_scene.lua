module(..., package.seeall)

function onCreate(params)
    layer = Layer:new{scene = scene}

    local attachmentLoader = spine.AttachmentLoader.new()
    function attachmentLoader:createImage(attachment)
        local texture = "data/" .. attachment.name .. ".png"
        return Sprite:new{texture = texture, layer = layer}
    end

    local json = spine.SkeletonJson.new(attachmentLoader)
    json.scale = 0.7
    
    local skeletonData = json:readSkeletonDataFile("data/spineboy.json")

    skeleton = spine.Skeleton.new(skeletonData)
    skeleton:setLoc(0, 280)
    skeleton:moveLoc(480, 0, 5)
    skeleton.flipX = false
    skeleton.flipY = false
    skeleton.debug = false
    skeleton.debugLayer = layer
    skeleton:setToBindPose()
    
    local animationStateData = spine.AnimationStateData.new(skeletonData)
    animationStateData:setMix("walk", "jump", 0.2)
    animationStateData:setMix("jump", "walk", 0.2)

    animationState = spine.AnimationState.new(animationStateData)
    animationState:setAnimation("walk", true)
end

function onEnterFrame()
  animationState:update(MOAISim.getStep())
  animationState:apply(skeleton)
  
  skeleton:updateWorldTransform()

  if animationState.current.name == "jump" and animationState.currentTime > animationState.current.duration then
    animationState:setAnimation("walk", true)
  end
end

function onTouchDown()
  if animationState.current.name ~= "jump" then
    animationState:setAnimation("jump")
  end
end

