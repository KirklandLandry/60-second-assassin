local Quad = love.graphics.newQuad
playerTileW = 15
playerTileH = 15
swordW = 12
swordH = 13

local iterator, max, timer, moving, direction, swordIterator, swordMax, swordTimer, swordSwing, swordSwing = nil 
function initializePlayerAnimation()
	playerSprite = love.graphics.newImage ("assets/images/ninjaSpritesheetNoSquares.png")
	playerSprite:setFilter('nearest','nearest')
	playerSpriteWidth = playerSprite:getWidth()
	playerSpriteHeight = playerSprite:getHeight()
	swordSprite = love.graphics.newImage ("assets/images/sword.png")
	swordSprite:setFilter('nearest','nearest')
	swordSpriteWidth = swordSprite:getWidth()
	swordSpriteHeight = swordSprite:getHeight()
	quads = {
		down = {
			Quad( 0,  45, playerTileW, playerTileH, playerSpriteWidth, playerSpriteHeight);
			Quad(15,  45, playerTileW, playerTileH, playerSpriteWidth, playerSpriteHeight);
			Quad(30,  45, playerTileW, playerTileH, playerSpriteWidth, playerSpriteHeight);
		};
		left = {
			Quad( 0,  15, playerTileW, playerTileH, playerSpriteWidth, playerSpriteHeight);
			Quad(15,  15, playerTileW, playerTileH, playerSpriteWidth, playerSpriteHeight);
			Quad(30,  15, playerTileW, playerTileH, playerSpriteWidth, playerSpriteHeight);
			Quad(45,  15, playerTileW, playerTileH, playerSpriteWidth, playerSpriteHeight);
			Quad(60,  15, playerTileW, playerTileH, playerSpriteWidth, playerSpriteHeight);
			Quad(75,  15, playerTileW, playerTileH, playerSpriteWidth, playerSpriteHeight);
		};
		right = {
			Quad( 0,   0, playerTileW, playerTileH, playerSpriteWidth, playerSpriteHeight);
			Quad(15,   0, playerTileW, playerTileH, playerSpriteWidth, playerSpriteHeight);
			Quad(30,   0, playerTileW, playerTileH, playerSpriteWidth, playerSpriteHeight);
			Quad(45,   0, playerTileW, playerTileH, playerSpriteWidth, playerSpriteHeight);
			Quad(60,   0, playerTileW, playerTileH, playerSpriteWidth, playerSpriteHeight);
			Quad(75,   0, playerTileW, playerTileH, playerSpriteWidth, playerSpriteHeight);
		};
		up = {
			Quad( 0,  30, playerTileW, playerTileH, playerSpriteWidth, playerSpriteHeight);
			Quad(15,  30, playerTileW, playerTileH, playerSpriteWidth, playerSpriteHeight);
			Quad(30,  30, playerTileW, playerTileH, playerSpriteWidth, playerSpriteHeight);
		};
		neutral = {
			Quad( 0,  60, playerTileW, playerTileH, playerSpriteWidth, playerSpriteHeight);
			Quad( 15, 60, playerTileW, playerTileH, playerSpriteWidth, playerSpriteHeight);
		};
		stabRight = {
			Quad(30, 60, playerTileW, playerTileH, playerSpriteWidth, playerSpriteHeight);
		};
		stabLeft = {
			Quad(45, 60, playerTileW, playerTileH, playerSpriteWidth, playerSpriteHeight);
		};
		swordRight = {
			Quad(0, 0, swordW, swordH, 48, 26 );
			Quad(12,0, swordW, swordH, 48, 26 );
			Quad(24,0, swordW, swordH, 48, 26 );
			Quad(36,0, swordW, swordH, 48, 26 );
		};
		swordLeft = {
			Quad(0, 13, swordW, swordH, 48, 26 );
			Quad(12,13, swordW, swordH, 48, 26 );
			Quad(24,13, swordW, swordH, 48, 26 );
			Quad(36,13, swordW, swordH, 48, 26 );
		};

	}
	iterator = 1
	max = 6
	timer = 0
	moving = true
	direction = "neutral"

	swordIterator = 1
	swordMax = 4
	swordTimer = 0
	swordSwing = false 
	lockSwing = false
