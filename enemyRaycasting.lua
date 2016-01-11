
local rays={}
function enemyRaycast(enemy, player)
    local yPositions = {enemy.y,enemy.y+(enemy.height/2),enemy.y+enemy.height-1}
    local xPositions = {enemy.x,enemy.x+(enemy.width/2),enemy.x+enemy.width-1}
    rays={}
    local collision = false
    
    for i=1, 3 do 
        --print (i)
        local rayLength = 0
        local yPos = yPositions[i]
        local xPos = xPositions[i]
        --print(yPos)
        for i=1,love.graphics.getWidth()/5 do
            rayLength = rayLength + 5
            collision = sendRay(rayLength, enemy, player, yPos, xPos) 
            if collision then break end 
        end 
        table.insert(rays, rayLength)
    end 
    return rays
end 

-- need to minimize this shitty loop
function sendRay(ray, enemy, player, yPos, xPos) 


    local pColumn =   math.floor(player.x/32) + 1
    local pRow    =   math.floor(player.y/32) + 1
    --eColumn =   math.floor(enemy.x/32)  + 1
    local eColumn =   math.floor(xPos/32)  + 1
    local eRow    =   math.floor(yPos/32)  + 1

    local bounds = {x1=0, x2=0, y1=0, y2=0} 

    -- use this for switching between x and y casting
    --[[if enemy.facing.x==1 then 
        min = 1
        max = #collisionTable
    end 
    if enemy.facing.x==1 then 
        min = 1
        max = #collisionTable
    end ]]
    
    

    local collision = false


    -- for some reason each attempt at this has destroyed the game
    -- if facing left or right 
        -- use this min/mix for the for loop
    -- if facing up or down
        -- use this min/max for the for loop
    
    --for i=1, #collisionTable[1] do  -- y
    local max = 0
    local x,y =0
    if enemy.facing.x==1 or enemy.facing.x==-1 then 
        max = #collisionTable
    elseif enemy.facing.y==1 or enemy.facing.y==-1 then 
        max = #collisionTable[1] 
    end 


        for j=1, max do--#collisionTable do -- x

            if enemy.facing.x==1 or enemy.facing.x==-1 then 
                x=j
                y=eRow
            elseif enemy.facing.y==1 or enemy.facing.y==-1 then 
                --max = #collisionTable[1] 
                x=eColumn
                y=j
            end 

            --if x >  #collisionTable[1] or y > #collisionTable[1] or x > #collisionTable or y > #collisionTable then 
            --[[if x>25 then 
                print ('y-width:'..#collisionTable[1], 'x-width:'..#collisionTable,'x:'..x,'y:'..y, 'ecol:'..eColumn, 'floor(xpos/32):'..math.floor(xPos/32),'xpos/32:'..xPos/32,'xpos:'..xPos,'enemy.x:'..enemy.x)
            end ]]
            
            -- because of how i'm randomly spawning, that can cause enemies to be out of the table's bounds 
            -- this makes sure everything is within table bounds 
            if x < #collisionTable and y < #collisionTable[1] and eColumn < #collisionTable and eRow < #collisionTable[1] then 
 
                if collisionTable[x][y]==1 then 
                    
                    if max == #collisionTable then 
                        bounds.x1 = (x-1)*32
                        bounds.x2 = x*32
                        bounds.y1 = (eRow-1)*32
                        bounds.y2 = eRow*32
                    elseif max == #collisionTable[1] then 
                        bounds.x1 = (eColumn-1)*32
                        bounds.x2 = eColumn*32
                        bounds.y1 = (y-1)*32
                        bounds.y2 = y*32
                    end 

                    if enemy.facing.x==-1 then 
                        if enemyRaycastCollisions(ray, ray, 0, enemy, player, bounds,yPos, xPos) then 
                            collision = true 
                        end
                    end 
                    if enemy.facing.x==1 then 
                        if enemyRaycastCollisions(ray, -enemy.width, 0, enemy, player, bounds, yPos, xPos) then 
                            collision = true 
                        end 
                    end 
                    if enemy.facing.y==1 then 
                        if enemyRaycastCollisions(ray, 0, 0, enemy, player, bounds,yPos, xPos) then 
                            collision = true 
                        end
                    end 
                    if enemy.facing.y==-1 then 
                        if enemyRaycastCollisions(ray, 0, ray, enemy, player, bounds,yPos, xPos) then 
                            collision = true 
                        end
                    end 

                end
            end 
        end 
    
    if collision then return true 
    else return false end 

end 

function enemyRaycastCollisions(ray, xOffset, yOffset, enemy, player, bounds, yPos, xPos)
    
    if enemy.facing.x ==1 or enemy.facing.x==-1 then 
        if CheckCollision(enemy.x-xOffset,yPos, ray, 1,  bounds.x1,bounds.y1,32,32) then 
            return true
        end 
        if CheckCollision(enemy.x-xOffset,yPos, ray, 1,  player.x,player.y,player.width,player.height) then 
            enemy.target = player
            enemy.speed = 300--enemy.speed*2
            return true
        end 
    elseif enemy.facing.y == 1 or enemy.facing.y==-1 then 
        if CheckCollision(xPos,enemy.y-yOffset, 1, ray,  bounds.x1,bounds.y1,32,32) then 
            return true
        end 
        if CheckCollision(xPos,enemy.y-yOffset, 1, ray,  player.x,player.y,player.width,player.height) then 
            enemy.target = player
            enemy.speed = 300--enemy.speed*2
            return true
        end 
    end 
    return false
end 


function drawRay(enemy)
    local yRayPositions = {enemy.y,enemy.y+(enemy.height/2),enemy.y+enemy.height}
    local xRayPositions = {enemy.x,enemy.x+(enemy.width/2),enemy.x+enemy.width}

        --[[love.graphics.push()
            love.graphics.setColor(255,0,0,230) 
            local yPos = rays[2]
            if enemy.facing.x ==-1 then 
                love.graphics.rectangle('fill', enemy.x-enemy.rayLengths[2], yPos, enemy.rayLengths[2], 1)
            end 
            if enemy.facing.x==1 then
                love.graphics.rectangle('fill', enemy.x, yPos, enemy.rayLengths[2], 1)
            end 
            love.graphics.reset()
        love.graphics.pop()]]



    love.graphics.push()
        love.graphics.setColor(255,0,0,230)         
        for i=1,3 do
            local yPos = yRayPositions[i]
            local xPos = xRayPositions[i]

            if enemy.facing.x ==-1 then 
                love.graphics.rectangle('fill', enemy.x-enemy.rayLengths[i], yPos, enemy.rayLengths[i], 1)
            end 
            if enemy.facing.x==1 then
                love.graphics.rectangle('fill', enemy.x+enemy.width, yPos, enemy.rayLengths[i], 1)
            end 
            if enemy.facing.y==1 then 
                love.graphics.rectangle('fill', xPos, enemy.y, 1, enemy.rayLengths[i])
            end 
            if enemy.facing.y==-1 then 
                love.graphics.rectangle('fill', xPos, enemy.y-enemy.rayLengths[i], 1, enemy.rayLengths[i])
            end 
        end
        love.graphics.reset()
    love.graphics.pop()

end 