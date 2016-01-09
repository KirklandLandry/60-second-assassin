local tileString = [[
@^^^^^^^^^^^^^^^^^^^^^^^#
<                       >
<                       >
< quit                  >
< instructions          >
< jklmnopqrstuv         >
< wxyz                  >
< im sorry dave im      >
< afraid i cant do that >
< null pointer expected >
< white rose is real    >
<                       >
<                       >
<                       >
<                       >
<                       >
<                       >
<                       >
$***********************&
]]

local quadInfo = { 
  { '~1', 64,  96, 1 }, 
  { '@', 32,  0, 1 }, 
  { '^', 64,  0, 1 }, 
  { '#', 96,  0, 1 }, 
  { '<', 32, 32, 1 }, 
  { ' ', 64, 32, 1 }, 
  { '>', 96, 32, 1 }, 
  { '$', 32, 64, 1 }, 
  { '*', 64, 64, 1 }, 
  { '&', 96, 64, 1 },
  { 'a', 0  ,  0, 2 },
  { 'b', 32 ,  0, 2 },
  { 'c', 64 ,  0, 2 },
  { 'd', 96 ,  0, 2 },
  { 'e', 128,  0, 2 },
  { 'f', 160,  0, 2 },
  { 'g', 192,  0, 2 },
  { 'h', 224,  0, 2 },
  { 'i', 256,  0, 2 },
  { 'j', 288,  0, 2 },
  { 'k', 320,  0, 2 },
  { 'l', 352,  0, 2 },
  { 'm', 384,  0, 2 },
  { 'n', 416,  0, 2 },
  { 'o', 448,  0, 2 },
  { 'p', 480,  0, 2 },
  { 'q', 512,  0, 2 },
  { 'r', 544,  0, 2 },
  { 's', 576,  0, 2 },
  { 't', 608,  0, 2 },
  { 'u', 640,  0, 2 },
  { 'v', 672,  0, 2 },
  { 'w', 704,  0, 2 },
  { 'x', 736,  0, 2 },
  { 'y', 768,  0, 2 },
  { 'z', 800,  0, 2 },
}

local imagePaths = {
  'assets/images/menu/32x32PixelTiles.png',
  'assets/images/menu/32x32PixelFont.png'
}

local states = {
  {3*32, 'quit' },
  {4*32, 'quit2'},
  {5*32, 'blah' },
  {6*32, 'wqyz' },
  {7*32, 'srry' },
  {8*32, 'dav'  },
  {9*32, 'nool' },
  {10*32, 'rwby' }
}

newMenu(32,32,imagePaths, tileString, quadInfo, states)