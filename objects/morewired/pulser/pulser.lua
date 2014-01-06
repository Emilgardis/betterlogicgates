function init(args)
	 entity.setInteractive(true)
	 entity.setAllOutboundNodes(false)
	 if storage.state == nil then
    storage.state = false
  end
  if storage.mode == nil then
    storage.mode = 1
  end
  if storage.countdown == nil then
    storage.countdown = 0
  end
  self.interval = entity.configParameter("pulseDuration")
  self.intervalNames = entity.configParameter("pulseName")
  self.hasChanged = false
end


function onInteraction(args)
	--On interaction change pulse duration
	storage.mode = storage.mode + 1
	if storage.mode > #self.interval then
	 storage.mode = 1
	end
end

function render()
	if storage.state then
		entity.setAnimationState("pulserIntervalState", self.intervalNames[storage.mode])
		entity.setAnimationState("pulserFrameState", "on")
	else
		entity.setAnimationState("pulserIntervalState", self.intervalNames[storage.mode]..".off")
		entity.setAnimationState("pulserFrameState", "off")
	end
end

function output(state)
	if state then 
  entity.setAllOutboundNodes(true)
  storage.state = false
	else
		entity.setAllOutboundNodes(false)
		end
end

function main()
 local state = entity.getInboundNodeLevel(0)
 if storage.state ~= state and not self.hasChanged then
 	storage.state = state
 	self.hasChanged = true
 end
	if storage.countdown > 0 then --Is a countdown on? Then countdown...
		storage.countdown = storage.countdown - ((entity.dt() * 1000) * 2) --Makes countdown correct with time.
	elseif storage.countdown <= 0.01 and not self.hasChanged then --Hasn't changed yet, therefore it is blocked.
		output(false)
	elseif storage.countdown <= 0.01 and self.hasChanged then --Has changed, allows a new output to be sent.
		storage.countdown = self.interval[storage.mode]
		self.hasChanged = false
  output(state)
	end
	render()
end	
