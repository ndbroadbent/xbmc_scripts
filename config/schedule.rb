# ---------------------------------------------------------
#                    XBMC Schedule
# ---------------------------------------------------------
def xbmc(cmd)
  command "cd /opt/scripts/xbmc_scripts/current && rake #{cmd}"
end

work_day = [:tuesday, :wednesday, :thursday, :friday, :saturday]

# Play radio on workday mornings for an hour.
every work_day, :at => '7:20 am' do
  xbmc "play url=lastfm://globaltags/worship volume=40"
end
every work_day, :at => '8:30 am' do
  xbmc "audio:pause"
end

# Chill-out on a monday morning.
every :monday, :at => '9:15 am' do
  xbmc "play url=lastfm://globaltags/chillout volume=25"
end

