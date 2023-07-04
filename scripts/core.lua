local otherJson
local _unitMapping
local _unitMappingOverride = {}

local _unitSpacing = 2
local _modelsPerRow = 3

------------------------------------------------------------
local Cached = {
   _cache = {}
}

function Cached.getJson(url)
   local existing = Cached._cache[url]
   if existing then
      return existing
   end

   local data = downloadJson(url)
   Cached._cache[url] = data

   return data
end

function Cached.clear(regex)
   if not regex then
      Cached._cache = {}
      return
   end

   local cache = Cached._cache
   for k, v in pairs(cache) do
      if k:match(regex) then
         cache[k] = nil
      end
   end
end
------------------------------------------------------------

------------------------------------------------------------
local Fibers = {
   _queue = {}
}

function Fibers.queue(f)
   local co = coroutine.create(f)

   coroutine.resume(co)
   table.insert(Fibers._queue, co)

   return co
end

function Fibers.process()
   local _dead = {}

   for i, fiber in ipairs(Fibers._queue) do
      local status = coroutine.status(fiber)
      local running, error = status ~= "dead" and coroutine.resume(fiber)

      if not running then
         if error then
            print(string.format("[ff0000]%s[-]", error))
         end

         table.insert(_dead, i)
      end
   end

   for i = #_dead, 0, -1 do
      Fibers._queue[i] = nil
   end
end
------------------------------------------------------------

function processUnit(entry)
   local pattern = "(.*) %[(%d+)] Q(%d)%+ D(%d)%+ | (%d+)pts | (.*)"
   local data = { string.match(entry, pattern) }

   local name = data[1]
   local duplicates
   local nameData = { string.match(name, "(%d+)x (.*)") }
   if nameData[1] then
      name = nameData[2]
      duplicates = tonumber(nameData[1])
   end

   return {
      name = name,
      count = data[2],
      quality = data[3],
      defense = data[4],
      points = data[5],
      keywords = data[6],
      duplicates = duplicates,
      attacks = "",
   }
end

local T = {}

function T.clone(tbl)
   local out = {}

   for key, value in pairs(tbl) do
      if type(value) == "table" then
         out[key] = T.clone(value)

      else
         out[key] = value
      end
   end

   return out
end

function T.merge(a, b)
   local out = T.clone(a)

   for k, v in pairs(b) do
      out[k] = v
   end

   return out
end

function copyPos(pos)
   return {
      x = pos.x,
      y = pos.y,
      z = pos.z,
   }
end

function matchUnit(mapping, unitData)
   local matches = mapping[unitData.name] or mapping._default

   return matches
end

function specialRulesToString(rules, first)
   local out = ""

   local sep = first and "" or ", "

   for _, data in ipairs(rules) do
      local rating = data.rating

      out = string.format("%s%s%s%s",
              out,
              sep,
              data.name,
              (rating and rating ~= "" and string.format("(%s)", rating)) or "")

      sep = ", "
   end

   return out
end

function processUnitLoadout(unit)
   local out = {
      attacks = "",
      rules = specialRulesToString(unit.specialRules, true),
   }

   local multiples = unit.combined and 2 or 1

   for _, entry in ipairs(unit.loadout) do
      if entry.type == "ArmyBookWeapon" then
         local count = entry.count * multiples
         local countLabel = count > 2 and string.format("%sx", count) or ""
         local rules = specialRulesToString(entry.specialRules, true)
         local range = entry.range and string.format("%s\" ", entry.range) or ""

         out.attacks = out.attacks .. string.format("%s %s (%sA%s %s)\n",
                 countLabel,
                 entry.label,
                 range,
                 entry.attacks,
                 rules)

      elseif entry.type == "ArmyBookItem" then
         out.rules = out.rules .. specialRulesToString(entry.content, out.rules == "")
      end
   end

   return out
end

