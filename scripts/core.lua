local _unitMapping = {}

_unitMapping["Alien Hives"] = {
   ["Hive Lord"] = {
      mesh = "http://cloud-3.steamusercontent.com/ugc/786374678936128171/F0C0FC65F81A2AFDEC91CA2F92421FC1E8A3CA70/",
      diffuse = "http://cloud-3.steamusercontent.com/ugc/786374678936167479/A2B103E6B11ECA6E4E1439E185BE72197EF2596A/",
      collider = "http://cloud-3.steamusercontent.com/ugc/786374678936102283/3E6999C8480E54A2E682797D4A7303765EFE03B3/",
   },

   ["Prime Warrior"] = {
      mesh = "http://cloud-3.steamusercontent.com/ugc/786374678936130483/5D77BF55DFE7DEDEC8C01369D1D6536805431F34/",
      diffuse = "http://cloud-3.steamusercontent.com/ugc/786374678936154303/106ACFA61BBF93A16FFE5ECAEEB618A9AEFB4D60/",
      collider = "http://cloud-3.steamusercontent.com/ugc/786374678936109828/2C84DE4EB0D1401E132818075B29FD130E2A1F4F/",
   },

   ["Hive Swarm"] = {
      mesh = "http://cloud-3.steamusercontent.com/ugc/786374678936178055/5D9FA2057E4AAA73EE580279BB4309E72B9055A4/",
      diffuse = "http://cloud-3.steamusercontent.com/ugc/786374678936178227/B9337A11A1C82458BF1CF6539F20833480ABF87F/",
      collider = "http://cloud-3.steamusercontent.com/ugc/786374678936109828/2C84DE4EB0D1401E132818075B29FD130E2A1F4F/",
   },

   ["Winged Grunts"] = {
      mesh = "http://cloud-3.steamusercontent.com/ugc/786374678936133373/DCA1475D91F3F0D74ACD66F9B4C7F3F0256AEF9D/",
      diffuse = "http://cloud-3.steamusercontent.com/ugc/786374678936164777/AB76388A4C08353DB7D7F842F956E445B45AC725/",
      collider = "http://cloud-3.steamusercontent.com/ugc/786374678936133623/E1B8842A5BB217612EE3E386C71A65032236C2D0/",
   },
   
   ["Hive Warriors"] = {
      mesh = "http://cloud-3.steamusercontent.com/ugc/786374678936118486/6FF029D2AD24A2361C49B09CE5EEAC7B4AB7DD68/",
      diffuse = "http://cloud-3.steamusercontent.com/ugc/786374678936172187/3ADA7DFBD90E06CB211FEB828CAFAE234435A391/",
      collider = "http://cloud-3.steamusercontent.com/ugc/786374678936109828/2C84DE4EB0D1401E132818075B29FD130E2A1F4F/",
   },

   ["Carnivo-Rex"] = {
      mesh = "http://cloud-3.steamusercontent.com/ugc/786374678936102283/3E6999C8480E54A2E682797D4A7303765EFE03B3/",
      diffuse = "http://cloud-3.steamusercontent.com/ugc/786374678936102283/3E6999C8480E54A2E682797D4A7303765EFE03B3/",
      collider = "http://cloud-3.steamusercontent.com/ugc/786374678936102283/3E6999C8480E54A2E682797D4A7303765EFE03B3/",
   },

   ["Assault Grunts"] = {
      mesh = "http://cloud-3.steamusercontent.com/ugc/786374678936144008/430E198932D29C4F903B81B9C9DB752FF10E83EC/",
      diffuse = "http://cloud-3.steamusercontent.com/ugc/786374678936168997/2867D4E21E85873BCB6B097B2CB7A5DF23669213/",
      collider = "http://cloud-3.steamusercontent.com/ugc/786374678936133623/E1B8842A5BB217612EE3E386C71A65032236C2D0/",
   },

   ["Spores"] = {
      mesh = "http://cloud-3.steamusercontent.com/ugc/786374678936135718/4424E3EAB0BEECA054DD3CF0686688912F4EDE11/",
      diffuse = "http://cloud-3.steamusercontent.com/ugc/786374678936157066/40AA0E956876077F440D5004C28DB0847E7B8E74/",
      collider = "http://cloud-3.steamusercontent.com/ugc/786374678936133623/E1B8842A5BB217612EE3E386C71A65032236C2D0/",
   },

   ["Invasion Artillery Spore"] = {
      mesh = "http://cloud-3.steamusercontent.com/ugc/786374678936128756/9D94FC33977DDA058776D1B62038197DCFF03828/",
      diffuse = "http://cloud-3.steamusercontent.com/ugc/786374678936167096/BF68FB70471EA8085C9B7E357A24B0E2893E48C2/",
      collider = "http://cloud-3.steamusercontent.com/ugc/786374678936102283/3E6999C8480E54A2E682797D4A7303765EFE03B3/",
   },

   ["Invasion Carrier Spore"] = {
      mesh = "http://cloud-3.steamusercontent.com/ugc/786374678936141793/B831F82C5D20F70C475C1B6660595433D62CF46F/",
      diffuse = "http://cloud-3.steamusercontent.com/ugc/786374678936171405/FC3D654B4FA52CCCED29F1081E33EDF86A421318/",
      collider = "http://cloud-3.steamusercontent.com/ugc/786374678936139764/3A10398982B240DBE6215E83F172C863EDC1938C/",
   },

   ["Venom Floaters"] = {
      mesh = "http://cloud-3.steamusercontent.com/ugc/786374678936135162/38B5548773B28B2034956ED29396A885104A369B/",
      diffuse = "http://cloud-3.steamusercontent.com/ugc/786374678936166902/A896D2CC400DEDF14A5A858FDAC806F9194D8233/",
      collider = "http://cloud-3.steamusercontent.com/ugc/786374678936109828/2C84DE4EB0D1401E132818075B29FD130E2A1F4F/",
   },

   _default = {
      assetbundle = "http://cloud-3.steamusercontent.com/ugc/946222093771739578/CBC341707C193AA6E6F1EAACB700A615889EC227/"
   },
}

