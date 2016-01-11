
require 'collisions'
-- very b a d
enemyHit = love.graphics.newImage('assets/images/enemyHit.png')

-- after an enemy death just place an animation that plays through once

local knifeSound = love.audio.newSource('assets/audio/fx/knife.wav')--, 'stream')
knifeSound:setVolume(0.1)

function checkDirection(enemy)
	if enemy.facing.x==1 and (player.x+player.width) < (enemy.x+(enemy.width/2)) then 
		return true 
	elseif enemy.facing.x==-1 and player.x > (enemy.x+enemy.width) then 
		return true 
	elseif enemy.facing.y==1 and (player.y+player.height) < (enemy.y+(enemy.height/2)) then 
		return true 
	elseif enemy.facing.y==-1 and player.y > (enemy.y+enemy.height) then 
		return true 
	else
		return false 
	end 
end 


-- check if there's any targets to kill
-- if yes, start kill process
function canKillCheck()

	if #getCurrentTargets()>0 then 
		if #getCurrentTargets() > #particleSystems then 
			-- add as many as needed
			for i=1, (#getCurrentTargets() - #particleSystems) do
				createParticleSystem()
			end
		end 

    	for i=1,#getCurrentTargets() do
    		particleSystems[i]:reset()
    		particleSystems[i]:setPosition(enemies[getCurrentTargets()[i]].x+(enemies[getCurrentTargets()[i]].width/2), enemies[getCurrentTargets()[i]].y+(enemies[getCurrentTargets()[i]].height/3))
    	end
    	--kill = true 
    	player.state = 'kill'
    	setCurrentTargetIndex(1)
	end 

end 

-- maybe hold down the button and the circle grows to a max size
-- and then you can assasinate
-- also add facing directions so you can only target an enemy whose back
-- is facing you (can only do quick assasination from behind)

-- to decouple calculations and drawing, need to make a queue system
-- queue takes in stuff and then calls draw functions like line, rect, circle


function gatherTargets()
	local radius = 60
	Xc = (player.x+(player.width/2))
	Yc = (player.y+(player.height/2))

	local localTargets = {}	

	for i, enemy in ipairs(enemies) do 

		-- move circular 
		topLeft = math.sqrt(math.pow(enemy.x-Xc,2) + math.pow(enemy.y-Yc,2))
		bottomRight = math.sqrt(math.pow(enemy.x+enemy.width-Xc,2) + math.pow(enemy.y+enemy.height-Yc,2))
		topRight = math.sqrt(math.pow(enemy.x+enemy.width-Xc,2) + math.pow(enemy.y-Yc,2))
		bottomLeft = math.sqrt(math.pow(enemy.x-Xc,2) + math.pow(enemy.y+enemy.height-Yc,2))


		if ( (topLeft <= radius) or (bottomRight<=radius) or (topRight<=radius) or (bottomLeft<=radius) ) and checkDirection(enemy) then 
			love.graphics.push()
				love.graphics.line(Xc, Yc, enemy.x+(enemy.width/2), enemy.y+(enemy.height/2))

				if #localTargets<1 then 
					love.graphics.setColor(255,0,0,111)
					love.graphics.circle('fill', Xc, Yc, radius)
				end 
			love.graphics.pop()
			table.insert(localTargets, i)
		elseif #localTargets==0 and i<=1 then 
			love.graphics.push()
				love.graphics.setColor(0,0,0,111)
				love.graphics.circle('fill', Xc, Yc, radius)
			love.graphics.pop()
		end 
		love.graphics.setColor(255,255,255,255,255)
	end 

	--targets = localTargets 
	setCurrentTargets(localTargets)
end

-- all other game activity should be frozen while this runs
-- when this is initiated do some cool screen effect
-- move all this kill stuff to another function, use state pattern

--time = 0.5 -- seconds
function killTargets()
	-- v = d/t
	local Vx = (enemies[getCurrentTargets()[getCurrentTargetIndex()]].x-player.x)--/time 
	local Vy = (enemies[getCurrentTargets()[getCurrentTargetIndex()]].y-player.y)--/time 
	player.x = player.x + (Vx*love.timer.getDelta()*15)
	player.y = player.y + (Vy*love.timer.getDelta()*15)


	if Vx >=0 then player.killDirection='right' end
	if Vx <0 then player.killDirection='left' end

	--if CheckCollision(player.x,player.y,player.width,player.height, 
	--	enemies[getCurrentTargets()[getCurrentTargetIndex()]].x,enemies[getCurrentTargets()[getCurrentTargetIndex()]].y,enemies[getCurrentTargets()[getCurrentTargetIndex()]].width,enemies[getCurrentTargets()[getCurrentTargetIndex()]].height) then 
	-- this version will only match the top left of each sprite
	if CheckCollision(player.x,player.y,6,6, 
		enemies[getCurrentTargets()[getCurrentTargetIndex()]].x,enemies[getCurrentTargets()[getCurrentTargetIndex()]].y,6,6) then 
		
		if getCurrentTargetIndex() + 1  <= #getCurrentTargets() then 
			setCurrentTargetIndex(getCurrentTargetIndex() + 1)
		else 
			setCurrentTargetIndex(getCurrentTargetIndex() + 1)
			--kill = false 
			--postKill = true
			player.state='postKill'
		end 
		knifeSound:seek(0, 'seconds')
		knifeSound:play()
		print('killed', getCurrentTargetIndex()-1)
	end 
end 


displayKillTimer = 1
--postKill = false
function postKillScreen()
	
	love.graphics.draw(black,0,0,0,love.graphics.getWidth(), love.graphics.getHeight())
    displayKillTimer = displayKillTimer - (1 * love.timer.getDelta())
    


	for i=1,#getCurrentTargets() do
		
		--particleSystems[index]:setPosition(enemies[targets[index]].x+(enemies[targets[index]].width/2), enemies[targets[index]].y+(enemies[targets[index]].height/2))
		
		love.graphics.draw(enemyHit, enemies[getCurrentTargets()[i]].x, enemies[getCurrentTargets()[i]].y)
		particleSystems[i]:start()
		particleSystems[i]:update(love.timer.getDelta())
		drawParticleSystem(i)
		particleSystems[i]:stop()
		
	end  

    if displayKillTimer <= 0 then   
		--postKill = false 
		player.state = 'gatherTargets'

		displayKillTimer=1
		-- remove all enemies that were killed (or replace bodies with dead ones)
	    
		local numberKilled = #getCurrentTargets()

		for i=#getCurrentTargets(),1,-1 do
			table.remove(enemies, getCurrentTargets()[i])
			table.remove(getCurrentTargets(), i)
		end  
		return numberKilled
    else 
    	return 0 
    end 
end 
-- after this function there should be a check to see if you went into an object or off the edge of the screen


function resetAssassination()
	currentTargetIndex = 0
	currentTargets = {}
	displayKillTimer=1
end 



local currentTargetIndex = 0
function setCurrentTargetIndex(s)
	currentTargetIndex = s
end 
function getCurrentTargetIndex()
	return currentTargetIndex
end 

--kill = false
--targets = {} 
local currentTargets = {}
function setCurrentTargets(s)
	currentTargets = s
end 
function getCurrentTargets()
	return currentTargets
end 



