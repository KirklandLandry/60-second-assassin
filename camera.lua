camera = {}
camera.x = 0
camera.y = 0
camera.scaleX = 1
camera.scaleY = 1
camera.rotation = 0
local scaleModifier = 1--0.5

-- applies transformations
function camera:set()
  love.graphics.push()
  love.graphics.rotate(-self.rotation)
  love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
  love.graphics.translate(-self.x, -self.y)
end

-- removes the transformations
function camera:unset()
  love.graphics.pop()
end

function camera:move(dx, dy)
  self.x = self.x + (dx or 0)
  self.y = self.y + (dy or 0)
end

function camera:rotate(dr)
  self.rotation = self.rotation + dr
end

function camera:scale(sx, sy)
  sx = sx or 1
  self.scaleX = self.scaleX * sx
  self.scaleY = self.scaleY * (sy or sx)
end

function camera:setPosition(x, y)
  self.x = x or self.x
  self.y = y or self.y
end

function camera:setScale(sx, sy)
  self.scaleX = sx or self.scaleX
  self.scaleY = sy or self.scaleY
end


-- need a way to try to keep the camera centered
-- maybe have a sort of second bounding box? 
-- also needs correction so that if the camera goes past the bounds
-- and you can see black it fixes it so you don't see black
function camera:updateCamera(player, bBox)

  if (player.x+player.width)>(bBox.x+bBox.width) then 
    -- move the camera 
    if camera.x+(love.graphics.getWidth()*scaleModifier) < love.graphics.getWidth() then 
      if (bBox.x+bBox.width) >= camera.x+((love.graphics.getWidth()*scaleModifier)/2) then 
        camera.x = camera.x + ((player.x+player.width)-(bBox.x+bBox.width))
      end 
    end
    -- move the bounding box 
    bBox.x = bBox.x + ((player.x+player.width)-(bBox.x+bBox.width))
  end 
  if player.x < bBox.x then 
    if camera.x > 0 then 
      if (bBox.x) <= camera.x+((love.graphics.getWidth()*scaleModifier)/2) then 
        camera.x = camera.x - (bBox.x-player.x)
      end 
    end 
    bBox.x = bBox.x - (bBox.x-player.x)
  end 
  if (player.y+player.height)>(bBox.y+bBox.height) then 
    if camera.y+(love.graphics.getHeight()*scaleModifier) < love.graphics.getHeight() then 
      if (bBox.y+bBox.height) >= camera.y+((love.graphics.getHeight()*scaleModifier)/2) then 
        camera.y = camera.y + ((player.y+player.height)-(bBox.y+bBox.height))
      end 
    end 
    bBox.y = bBox.y + ((player.y+player.height)-(bBox.y+bBox.height))

  end 
  if player.y < bBox.y then 
    if camera.y >0 then 
      if (bBox.y) <= camera.y+((love.graphics.getHeight()*scaleModifier)/2) then 
        camera.y = camera.y - (bBox.y-player.y)
      end 
    end 
    bBox.y = bBox.y - (bBox.y-player.y)
  end 
  camera:correctCameraPosition(player)
end

function camera:correctCameraPosition(player)
    if camera.y < 0 then
        camera.y = camera.y + math.abs(camera.y) --CorrectCollision('u', camera.x,camera.y,love.graphics.getWidth(),love.graphics.getHeight(), 0,0,love.graphics.getWidth(),love.graphics.getHeight())  --math.floor(camera.y - (player.speed * dt))
      --[[if camera.y+(love.graphics.getHeight()*scaleModifier) < player.y then 
        camera.y = player.y - ((love.graphics.getHeight()*scaleModifier)/2)
      end ]]
    end
    if camera.y+(love.graphics.getHeight()*scaleModifier) > (love.graphics.getHeight()) then
        camera.y = camera.y - math.abs((camera.y+(love.graphics.getHeight()*scaleModifier))-(love.graphics.getHeight())) --CorrectCollision('u', camera.x,camera.y,love.graphics.getWidth(),love.graphics.getHeight(), 0,0,love.graphics.getWidth(),love.graphics.getHeight())  --math.floor(camera.y - (player.speed * dt))
      if camera.y > player.y then 
        camera.y = player.y - ((love.graphics.getHeight()*scaleModifier)/2)
      end 
    end
    if camera.x < 0 then
        camera.x = camera.x + math.abs(camera.x) --CorrectCollision('u', camera.x,camera.y,love.graphics.getWidth(),love.graphics.getHeight(), 0,0,love.graphics.getWidth(),love.graphics.getHeight())  --math.floor(camera.y - (player.speed * dt))
    end
    if camera.x+(love.graphics.getWidth()*scaleModifier) > (love.graphics.getWidth()) then
        camera.x = camera.x - math.abs((camera.x+(love.graphics.getWidth()*scaleModifier))-(love.graphics.getWidth())) --CorrectCollision('u', camera.x,camera.y,love.graphics.getWidth(),love.graphics.getHeight(), 0,0,love.graphics.getWidth(),love.graphics.getHeight())  --math.floor(camera.y - (player.speed * dt))
      if camera.x > player.x then 
        camera.x = player.x - ((love.graphics.getWidth()*scaleModifier)/2)
      end 
    end
end 

function camera:zoomIn()
    if scaleModifier>=0.5 then 
      scaleModifier = scaleModifier - 0.02
      --moves camera to focues on player while it's zooming in
      camera:setPosition(player.x-((love.graphics.getWidth()*scaleModifier)/2), player.y-((love.graphics.getHeight()*scaleModifier)/2))
      --camera:scale(1)
      camera:setScale(scaleModifier, scaleModifier)
    end 
end 

function camera:reset() 
  scaleModifier = 1
  camera:setScale(scaleModifier, scaleModifier)
  camera.scaleX = 1
  camera.scaleY = 1
  camera.rotation = 0
end 

