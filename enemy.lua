require 'enemyRaycasting'
enemies = {}

function createEnemy(xPos,yPos,facingX, facingY, move)
	--randomNum = math.random(10, love.graphics.getWidth())
	--randomNum2 = math.random(10, love.graphics.getHeight())
	
	newEnemy = {
	facing={x=facingX, y=facingY},--{x=0,y=1},-- left, right, up, down  --facing ='right', 
	moving=move, 
	x = xPos,--randomNum, 
	y = yPos,--randomNum2, 
	width = enemyImg:getWidth(), 
	height = enemyImg:getHeight(), 
	speed=100, 
	angle = 0, 
	img = enemyImg, 
	rayLengths={0,0,0}, 
	target = nil, 
	bullets = {}, 
	shootTimer = 0, 
	shootTimerMax = 1, 
	shootTimerIncrement = 10
	}
	table.insert(enemies, newEnemy)
end 

function initializeEnemies(EnemyTable)
	enemyImg = love.graphics.newImage('assets/images/enemy.png')

	for i,enemy in ipairs(EnemyTable) do
		createEnemy(enemy.xPos, enemy.yPos, enemy.facingX, enemy.facingY, enemy.move)
	end
end 

function resetEnemies()
	for i=#enemies,1,-1 do
		table.remove(enemies, i)
	end
	enemies = {}
	print (#enemies)
end 


function updateEnemies(dt, collisionTable, player)


	-- why is the left moving so much faster??
	for i, enemy in ipairs(enemies) do 

        local centerX,centerY,width,height,hypotenuse, angle,dx,dy = nil 

		if (enemy.target~=nil) then 

    		velocity = enemy.speed
    		centerX = enemy.x + (enemy.width/2)
		    centerY = enemy.y + (enemy.height/2)
	        width = (enemy.target.x+(enemy.target.width/2)) - centerX
	        height = (enemy.target.y+(enemy.target.width/2)) - centerY
	        hypotenuse = math.sqrt((width^2) + (height^2))
	        angle = math.acos(width/hypotenuse)
	        if height < 0 then 
	        	dx = (math.cos(angle) * velocity);
				dy = (math.sin(math.pi + angle) * velocity);    
	        else 
				dx = (math.cos(angle) * velocity);
				dy = (math.sin(angle) * velocity);            
			end 

			if dx < 0 then enemy.facing.x=-1 end
			if dx > 0 then enemy.facing.x= 1 end
			if dy < 0 then enemy.facing.y=-1 end
			if dy > 0 then enemy.facing.y= 1 end


			if enemy.facing.x==-1 then 
		        if enemy.x > 0 then
		            enemy.x = enemy.x + (dx*love.timer.getDelta())
		        	collided = collisionLoop(enemy,'l', collisionTable)
		        	if collided then 
		        		
		        	end 
		        end
		    end 
		    if enemy.facing.x==1 then
		        if enemy.x < (love.graphics.getWidth() - enemy.width) then     
		            enemy.x = enemy.x + (dx*love.timer.getDelta())
		          	collided = collisionLoop(enemy,'r', collisionTable)
		            if collided then 
		            	
		            end 
		        end
		    end
		    if enemy.facing.y==-1 then 
		        if enemy.y > 0 then
		            enemy.y = enemy.y + (dy*love.timer.getDelta())
		        	collided = collisionLoop(enemy,'u', collisionTable)
		        	if collided then 
		            	
		            end 
		        end
		    end 
		    if enemy.facing.y==1 then
		        if enemy.y < (love.graphics.getHeight() - enemy.height) then
		        	enemy.y = enemy.y + (dy*love.timer.getDelta())
		        	collided = collisionLoop(enemy, 'd', collisionTable)
		        	if collided then 
		            	
		            end 
		        end
		    end	


		    enemy.shootTimer = enemy.shootTimer - (enemy.shootTimerIncrement * dt)
    		if enemy.shootTimer < 0 then
        		enemy.shootTimer = enemy.shootTimerMax

        		velocity = 400
		        --[[local centerX = enemy.x + (enemy.width/2)
		        local centerY = enemy.y + (enemy.height/2)


		        local width = (enemy.target.x+(enemy.target.width/2)) - centerX
		        local height = (enemy.target.y+(enemy.target.width/2)) - centerY
		        local hypotenuse = math.sqrt((width^2) + (height^2))

		        local angle = math.acos(width/hypotenuse)]]


		        if height < 0 then 
		        	dx = (math.cos(angle) * velocity);
					dy = (math.sin(math.pi + angle) * velocity);    
		        else 
        			dx = (math.cos(angle) * velocity);
					dy = (math.sin(angle) * velocity);            
				end 



				local bullet = {x = centerX, y = centerY, Vx=dx, Vy=dy}--, Xc = (enemy.target.x+(enemy.target.width/2)), Yc = (enemy.target.y+(enemy.target.height/2)),  }
        		table.insert(enemy.bullets, bullet)
    		end	
			
		else

			if enemy.facing.x==-1 and enemy.moving then 
		        if enemy.x > 0 then
		            enemy.x = enemy.x-(enemy.speed * dt)
		        	collided = collisionLoop(enemy,'l', collisionTable)
		        	if collided then 
		        		enemy.facing.x=1
		        	end 
		        end
		    end 
		    if enemy.facing.x==1 and enemy.moving then
		        if enemy.x < (love.graphics.getWidth() - enemy.width) then     
		            enemy.x = enemy.x+(enemy.speed * dt)
		          	collided = collisionLoop(enemy,'r', collisionTable)
		            if collided then 
		            	enemy.facing.x=-1
		            end 
		        end
		    end
		    if enemy.facing.y==-1 and enemy.moving then 
		        if enemy.y > 0 then
		            enemy.y = enemy.y - (enemy.speed * dt) --math.floor(enemy.y - (enemy.speed * dt))
		        	collided = collisionLoop(enemy,'u', collisionTable)
		        	if collided then 
		            	enemy.facing.y=1
		            end 
		        end
		    end 
		    if enemy.facing.y==1 and enemy.moving then
		        -- screen width - player width
		        if enemy.y < (love.graphics.getHeight() - enemy.height) then
		        	enemy.y =  enemy.y + (enemy.speed * dt) --math.floor(enemy.y + (enemy.speed * dt))
		        	collided = collisionLoop(enemy, 'd', collisionTable)
		        	if collided then 
		            	enemy.facing.y=-1
		            end 
		        end
		    end
		end 


		-- raycasting
		if enemy.target==nil then
			enemy.rayLengths = enemyRaycast(enemy, player)
		end 

		updateBullets(i)
		
	end 
