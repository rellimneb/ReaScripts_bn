--[[
 * ReaScript Name: Mulitmonosim - Link parameter of mulitple instances of an FX on a track
 * Description: if there are multiple instance of a FX on track then link there parameters, if they have the same name.  This is a workaround to make up for the absence of multimon plugin possibility.
 * Instructions: Toggle script on to activate linking, toogle off to deactivate linking
 * Screenshot:
 * Author: benrellim based on script by spk77
 * Licence: GPL v3
 * Forum Thread:   Scripts: FX Param Values (various)
 * Forum Thread URI:
 * REAPER: 6.0
 * Version: 1.0
--]]

--todo bug: when  multiple ^arametes are change at once (ex dragingn a point in the eq curve in rea eq) some value changes can get dropped...


-- Link FX parameters
----based on lua script by  X-Raym, casrya and SPK77

local last_param_number = -1
local last_val = -10000000
local param_changed = false

---- param_value_change_count = 0 -- for debugging
---- param_change_count = -1 -- for debugging

function Msg(string)
  reaper.ShowConsoleMsg(tostring(string).."\n")
end


-- http://lua-users.org/wiki/SimpleRound
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function main()
  local ret, track_number, fx_number, param_number = reaper.GetLastTouchedFX()
  if ret then
    local track_id = reaper.CSurf_TrackFromID(track_number, false)
    if track_id ~= nil then
      local val, minvalOut, maxvalOut = reaper.TrackFX_GetParam(track_id, fx_number, param_number)
      local fx_name_ret, fx_name = reaper.TrackFX_GetFXName(track_id, fx_number, "")

      -- convert double to float precision
      val=round(val,7)

      -- Check if parameter has changed
      param_changed = param_number ~= last_param_number or last_val~=val

      -- Run this code only when parameter value has changed
      if param_changed then
        --Msg("last_val: " .. last_val .. ", val: " .. val .. ", last_param_number: " .. last_param_number .. ", param_number: " .. param_number .. ", fx_number: " .. fx_number)
        last_val = val
        last_param_number = param_number

        
 

          for fx_i=1, reaper.TrackFX_GetCount(track_id) do -- loop through FXs on current track
            local dest_fx_name_ret, dest_fx_name = reaper.TrackFX_GetFXName(track_id, fx_i-1, "")
            if dest_fx_name == fx_name then
            ----  Msg("FX number: " .. fx_i ..", Setting last_val: " .. last_val .. ", val: " .. val .. ", param_number: " .. param_number)
              reaper.TrackFX_SetParam(track_id, fx_i-1, param_number, val)
            end
          end
        
        ---- param_value_change_count = param_value_change_count + 1 -- for debugging
      end
    end
  end
  reaper.defer(main)
end

local _, _, sectionID, cmdID, _, _, _ = reaper.get_action_context()
reaper.SetToggleCommandState(sectionID, cmdID, 1)
reaper.RefreshToolbar2(sectionID, cmdID)
function DoAtExit()
  -- set toggle state to off
  reaper.SetToggleCommandState(sectionID, cmdID, 0);
  reaper.RefreshToolbar2(sectionID, cmdID);
end

reaper.atexit(DoAtExit)

main()
