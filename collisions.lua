

-- 32 is assuming a background tile size of 32x32
-- this is obsiously bad
-- initialize this class to have the proper information from the map
function initializeCollisions()

end 


function collisionLoop(object, direction, collisionTable)
    local bounds = {x1=0, x2=0, y1=0, y2=0} 
	for i=1, #collisionTable[1] do  -- y
		for j=1, #collisionTable do -- x
			if collisionTable[j][i]==1 then 
				bounds.x1 = (j-1)*32
				bounds.x2 = j*32
				bounds.y1 = (i-1)*32
				bounds.y2 = i*32
				if CheckCollision(object.x,object.y,object.width, object.height, bounds.x1,bounds.y1,32,32) then
					if direction=='r' then
						object.x = object.x - CorrectCollision('r', object.x,object.y,object.width,object.height, bounds.x1,bounds.y1,32,32)
					end
					if direction=='l' then
						object.x = object.x + CorrectCollision('l', object.x,object.y,object.width,object.height, bounds.x1,bounds.y1,32,32)
					end
					if direction=='u' then
						object.y = object.y + CorrectCollision('u', object.x,object.y,object.width,object.height, bounds.x1,bounds.y1,32,32)
					end
					if direction=='d' then
						object.y = object.y - CorrectCollision('d', object.x,object.y,object.width,object.height, bounds.x1,bounds.y1,32,32)
					end
                    return true 
				end 
			end
		end 
	end 
end


-- Collision detection taken function from http://love2d.org/wiki/BoundingBox.lua
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

-- will also want to know how much overlap has occured so it can
-- be corrected
function CorrectCollision(direction, x1,y1,w1,h1, x2,y2,w2,h2)	
	if direction == 'r' then 
		return w1-(x2-x1)
	end
	if direction == 'l' then  
		return (x2+w2)-x1
	end
	if direction == 'u' then 
		return (y2+h2)-y1
	end
	if direction == 'd' then  
		return (y1+h1)-y2
	end
end





