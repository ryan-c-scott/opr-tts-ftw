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

local _testData = [[++ Alien Hives [GF 1985pts] ++

Hive Lord [1] Q3+ D2+ | 390pts | Fear, Fearless, Hero, Tough(12), 1x Brood Leader(Pheromones)
4x Razor Claws (A3, AP(1)), Stomp (A4, AP(1))

Prime Warrior [1] Q4+ D4+ | 165pts | Fearless, Hero, Tough(6), 1x Hive Protector(Psy-Barrier)
2x Razor Claws (A4, AP(1))

Winged Grunts [10] Q5+ D5+ | 160pts | Ambush, Flying
10x Bio-Borers (12", A2), 10x Razor Claws (A1)

Hive Warriors [6] Q4+ D4+ | 290pts | Fearless, Tough(3)
12x Razor Claws (A3)

Hive Swarm [3] Q6+ D6+ | 70pts | Fearless, Strider, Tough(3)
3x Swarm Attacks (A3, Poison)

Venom Floaters [3] Q4+ D4+ | 225pts | Shrouding Mist, Stealth, Tough(3)
3x Whip Limbs (A3, Poison)

Invasion Carrier Spore [1] Q4+ D2+ | 190pts | Ambush, Fear, Fearless, Tough(6), Transport(11)
Razor Tendrils (A6, AP(1))

2x Invasion Artillery Spore [1] Q4+ D2+ | 225pts | Ambush, Fear, Fearless, Slow, Tough(6)
Razor Tendrils (A6, AP(1)), Spore Gun (24", A1, Blast(9), Indirect, Spores)

Spores [3] Q6+ D6+ | 45pts | Explode(1)]]

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
   }
end

function processAttacks(data)
   return data
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

function processList(player, list)
   local data = {
      units = {},
   }

   local currentEntry
   local unit = 1

   for str in string.gmatch(list, "([^\n]*)\n") do
      if str == "" then
         if currentEntry and currentEntry.duplicates then
            -- Create the appropriate number of duplicates for this unit
            for i = 2, currentEntry.duplicates do
               local clone = T.clone(currentEntry)
               clone.unit = string.format("%s_%s", clone.unit, i)
               table.insert(data.units, clone)
            end
         end

         currentEntry = nil

      elseif string.sub(str, 1, 2) == "++" then
         print(string.format("PROCESSING: Player %s - %s", player, str))
         local heading = { string.match(str, "%+%+ (.*) %[(.*) (%d+)pts%] %+%+") }

         data.books = {}
         for armyBook in string.gmatch(heading[1], "([^,]*)") do
            if armyBook ~= "" then
               table.insert(data.books, armyBook)
            end
         end

      else
         if currentEntry then
            -- Add to current entry
            currentEntry.attacks = processAttacks(str)

         else
            currentEntry = processUnit(str)
            table.insert(data.units, currentEntry)

            currentEntry.unit = string.format("%s%s", player, unit)
            unit = unit + 1
         end
      end
   end

   return data
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

function spawnUnit(books, data, pos)
   local maxX = pos.x
   local cursor = copyPos(pos)
   local maxSize = Vector()

   for i = 1, data.count do
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
              data.unit,
              data.name,
              data.quality,
              data.defense))

      local grey = 16 / 255
      obj.setColorTint(Color(grey, grey, grey))

      obj.addTag("TESTING")
      obj.measure_movement = true
      obj.tooltip = true

      obj.setDescription(string.format("%s\n\n%s",
              data.keywords,
              data.attacks))

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
   for _, unit in ipairs(data.units) do
      local obj, pos = spawnUnit(data.books, unit, pos)
   end
end

function destroyTagged(tag)
   print("Attempting to destroy everything tagged ", tag)

   for _, obj in ipairs(getObjectsWithTag(tag)) do
      destroyObject(obj)
   end
end

function _spawnTest()
   spawnList(processList("A", _testData), {
           x = -20,
           y = 0,
           z = 0,
   })

   return 1
end

function onLoad()
   print("And here we are, hacking /the/ Gibson!!!")

   destroyTagged("TESTING")
   startLuaCoroutine(Global, "_spawnTest")
end
