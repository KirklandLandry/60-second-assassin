local index = 1
local maps = {}

function getNextMap()
	index = index + 1 
	return maps[index]
end 

function getCurrentMap()
	return maps[index]
end 

-- check for out of index
function initializeMapSelector()
	maps = {
		'assets/maps/core-dump.lua',
		'assets/maps/core-dump2.lua',
 		'assets/maps/core-dump3.lua'
	}
	return maps[index]
end 

function resetMapSelector()
	index = 1 
end 