require 'playerAnimation'
require 'collisions'

player = {x = 33, y = 33, width=nil, height=nil, speed = 150, img = nil, state ='gatherTargets', alive = true}

--local Quad = love.graphics.newQuad
function initializePlayer()
	initializePlayerAnimation()
	player.width = playerTileW--player.img:getWidth()
	player.height = playerTileH--player.img:getHeight()
	player.state = 'gatherTargets'
end

function resetPlayer()
    -- *choir chorus singing "mmmm this is real bad"*
    player.x = 33
    player.y = 33
    player.state = 'gatherTargets'
    player.alive = true
    swordDown = false
end 


-- player update
function checkPlayerInput(dt, collisionTable, enemies)

    for i,enemy in ipairs(enemies) do
        if CheckCollision(player.x,player.y,player.width,player.height, enemy.x,enemy.y,enemy.width,enemy.height) then 
            player.alive = false 
            return 
        end 
    end


    local direction = 'neutral'

    if love.keyboard.isDown('left', 'a') then 
        if player.x > 0 then
            player.x = math.floor(player.x - (player.speed * dt))
        	collisionLoop(player,'l', collisionTable)
        	direction = 'left'
        end
    elseif love.keyboard.isDown('right', 'd') then
        -- screen width - player width
        if player.x < (love.graphics.getWidth() - player.width) then     
            player.x = math.floor(player.x + (player.speed * dt))
            collisionLoop(player,'r', collisionTable)
            direction = 'right'
        end
    end
    if love.keyboard.isDown('up', 'w') then 
        if player.y > 0 then
            player.y = math.floor(player.y - (player.speed * dt))
        	collisionLoop(player,'u', collisionTable)
        	direction = 'up'
        end
    elseif love.keyboard.isDown('down', 's') then
        -- screen width - player width
        if player.y < (love.graphics.getHeight() - player.height) then
        	player.y =  math.floor(player.y + (player.speed * dt))
        	collisionLoop(player, 'd', collisionTable)
        	direction = 'down'
        end
    end
    if love.keyboard.isDown('j') then 
    	-- substitute for keyup function
    	if not swordDown then 
    		swordDown = true 
    		swing = true
    	else 
    		swing = false 
    	end 
    else 
    	swing = false 
    	swordDown = false
    end 



    updatePlayerAnimation(dt, direction, swing)
end
swordDown = false



function drawPlayer()
	
	drawAnimation(player.x, player.y)

end







