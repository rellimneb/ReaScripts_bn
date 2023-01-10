--[[
 * ReaScript Name: InputMonitorGroup
 * Description: Group the Input parameter
 * Instructions: Toggle script on to activate grouping, toogle off to deactivate linking
 * Screenshot:
 * Author: benrellim 
 * Licence: GPL v3
 * Forum Thread:   
 * Forum Thread URI:
 * REAPER: 6.73
 * Version: 1.0
--]]



local lastsIMstate = 0
local newIMstate = 0
local lasttrack = nil
local newtrack = nil

function Msg(string)
  reaper.ShowConsoleMsg(tostring(string).."\n")
end


function get_media_edit_group_follow_tracks(track)
-- group types: MEDIA_EDIT  

  local groupedtracks={}
  local hash = {}
  local res = {}
  reftrackgrouplow=reaper.GetSetTrackGroupMembership( track, 'RECARM_LEAD', 0, 0  )
  reftrackgrouphi=reaper.GetSetTrackGroupMembershipHigh( track, 'RECARM_LEAD',0, 0 )

  -- if track is MEDIA_EDIT_LEAD of at least one group then continue
  if reftrackgrouplow+reftrackgrouplow ~=0 then
 
    for tridx =1, reaper.CountTracks(0) do
      local trk=reaper.GetTrack(0, tridx-1)
      trkgrouplow=reaper.GetSetTrackGroupMembership( trk, 'RECARM_FOLLOW', 0, 0 )
      trkgrouphi=reaper.GetSetTrackGroupMembershipHigh( trk, 'RECARM_FOLLOW', 0, 0 )
      
      if reftrackgrouplow & trkgrouplow ~=0 or reftrackgrouphi & trkgrouphi ~=0
      --or reftrackgrouphi & trkgrouphi
        then table.insert(groupedtracks, trk)
      end
    
    end
  end
 
  
  --[[
  --delete duplicate in table
  for _,v in ipairs(groupedtracks) do
     if (not hash[v]) then
         res[#res+1] = v -- you could print here instead of saving to result table if you wanted
         hash[v] = true
     end
  
  end
  --]]
  return groupedtracks

end

function main()
  newtrack=reaper.GetLastTouchedTrack()
  if newtrack==oldtrack then
    newIMstate=reaper.GetMediaTrackInfo_Value(newtrack,"I_RECMON")
    if newIMstate~=oldIMstate then
    --Msg('change')
    --propagate recmon to all tracks in group
    groupedtracks=get_media_edit_group_follow_tracks(newtrack)
    
      if #groupedtracks>1 then
        for i=1, #groupedtracks do 
          local tra = groupedtracks[i]
          reaper.SetMediaTrackInfo_Value(tra,"I_RECMON",newIMstate)
        end

      end 


    oldIMstate=newIMstate
    end
  else 
    oldtrack=newtrack
    newIMstate=reaper.GetMediaTrackInfo_Value(newtrack,"I_RECMON")    
    oldIMstate=newIMstate


    --propagate recmon to all tracks in group

    groupedtracks=get_media_edit_group_follow_tracks(newtrack)
    
      if #groupedtracks>1 then
        for i=1, #groupedtracks do 
          local tra = groupedtracks[i]
          reaper.SetMediaTrackInfo_Value(tra,"I_RECMON",newIMstate)
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
