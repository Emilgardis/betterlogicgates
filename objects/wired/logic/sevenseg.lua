function init()
  object.setInteractive(true)
  if storage.isOn == nil then
    storage.isOn = false
  end
  if storage.toggled == nil then
    storage.toggled = false
  end
  if storage.truth == nil then
  storage.truth = {}
    for i=1, 7 do
      storage.truth[i] = false
    end
  end
end

function change()
  local directive = "replace="
  -- This turned ut to not be as good as I thought it would be
  if storage.isOn == true then
    animator.setLightColor("glow", {90,75,60})
    animator.setLightActive("glow", true)
  elseif storage.toggled == true then
    animator.setLightColor("glow", {75,75,75})
    animator.setLightActive("glow", true)
  elseif storage.isOn == false then
    animator.setLightActive("glow", false)
  end
  color = "ffffff"
  for i,t in ipairs(storage.truth) do
    if i ~= 1 then directive = directive..";" end
    if t == true then
      color = "ff0000"
    else
      color = "404040"
    end
    directive = directive..string.format("ffdea%d=%s", i, color)
  end
  if storage.directive ~= directive then 
    --sb.logInfo("Sending: %s", directive)
    object.setProcessingDirectives(directive)
  end
end 

function onNodeConnectionChange(args)
  --shamelessly implemented from customsigns.lua
  local isConnected = false
  for i=1, 7 do
    if object.isInputNodeConnected(i-1) then 
      isConnected = true
    end
  end
  object.setInteractive(not isConnected)
end

function onInteraction(args)
  storage.toggled = not storage.toggled
end

function update(dt)
  storage.isOn = false
  for i=1, 7 do
    storage.truth[i] = object.getInputNodeLevel(i-1)
    if object.getInputNodeLevel(i-1) ==true then
      storage.isOn = true
    end
  end
  change()
end

-- Borrowed from customsigns.lua
function convertRGBAtoArray(rgba)
  return {tonumber(string.sub(rgba,1,2),16),
  tonumber(string.sub(rgba,3,4),16),
  tonumber(string.sub(rgba,5,6),16),
  tonumber(string.sub(rgba,7,8),16)}
end
