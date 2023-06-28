local _unitMapping = {}
local _unitMappingOverride = {}

_unitMapping = {}

local _unitSpacing = 2
local _modelsPerRow = 3

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
      local running, error = coroutine.resume(fiber)
      if not running then
         print(error)
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
   local overrides = _unitMappingOverride[unitData.name]

   if overrides then
      matches = T.merge(matches, overrides)
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

function spawnUnit(data, pos)
   local maxX = pos.x
   local cursor = copyPos(pos)
   local maxSize = Vector()

   local modelCount = data.size * (data.combined and 2 or 1)

   for i = 1, modelCount do
      local modelVariants = matchUnit(_unitMapping, data)
      local model = modelVariants[1]
      local scale = model.scale or 0.5

      -- TODO: Refactor so all variants can be context menu items
      local col = math.floor((i - 1) % _modelsPerRow)
      local row = math.floor((i - 1) / _modelsPerRow)

      local spawnPos = Vector(
         pos.x + col * maxSize.x,
         pos.y,
         pos.z + row * maxSize.z)

      maxX = math.max(spawnPos.x, maxX)

      local modelType
      local objData = {
         position = spawnPos,
         scale = Vector(scale, scale, scale),
      }

      if model.assetbundle then
         objData = T.merge(objData, {
                 type = "Custom_Assetbundle",
         })

         model = T.merge(model, {
                 type = 1,
                 material = 3,
         })

      elseif model.mesh then
         objData = T.merge(objData, {
                 type = "Custom_Model",
         })

         model = T.merge(model, {
                 type = 1,
                 material = 3,
         })

      elseif model.face then
         objData = T.merge(objData, {
                 type = "CardCustom",
                 rotation = Vector(0, 180, 0),
         })

         model = T.merge(model, {
                 type = 4,
                 back = "https://uploads-ssl.webflow.com/63615fdab9c39472c7fcfe4f/6361616586af540d18a28344_onepagerules_round_2.png",
         })
      end

      local obj = spawnObject(objData)
      obj.setCustomObject(model)

      obj.setName(string.format(
              "%s [b][00eeee]Q%s[-] [Ffc125]D%s[-][/b] \[%s\]",
              data.name,
              data.quality,
              data.defense,
              data.id))

      local grey = 16 / 255
      obj.setColorTint(Color(grey, grey, grey))

      obj.addTag("TESTING")
      obj.measure_movement = true
      obj.tooltip = true

      local unitLoadout = processUnitLoadout(data)
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
         local obj, pos = spawnUnit(unit, pos)
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

function yieldForDownload(req)
   while not req.is_done do
      coroutine.yield()
   end

   return req
end

function yieldForDownloadJson(req)
   yieldForDownload(req)

   if req.is_error then
      log(request.error)

   else
      local data = JSON.decode(req.text)
      return data
   end
end

function downloadJson(url)
   return yieldForDownloadJson(WebRequest.get(url))
end

function downloadList(url)
   local urlData = { url:match("(https://.*)/share(%?.*)") }

   if #urlData < 2 then
      print("[ff0000]Bad or missing sharing URL in description[-]")
      return
   end

   local ttsUrl = string.format("%s/api/tts%s", urlData[1], urlData[2])

   return downloadJson(ttsUrl)
end

function handleButton(obj, color, altClick)
   local listUrl = obj.getDescription()

   Fibers.queue(function()
         local data = downloadList(listUrl)
         overrideMappings("OPR_OVERRIDE")
         destroyTagged("TESTING")

         local pos = obj.getPosition()
         pos.z = pos.z + 3

         spawnList(data, pos)
   end)
end

function overrideMappings()
   local out = {}

   local hasErrors

   for _, obj in ipairs(getObjectsWithTag("OPR_OVERRIDE")) do
      local raw = obj.getDescription()

      for url in raw:gmatch("(http[s]*://[^%s]+)") do

         if url ~= "" then
            print("LOADING OVERRIDE: ", url)
            local override = downloadJson(url)
            if override then
               out = T.merge(out, override)
            else
               print(string.format("Failed to process JSON from %s", obj.getName()))
               break
            end
         end
      end
   end

   if not hasErrors then
      _unitMappingOverride = out
   end
end

function contextCollectMappings()
   print("Collecting mapping overrides")
   Fibers.queue(function()
         overrideMappings()
   end)
end

function contextGenerateMappings(color, pos, obj)
   print("Generating override mappings")
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

   -- Context menu items
   self.addContextMenuItem("Collect Mappings", contextCollectMappings)
   self.addContextMenuItem("Generate Mappings", contextGenerateMappings)
end

function onUpdate()
   Fibers.process()
end
