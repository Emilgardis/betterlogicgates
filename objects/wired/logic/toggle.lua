function init()
  object.setInteractive(false)
  if storage.state == nil then
    storage.state = false
  end
  if storage.status == nil then
    storage.status = 0
  end
end

function switch()
  storage.state = not storage.state
  object.setAllOutputNodes(storage.state)
  if storage.state then
    animator.setAnimationState("switchState", "on")
  else
    animator.setAnimationState("switchState", "off")
  end
  sb.logInfo("State is %s", tostring(storage.state))
end 

function update(dt)
  if object.getInputNodeLevel(0) and storage.status == 0 then
    switch()
    storage.status = 1
  elseif object.getInputNodeLevel(0) == false and storage.status == 1 then
    storage.status = 2
  elseif object.getInputNodeLevel(0) and storage.status == 2 then
    storage.status = 0
  end
end