function spawnUnit(data, color, spawnerObj, pos)
   local maxX = pos.x
   local cursor = copyPos(pos)
   local maxSize = Vector()
   local spawnerRotationY = spawnerObj.getRotation().y

   local modelCount = data.size * (data.combined and 2 or 1)

   for i = 1, modelCount do
      local modelVariants = matchUnit(_unitMapping, data)
      local model = T.clone(modelVariants[#modelVariants])

      -- TODO: Refactor so all variants can be context menu items
      local col = math.floor((i - 1) % _modelsPerRow)
      local row = math.floor((i - 1) / _modelsPerRow)

      local spawnPos = Vector(
         pos.x + col * maxSize.x,
         pos.y,
         pos.z + row * maxSize.z)

      maxX = math.max(spawnPos.x, maxX)

      local objName = string.format(
              "%s [b][00eeee]Q%s[-] [Ffc125]D%s[-][/b] \[%s\]",
              data.name,
              data.quality,
              data.defense,
              data.joinToUnit or data.selectionId)

      local unitLoadout = processUnitLoadout(data)
      local objDescription = string.format("%s\n\n%s",
              unitLoadout.rules,
              unitLoadout.attacks)

      forAllStates(model, function(state, depth)
              state.Description = state.Description and objDescription
              state.Nickname = state.Nickname and objName
      end)

      local obj = spawnObjectData({
         data = model,
         position = spawnerObj.positionToWorld(spawnPos),
      })

      obj.setRotation(Vector(0, spawnerRotationY, 0) + obj.getRotation())
      obj.addTag(color)
      obj.measure_movement = true
      obj.tooltip = true

      while obj.loading_custom do
         coroutine.yield(0)
      end

      local bounds = obj.getBounds()
      maxSize = Vector.max(maxSize, bounds.size * 1.5)
   end

   pos.x = maxX + maxSize.x * 0.5 + _unitSpacing
   return obj, pos
end

function spawnList(data, color, obj)
   local seen = {}
   local pos = Vector(0, 0, 3)

   for i, unit in ipairs(data.units) do
      local combinedId = unit.combined and (unit.joinToUnit or unit.selectionId)

      if not combinedId or not seen[combinedId] then
         print("SPAWNING ", unit.name)
         local obj, pos = spawnUnit(unit, color, obj, pos)

         if combinedId then
            seen[combinedId] = true
         end
      end
   end
end

function destroyTagged(tag)
   print("Attempting to destroy everything tagged ", tag)

   for _, obj in ipairs(getObjectsWithTag(tag)) do
      destroyObject(obj)
   end
end

function yieldForDownload(req)
   while not req.is_done do
      coroutine.yield()
   end

   return req
end

function yieldForDownloadJson(req)
   yieldForDownload(req)

   if req.is_error then
      print(string.format("[ff0000]%s[-]", req.error))

   elseif req.response_code ~= 200 then
      print(string.format("[ff0000]Bad response: %s[-]", req.response_code))

   else
      local data = otherJson.decode(req.text)
      return data
   end
end

function downloadJson(url)
   return yieldForDownloadJson(WebRequest.get(url))
end

function downloadList(url)
   local urlData = { url:match("(https://.*)/share(%?.*)") }

   if #urlData < 2 then
      print("[ff0000]Bad or missing sharing URL in user's private notebook tab[-]")
      return
   end

   local ttsUrl = string.format("%s/api/tts%s", urlData[1], urlData[2])

   return downloadJson(ttsUrl)
end

function handleButton(obj, color, altClick)
   local _, userBook = getNotebookTab(color, color)
   local listUrl = userBook.body

   Fibers.queue(function()
         local data = downloadList(listUrl)
         loadMappings()

         if not _unitMapping then
            print("[ff0000]Failed to load unit mapping data[-]")
            return
         end

         destroyTagged(color)

         spawnList(data, color, obj)
   end)
end

function getNotebookTab(title, color)
   for i, book in ipairs(Notes.getNotebookTabs()) do
      if (not title or book.title == title) and (not color or book.color == color) then
         return i - 1, book
      end
   end
end

function getOrCreateNotebookTab(title, color)
   local tab, book = getNotebookTab(title, color)

   if not tab then
      book = {
            title = title,
            color = color,
            body = "",
      }

      tab = Notes.addNotebookTab(book) - 1
   end

   return tab, book
end

function forAllStates(data, func)
   if not data then
      return
   end

   func(data)

   if not data.States then
      return
   end

   for _, state in pairs(data.States) do
      forAllStates(state, func)
   end
end

function generateMappings()
   local out = {}

   for _, obj in ipairs(getObjectsWithTag("OPR_MAP")) do
      local data = obj.getData()
      local name = obj.getName()

      local entry = out[name] or {}
      out[name] = entry

      forAllStates(data, function(stateData)
              -- Clear out some data
              stateData.Description = stateData.Description and ""
              stateData.LuaScript = nil
              stateData.LuaScriptState = nil
              stateData.XmlUI = nil
      end)

      table.insert(entry, data)
   end

   -- Write to notebook
   local tab = getOrCreateNotebookTab("OPR_MAP")

   Notes.editNotebookTab({
         index = tab,
         body = JSON.encode_pretty(out),
   })

   validateMappings(out)
end

function validateMappings(mappings)
   local _, userBook = getOrCreateNotebookTab("ARMY")
   local armyName = userBook.body

   if armyName == "" then
      print("[ffff00]No army name listed under 'ARMY' notebook tab for validation[-]")
      return
   end

   print("Validating mapping")

   print(string.format("Downloading army book for '%s'", armyName))
   local armyInfo = Cached.getJson(string.format("https://army-forge-studio.onepagerules.com/api/army-books?filters=official&gameSystemSlug=grimdark-future&searchText=%s", armyName))

   -- Warn on multiple matches
   if #armyInfo > 1 then
      print(string.format("[ffff00]WARN: Search for '%s' yielded %s results; using first match[-]",
              armyName,
              #armyInfo))
   end

   -- TODO: Multiple game systems
   local gameSystem = 2
   local armyList = Cached.getJson(string.format("https://army-forge.onepagerules.com/api/afs/book/%s?gameSystem=%s",
           armyInfo[1].uid,
           gameSystem))


   local report = ""
   for _, unit in pairs(armyList.units) do
      local name = unit.name

      if not mappings[name] then
         print(string.format("[00ffff]%s unmapped[-]", name))
         report = string.format("%s%s\n", report, name )
      end
   end

   local tab = getOrCreateNotebookTab("UNMAPPED")
   Notes.editNotebookTab({
         index = tab,
         body = report,
   })
end

function loadMappings()
   local out = {}
   local hasErrors

   print("Downloading unit mapping data")

   local urls = {
      "https://raw.githubusercontent.com/ryan-c-scott/opr-tts-ftw/master/build/master.json",
   }

   -- List of urls from tab
   local _, urlBook = getNotebookTab("MAP_URL")
   if urlBook then
      for url in urlBook.body:gmatch("(http[s]*://[^%s]+)") do
         if url ~= "" then
            table.insert(urls, url)
         end
      end
   end

   for _, url in ipairs(urls) do
      print("LOADING MAPPING: ", url)
      local override = Cached.getJson(url)
      if override then
         out = T.merge(out, override)

      else
         print(string.format("Failed to process JSON from %s", url))
         break
      end
   end

   -- OPR_MAP tab as override
   local _, mapBook = getNotebookTab("OPR_MAP")
   if mapBook then
      print("Loading notebook 'OPR_MAP'")
      local data = JSON.decode(mapBook.body)
      if data then
         out = T.merge(out, data)
      end
   end

   -- TODO: Should errors stop all mapping?

   _unitMapping = out
end

function contextCollectMappings()
   Fibers.queue(loadMappings)
end

function contextGenerateMappings(color, pos, obj)
   print("Generating override mappings")
   Fibers.queue(generateMappings)
end

function onLoad()
   print("And here we are, hacking /the/ Gibson!!!")

   self.createButton({
         click_function = "handleButton",
         function_owner = self,
         label          = "Generate",
         position       = {0, 1, 0},
         rotation       = {0, 180, 0},
         width          = 800,
         height         = 400,
         font_size      = 340,
         color          = {0.5, 0.5, 0.5},
         font_color     = {1, 1, 1},
         tooltip        = "Paste the share link from Army Forge into your private notebook tab",
   })

   -- Context menu items
   self.addContextMenuItem("Collect Mappings", contextCollectMappings)
   self.addContextMenuItem("Generate Mappings", contextGenerateMappings)
   self.addContextMenuItem("Clear Cache", Cached.clear)
end

function onUpdate()
   Fibers.process()
end

-----------------------------------------------------------------------------
------------------------------------------------------------
function requireJson()
   -----------------------------------
   --
   -- json.lua
   --
   -- Copyright (c) 2020 rxi
   --
   -- Permission is hereby granted, free of charge, to any person obtaining a copy of
   -- this software and associated documentation files (the "Software"), to deal in
   -- the Software without restriction, including without limitation the rights to
   -- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
   -- of the Software, and to permit persons to whom the Software is furnished to do
   -- so, subject to the following conditions:
   --
   -- The above copyright notice and this permission notice shall be included in all
   -- copies or substantial portions of the Software.
   --
   -- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   -- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   -- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   -- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   -- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   -- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
   -- SOFTWARE.
   --

   local json = { _version = "0.1.2" }

   -------------------------------------------------------------------------------
   -- Encode
   -------------------------------------------------------------------------------

   local encode

   local escape_char_map = {
      [ "\\" ] = "\\",
      [ "\"" ] = "\"",
      [ "\b" ] = "b",
      [ "\f" ] = "f",
      [ "\n" ] = "n",
      [ "\r" ] = "r",
      [ "\t" ] = "t",
   }

   local escape_char_map_inv = { [ "/" ] = "/" }
   for k, v in pairs(escape_char_map) do
      escape_char_map_inv[v] = k
   end


   local function escape_char(c)
      return "\\" .. (escape_char_map[c] or string.format("u%04x", c:byte()))
   end


   local function encode_nil(val)
      return "null"
   end


   local function encode_table(val, stack)
      local res = {}
      stack = stack or {}

      -- Circular reference?
      if stack[val] then error("circular reference") end

      stack[val] = true

      if rawget(val, 1) ~= nil or next(val) == nil then
         -- Treat as array -- check keys are valid and it is not sparse
         local n = 0
         for k in pairs(val) do
            if type(k) ~= "number" then
               error("invalid table: mixed or invalid key types")
            end
            n = n + 1
         end
         if n ~= #val then
            error("invalid table: sparse array")
         end
         -- Encode
         for i, v in ipairs(val) do
            table.insert(res, encode(v, stack))
         end
         stack[val] = nil
         return "[" .. table.concat(res, ",") .. "]"

      else
         -- Treat as an object
         for k, v in pairs(val) do
            if type(k) ~= "string" then
               error("invalid table: mixed or invalid key types")
            end
            table.insert(res, encode(k, stack) .. ":" .. encode(v, stack))
         end
         stack[val] = nil
         return "{" .. table.concat(res, ",") .. "}"
      end
   end


   local function encode_string(val)
      return '"' .. val:gsub('[%z\1-\31\\"]', escape_char) .. '"'
   end


   local function encode_number(val)
      -- Check for NaN, -inf and inf
      if val ~= val or val <= -math.huge or val >= math.huge then
         error("unexpected number value '" .. tostring(val) .. "'")
      end
      return string.format("%.14g", val)
   end


   local type_func_map = {
      [ "nil"     ] = encode_nil,
      [ "table"   ] = encode_table,
      [ "string"  ] = encode_string,
      [ "number"  ] = encode_number,
      [ "boolean" ] = tostring,
   }


   encode = function(val, stack)
      local t = type(val)
      local f = type_func_map[t]
      if f then
         return f(val, stack)
      end
      error("unexpected type '" .. t .. "'")
   end


   function json.encode(val)
      return ( encode(val) )
   end


   -------------------------------------------------------------------------------
   -- Decode
   -------------------------------------------------------------------------------

   local parse

   local function create_set(...)
      local res = {}
      for i = 1, select("#", ...) do
         res[ select(i, ...) ] = true
      end
      return res
   end

   local space_chars   = create_set(" ", "\t", "\r", "\n")
   local delim_chars   = create_set(" ", "\t", "\r", "\n", "]", "}", ",")
   local escape_chars  = create_set("\\", "/", '"', "b", "f", "n", "r", "t", "u")
   local literals      = create_set("true", "false", "null")

   local literal_map = {
      [ "true"  ] = true,
      [ "false" ] = false,
      [ "null"  ] = nil,
   }


   local function next_char(str, idx, set, negate)
      for i = idx, #str do
         if set[str:sub(i, i)] ~= negate then
            return i
         end
      end
      return #str + 1
   end


   local function decode_error(str, idx, msg)
      local line_count = 1
      local col_count = 1
      for i = 1, idx - 1 do
         col_count = col_count + 1
         if str:sub(i, i) == "\n" then
            line_count = line_count + 1
            col_count = 1
         end
      end
      error( string.format("%s at line %d col %d", msg, line_count, col_count) )
   end


   local function codepoint_to_utf8(n)
      -- http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=iws-appendixa
      local f = math.floor
      if n <= 0x7f then
         return string.char(n)
      elseif n <= 0x7ff then
         return string.char(f(n / 64) + 192, n % 64 + 128)
      elseif n <= 0xffff then
         return string.char(f(n / 4096) + 224, f(n % 4096 / 64) + 128, n % 64 + 128)
      elseif n <= 0x10ffff then
         return string.char(f(n / 262144) + 240, f(n % 262144 / 4096) + 128,
                 f(n % 4096 / 64) + 128, n % 64 + 128)
      end
      error( string.format("invalid unicode codepoint '%x'", n) )
   end


   local function parse_unicode_escape(s)
      local n1 = tonumber( s:sub(1, 4),  16 )
      local n2 = tonumber( s:sub(7, 10), 16 )
      -- Surrogate pair?
      if n2 then
         return codepoint_to_utf8((n1 - 0xd800) * 0x400 + (n2 - 0xdc00) + 0x10000)
      else
         return codepoint_to_utf8(n1)
      end
   end


   local function parse_string(str, i)
      local res = ""
      local j = i + 1
      local k = j

      while j <= #str do
         local x = str:byte(j)

         if x < 32 then
            decode_error(str, j, "control character in string")

         elseif x == 92 then -- `\`: Escape
            res = res .. str:sub(k, j - 1)
            j = j + 1
            local c = str:sub(j, j)
            if c == "u" then
               local hex = str:match("^[dD][89aAbB]%x%x\\u%x%x%x%x", j + 1)
                  or str:match("^%x%x%x%x", j + 1)
                  or decode_error(str, j - 1, "invalid unicode escape in string")
               res = res .. parse_unicode_escape(hex)
               j = j + #hex
            else
               if not escape_chars[c] then
                  decode_error(str, j - 1, "invalid escape char '" .. c .. "' in string")
               end
               res = res .. escape_char_map_inv[c]
            end
            k = j + 1

         elseif x == 34 then -- `"`: End of string
            res = res .. str:sub(k, j - 1)
            return res, j + 1
         end

         j = j + 1
      end

      decode_error(str, i, "expected closing quote for string")
   end


   local function parse_number(str, i)
      local x = next_char(str, i, delim_chars)
      local s = str:sub(i, x - 1)
      local n = tonumber(s)
      if not n then
         decode_error(str, i, "invalid number '" .. s .. "'")
      end
      return n, x
   end


   local function parse_literal(str, i)
      local x = next_char(str, i, delim_chars)
      local word = str:sub(i, x - 1)
      if not literals[word] then
         decode_error(str, i, "invalid literal '" .. word .. "'")
      end
      return literal_map[word], x
   end


   local function parse_array(str, i)
      local res = {}
      local n = 1
      i = i + 1
      while 1 do
         local x
         i = next_char(str, i, space_chars, true)
         -- Empty / end of array?
         if str:sub(i, i) == "]" then
            i = i + 1
            break
         end
         -- Read token
         x, i = parse(str, i)
         res[n] = x
         n = n + 1
         -- Next token
         i = next_char(str, i, space_chars, true)
         local chr = str:sub(i, i)
         i = i + 1
         if chr == "]" then break end
         if chr ~= "," then decode_error(str, i, "expected ']' or ','") end
      end
      return res, i
   end


   local function parse_object(str, i)
      local res = {}
      i = i + 1
      while 1 do
         local key, val
         i = next_char(str, i, space_chars, true)
         -- Empty / end of object?
         if str:sub(i, i) == "}" then
            i = i + 1
            break
         end
         -- Read key
         if str:sub(i, i) ~= '"' then
            decode_error(str, i, "expected string for key")
         end
         key, i = parse(str, i)
         -- Read ':' delimiter
         i = next_char(str, i, space_chars, true)
         if str:sub(i, i) ~= ":" then
            decode_error(str, i, "expected ':' after key")
         end
         i = next_char(str, i + 1, space_chars, true)
         -- Read value
         val, i = parse(str, i)
         -- Set
         res[key] = val
         -- Next token
         i = next_char(str, i, space_chars, true)
         local chr = str:sub(i, i)
         i = i + 1
         if chr == "}" then break end
         if chr ~= "," then decode_error(str, i, "expected '}' or ','") end
      end
      return res, i
   end


   local char_func_map = {
      [ '"' ] = parse_string,
      [ "0" ] = parse_number,
      [ "1" ] = parse_number,
      [ "2" ] = parse_number,
      [ "3" ] = parse_number,
      [ "4" ] = parse_number,
      [ "5" ] = parse_number,
      [ "6" ] = parse_number,
      [ "7" ] = parse_number,
      [ "8" ] = parse_number,
      [ "9" ] = parse_number,
      [ "-" ] = parse_number,
      [ "t" ] = parse_literal,
      [ "f" ] = parse_literal,
      [ "n" ] = parse_literal,
      [ "[" ] = parse_array,
      [ "{" ] = parse_object,
   }


   parse = function(str, idx)
      local chr = str:sub(idx, idx)
      local f = char_func_map[chr]
      if f then
         return f(str, idx)
      end
      decode_error(str, idx, "unexpected character '" .. chr .. "'")
   end


   function json.decode(str)
      if type(str) ~= "string" then
         error("expected argument of type string, got " .. type(str))
      end
      local res, idx = parse(str, next_char(str, 1, space_chars, true))
      idx = next_char(str, idx, space_chars, true)
      if idx <= #str then
         decode_error(str, idx, "trailing garbage")
      end
      return res
   end


   return json
end

otherJson = requireJson()
