local alpha = 0
--startAlpha, endAlpha
local time = 1
local n = 1

asd = {one=function() co = coroutine.create(function () for i=1,1000 do print(i) end end ) coroutine.resume(co) end}
local method = ' '

function setFade(_method)
	method=_method
end

function fadeFrom()
	if alpha > 0 then 
	love.graphics.push()
		love.graphics.setColor(0,0,0,alpha)
		love.graphics.rectangle('fill',0,0,love.graphics.getWidth(), love.graphics.getHeight())
		--love.graphics.draw(black,0,0,0,love.graphics.getWidth(), love.graphics.getHeight())
		alpha = alpha - 255/(time/love.timer.getDelta())
	love.graphics.pop()
	love.graphics.reset()
	else 
		method = ' '
	end 
end 


function fadeTo()
	if alpha < 255 then 
	love.graphics.push()
		love.graphics.setColor(0,0,0,alpha)
		love.graphics.rectangle('fill',0,0,love.graphics.getWidth(), love.graphics.getHeight())
		--love.graphics.draw(black,0,0,0,love.graphics.getWidth(), love.graphics.getHeight())
		alpha = alpha + 255/(time/love.timer.getDelta())
	love.graphics.pop()
	love.graphics.reset()
	else 
		method = ' '
	end 
end 

-- look at unity for a real proper crossfade
local switch = false
function crossfade()
	if alpha < 255 and not switch then 
	love.graphics.push()
		love.graphics.setColor(0,0,0,alpha)
		love.graphics.rectangle('fill',0,0,love.graphics.getWidth(), love.graphics.getHeight())
		--love.graphics.draw(black,0,0,0,love.graphics.getWidth(), love.graphics.getHeight())
		alpha = alpha + 255/(time/love.timer.getDelta())
	love.graphics.pop()
	love.graphics.reset()
	elseif alpha > 0 then 
		switch = true 
	love.graphics.push()
		love.graphics.setColor(0,0,0,alpha)
		love.graphics.rectangle('fill',0,0,love.graphics.getWidth(), love.graphics.getHeight())
		--love.graphics.draw(black,0,0,0,love.graphics.getWidth(), love.graphics.getHeight())
		alpha = alpha - 255/(time/love.timer.getDelta())
	love.graphics.pop()
	love.graphics.reset()
	end
end 


function updateFade()
	if method == 'fadeFrom' then 
		fadeFrom()
	end 
	if method == 'fadeTo' then 
		fadeTo()
	end 
	if method == 'crossfade' then 
		crossfade()
	end 
end 




