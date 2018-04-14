script_name('Frixen multicheat')
script_author('Frixen')
script_version("1.9")

local imgui = require 'imgui'
local key = require 'vkeys'
local mem = require "memory"
local ffi = require "ffi"

require 'lib.sampfuncs'
require 'lib.moonloader'

local sampev = require 'lib.samp.events' -- в начало скрипта
local dlstatus = require('moonloader').download_status



ffi.cdef[[
	short GetKeyState(int nVirtKey);
	bool GetKeyboardLayoutNameA(char* pwszKLID);
	int GetLocaleInfoA(int Locale, int LCType, char* lpLCData, int cchData);
]]
local BuffSize = 32
local KeyboardLayoutName = ffi.new("char[?]", BuffSize)
local LocalInfo = ffi.new("char[?]", BuffSize)
local color = 0x348cb2
nameTag = false
chathelper = true
adblock = true
FontName = "Tahoma"
FontSize = 11
FontFlag = 13

--[[
FontName - Имя шрифта
FontSize - Размер шрифта
FontFlag - Флаг шрифта
Флаги текста (объединяются путем сложения)
0	Текст без особенностей
1	Жирный текст
2	Наклонный текст
3   Наклонный и жирный текст
4	Обводка текста
8	Тень текста
16	Подчеркнутый текст
32	Зачеркнутый текст
]]


