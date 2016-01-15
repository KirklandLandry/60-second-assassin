local index = 1
local maps = {}

function getNextMap()
	index = index + 1 
	if index > #maps then 
		--resetMapSelector()
		return 'gameWon'
	else 
		return maps[index]
	end 
end 

function getCurrentMap()
	return maps[index]
end 

-- check for out of index
function initializeMapSelector()
	maps = {
		'assets/maps/map1.lua',
		'assets/maps/map2.lua',
 		'assets/maps/map3.lua',
 		'assets/maps/map4.lua',
 		'assets/maps/map5.lua',
 		'assets/maps/map6.lua'

	}
	return maps[index]
end 

function resetMapSelector()
	index = 1 
end 