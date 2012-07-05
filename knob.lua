-----------------------------------------------------------------------------------------
--
-- knob.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
--local widget = require "widget"

--------------------------------------------
local physics = require "physics"
physics.start()



-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------
local debugText, debugText2, debugText3
local knobBase, knobBlend1, knobBlend2


-----------------------------------------------------------
-- onTilt() -- accelerometer에 따른 중력 재설정(?)
-----------------------------------------------------------
local floor = math.floor
local abs = math.abs
local pi = math.pi
local asin = math.asin
local acos = math.acos

local function onTilt( event )
	if ( physics ) then
		--physics.setGravity( ( 9.8 * event.xGravity ), ( -9.8 * event.yGravity ) )
		debugText.text = "Event gravity X=".. event.xGravity
		debugText2.text = "Event gravity Y=".. event.yGravity
		
		local rotation = abs( asin( event.xGravity + event.yGravity ) * 320 / pi )
		knobBase.rotaion = rotation
		knobBlend.rotation = rotation - 50
		knobBlend2.rotation = 360 - (rotation + 50)		
		debugText3.text = "Knob angle is ".. rotation	
    end
end
Runtime:addEventListener( "accelerometer", onTilt )


local function startPhysics()
	physics.start()

	--Add a body to the knob
	physics.addBody( knobBase, "kinematic", {isSensor = false} )
	knobBase.rotation = 0
	physics.addBody( knobBlend, "kinematic", {isSensor = false} )
	knobBlend.rotation = 0
	physics.addBody( knobBlend2, "kinematic", {isSensor = false} )
	knobBlend2.rotation = 0
	
	--Set the knob's angular damping
	knobBase.angularDamping = 5
	knobBlend.angularDamping = 5
	knobBlend2.angularDamping = 5
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-- display a background image
	local background = display.newImageRect( "res/background.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
		
	-- Title
	local title = display.newText("Just tilt and look at the knob...", 0, 0, native.systemFontBold, 16)
	title:setTextColor( 255, 255, 255 )
	title.x = display.contentCenterX
	title.y = 10
	title.name = "title"
	
	-- debugText
	debugText = display.newText("-----", 0, 0, native.systemFontBold, 16)
	debugText:setTextColor( 255, 255, 255 )
	debugText.x = display.contentCenterX
	debugText.y = display.contentHeight - 60
	debugText.name = "debug"
	
	-- debugText2
	debugText2 = display.newText("-----", 0, 0, native.systemFontBold, 16)
	debugText2:setTextColor( 255, 255, 255 )
	debugText2.x = display.contentCenterX
	debugText2.y = display.contentHeight - 40
	debugText2.name = "debug2"

	-- debugText3
	debugText3 = display.newText("-----", 0, 0, native.systemFontBold, 16)
	debugText3:setTextColor( 255, 230, 40 )
	debugText3.x = display.contentCenterX
	debugText3.y = display.contentHeight - 20
	debugText3.name = "debug3"
			
	-- knob in center
	knobBase = display.newImageRect( "res/knob-shadow.png", 108, 108 )
	knobBase:setReferencePoint( display.CenterReferencePoint )
	knobBase.x = display.contentCenterX
	knobBase.y = display.contentCenterY

	-- blended knob in center
	knobBlend = display.newImageRect( "res/knob.png", 108, 108 )
	knobBlend:setReferencePoint( display.CenterReferencePoint )
	knobBlend.x = display.contentCenterX
	knobBlend.y = display.contentCenterY
	knobBlend.blendMode = "add"
	knobBlend.alpha = 0.5
	
	-- blended knob2 in center
	knobBlend2 = display.newImageRect( "res/knob-inverted.png", 108, 108 )
	knobBlend2:setReferencePoint( display.CenterReferencePoint )
	knobBlend2.x = display.contentCenterX
	knobBlend2.y = display.contentCenterY
	knobBlend2.blendMode = "add"
	knobBlend2.alpha = 0.5
	
	-- start and add physics
	startPhysics()
			
	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( title )
	group:insert( debugText )
	group:insert( debugText2 )
	group:insert( debugText3 )
	group:insert( knobBase )
	group:insert( knobBlend )
	group:insert( knobBlend2 )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	--startPhysics()
	
	-- add accelerometer event listener to runtime
	--Runtime:addEventListener( "accelerometer", onTilt )
	
	debugText.text = "Event gravity X=0.0"
	debugText2.text = "Event gravity Y=0.0"
	debugText3.text = "Knob angle is 0.0"

end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)	
	-- remove accelerometer event listener to runtime
	--Runtime:removeEventListener( "accelerometer", onTilt )
	
	--physics.stop()	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	--[[
	if knobBase then
		knobBase:removeSelf()
		knobBase = nil
	end
	--]]
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene