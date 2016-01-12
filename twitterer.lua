-- source 
-- https://gist.github.com/y2bd/ed7f5774656ad06d0d5a#file-twitterer-lua

local tweet, map, appendparam, encode

local Twitterer = setmetatable({tweet=tweet}, {__call = function(t, params) return tweet(params) end})

tweet = function(params)
  text = params[1] or params.text or nil
  url = params[2] or params.url or nil
  via = params[3] or params.via or nil
  hashtags = params[4] or params.hashtags or nil
  related = params[5] or params.related or nil

  twiturl = "https://twitter.com/intent/tweet?"

  if text then
    twiturl = appendparam(twiturl, "text", encode(text))
  end

  if url then
    twiturl = appendparam(twiturl, "url", encode(url))
  end

  if via then
    via = string.gsub(via, "@", "") -- don't need at signs
    twiturl = appendparam(twiturl, "via", encode(via))
  end

  if hashtags then
    if type(hashtags) ~= "table" then hashtags = { hashtags } end

    hashtags = map(function(hashtag) return encode(string.gsub(hashtag, "#", "")) end, hashtags)
    twiturl = appendparam(twiturl, "hashtags", table.concat(hashtags, ","))
  end

  if related then
    if type(related[1]) ~= "table" then related = map(function(rel) return { rel } end, related) end

    local function encoderelated(rel)
      rel[1] = string.gsub(rel[1], "@", "")

      if #rel > 1 then
        return encode(rel[1] .. ":" .. rel[2])
      else
        return rel[1]
      end
    end

    related = map(encoderelated, related)
    twiturl = appendparam(twiturl, "related", table.concat(related, ","))
  end

  return twiturl
end

map = function(func, table)
  local mapped = {}

  for k,v in ipairs(table) do
    mapped[#mapped+1] = func(v)
  end

  return mapped
end

appendparam = function(to, pname, pvalue)
  return to .. pname .. "=" .. pvalue .. "&"
end

encode = function(str)
  if (str) then
    str = string.gsub (str, "\n", "\r\n")
    str = string.gsub (str, "([^%w %-%_%.%~])",
        function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
  end
  return str  
end

return Twitterer

-- how to use

local url = ""

-- just a basic tweet
url = Twitterer{text="Hello Twitter!"}

-- tweet a url, it'll be autoshortened if necessary
url = Twitterer{url="http://ludumdare.com"}

-- via adds a " via @account" to the end the tweet
-- related lets you suggest twitter accounts for the user to follow,
--  some optional description text
url = Twitterer{text="Using this awesome Twitter URL generator!!", 
                via="@y2bd",
                related={{"@y2bd", "Developer of the library."}}}

-- autoappend hashtags to the end of your tweet
url = Twitterer{text="Getting ready for Ludum Dare!", 
                hashtags={"#ld48", "#ld30"}}

-- putting it all together
url = Twitterer{text="Quickly, get ready for Ludum Dare! I'm using Love2D!",
                url="http://ludumdare.com",
                hashtags={"#ld48", "#gamejam"},
                related={{"@ludumdare", "Official Ludum Dare Twitter Account"},
                         {"@mikekasprzak"},
                         {"@@philhassey"}}}

-- open with love2d
-- success is a bool that'll tell you if the url was opened successfully
success = love.system.openURL(url)