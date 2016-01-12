local TileW
local TileH
local Tileset
local TileTable
collisionTable=nil
enemyTable={}
local Quads

function getEnemyTable()
	return enemyTable
end

local enemyTotal 
local enemiesRemaining
function getEnemiesRemaining(killed)
	enemiesRemaining = enemiesRemaining - killed
	return enemiesRemaining
end 

function resetMap()
	for i=#enemyTable,1,-1 do
		table.remove(enemyTable, i)
	end
	for i=#collisionTable,1,-1 do
		table.remove(collisionTable, i)
	end
	enemyTable={}
	collisionTable = nil
	enemyTotal = 0
	enemiesRemaining = 0
end 

function drawMap()
  for x,column in ipairs(TileTable) do
    for y,char in ipairs(column) do
      love.graphics.draw(Tileset, Quads[ char ] , (x-1)*TileW, (y-1)*TileH)
    end
  end
end

function loadMap(path)
	-- this is basically loading the file in that path and then 
	-- returns a "chunk". when executed, it runs the code in the file
	-- so it's 
	-- f = load(path)
	-- f()
	love.filesystem.load(path)()
end



function newMap(tileW, tileH, tilesetPath, tileString, quadInfo)
  
	TileW = tileW
	TileH = tileH
	Tileset = love.graphics.newImage(tilesetPath)
	Tileset:setFilter('nearest','nearest')

	collisionTable = {}

	local tilesetW, tilesetH = Tileset:getWidth(), Tileset:getHeight()

	Quads = {}

	for _,info in ipairs(quadInfo) do
		-- info[1] = the character, info[2] = x, info[3] = y
		Quads[info[1]] = love.graphics.newQuad(info[2], info[3], TileW,  TileH, tilesetW, tilesetH)
	end

	TileTable = {}

	local width = #(tileString:match("[^\n]+"))

	for x = 1,width,1 do 
		TileTable[x] = {} 
		collisionTable[x]={}
	end

	local x,y = 1,1
	for row in tileString:gmatch("[^\n]+") do
		assert(#row == width, 'Map is not aligned: width of row ' .. tostring(y) .. ' should be ' .. tostring(width) .. ', but it is ' .. tostring(#row))
		x = 1
		for tile in row:gmatch(".") do
			checkTile(x,y,tile)
			x = x + 1
		end
		y=y+1
	end

	for i=1, y-1 do 
		string=''
		for j=1,x-1 do 
			--print(#collisionTable,#collisionTable[1])
			--print(j,i)
			string = string..tostring(collisionTable[j][i]) 
		end 
		print(string)
	end 
	enemyTotal = #enemyTable
	enemiesRemaining = enemyTotal
end

function checkTile(x,y,tile)
	TileTable[x][y] = tile
	if tile =='l' then 
		table.insert(enemyTable, {xPos=((x-1)*32)+8, yPos=((y-1)*32)+8, facingX=-1, facingY=0, move=true})
		collisionTable[x][y]=0
	elseif tile =='r' then 
		table.insert(enemyTable, {xPos=((x-1)*32)+8, yPos=((y-1)*32)+8, facingX=1, facingY=0, move=true})
		collisionTable[x][y]=0
	elseif tile =='u' then 
		table.insert(enemyTable, {xPos=((x-1)*32)+8, yPos=((y-1)*32)+8, facingX=0, facingY=-1, move=true})
		collisionTable[x][y]=0
	elseif tile =='d' then 
		table.insert(enemyTable, {xPos=((x-1)*32)+8, yPos=((y-1)*32)+8, facingX=0, facingY=1, move=true})
		collisionTable[x][y]=0
	elseif tile =='L' then 
		table.insert(enemyTable, {xPos=((x-1)*32)+8, yPos=((y-1)*32)+8, facingX=-1, facingY=0, move=false})
		collisionTable[x][y]=0
	elseif tile =='R' then 
		table.insert(enemyTable, {xPos=((x-1)*32)+8, yPos=((y-1)*32)+8, facingX=1, facingY=0, move=false})
		collisionTable[x][y]=0
	elseif tile =='U' then 
		table.insert(enemyTable, {xPos=((x-1)*32)+8, yPos=((y-1)*32)+8, facingX=0, facingY=-1, move=false})
		collisionTable[x][y]=0
	elseif tile =='D' then 
		table.insert(enemyTable, {xPos=((x-1)*32)+8, yPos=((y-1)*32)+8, facingX=0, facingY=1, move=false})
		collisionTable[x][y]=0
	elseif tile=='p' then 
		player.x = ((x-1)*32)+1
		player.y = ((y-1)*32)+1
		collisionTable[x][y]=0
	elseif tile ~=' ' then
		collisionTable[x][y]=1
	else -- add a 2 for doors or something
		collisionTable[x][y]=0
	end

end 