end




local animationSpeed = 0.05
function updatePlayerAnimation(dt, key, swing)
	
	checkKey(key)

	if moving then
		timer = timer + dt
		if timer > animationSpeed then
			timer = 0
			iterator = iterator + 1
			if iterator > max then
				iterator = 1
			end
		end
	end


	if swing and not lockSwing then 
		lockSwing = true
		swordSwing = true
	end 

	if swordSwing then
		swordTimer = swordTimer + dt
		if swordTimer > 0.03 then
			swordTimer = 0
			swordIterator = swordIterator + 1 
			if swordIterator > swordMax then
				swordIterator = 1
				lockSwing = false
				swordSwing = false
			end
		end
	end
end

function drawAnimation(slomoShadows, x,y)
	-- got an error here? Not sure how.
	-- playerAnimation.lua:106: bad argument #2 to 'draw' (Quad expected, got nil)
	--PROBLEM SOLVED: bad variable name -> 2 global variables sharing a name. 
	if player.state~='gatherTargets' then 
		if player.killDirection =='right' then 
			love.graphics.draw(playerSprite, quads['stabRight'][1], x, y)
			love.graphics.draw(swordSprite, quads['swordRight'][4], x+(playerTileW-4), y-1)
		end 
		if player.killDirection =='left' then 
			love.graphics.draw(playerSprite, quads['stabLeft'][1], x, y)
			love.graphics.draw(swordSprite, quads['swordLeft'][4], x-12+4, y-1)
		end 
	else

		--for i,v in ipairs(slomoShadows) do
		counter = 1 
		--love.graphics.setBlendMode('additive')
		for i=#slomoShadows,1,-1 do
			if slomoShadows[i].direction==nil then 
				slomoShadows[i].direction = direction 
			end 
			if slomoShadows[i].iterator==nil then 
				slomoShadows[i].iterator = iterator 
			end 
			love.graphics.push()
				love.graphics.setColor(255,255,255,230-(counter*20))			
				love.graphics.draw(playerSprite, quads[slomoShadows[i].direction][slomoShadows[i].iterator], slomoShadows[i].x, slomoShadows[i].y)
				love.graphics.setColor(255,255,255, 255)
			love.graphics.pop()
			counter = counter + 1
		end
		love.graphics.setBlendMode('alpha')
		love.graphics.draw(playerSprite, quads[direction][iterator], x, y)
	end 

	-- draw based on direction
	-- draw special player sprite and stop movement
	if swordSwing then 
		love.graphics.draw(swordSprite, quads['swordRight'][swordIterator], x+(playerTileW-4), y-1)
	end 
end


local currentKey = ''
-- this should be changed so that the key isn't brough in so you can 
-- check for multiple keys down at once 
function checkKey(key)


	if key=='up' and currentKey ~= key then 
		max = 3 
		iterator = 1
		currentKey = key
		animationSpeed = 0.1
	elseif key=='down' and currentKey ~= key then 
		max = 3 
		iterator = 1
		currentKey = key
		animationSpeed = 0.1
	end 
	if key=='left' and currentKey ~= key then 
		max = 6 
		iterator = 1
		currentKey = key
		animationSpeed = 0.07
	elseif key=='right' and currentKey ~= key then 
		max = 6 
		iterator = 1
		currentKey = key
		animationSpeed = 0.07
	end 
	if key=='neutral' and currentKey ~= key then 
		max = 2
		iterator = 1
		currentKey = key
		animationSpeed = 0.3
	end 


	direction = key

	--[[if quads[key] then -- this is really ugly. Don't do it like this in your final game.
		moving = true
		direction = key
	end

	if quads[key] and direction == key then -- only stop moving if we're still moving in only that direction.
		moving = false
		direction = "down"
		iterator = 1
	end]]
end
