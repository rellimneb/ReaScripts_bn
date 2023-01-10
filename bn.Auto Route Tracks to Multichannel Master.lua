i=0
while reaper.GetTrack(0,i) do
  tra=reaper.GetTrack(0,i)
  reaper.SetMediaTrackInfo_Value(tra,"D_PAN", -1)
  reaper.SetMediaTrackInfo_Value(tra,"C_MAINSEND_OFFS", i)

  i=i+1
end
