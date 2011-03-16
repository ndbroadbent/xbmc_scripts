require "rubygems"
require "rake"
require "bundler/setup"
require "xbmc-client"
require "yaml"

def initialize_xbmc
  # Fetch config
  @config = YAML.load_file(File.join(File.dirname(__FILE__), 'config', 'config.yml'))
  # Set up the url and auth credentials
  Xbmc.base_uri @config[:base_uri]
  Xbmc.basic_auth @config[:username], @config[:password]
  # This will call JSONRPC.Introspect and create all subclasses and methods dynamically
  Xbmc.load_api!
end

initialize_xbmc

desc "Play a url or file in XBMC"
task "play" do
  raise "You must specify a URL or file to be played!" unless ENV["url"]
  #---------------------------------------------------------------------

  # Set volume to comfortable level.
  Xbmc::XBMC.set_volume ENV["volume"] || 25

  # Play stream
  Xbmc::XBMC.play ENV["url"].gsub(" ", "%20")
end

namespace "audio" do
  desc "Pause XBMC AudioPlayer"
  task "pause" do
    # If audioplayer is active and not paused, toggle the play/pause command
    if Xbmc::Player.get_active_players[:audio] && !Xbmc::AudioPlayer.state[:paused]
      Xbmc::AudioPlayer.play_pause
    end
  end
  desc "Play (unpause) XBMC AudioPlayer"
  task "play" do
    # If audioplayer is active and paused, toggle the play/pause command
    if Xbmc::Player.get_active_players[:audio] && Xbmc::AudioPlayer.state[:paused]
      Xbmc::AudioPlayer.play_pause
    end
  end
end

