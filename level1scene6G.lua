 --Yes. Level 1 End. Win
local loadsave = require("loadsave")
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local sfx = require( "sfx" )
local widget = require("widget")
local score = require("score")
local energyM = require("energy")
local gamestate = require( "gamestate" )

gameSettings = loadsave.loadTable("myTable.json", system.DocumentsDirectory)
local energy = {}
local curLvl = gameSettings.currentLevel; local numberOfEnergy = gameSettings.levels[curLvl].energy; 
-- if numberOfEnergy < 1 then storyboard.removeAll(); storyboard.gotoScene("levelfailedG","fade",200) end
loadsave.printTable(gameSettings.levels[curLvl].energy)
gameSettings.levels[curLvl].score = score.get()
loadsave.printTable(gameSettings.levels[curLvl].energy)
local tmr, t;
print("level1scene6")

-- local function buttonOnPress(event)
-- 	local availableChannel = audio.findFreeChannel()
-- 	if gameSettings.soundOn == true then
-- 		-- audio.play( sfx.click, { loops = 0, channel = availableChannel, onComplete = function()  audio.dispose( sfx.click )  end } )
-- 	end
-- end

-- local function buttonOnRelease(event)
-- 	local button = event.target.id
-- 		if button == "back" then
-- 			timer.cancel(tmr); audio.stop(7);  
-- 			if gameSettings.musicOn == true then audio.resume(1) end
-- 			storyboard.removeAll(); storyboard.gotoScene( "mapG", "fade", 200 ); 
-- 		elseif button == "nextB" then
-- 			storyboard.removeAll(); storyboard.removeScene( "level1scene6G", false )
-- 			-- storyboard.gotoScene( "levelpassedG", "fade", 200 )
-- 		end
-- end

function scene:createScene( event )
	local group = self.view

	local background = display.newImage("images/bg.png"); background.height = _H; background.width = _W + _W/4; background.x = _W/2; background.y = _H/2;group:insert(background)
	-- local back = widget.newButton{ defaultFile = "images/back2.png", overFile ="images/back2.png", id = "back", x = _W/30, y = _H - _H/10,height =  _H/9 + 17, width = _W/9 + 18 ,onRelease = buttonOnRelease , onPress = buttonOnPress}
	local candy = display.newImage("images/candy.png"); candy.x = _W - 20; candy.y = _H/15; candy.width = 80; candy.height = 25
	local scoreText = display.newText(gameSettings.levels[curLvl].score, _W - 5, _H/15, "riffic", 18 ); scoreText:setFillColor( 1,0,0 )	
	-- local textmap = display.newText( "Map", _W/30 - 10, _H - _H/40, "riffic", 10 ); textmap:setFillColor( 1,1,1 )
	
	local scenario, sheetOptions, sheet1, sequence, animation
	if curLvl == 5 then
		scenario = display.newImage("images/"..gameSettings.lang.."/"..gameSettings.character.."/level"..curLvl.."/scene5.jpg")
		scenario.height = _H; scenario.width = _W + _W/4; scenario.x = _W/2; scenario.y = _H/2;
		group:insert(scenario)
	else
		sheetOptions = { width = 576, height = 320, numFrames = 12 }
		sheet1 = graphics.newImageSheet( "images/"..gameSettings.lang.."/"..gameSettings.character.."/level"..curLvl.."/imgsheet1.png", sheetOptions )
		sequence= { { name = "level1", start = 9, count = 4, time = 16000, loopCount = 1, loopDirection = "forward" },
						  { name = "level3", start = 9, count = 2, time = 3000, loopCount = 1, loopDirection = "forward" } }	
		animation = display.newSprite( sheet1, sequence); animation.x = _W/2; animation.y = _H/2 
		animation:setSequence("level"..tostring(curLvl))
		animation:play()
					
		local function spriteListener( event )
		    local thisSprite = event.target  -- "event.target" references the sprite
		    if ( thisSprite.frame == 11) then    	
		    end
		end
		animation:addEventListener( "sprite", spriteListener )
		group:insert(animation)
	end
	
	if gameSettings.lang == "english" then 		
		if curLvl == 1 then audio.play( sfx.level1s6, { loops = 0, channel = 2, onComplete = audio.stop(2)} )
		elseif curLvl == 5 then
	    	audio.play( sfx.level5s4, { loops = 0, channel = 3, onComplete = audio.stop(3)}) ; audio.setVolume( 4) 
		end
	elseif gameSettings.lang == "tagalog" then 
		if curLvl == 1 then audio.play( sfx.level1s6t, { loops = 0, channel = 2, onComplete = audio.stop(2)} )
		elseif curLvl == 5 then
	    	audio.play( sfx.level5s4t, { loops = 0, channel = 3, onComplete = audio.stop(3)}) ; audio.setVolume( 4) 
		end
	elseif gameSettings.lang == "bicol" then
		if curLvl == 1 then audio.play( sfx.level1s6g, { loops = 0, channel = 2, onComplete = audio.stop(2)} )
		elseif curLvl == 5 then
	    	audio.play( sfx.level5s4g, { loops = 0, channel = 3, onComplete = audio.stop(3)}) ; audio.setVolume( 4) 
		end 
	end

	if curLvl == 1 then t = 17000 elseif curLvl == 3 then t = 3000 elseif curLvl == 5 then t = 3000  end
	tmr = timer.performWithDelay(t,function(e) storyboard.removeAll()
		if curLvl == 1 or curLvl == 5 then storyboard.gotoScene( "levelpassedG", "fade", 200);  
		-- elseif curLvl == 3 then storyboard.gotoScene( "levelfailedG", "fade", 200); 
		end
	end,1)


-- group:insert( back )
group:insert( candy )
group:insert( scoreText )
-- group:insert( textmap )
for i=1,numberOfEnergy do
	energy[i] = display.newImage("images/english/"..gameSettings.character.."/energy.png"); energy[i].x = _W/90 + (30*i) -_W/9; energy[i].y = _H/15; energy[i].width = 26; energy[i].height = 25
		group:insert(energy[i])
end
		
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
local group = self.view
	if back and nextB  then
		back:removeSelf()
		nextB:removeSelf()
		back = nil 
		nextB = nil 
	end
	audio.dispose(7);
	loadsave.saveTable(gameSettings, "myTable.json", system.DocumentsDirectory)
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "destroyScene", scene )


return scene