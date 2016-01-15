-- local tileW, tileH --= 32,32 -- the width and height of each tile

-- so input is very tightly coupled to this class which is very bad
-- input should be check in another class and returned here and then 
-- given to any class that requires checking input
-- ie calling input = updateInput() would return a table containing all input
-- and that would be used to check input related stuff
-- tldr->decouple input from main class and also decouple update/draw from other classes
-- need a similar thing for audio

-- also, everything should operate in actual classes (like in camera)

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
require 'menuSelector'

local bgm = nil
local blip = nil
local selectNoise = nil
function love.load()
	loadMap(initializeMapSelector())
	loadMenu(initializeMenuSelector())
	
	bgm = love.audio.newSource('assets/audio/music/level1.wav')--, 'stream')
	blip = love.audio.newSource('assets/audio/fx/blip.wav')
	selectNoise = love.audio.newSource('assets/audio/fx/select-noise.mp3')
	bgm:setVolume(0.5)
	initializePlayer()
	initializeEnemies(getEnemyTable())
	initializeBloodSpray()
	black = love.graphics.newImage('assets/images/black.png')
	bBox = {x=player.x, y=player.y, width=player.width*4, height=player.height*2, mode='fill'}
	love.graphics.setDefaultFilter('nearest', 'nearest') -- should be set on a per image basis
end


-- all these bools are terribly horribly awfully bad. Done to save time. Change to a state system to tell what menu you're at
local paused = false
local pauseKeyDown = false
local levelStart = false
local gameOver = false
local gameOverScreenLoaded = false
local win = false
local winScreenLoaded = false
local musicStarted = false
local musicPosition = 0
local onTitleScreen = true 
local titleScreenLoaded = false
local onInstructionsScreen = false
local gameWon = false
--local currentMap = 'assets/maps/core-dump.lua'

function love.update(dt)
	local tempdt = dt 
	
	dt = updateSlomo(dt, player)

	input(dt)  -- this is all player driven updates

	if gameWon then 
		bgm:stop()
		levelStart= false
	elseif onTitleScreen then 
		bgm:stop()
	else 
		if musicStarted and not paused then 
			if not bgm:isPlaying() then
				bgm:play()
			end 
			musicPosition = musicPosition + tempdt
			--local temp2 = (math.floor(temp * (100) + 0.5) / 100)
			--musicPosition = musicPosition + tempdt
			--print (musicPosition)
		elseif bgm:isPlaying() then 
			bgm:pause() 
		end 
		if musicPosition>=156 then --the song length   --bgm:isPlaying() then 
			-- need to check if this is first round or not
			-- need to either restart from loop point or from beginning
			bgm:stop()
			bgm:play()
			bgm:seek(60,'seconds')
			musicPosition=60
		end 
		if levelStart then 

			if not musicStarted then 
				musicStarted = true 
				bgm:play()
			end 
			if not paused then 
				tempTimer = updateLevelTimer(dt,player)
			end 
			if tempTimer<=0  or not player.alive then 
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
				bgm:stop()
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
end


function love.draw()
	if gameWon then 
		drawMenu()
	else 
		if not paused then 
			camera:set()
				drawMap()
				drawEnemies()		
				if player.state == 'postKill' then 
					if getEnemiesRemaining(postKillScreen()) <= 0 then 
						win = true 
					end 
				elseif player.state == 'gatherTargets' then 
					gatherTargets()
				elseif player.state == 'kill' then 
					killTargets()
				end 	
				drawPlayer(slomoShadows)
			camera:unset()
			--updateFade()
			love.graphics.push()
				love.graphics.setColor(0, 0, 0, 100)
				love.graphics.rectangle('fill', 0, 0, 120, 40)
				love.graphics.setColor(255, 255, 255, 255)
			love.graphics.pop()
			drawSlomoBar()
			drawLevelTimer()
		end 
		if paused then 
			drawMenu()
		end 
		if gameOver then 
			if not gameOverScreenLoaded then 
				loadMenu(getMenu('gameover'))
				gameOverScreenLoaded = true 
			end 
			drawMenu()		
		end 
		if win then 
			if not winScreenLoaded then 
				loadMenu(getMenu('win'))
				winScreenLoaded = true 
			end 
			drawMenu()
		end 
		if onTitleScreen then 
			if not titleScreenLoaded then 
				loadMenu(getMenu('title'))
				titleScreenLoaded = true 
			end 
			drawMenu()
		end 
	end 
	--love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 150, 0) 
end 



-- input should be acted upon or anything, it should just be pushed to the proper functions/classes
function input(dt)
	if levelStart then 
		if love.keyboard.isDown('escape') then 
			--love.event.push('quit')
			if pauseKeyDown == false then 
				loadMenu(getMenu('pause'))
				pauseKeyDown = true
				if not onInstructionsScreen then 
					paused = not paused 
				end 
				selectNoise:stop()
				selectNoise:play()
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
		    	if not iKeyDown then 
					iKeyDown = true 
		    		canKillCheck()
		    	end 
		    else 
		    	iKeyDown = false 
		    end  

		    if player.state == 'gatherTargets' then --not kill and not postKill then 
		    	checkPlayerInput(dt, collisionTable, enemies) -- in player class
		    end 
		elseif paused then 
			menuInput()
		end  
	else 
		if love.keyboard.isDown('i') and player.alive then 
			if not iKeyDown then 
				iKeyDown = true 
				if not onInstructionsScreen then 
					levelStart = true 
				end 
			end 
		else 
			iKeyDown = false 
		end 
	end 

	if onTitleScreen or gameWon then 
		menuInput()
	end 

    if love.keyboard.isDown('r') then 
    	if rKeyDown==false then 
	    	rKeyDown=true
	    	if not gameWon then 
				reset()
			end 
		end 
    else 
		rKeyDown=false
    end 
    if love.keyboard.isDown('n') and win then 
    	if nKeyDown==false then 
    		nKeyDown=true
    		if getNextMap() == 'gameWon' then 
				loadMenu(getMenu('gamewin'))
				gameWon = true 
    		else 
    			reset()
    		end 
    	end 
    else 
		nKeyDown=false
    end  
end
iKeyDown = false


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
	onInstructionsScreen = false
	gameWon = false
	resetLevelTimer()
	resetSlomoTimer()
	resetEnemies()
	resetPlayer()
	resetAssassination()
	resetMap()
	-- should reload a current map or something. this is bad
	loadMap(getCurrentMap())
	loadMenu(getMenu('pause'))
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
	if not onInstructionsScreen then 
		if love.keyboard.isDown('w') then
			if pauseMenuW_keyDown==false then 
				pauseMenuW_keyDown=true 
				key = 'up'
				blip:stop()
				blip:play()
			end 
	    else
			pauseMenuW_keyDown=false
	    end 
	    if love.keyboard.isDown('s') then 
	    	if pauseMenuS_keyDown==false then 
		    	pauseMenuS_keyDown=true
				key = 'down'
				blip:stop()
				blip:play()
			end 
	    else
			pauseMenuS_keyDown=false
	    end 
	    if love.keyboard.isDown('i') then 
	    	if pauseMenuI_keyDown==false then 
		    	pauseMenuI_keyDown=true
				key = 'ok'
				selectNoise:stop()
				selectNoise:play()
			end 
	    else 
			pauseMenuI_keyDown=false
	    end 
	end 


	if love.keyboard.isDown('escape') then 
		if onInstructionsScreen then 
			onInstructionsScreen = false 
			if onTitleScreen then 
				selectNoise:stop()
				selectNoise:play()
				loadMenu(getMenu('title'))
			elseif paused then 
				loadMenu(getMenu('pause'))
			end 
		end
		if gameWon then 

		end 
	end 

	local temp = updateMenu(key) 
	if temp == 'start' then 
		onTitleScreen = false
		titleScreenLoaded = false
		reset() 
	end 
	if temp =='resume' then 
		paused = false 
	end 
	if temp =='instructions' then 
		loadMenu(getMenu('instructions'))
		onInstructionsScreen = true 
		if onTitleScreen  then 
			levelStart = false -- because selecting i on the menu will default to starting the level
		end 
	end 
	if temp =='title' then 
		musicStarted = false
		musicPosition = 0

		resetMapSelector()
		reset()
	end 
	
end 



