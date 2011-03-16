# ---------------------------------------------------------
#                    XBMC Schedule
# ---------------------------------------------------------

every 1.day, :at => '7:20 am' do
  rake "play url=lastfm://globaltags/worship"
end

every 1.day, :at => '8:30 am' do
  rake "audio:pause"
end

