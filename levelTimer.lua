
local slomoTimerMax=60
local slomoTimer=slomoTimerMax

function updateLevelTimer(dt, player )
		if player.state=='gatherTargets' then 
			slomoTimer=slomoTimer - dt  --decrement by 1 every second (so...a clock going from 60 to 0)
		end 
		return slomoTimer
	--[[elseif slomoTimer < slomoTimerMax and player.state=='gatherTargets' and not slomoKeyDown then 
		slomoTimer=slomoTimer + dt
		if slomoTimer> slomoTimerMax then 
			slomoTimer = slomoTimerMax 
		end 
	end ]]
end 

function resetLevelTimer()
	slomoTimer=slomoTimerMax
end 

function drawLevelTimer()
	love.graphics.print(tostring(math.floor(slomoTimer))..'s', 10, 20)
end 