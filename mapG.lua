local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require("widget")
local loadsave = require("loadsave")
local gamestate = require("gamestate")
local sfx = require( "sfx" ) 
local score = require("score")
local energyM = require("energy")

local starVertices = { 0,-8,1.763,-2.427,7.608,-2.472,2.853,0.927,4.702,6.472,0.0,3.0,-4.702,6.472,-2.853,0.927,-7.608,-2.472,-1.763,-2.427 }
gameSettings = loadsave.loadTable("myTable.json", system.DocumentsDirectory)
loadsave.printTable(gameSettings)

local function buttonOnPress(event)
	if gameSettings.soundOn == true then
		audio.play( sfx.click, { loops = 0, channel = 32, onComplete = function()  audio.dispose(32)  end } )
	end
end

local function buttonOnRelease(event)
	local button = event.target.id
		if button == "level1"  then
			storyboard.removeAll(); storyboard.gotoScene( "trivia1G" );  
			gameSettings.currentLevel = 1; gameSettings.levels[1].score = 0;
			energyM.set(3); energyM.save(); gameSettings.levels[1].energy = energyM.get(); 
			loadsave.saveTable(gameSettings, "myTable.json", system.DocumentsDirectory)
		elseif button == "level2"  then
			gameSettings.currentLevel = 2; gameSettings.levels[2].score = 0;
			energyM.set(3); energyM.save(); gameSettings.levels[2].energy = energyM.get(); 
			loadsave.saveTable(gameSettings, "myTable.json", system.DocumentsDirectory)
			storyboard.removeAll(); storyboard.gotoScene( "trivia1G", "fade", 200 )
		elseif button == "level3" then
			gameSettings.currentLevel = 3; gameSettings.levels[3].score = 0;
			energyM.set(3); energyM.save(); gameSettings.levels[3].energy = energyM.get(); 
			loadsave.saveTable(gameSettings, "myTable.json", system.DocumentsDirectory)
			storyboard.removeAll(); storyboard.gotoScene( "trivia1G", "fade", 200 )
		elseif button == "level4" then
			gameSettings.currentLevel = 4; gameSettings.levels[4].score = 0;
			energyM.set(3); energyM.save(); gameSettings.levels[4].energy = energyM.get(); 
			loadsave.saveTable(gameSettings, "myTable.json", system.DocumentsDirectory)
			storyboard.removeAll(); storyboard.gotoScene( "trivia1G", "fade", 200 )
		elseif button == "level5" then
			gameSettings.currentLevel = 5;  gameSettings.levels[5].score = 0;
			energyM.set(3); energyM.save(); gameSettings.levels[5].energy = energyM.get(); 
			loadsave.saveTable(gameSettings, "myTable.json", system.DocumentsDirectory)
			storyboard.removeAll(); storyboard.gotoScene( "trivia1G", "fade", 200 )
		elseif button == "back" then
			storyboard.gotoScene( "menu", "fade", 200 )
		end
end

function scene:enterScene( event )
local group = self.view
	 audio.play( sfx.bgmusic, { loops = -1, channel = 1, onComplete = function()  audio.dispose( 1 )  end } )
	local textmap = display.newText( "Tap candy to choose level.", _W - _W/5, _H - _H/40, "riffic", 14 ); textmap:setFillColor( 1,1,1)
	if gameSettings.lang == "tagalog" or gameSettings.lang == "bicol" then
		textmap.text = "Pindutin ang kendi para pumili ng level."
	end 
	transition.fadeIn(textmap,{ time=1000, x=_W - _W/5 ,y= _H - _H/40})
	transition.fadeOut(textmap,{time=2000,delay=5500})	
	group:insert( textmap )
end

function scene:createScene( event )
	local group = self.view
	
	local bg = display.newImage("images/map.png"); bg.height = _H; bg.width = _W + _W/4; bg.x = _W/2; bg.y = _H/2;
	group:insert( bg )
	local back = widget.newButton { defaultFile = "images/back.png", overFile ="images/back.png", id = "back", x = _W/30, y = _H/10, height =  _H/9 + 17, width = _W/9 + 18 , onRelease = buttonOnRelease , onPress = buttonOnPress}	
	group:insert( back )
	
	
	local level = {}
	for i=1, gamestate.maxLevels do 
 			level[i] = widget.newButton	{ defaultFile = "images/level.png", overFile ="images/level_candies_active.png", height = _W/15,	width = _W/15 ,   onRelease = buttonOnRelease	, onPress = buttonOnPress}
 		if i==1 then level[i].x = _W/2 + _W/6  + 19; level[i].y = _H/2 + _H/4 + 21; level[i].id = "level"..tostring( i )
 		elseif i==2 then level[i].x = _W/2 + _W/3 - 8;	level[i].y = _H/2 + 20; level[i].id = "level"..tostring( i )
 		elseif i==3 then level[i].x = _W/2 + _H/4 ;	level[i].y = _H/2 - 50; level[i].id = "level"..tostring( i )
 		elseif i==4 then level[i].x = _W/2 -_W/9; level[i].y = _H/2 - 50; level[i].id = "level"..tostring( i )
 		elseif i==5 then level[i].x = _W/2 - _W/3 + 27; level[i].y = _H/2 - _H/3; level[i].id = "level"..tostring( i )
 		end	

		if ( gameSettings.unlockedLevels == nil ) then
            gameSettings.unlockedLevels = 1
        end
        if ( i <= gameSettings.unlockedLevels ) then
			level[i]:setEnabled( true )
			transition.to(level[i],{time= 1200, rotation=180, iterations = 0})	
        else 
            level[i]:setEnabled( false );
            level[i].alpha = 0.3
        end   
		group:insert( level[i] )
	
		local star = {}      
		for j = 1, 3 do
        	 star[j] = display.newPolygon( 0, 0, starVertices )
                star[j]:setFillColor( 1, 0.9, 1 ); star[j].strokeWidth = 1; star[j]:setStrokeColor(  1, 0.9, 0 ); star[j].x = level[i].x + (j * 16) - 32; star[j].y = level[i].y + 22; star[j].alpha = 0.3
                group:insert( star[j] )
        end     
        if ( gameSettings.levels[i] and gameSettings.levels[i].stars and gameSettings.levels[i].stars > 0 ) then
            for j = 1, gameSettings.levels[i].stars do
                star[j] = display.newPolygon( 0, 0, starVertices ); star[j]:setFillColor( 1, 0.9, 0 ); star[j].strokeWidth = 0.5; star[j]:setStrokeColor( 1, 0.9, 0 ); star[j].x = level[i].x + (j * 16) - 32; star[j].y = level[i].y + 22
                group:insert( star[j] )
            end
        end
       
 	end

end


function scene:destroyScene( event )
local group = self.view
	-- for i=1, gamestate.maxLevels do 
	-- 	if level[i]  then
	-- 		level[i]:removeSelf()
	-- 		level[i] = nil 
	-- 	end
	-- end
end
			
scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene