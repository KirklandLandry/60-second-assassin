local slomoKeyDown=false
local slomoTimerMax=1
local slomoTimer=slomoTimerMax
local slomoTimerBarImage = nil 
slomoShadows = {}
slomoTimerBarImage = love.graphics.newImage('assets/images/slomoTimerBar.png')

function updateSlomo(dt, player)
	if slomoKeyDown==true and slomoTimer>0 and player.state=='gatherTargets' then 
		dt = dt/2 
		slomoTimer=slomoTimer - dt  --slomoTimerMax
		addSlomoShadow()
		return dt
	elseif slomoTimer < slomoTimerMax and player.state=='gatherTargets' and not slomoKeyDown then 
		slomoTimer=slomoTimer + dt
		if slomoTimer> slomoTimerMax then 
			slomoTimer = slomoTimerMax 
		end 
	end 
	clearSlomoShadowTable() 
	return dt
end 



-- have this thing function on it's own timer
-- that way it won't double up on shadows if the player presses slomo
-- and the timer immediatly crosses over 2 numbers ()
function addSlomoShadow()
	print (slomoTimer)
	for i=0,10 do
		if slomoTimer >= ((10-i)/10)-0.05 and slomoTimer <=((10-i)/10) and (#slomoShadows<i+1) then 
			xy = {x = player.x, y = player.y, direction = nil, iterator=nil}
			table.insert(slomoShadows, xy)
		end 
	end

	--[[if slomoTimer >=0.98 and slomoTimer <=1 and #slomoShadows<1 then 
		xy = {x = player.x, y = player.y, direction = nil, iterator=nil}
		table.insert(slomoShadows, xy)
	end 
	if slomoTimer >=0.9 and slomoTimer <=0.92 and #slomoShadows<2 then 
		xy = {x = player.x, y = player.y, direction = nil, iterator=nil}
		table.insert(slomoShadows, xy)
	end 
	if slomoTimer >=0.8 and slomoTimer <0.82 and #slomoShadows<3 then 
		xy = {x = player.x, y = player.y, direction = nil, iterator=nil}
		table.insert(slomoShadows, xy)
	end 
	if slomoTimer >=0.7 and slomoTimer <0.72 and #slomoShadows<4 then 
		xy = {x = player.x, y = player.y, direction = nil, iterator=nil}
		table.insert(slomoShadows, xy)
	end 
	if slomoTimer >=0.6 and slomoTimer <0.62 and #slomoShadows<5 then 
		xy = {x = player.x, y = player.y, direction = nil, iterator=nil}
		table.insert(slomoShadows, xy)
	end 
	if slomoTimer >=0.5 and slomoTimer <0.52 and #slomoShadows<6 then 
		xy = {x = player.x, y = player.y, direction = nil, iterator=nil}
		table.insert(slomoShadows, xy)
	end 
	if slomoTimer >=0.4 and slomoTimer <0.42 and #slomoShadows<7 then 
		xy = {x = player.x, y = player.y, direction = nil, iterator=nil}
		table.insert(slomoShadows, xy)
	end 
	if slomoTimer >=0.3 and slomoTimer <0.32 and #slomoShadows<8 then 
		xy = {x = player.x, y = player.y, direction = nil, iterator=nil}
		table.insert(slomoShadows, xy)
	end 
	if slomoTimer >=0.2 and slomoTimer <0.22 and #slomoShadows<9 then 
		xy = {x = player.x, y = player.y, direction = nil, iterator=nil}
		table.insert(slomoShadows, xy)
	end 
	if slomoTimer >=0.1 and slomoTimer <0.12 and #slomoShadows<10 then 
		xy = {x = player.x, y = player.y, direction = nil, iterator=nil}
		table.insert(slomoShadows, xy)
	end 
	if slomoTimer >=0.0 and slomoTimer <0.02 and #slomoShadows<11 then 
		xy = {x = player.x, y = player.y, direction = nil, iterator=nil}
		table.insert(slomoShadows, xy)
	end ]]
end 

function clearSlomoShadowTable()
	for i=#slomoShadows,1,-1 do
		table.remove(slomoShadows, i)
	end
	slomoShadows = {}
end 

function checkSlomoInput(player)
    if love.keyboard.isDown('o') and player.state == 'gatherTargets' then --and not kill and not postKill then 
		if pauseMenuW_keyDown==false then 
			slomoKeyDown=true 
		end 
    else 
    	slomoKeyDown=false
    	clearSlomoShadowTable()
    end 
end 

function resetSlomoTimer()
	slomoTimer=slomoTimerMax
	slomoKeyDown = false
	clearSlomoShadowTable()
end 

function drawSlomoBar()
	if slomoTimer > 0 then 
    	love.graphics.rectangle('fill', 5, 4, (slomoTimerBarImage:getWidth()-8)*slomoTimer, slomoTimerBarImage:getHeight()-4)
	end 
	love.graphics.draw(slomoTimerBarImage, 1, 1)
end 