-- modified library
function initializeBloodSpray()
  --sorry, too lazy to pick an image, just skip point 1a and 1b when you use an image file
  --1a. create a blank 32px*32px image data
  id = love.image.newImageData(32, 32)
  --1b. fill that blank image data
  for x = 0, 31 do
    for y = 0, 31 do
      local gradient = 1 - ((x-15)^2+(y-15)^2)/40
      id:setPixel(x, y, 255, 255, 255, 255*(gradient<0 and 0 or gradient))
    end
  end
  
  --2. create an image from that image data
  i = love.graphics.newImage(id)

  -- create 10 to start
  for i=1,10 do
    createParticleSystem()
  end
end

particleSystems = {}
-- this should be general. bring in a string to specify type
-- and then create
function createParticleSystem()
  --3a. create a new particle system which uses that image, set the maximum amount of particles (images) that could exist at the same time to 256
  local p = love.graphics.newParticleSystem(i, 256)
  --3b. set various elements of that particle system, please refer the wiki for complete listing
  p:setEmissionRate          (500  )
  p:setEmitterLifetime       (0.5,0.6)
  p:setParticleLifetime      (0.1,0.2)
  p:setPosition              (50, 50)
  p:setDirection             (300)
  p:setSpread                (1)
  p:setSpeed                 (500,500)
  --p:setGravity               (29,30)
  p:setRadialAcceleration    (10)
  p:setTangentialAcceleration(0)
  p:setSizes                 (0.9,1.5)
  p:setSizeVariation         (0.5)
  p:setRotation              (0)
  p:setSpin                  (0)
  p:setSpinVariation         (0)
  p:setColors                 ( 255, 0, 0, 200, 255, 0, 0, 10 )
  p:stop();--this stop is to prevent any glitch that could happen after the particle system is created
  table.insert(particleSystems, p)
end 


function updateParticleSystem(dt)
  --4a. on each frame, the particle system should be started/burst. try to move this line to love.load instead and see what happens
  p:start();
  --4b. on each frame, the particle system needs to update its particles's positions after dt miliseconds
  p:update(dt);
end

function drawParticleSystem(i)
  --5. draw the particle system, with its origin (0, 0) located at love's 20, 20. Compare this origin position with the particle system's emitter position being set by "p:setPosition(50, 50)" in love.load
  love.graphics.push()
    --love.graphics.setColor(255,0,0,200)
    love.graphics.draw(particleSystems[i], 0, 0)
  love.graphics.pop()

end

