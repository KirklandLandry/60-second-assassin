--local index = 1
local menu = {}

--[[function getNextMenu()
	index = index + 1 
	return menu[index]
end]]

function getMenu(index)
	--return menu[index]
	return menu[index]
end 

-- check for out of index
function initializeMenuSelector()
	menu = {
		gameover='assets/maps/gameover-menu.lua',
		pause='assets/maps/pause-menu.lua',
		win='assets/maps/win-menu.lua',
		title='assets/maps/title-menu.lua'
	}
	return menu['title']
end 

function resetMenuSelector()
	--index = 1 
end 