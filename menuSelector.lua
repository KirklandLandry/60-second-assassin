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
		gameover='assets/menus/gameover-menu.lua',
		pause='assets/menus/pause-menu.lua',
		win='assets/menus/win-menu.lua',
		title='assets/menus/title-menu.lua',
		instructions='assets/menus/instructions-menu.lua',
		gamewin='assets/menus/game-win.lua'
	}
	return menu['title']
end 

function resetMenuSelector()
	--index = 1 
end 