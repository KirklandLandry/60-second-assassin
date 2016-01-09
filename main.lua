-- local tileW, tileH --= 32,32 -- the width and height of each tile

-- so input is very tightly coupled to this class which is very bad
-- input should be check in another class and returned here and then 
-- given to any class that requires checking input
-- ie calling input = updateInput() would return a table containing all input
-- and that would be used to check input related stuff

-- need a similar thing for audio

require 'map-functions'
require 'player'
require 'camera'
require 'fade'
require 'enemy'
require 'bloodSpray'
require 'assassination'
require 'menu-functions'
require 'slomo'
require 'levelTimer'
require 'mapSelector'


local audio_source = nil
function love.load()
	loadMap(initializeMapSelector())
	loadMenu('assets/maps/pause-menu.lua')
	
	audio_source = love.audio.newSource('assets/audio/music/level1.wav')--, 'stream')
	audio_source:setVolume(0.5)
	initializePlayer()
	initializeEnemies(getEnemyTable())
	initializeBloodSpray()
	black = love.graphics.newImage('assets/images/black.png')
	bBox = {x=player.x, y=player.y, width=player.width*4, height=player.height*2, mode='fill'}
	love.graphics.setDefaultFilter('nearest', 'nearest') -- should be set on a per image basis
end

local paused = false
local pauseKeyDown = false
local levelStart = false
local gameOver = false
local gameOverScreenLoaded = false
local win = false
local winScreenLoaded = false
local musicStarted = false
local musicPosition = 0

--local currentMap = 'assets/maps/core-dump.lua'

function love.update(dt)
	local tempdt = dt 
	
	dt = updateSlomo(dt, player)

	input(dt)  -- this is all player driven updates


	if musicStarted then 
		musicPosition = musicPosition + tempdt
		--local temp2 = (math.floor(temp * (100) + 0.5) / 100)
		musicPosition = musicPosition + tempdt
		print (musicPosition)
	end 
	if musicPosition>=156 then --the song length   --audio_source:isPlaying() then 
		-- need to check if this is first round or not
		-- need to either restart from loop point or from beginning
		audio_source:stop()
		audio_source:play()
		audio_source:seek(60,'seconds')
		musicPosition=60
	end 
	if levelStart then 

		if not musicStarted then 
			musicStarted = true 
			audio_source:play()
		end 

		if updateLevelTimer(dt,player)<=0  or not player.alive then 
			--print ("gameOver")
			--player.alive=false
			levelStart=false
			gameOver = true 
			paused=false
			win = false 

			-- show a death screen
			-- then reset everything
			-- all keystates 
			-- all enemies
			-- levelstart
			-- player
		elseif win then 
			levelStart = false
			audio_source:stop()
			musicPosition=0
			musicStarted = false 
		else 
			camera:zoomIn()	
			if not paused then 
				-- need on for updating all enemies
				if player.state == 'gatherTargets' then --not kill and not postKill then 
					updateEnemies(dt, collisionTable, player)
				end 	
			end 
		end 
	end 	
	camera:updateCamera(player, bBox)	
end


function love.draw()
	if not paused then 
		camera:set()
			drawMap()
			drawEnemies()		
			if player.state == 'postKill' then 
				--print (player.state)
				if getEnemiesRemaining(postKillScreen()) <= 0 then 
					win = true 
				end 
			elseif player.state == 'gatherTargets' then 
				--print (player.state)
				gatherTargets()
			elseif player.state == 'kill' then 
				--print (player.state)
				killTargets()
			end 	
			drawPlayer()
		camera:unset()
		updateFade()
		drawSlomoBar()
		drawLevelTimer()
	end 
	if paused then 
		drawMenu()
	end 
	if gameOver then 
		if not gameOverScreenLoaded then 
			loadMenu('assets/maps/gameover-menu.lua')
			gameOverScreenLoaded = true 
		end 
		drawMenu()		
	end 
	if win then 
		if not winScreenLoaded then 
			loadMenu('assets/maps/win-menu.lua')
			winScreenLoaded = true 
		end 
		drawMenu()
	end 

	love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 150, 0) 
end 



-- input should be acted upon or anything, it should just be pushed to the proper functions/classes
function input(dt)
	if levelStart then 
		if love.keyboard.isDown('escape') then 
			--love.event.push('quit')
			if pauseKeyDown == false then 
				pauseKeyDown = true
				paused = not paused 
				if paused then 
					print ('paused')
				elseif not paused then 
					print('unpaused')
				end 
			end 
	    else 
	    	pauseKeyDown =false 
	    end 

	    if not paused  then 
		    --[[if love.keyboard.isDown('f') then 
				setFade('crossfade')
		    end ]]
			checkSlomoInput(player)
		    if love.keyboard.isDown('i') and player.state == 'gatherTargets' then --and not kill and not postKill then 
		    	canKillCheck()
		    end 
		    if player.state == 'gatherTargets' then --not kill and not postKill then 
		    	checkPlayerInput(dt, collisionTable, enemies) -- in player class
		    end 
		elseif paused then 
			menuInput()
		end  
	else 
		if love.keyboard.isDown('i') and player.alive then 
			levelStart = true 
		end 
	end 

    if love.keyboard.isDown('r') then 
    	if rKeyDown==false then 
	    	rKeyDown=true
			--key = 'restart'
			reset()
		end 
    else 
		rKeyDown=false
    end 
    if love.keyboard.isDown('n') and win then 
    	if nKeyDown==false then 
    		nKeyDown=true
    		getNextMap()
    		reset()
    	end 
    else 
		nKeyDown=false
    end  


end
--[[slomoKeyDown=false
slomoTimerMax=1
slomoTimer=slomoTimerMax]]


function reset() 
	paused = false
	pauseKeyDown = false
	levelStart = false
	gameOver = false
	gameOverScreenLoaded = false
	win = false
	winScreenLoaded = false
	pauseMenuW_keyDown = false
	pauseMenuS_keyDown = false
	pauseMenuI_keyDown = false

	resetLevelTimer()
	resetSlomoTimer()
	resetEnemies()
	resetPlayer()
	resetAssassination()
	resetMap()
	-- should reload a current map or something. this is bad
	loadMap(getCurrentMap())
	loadMenu('assets/maps/pause-menu.lua')
	--initializePlayer()
	initializeEnemies(getEnemyTable())
	--initializeBloodSpray()

	camera:reset() 
end 


pauseMenuW_keyDown = false
pauseMenuS_keyDown = false
pauseMenuI_keyDown = false
rKeyDown = false
nKeyDown = false
function menuInput()
	local key =''
	if love.keyboard.isDown('w') then
		if pauseMenuW_keyDown==false then 
			pauseMenuW_keyDown=true 
			key = 'up'
		end 
    else
		pauseMenuW_keyDown=false
    end 
    if love.keyboard.isDown('s') then 
    	if pauseMenuS_keyDown==false then 
	    	pauseMenuS_keyDown=true
			key = 'down'
		end 
    else
		pauseMenuS_keyDown=false
    end 
    if love.keyboard.isDown('i') then 
    	if pauseMenuI_keyDown==false then 
	    	pauseMenuI_keyDown=true
			key = 'ok'
		end 
    else 
		pauseMenuI_keyDown=false
    end 


    --[[if love.keyboard.isDown('r') then 
    	if rKeyDown==false then 
	    	rKeyDown=true
			key = 'restart'
		end 
    else 
		pauseMenuI_keyDown=false
    end]] 
    --if key=='restart' then 

    --else 
		updateMenu(key)
	--end 
end 