function apply_custom_style()
  imgui.SwitchContext()
  local style = imgui.GetStyle()
  local colors = style.Colors
  local clr = imgui.Col
  local ImVec4 = imgui.ImVec4

  style.WindowRounding = 2.0
  style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
  style.ChildWindowRounding = 2.0
  style.FrameRounding = 2.0
  style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
  style.ScrollbarSize = 13.0
  style.ScrollbarRounding = 0
  style.GrabMinSize = 8.0
  style.GrabRounding = 1.0
  -- style.Alpha =
  -- style.WindowPadding =
  -- style.WindowMinSize =
  -- style.FramePadding =
  -- style.ItemInnerSpacing =
  -- style.TouchExtraPadding =
  -- style.IndentSpacing =
  -- style.ColumnsMinSpacing = ?
  -- style.ButtonTextAlign =
  -- style.DisplayWindowPadding =
  -- style.DisplaySafeAreaPadding =
  -- style.AntiAliasedLines =
  -- style.AntiAliasedShapes =
  -- style.CurveTessellationTol =

  colors[clr.Text] = ImVec4(1.00, 1.00, 1.00, 1.00)
  colors[clr.TextDisabled] = ImVec4(0.50, 0.50, 0.50, 1.00)
  colors[clr.WindowBg] = ImVec4(0.06, 0.06, 0.06, 0.94)
  colors[clr.ChildWindowBg] = ImVec4(1.00, 1.00, 1.00, 0.00)
  colors[clr.PopupBg] = ImVec4(0.08, 0.08, 0.08, 0.94)
  colors[clr.ComboBg] = colors[clr.PopupBg]
  colors[clr.Border] = ImVec4(0.43, 0.43, 0.50, 0.50)
  colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
  colors[clr.FrameBg] = ImVec4(0.16, 0.29, 0.48, 0.54)
  colors[clr.FrameBgHovered] = ImVec4(0.26, 0.59, 0.98, 0.40)
  colors[clr.FrameBgActive] = ImVec4(0.26, 0.59, 0.98, 0.67)
  colors[clr.TitleBg] = ImVec4(0.04, 0.04, 0.04, 1.00)
  colors[clr.TitleBgActive] = ImVec4(0.16, 0.29, 0.48, 1.00)
  colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.51)
  colors[clr.MenuBarBg] = ImVec4(0.14, 0.14, 0.14, 1.00)
  colors[clr.ScrollbarBg] = ImVec4(0.02, 0.02, 0.02, 0.53)
  colors[clr.ScrollbarGrab] = ImVec4(0.31, 0.31, 0.31, 1.00)
  colors[clr.ScrollbarGrabHovered] = ImVec4(0.41, 0.41, 0.41, 1.00)
  colors[clr.ScrollbarGrabActive] = ImVec4(0.51, 0.51, 0.51, 1.00)
  colors[clr.CheckMark] = ImVec4(0.26, 0.59, 0.98, 1.00)
  colors[clr.SliderGrab] = ImVec4(0.24, 0.52, 0.88, 1.00)
  colors[clr.SliderGrabActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
  colors[clr.Button] = ImVec4(0.26, 0.59, 0.98, 0.40)
  colors[clr.ButtonHovered] = ImVec4(0.26, 0.59, 0.98, 1.00)
  colors[clr.ButtonActive] = ImVec4(0.06, 0.53, 0.98, 1.00)
  colors[clr.Header] = ImVec4(0.26, 0.59, 0.98, 0.31)
  colors[clr.HeaderHovered] = ImVec4(0.26, 0.59, 0.98, 0.80)
  colors[clr.HeaderActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
  colors[clr.Separator] = colors[clr.Border]
  colors[clr.SeparatorHovered] = ImVec4(0.26, 0.59, 0.98, 0.78)
  colors[clr.SeparatorActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
  colors[clr.ResizeGrip] = ImVec4(0.26, 0.59, 0.98, 0.25)
  colors[clr.ResizeGripHovered] = ImVec4(0.26, 0.59, 0.98, 0.67)
  colors[clr.ResizeGripActive] = ImVec4(0.26, 0.59, 0.98, 0.95)
  colors[clr.CloseButton] = ImVec4(0.41, 0.41, 0.41, 0.50)
  colors[clr.CloseButtonHovered] = ImVec4(0.98, 0.39, 0.36, 1.00)
  colors[clr.CloseButtonActive] = ImVec4(0.98, 0.39, 0.36, 1.00)
  colors[clr.PlotLines] = ImVec4(0.61, 0.61, 0.61, 1.00)
  colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
  colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
  colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
  colors[clr.TextSelectedBg] = ImVec4(0.26, 0.59, 0.98, 0.35)
  colors[clr.ModalWindowDarkening] = ImVec4(0.80, 0.80, 0.80, 0.35)
end
apply_custom_style()



local main_window_state = imgui.ImBool(false)
local simplewallhack = imgui.ImBool(false)
local boneswallhack = imgui.ImBool(false)
local nospreadhack = imgui.ImBool(false)
local playergodmode = imgui.ImBool(false)
local stayonbike = imgui.ImBool(false)
local getBonePosition = ffi.cast("int (__thiscall*)(void*, float*, int, bool)", 0x5E4280)

function imgui.OnDrawFrame()
  local sw, sh = getScreenResolution()
  if main_window_state.v then
    imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(250, 200), imgui.Cond.FirstUseEver)
    imgui.Begin('Frixen menu', main_window_state)


    if imgui.Checkbox('Nametag', simplewallhack) then
      if nameTag == false then
        nameTagOn()
      elseif nameTag == true then
        nameTagOff()
      end
    end
    imgui.Checkbox('Bones', boneswallhack)


    if imgui.Checkbox('NoSpread', nospreadhack) then
      noSpread()
    end


    if imgui.Checkbox('GodMode', playergodmode) then
      GMPed()
    end


    if imgui.Checkbox('Stay On Bike', stayonbike) then
      stayBike()
    end


    imgui.End()
  end
end

function main()
  if not isSampfuncsLoaded() or not isSampLoaded() then return end
  while not isSampAvailable() do wait(100) end

  -- вырежи тут, если хочешь отключить проверку обновлений
  update()
  while update ~= false do wait(100) end
  -- вырежи тут, если хочешь отключить проверку обновлений

  sampRegisterChatCommand('cc', function() ClearChat() end)
  sampRegisterChatCommand('ftick', frixen_ticket)
  sampRegisterChatCommand('farr', frixen_arrest)
  sampRegisterChatCommand("chathelper", cmd)
  sampRegisterChatCommand("adblock", adsblock)
  font = renderCreateFont(--[[string]] FontName, --[[int]] FontSize, --[[int]] FontFlag)
    writeMemory(0xB7CEE4, 1, 1, false) -- InfiniteRun
    GMpatch()


    local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    NICKNAME = sampGetPlayerNickname(id)

    while true do
      wait(0)
      func()
      if wasKeyPressed(key.VK_X) and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
        main_window_state.v = not main_window_state.v
      end
      if wasKeyPressed(key.VK_F8) then
        if nameTag == true then
          nameTagOff()
          wait (1500)
          nameTagOn()
        end
      end
      if boneswallhack.v == true then
        boneswh()
      end



      imgui.Process = main_window_state.v
    end
  end

  function func()

    chat = sampIsChatInputActive()
    if chat == true and chathelper == true then
      in1 = sampGetInputInfoPtr()
      in1 = getStructElement(in1, 0x8, 4)
      in2 = getStructElement(--[[int]] in1, --[[int]] 0x8, --[[int]] 4)
        in3 = getStructElement(--[[int]] in1, --[[int]] 0xC, --[[int]] 4)
          fib = in3 + 45
          fib2 = in2 + 5
          _, pID = sampGetPlayerIdByCharHandle(playerPed)
          name = sampGetPlayerNickname(--[[int]] pID)
            ping = sampGetPlayerPing(--[[int]] pID)
              score = sampGetPlayerScore(--[[int]] pID)
                color = sampGetPlayerColor(--[[int]] pID)
                  capsState = ffi.C.GetKeyState(20)
                  numState = ffi.C.GetKeyState(144)
                  success = ffi.C.GetKeyboardLayoutNameA(KeyboardLayoutName)
                  errorCode = ffi.C.GetLocaleInfoA(tonumber(ffi.string(KeyboardLayoutName), 16), 0x00000002, LocalInfo, BuffSize)
                  localName = ffi.string(LocalInfo)
                  --text = string.format("Ваш ID: {0088ff}%d {ffffff}| Ваш LvL: {0088ff}%d {ffffff}| Ваш Пинг: {0088ff}%d {ffffff}| Ваш Ник: {0088ff}%s", pID, score, ping, name)
                  text = string.format(
                    "| {%0.6x}%s {ffffff}| ID: {ff8533}%d {ffffff}| LvL: {ff8533}%d {ffffff}| Ping: %s | Num: %s | Caps: %s | {ffeeaa}%s{ffffff}",
                    bit.band(color, 0xffffff), name, pID, score, getStrByPing(ping), getStrByState(numState), getStrByState(capsState), localName
                  )
                  renderFontDrawText(--[[int]] font, --[[string]] text, --[[int]] fib2, --[[int]] fib, --[[int]] - 1)
                  end

                end

                function getStrByState(keyState)
                  if keyState == 0 then
                    return "{ff8533}OFF{ffffff}"
                  end
                  return "{85cf17}ON{ffffff}"
                end

                function getStrByPing(ping)
                  if ping < 100 then
                    return string.format("{85cf17}%d{ffffff}", ping)
                  elseif ping < 150 then
                    return string.format("{ff8533}%d{ffffff}", ping)
                  end
                  return string.format("{BF0000}%d{ffffff}", ping)
                end

                function cmd()
                  if chathelper == true then
                    chathelper = false
                    sampfuncsLog("[Frixen] ChatHelper выключен!")
                  else
                    chathelper = true
                    sampfuncsLog("[Frixen] ChatHelper включен!")
                  end
                end

                function adsblock()
                  if adblock == true then
                    adblock = false
                    sampfuncsLog("[Frixen] Adblock выключен!")
                  else
                    adblock = true
                    sampfuncsLog("[Frixen] Adblock включен!")
                  end
                end

                function ClearChat()
                  mem.fill(sampGetChatInfoPtr() + 306, 0x0, 25200, false)
                  setStructElement(sampGetChatInfoPtr() + 306, 25562, 4, true, false)
                  mem.write(sampGetChatInfoPtr() + 0x63DA, 1, 1, false)
                end

                function getBodyPartCoordinates(id, handle)
                  local pedptr = getCharPointer(handle)
                  local vec = ffi.new("float[3]")
                  getBonePosition(ffi.cast("void*", pedptr), vec, id, true)
                  return vec[0], vec[1], vec[2]
                end

                function noSpread()
                  if nospreadhack.v == true then
                    mem.fill(0x00740460, 0x90, 3, true)
                  else
                    mem.write(0x00740460, 0x2C48D8, 3, true)

                  end
                end

                function stayBike()
                  if stayonbike.v == true then
                    setCharCanBeKnockedOffBike(playerPed, true)
                    sampAddChatMessage("1", 0xC1C1C1)
                  else
                    setCharCanBeKnockedOffBike(playerPed, false)
                    sampAddChatMessage("0", 0xC1C1C1)

                  end
                end

                function GMPed()
                  if playergodmode.v == true then
                    setCharProofs(playerPed, true, true, true, true, true)
                    writeMemory(0x96916E, 1, 1, false)
                  else
                    setCharProofs(playerPed, false, false, false, false, false)
                    writeMemory(0x96916E, 1, 0, false)
                  end
                end



                function nameTagOn()
                  local pStSet = sampGetServerSettingsPtr();
                  NTdist = mem.getfloat(pStSet + 39)
                  NTwalls = mem.getint8(pStSet + 47)
                  NTshow = mem.getint8(pStSet + 56)
                  mem.setfloat(pStSet + 39, 1488.0)
                  mem.setint8(pStSet + 47, 0)
                  mem.setint8(pStSet + 56, 1)
                  nameTag = true
                end

                function nameTagOff()
                  local pStSet = sampGetServerSettingsPtr();
                  mem.setfloat(pStSet + 39, NTdist)
                  mem.setint8(pStSet + 47, NTwalls)
                  mem.setint8(pStSet + 56, NTshow)
                  nameTag = false
                end

                function boneswh()
                  for i = 0, sampGetMaxPlayerId() do
                    if sampIsPlayerConnected(i) then
                      local result, cped = sampGetCharHandleBySampPlayerId(i)
                      local color = sampGetPlayerColor(i)
                      local aa, rr, gg, bb = explode_argb(color)
                      local color = join_argb(255, rr, gg, bb)
                      if result then
                        if doesCharExist(cped) and isCharOnScreen(cped) then
                          local t = {3, 4, 5, 51, 52, 41, 42, 31, 32, 33, 21, 22, 23, 2}
                          for v = 1, #t do
                            pos1X, pos1Y, pos1Z = getBodyPartCoordinates(t[v], cped)
                            pos2X, pos2Y, pos2Z = getBodyPartCoordinates(t[v] + 1, cped)
                            pos1, pos2 = convert3DCoordsToScreen(pos1X, pos1Y, pos1Z)
                            pos3, pos4 = convert3DCoordsToScreen(pos2X, pos2Y, pos2Z)
                            renderDrawLine(pos1, pos2, pos3, pos4, 1, color)
                          end
                          for v = 4, 5 do
                            pos2X, pos2Y, pos2Z = getBodyPartCoordinates(v * 10 + 1, cped)
                            pos3, pos4 = convert3DCoordsToScreen(pos2X, pos2Y, pos2Z)
                            renderDrawLine(pos1, pos2, pos3, pos4, 1, color)
                          end
                          local t = {53, 43, 24, 34, 6}
                          for v = 1, #t do
                            posX, posY, posZ = getBodyPartCoordinates(t[v], cped)
                            pos1, pos2 = convert3DCoordsToScreen(posX, posY, posZ)
                          end
                        end
                      end
                    end
                  end

                end

                function join_argb(a, r, g, b)
                  local argb = b -- b
                  argb = bit.bor(argb, bit.lshift(g, 8)) -- g
                  argb = bit.bor(argb, bit.lshift(r, 16)) -- r
                  argb = bit.bor(argb, bit.lshift(a, 24)) -- a
                  return argb
                end

                function explode_argb(argb)
                  local a = bit.band(bit.rshift(argb, 24), 0xFF)
                  local r = bit.band(bit.rshift(argb, 16), 0xFF)
                  local g = bit.band(bit.rshift(argb, 8), 0xFF)
                  local b = bit.band(argb, 0xFF)
                  return a, r, g, b
                end

                function frixen_ticket(params)
                  local playerid, money, reason = string.match(params, "(.+)%s(.+)%s(.+)")
                  if playerid ~= nil and money ~= nil and reason ~= nil then
                    local name = sampGetPlayerNickname(playerid)
                    sampAddChatMessage('Вы выписали штраф '..name..'. Сумма: $'..money..' | Причина: '..reason..'', 0x6495ed)
                    sampAddChatMessage('[Информация] {FFFFFF}'..name..' оплатил штраф в размере $'..money..'', 0x659f56)
                  else
                    sampAddChatMessage('{F5F5DC}[{FF8C00}Подсказка{F5F5DC}]: /ftick [id] [сумма] [причина]', 0xFF8C00)
                  end
                end

                function frixen_arrest(params)
                  local playerid, time = string.match(params, "(.+)%s(.+)")
                  if playerid ~= nil and time ~= nil then
                    local name = sampGetPlayerNickname(playerid)
                    sampAddChatMessage('>> Вы посадили игрока '..name..' в тюрьму на '..time..' минут.', 0x42b02c)
                  else
                    sampAddChatMessage('{F5F5DC}[{FF8C00}Подсказка{F5F5DC}]: /farr [id] [время]', 0xFF8C00)
                  end
                end

                function GMpatch()
                  local patchAddr = 0x004B35A0
                  orig1 = readMemory(patchAddr, 4, true)
                  orig2 = readMemory(patchAddr + 4, 2, true)
                  writeMemory(patchAddr, 4, 0x560CEC83, true)
                  writeMemory(patchAddr + 4, 2, 0xF18B, true)
                end

                --- Events
                function onExitThread()
                  if orig1 and orig2 then
                    -- restore original
                    writeMemory(patchAddr, 4, orig1, true)
                    writeMemory(patchAddr + 4, 2, orig2, true)
                  end
                end



                function sampev.onServerMessage(color, text)
                  if text:find(NICKNAME .. '.+говорит:') then -- если найдена строка с таким форматом
                    local thisnick, thistext = text:match('%{.+%}(.+)%[.+%] говорит:%{.+%} (.+)') -- получаем текст из этой строки
                    if thisnick and thistext then -- если удачно
                      local thisid = sampGetPlayerIdByNickname(thisnick) -- получаем ID по NickName (функция imring)
                      sampAddChatMessage('{FFA420}'..thisnick..' {FFFFFF}говорит:{9cc63c} '..thistext, - 1) -- отправляем в чат
                      return false -- игнорируем прошлый текст, который без форматирования.
                    end
                  end

                  if adblock == true then
                    if text:find('Объявление: ') then -- если найдена строка с таким форматом

                      local thistext = text:match('Объявление: ') -- получаем текст из этой строки
                      if thistext then -- если удачно
                        sampfuncsLog(text)
                        return false -- игнорируем прошлый текст, который без форматирования.
                      end
                    end
                    if text:find('Отредактировал сотрудник СМИ') then -- если найдена строка с таким форматом
                      local thistext = text:match('Отредактировал сотрудник СМИ') -- получаем текст из этой строки
                      if thistext then -- если удачно
                        sampfuncsLog(text)
                        return false -- игнорируем прошлый текст, который без форматирования.
                      end

                    end

                  end

                end

                function sampGetPlayerIdByNickname(nick)
                  if type(nick) == "string" then
                    for id = 0, 1000 do
                      local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
                      if sampIsPlayerConnected(id) or id == myid then
                        local name = sampGetPlayerNickname(id)
                        if nick == name then
                          return id
                        end
                      end
                    end
                  end
                end





                --------------------------------------------------------------------------------
                ------------------------------------UPDATE--------------------------------------
                --------------------------------------------------------------------------------
                function update()
                  local fpath = os.getenv('TEMP') .. '\\frixenversion.json'
                  downloadUrlToFile('https://raw.githubusercontent.com/Frixen/frixenlab/master/version.json', fpath, function(id, status, p1, p2)
                    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    local f = io.open(fpath, 'r')
                    if f then
                      local info = decodeJson(f:read('*a'))
                      updatelink = info.updateurl
                      if info and info.latest then
                        version = tonumber(info.latest)
                        if version > tonumber(thisScript().version) then
                          lua_thread.create(goupdate)
                        else
                          update = false
                        end
                      end
                    end
                  end
                end)
              end
              --скачивание актуальной версии
              function goupdate()
                sampAddChatMessage(("Текущая версия: "..thisScript().version..". Новая версия: "..version), color)
                wait(300)
                downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23)
                  if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                  sampAddChatMessage(("Обновление завершено!"), color)
                  thisScript():reload()
                end
              end)
            end