local _unitSpacing = 2
local _modelsPerRow = 3

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

function matchUnit(mapping, books, unitData)
   local matches = {}

   for _, book in ipairs(books) do
      local map = mapping[book]

      if map then
         local model = map[unitData.name] or map._default
         table.insert(matches, model)
      end
   end

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
              rating ~= "" and string.format("(%s)", rating) or "")

      sep = ", "
   end

   return out
end

-- TODO: Clean up this function design. It doesn't need to take in the output table.
function processUnitLoadout(unit, out)
   out.attacks = out.attacks or ""
   out.rules = (out.rules or "") .. specialRulesToString(unit.specialRules, true)

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
end

function spawnUnit(books, data, pos)
   local maxX = pos.x
   local cursor = copyPos(pos)
   local maxSize = Vector()

   local modelCount = data.size * (data.combined and 2 or 1)

   for i = 1, modelCount do
      local scale = 0.5
      local modelVariants = matchUnit(_unitMapping, books, data)
      local model = modelVariants[1]

      -- TODO: Refactor so all variants can be context menu items

      local modelType
      if model.assetbundle then
         modelType = "Custom_Assetbundle"

      elseif model.mesh then
         modelType = "Custom_Model"
      end

      local col = math.floor((i - 1) % _modelsPerRow)
      local row = math.floor((i - 1) / _modelsPerRow)

      local spawnPos = Vector(
         pos.x + col * maxSize.x,
         pos.y,
         pos.z + row * maxSize.z)

      maxX = math.max(spawnPos.x, maxX)

      local obj = spawnObject({
            type = modelType,
            position = spawnPos,
            scale = Vector(scale, scale, scale),
      })

      obj.setCustomObject(T.merge(model, {
              type = 1,
              material = 3,
      }))

      obj.setName(string.format(
              "%s -- %s [b][00eeee]Q%s[-] [Ffc125]D%s[-][/b]",
              data.id,
              data.name,
              data.quality,
              data.defense))

      local grey = 16 / 255
      obj.setColorTint(Color(grey, grey, grey))

      obj.addTag("TESTING")
      obj.measure_movement = true
      obj.tooltip = true

      local unitLoadout = {}
      processUnitLoadout(data, unitLoadout)
      obj.setDescription(string.format("%s\n\n%s",
              unitLoadout.rules,
              unitLoadout.attacks))

      while obj.loading_custom do
         coroutine.yield(0)
      end

      local bounds = obj.getBounds()
      maxSize = Vector.max(maxSize, bounds.size * 1.5)
   end

   pos.x = maxX + maxSize.x * 0.5 + _unitSpacing
   return obj, pos
end

function spawnList(data, pos)
   local seen = {}

   for _, unit in ipairs(data.units) do
      if not seen[unit.id] then
         -- TODO: Handle multiple books
         local obj, pos = spawnUnit({data.name}, unit, pos)
         seen[unit.id] = true
      end
   end
end

function destroyTagged(tag)
   print("Attempting to destroy everything tagged ", tag)

   for _, obj in ipairs(getObjectsWithTag(tag)) do
      destroyObject(obj)
   end
end

function spawnProcess()
   local args = _spawnArgs
   spawnList(args.data, args.pos)

   return 1
end

_spawnArgs = nil

function downloadList(url, callback)
   local urlData = { url:match("(https://.*)/share(%?.*)") }
   local ttsUrl = string.format("%s/api/tts%s", urlData[1], urlData[2])
   WebRequest.get(ttsUrl, function(req)
           if req.is_error then
              log(request.error)

           else
              local data = JSON.decode(req.text)
              callback(data)
           end
   end)
end

function handleButton(obj, color, altClick)
   destroyTagged("TESTING")

   local pos = obj.getPosition()
   pos.z = pos.z + 3

   local listUrl = obj.getDescription()

   downloadList(listUrl, function(data)
           _spawnArgs = {
              data = data,
              pos = pos,
           }

           startLuaCoroutine(obj, "spawnProcess")
   end)
end

function onLoad()
   print("And here we are, hacking /the/ Gibson!!!")

   self.createButton({
         click_function = "handleButton",
         function_owner = self,
         label          = "Click to generate from description",
         position       = {0, 1, 0},
         rotation       = {0, 180, 0},
         width          = 800,
         height         = 400,
         font_size      = 340,
         color          = {0.5, 0.5, 0.5},
         font_color     = {1, 1, 1},
         tooltip        = "Paste your list in this object's description",
   })
end