end 



-- not really nessessary
function updateBullets(index)

	--[[
		for i,bullet in ipairs(enemies[index].bullets) do


			bullet.x = bullet.x + (bullet.Vx*love.timer.getDelta())
			bullet.y = bullet.y + (bullet.Vy*love.timer.getDelta())

			
			local column  	= 	math.floor(bullet.x/32) + 1
			local row 		= 	math.floor(bullet.y/32) + 1
			local bounds 	= 	{x1=0, x2=0, y1=0, y2=0} 

			if row < #collisionTable[1] and row>0 and  -- y
			column< #collisionTable and column>0 then -- x
				if collisionTable[column][row]==1 then 
					bounds.x1 = (column-1)*32
					bounds.x2 = column*32
					bounds.y1 = (row-1)*32
					bounds.y2 = row*32
					if CheckCollision(bullet.x,bullet.y, 16, 16,  bounds.x1,bounds.y1,32,32) then 
						table.remove(enemies[index].bullets, i)
					end 
				elseif bullet.x <0 or bullet.x>love.graphics.getWidth() or bullet.y<0 or bullet.y>love.graphics.getHeight() then 
					table.remove(enemies[index].bullets, i)
				end  
			end 

		end
	]]
end 


function drawEnemies()

	for i, enemy in ipairs(enemies) do
		if enemy.target==nil then
			drawRay(enemy)
		end 
		if enemy.facing.x==-1 then 
			love.graphics.draw(enemy.img, enemy.x+enemy.width, enemy.y, enemy.angle, -1, 1, 0, 0, 0, 0)
		else
			love.graphics.draw(enemy.img, enemy.x, enemy.y, enemy.angle, 1, 1, 0, 0, 0, 0)
		end 
		--[[for i,bullet in ipairs(enemy.bullets) do

			love.graphics.push()
				love.graphics.setColor(125, 199, 2, 255)
				love.graphics.circle('fill', bullet.x, bullet.y, 8)
				love.graphics.reset()
			love.graphics.pop()
		end ]]
	end 
end 
