local slomoKeyDown=false
local slomoTimerMax=1
local slomoTimer=slomoTimerMax
local slomoTimerBarImage = nil 
slomoTimerBarImage = love.graphics.newImage('assets/images/slomoTimerBar.png')

function updateSlomo(dt, player)
	if slomoKeyDown==true and slomoTimer>0 and player.state=='gatherTargets' then 
		dt = dt/2 
		slomoTimer=slomoTimer - dt  --slomoTimerMax
		return dt
	elseif slomoTimer < slomoTimerMax and player.state=='gatherTargets' and not slomoKeyDown then 
		slomoTimer=slomoTimer + dt
		if slomoTimer> slomoTimerMax then 
			slomoTimer = slomoTimerMax 
		end 
	end 
	return dt
end 


function checkSlomoInput(player)
    if love.keyboard.isDown('o') and player.state == 'gatherTargets' then --and not kill and not postKill then 
		if pauseMenuW_keyDown==false then 
			slomoKeyDown=true 
		end 
    else 
    	slomoKeyDown=false
    end 
end 

function resetSlomoTimer()
	slomoTimer=slomoTimerMax
	slomoKeyDown = false
	
end 

function drawSlomoBar()
	if slomoTimer > 0 then 
    	love.graphics.rectangle('fill', 5, 4, (slomoTimerBarImage:getWidth()-8)*slomoTimer, slomoTimerBarImage:getHeight()-4)
	end 
		love.graphics.draw(slomoTimerBarImage, 1, 1)
end 