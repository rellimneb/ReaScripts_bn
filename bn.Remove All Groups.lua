
-------------------------------------------------
--remove all track grouping from the grouping matrix 
-------------------------------------------------
function ungroupalltracks()
  local allgroupkeys = {"VOLUME_LEAD" , "VOLUME_FOLLOW" , "VOLUME_VCA_LEAD" , "VOLUME_VCA_FOLLOW" ,
  "PAN_LEAD" , "PAN_FOLLOW" , "WIDTH_LEAD" , "WIDTH_FOLLOW" , "MUTE_LEAD" , "MUTE_FOLLOW" , "SOLO_LEAD" ,
  "SOLO_FOLLOW" , "RECARM_LEAD" , "RECARM_FOLLOW" , "POLARITY_LEAD" , "POLARITY_FOLLOW" , "AUTOMODE_LEAD" , "AUTOMODE_FOLLOW" , "VOLUME_REVERSE" , "PAN_REVERSE" , "WIDTH_REVERSE" , "NO_LEAD_WHEN_FOLLOW" , "VOLUME_VCA_FOLLOW_ISPREFX"}
  for tridx = 1, reaper.CountTracks(0) do
    local track=reaper.GetTrack(0, tridx-1)
    for j, key in ipairs(allgroupkeys) do
      --for i=1,32,1 do
        reaper.GetSetTrackGroupMembership( track, key, 4294967295, 0 )
        reaper.GetSetTrackGroupMembershipHigh( track, key, 4294967295, 0 )
      --  end
    end
  end
end


ungroupalltracks()


