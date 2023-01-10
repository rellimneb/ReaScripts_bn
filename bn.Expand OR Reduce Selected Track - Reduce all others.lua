 
  
  
  function SetAllTrackHeightTo()
   for tridx = 1, reaper.CountTracks(0) do
    
    local tra=reaper.GetTrack(0, tridx-1)
    if reaper.GetMediaTrackInfo_Value(tra, "I_HEIGHTOVERRIDE")>10 
    and  reaper.GetMediaTrackInfo_Value(tra, "I_SELECTED")==0 then
      reaper.SetMediaTrackInfo_Value(tra, "I_HEIGHTOVERRIDE", 10)
      reaper.SetMediaTrackInfo_Value(tra, "B_HEIGHTLOCK", 0)
    end
    if reaper.GetMediaTrackInfo_Value(tra, "I_SELECTED")==1 and reaper.GetMediaTrackInfo_Value(tra, "I_HEIGHTOVERRIDE")<400  then
    reaper.SetMediaTrackInfo_Value(tra, "I_HEIGHTOVERRIDE", 400)
    else reaper.SetMediaTrackInfo_Value(tra, "I_HEIGHTOVERRIDE", 10)
    end
   end
  end

  function ExpandSelectedTracks()
    for i = 1, reaper.CountSelectedTracks(0) do
     local tr = reaper.GetSelectedTrack(0,0)
      reaper.SetMediaTrackInfo_Value(tr, "I_HEIGHTOVERRIDE", 400)
    end
  end
  
  SetAllTrackHeightTo()
 -- ExpandSelectedTracks()
  
  reaper.TrackList_AdjustWindows( false )
  reaper.UpdateArrange()
