require "whenever/capistrano"

set :application, "xbmc_scripts"
set :repository,  "https://github.com/ndbroadbent/xbmc_scripts.git"
set :scm, :git
set :user, "root"
server "flat10c-media", :app, :web, :primary => true
set :deploy_to, "/opt/scripts/#{application}"

set :keep_releases, 3

# Helper method which prompts for user input
def prompt_with_default(prompt, var, default)
  set(var) do
    Capistrano::CLI.ui.ask "#{prompt} [#{default}]: "
  end
  set var, default if eval("#{var.to_s}.empty?")
end

# ---------------------------------------------------
#                 Before / After Hooks
# ---------------------------------------------------

after "deploy",        "deploy:symlink_shared"
after "deploy",        "whenever:update_crontab"
after "deploy:update", "deploy:cleanup"
after "deploy:setup",  "setup:config"
after "deploy:setup",  "install:gems"

# ---------------------------------------------------
#                   Deploy Tasks
# ---------------------------------------------------

namespace :deploy do
  desc "Symlink shared files"
  task :symlink_shared do
    run "mkdir -p #{shared_path}/config"
    run "ln -nfs #{shared_path}/config/config.yml #{current_path}/config/config.yml"
  end
end

# ---------------------------------------------------
#                   Install Tasks
# ---------------------------------------------------

namespace :install do
  desc "Install bundled gems."
  task :gems do
    run "cd #{current_path} && bundle install --without development"
  end
end

# ---------------------------------------------------
#         Create / Update Config & Version
# ---------------------------------------------------

namespace :setup do
  desc "Create or update XBMC config.yml"
  task :config do
    prompt_with_default "XBMC URI:",      "base_uri", ""
    prompt_with_default "XBMC Username:", "username", "xbmc"
    prompt_with_default "XBMC Password:", "password", ""
    xbmc_api_config = <<-EOF
---
:base_uri: #{base_uri}
:username: #{username}
:password: #{password}
EOF
    put xbmc_api_config, "#{shared_path}/config/config.yml"
    puts "== Successfully created \"#{shared_path}/config/config.yml\""
  end
end

