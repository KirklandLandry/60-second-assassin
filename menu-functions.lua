local TileW
local TileH
local Tilesets = {}
local TileTable
--collisionTable=nil
local Quads
local menuStates = {}
local currentState = 1

function drawMenu()
  for x,column in ipairs(TileTable) do
    for y,char in ipairs(column) do
      love.graphics.draw(Tilesets[Quads[char].tileSet].img, Quads[char].quad , (x-1)*TileW, (y-1)*TileH)
    end
  end
  
  if #menuStates >0 then 
  	love.graphics.draw(Tilesets[1].img, Quads['~1'].quad , 32, menuStates[currentState][1])
  else 
  	--love.graphics.draw(Tilesets[1].img, Quads['~1'].quad , 32, menuStates[currentState][1])
  end 
end

function loadMenu(path)
	-- this is basically loading the file in that path and then 
	-- returns a "chunk". when executed, it runs the code in the file
	-- so it's 
	-- f = load(path)
	-- f()
	currentState=1
	menuStates={}
	love.filesystem.load(path)()
end

-- this is bad. should operate 
function updateMenu(key)
	if #menuStates>=1 then 
		if key=='ok' then 
			if menuStates[currentState][2]=='quit' then 
				love.event.push('quit')
			end 
			if menuStates[currentState][2]=='start' then 
				return 'start'
			end 
			if menuStates[currentState][2]=='resume' then 
				return 'resume'
			end 
			if menuStates[currentState][2]=='instructions' then 
				return 'instructions'
			end 
			if menuStates[currentState][2]=='title' then 
				return 'title'
			end 
		end 
		if key=='down' then 
			currentState = currentState + 1
			if currentState > #menuStates then 
				currentState = 1 
			end 
		end 
		if key=='up' then 
			currentState = currentState - 1 
			if currentState < 1 then 
				currentState = #menuStates 
			end 
		end 
		if key=='restart' then 
			if menuStates[currentState][2]=='restart' then 
			end 
		end 
	end 
end 


function newMenu(tileW, tileH, imagePaths, tileString, quadInfo, states)
  	
	--menuStates = states 
	for i=1,#states do
		menuStates[i] = {states[i][1],states[i][2]}
	end


	TileW = tileW
	TileH = tileH
	
	for i=1, #imagePaths do
		--print(i)
		setImg=love.graphics.newImage(imagePaths[i])
		Tilesets[i] = {tilesetW=setImg:getWidth(), tilesetH=setImg:getHeight(), img=setImg}--love.graphics.newImage(tilesetPath)
		Tilesets[i].img:setFilter('nearest','nearest')
	end
	--collisionTable = {}

	--local tilesetW, tilesetH = Tilesets[1]:getWidth(), Tilesets[1]:getHeight()

	Quads = {}

	for _,info in ipairs(quadInfo) do
		-- info[1] = the character, info[2] = x, info[3] = y
		Quads[info[1]] = { tileSet=info[4], quad = love.graphics.newQuad(info[2], info[3], TileW,  TileH, Tilesets[info[4]].tilesetW, Tilesets[info[4]].tilesetH)}
	end

	TileTable = {}

	local width = #(tileString:match("[^\n]+"))

	for x = 1,width,1 do 
		TileTable[x] = {} 
		--collisionTable[x]={}
	end

	local x,y = 1,1
	for row in tileString:gmatch("[^\n]+") do
		assert(#row == width, 'Map is not aligned: width of row ' .. tostring(y) .. ' should be ' .. tostring(width) .. ', but it is ' .. tostring(#row))
		x = 1
		for tile in row:gmatch(".") do
			TileTable[x][y] = tile
			--[[if tile ~=' ' then
				collisionTable[x][y]=1
			else -- add a 2 for doors or something
				collisionTable[x][y]=0
			end]]
			x = x + 1
		end
		y=y+1
	end

	--[[for i=1, y-1 do 
		string=''
		for j=1,x-1 do 
			--print(#collisionTable,#collisionTable[1])
			--print(j,i)
			string = string..tostring(collisionTable[j][i]) 
		end 
		print(string)
	end ]]
  
end






