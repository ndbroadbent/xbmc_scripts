# ---------------------------------------------------------
#                    XBMC Schedule
# ---------------------------------------------------------
def xbmc(cmd)
  command "cd /opt/scripts/xbmc_scripts/current && rake #{cmd}"
end

every 1.day, :at => '7:20 am' do
  xbmc "play url=lastfm://globaltags/worship volume=40"
end

every 1.day, :at => '8:30 am' do
  xbmc "audio:pause"
end

