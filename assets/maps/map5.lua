local tileString = [[
#########################
#    r  #               #
#p    r #               #
#    r  #               #
#         #             #
###################^A   #
#                  @|   #
#                  A^   #
#    ###D#D#D#D#D#D|@   #
#      L d d d d d      #
#      L u u u u u      #
################## ######
################## ######
#rrrrrrrrrrr       #    #
#rrrrrrrrrrr       #    #
#AAAAAA^AAA^AAA^####^^###
#||||||@|||@|||@    @@  #
#                       #
#########################
]]

local quadInfo = { 
  { ' ',  0,  0 }, -- gray floor
  { '#',  0, 32 }, -- brick wall
  { '^', 32,  0 }, -- mainframe 1 top
  { '@', 32, 32 }, -- mainframe 1 bottom
  { 'A', 64,  0 }, -- mainframe 2 top
  { '|', 64, 32 }, -- maingrame 2 bottom
  { 'l',  0,  0 }, -- moving left facing enemy
  { 'r',  0,  0 }, -- moving right facing enemy 
  { 'u',  0,  0 }, -- moving up facing enemy 
  { 'd',  0,  0 }, -- moving down facing enemy 
  { 'L',  0,  0 }, -- static left facing enemy
  { 'R',  0,  0 }, -- static right facing enemy 
  { 'U',  0,  0 }, -- static up facing enemy 
  { 'D',  0,  0 }, -- static down facing enemy 
  { 'p',  0,  0 }  -- player
  --{ '&', 96,  0 }, -- plant top
  --{ 'l', 96, 32 }  -- plant bottom
}

newMap(32,32,'assets/images/lab.png', tileString, quadInfo)