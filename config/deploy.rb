require 'rvm/capistrano'
set :rvm_ruby_version, "ruby-1.9.2-p180"

set :application, "xbmc_scripts"
set :repository,  "https://github.com/ndbroadbent/xbmc_scripts.git"
set :scm, :git
set :user, "root"
server "flat10c-media", :app
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
after "deploy",        "install:crontab"
after "deploy:update", "deploy:cleanup"
after "deploy:setup",  "setup:config"
after "deploy:setup",  "install:gems"
after "deploy:cold",   "deploy:create_shared_dirs"
after "deploy:cold",   "deploy:setup"
after "deploy:setup",  "deploy:symlink_shared"

# ---------------------------------------------------
#                   Deploy Tasks
# ---------------------------------------------------

namespace :deploy do
  desc "Symlink shared files"
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/config.yml #{current_path}/config/config.yml"
  end

  desc "Create dir structure"
  task :create_shared_dirs do
    run "mkdir -p #{shared_path}/config"
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

  desc "Install whenever crontab"
  task :crontab do
    run "cd #{current_path} && whenever --update-crontab"
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

