set :environment, (ENV['target'] || 'production')

# Change repo and domain for your setup
#if environment == 'production'
  set :domain, 'woodley.sunlightlabs.net'
#else
#   set :domain, 'hammond.sunlightlabs.org'
# end

set :application, "tcorps_#{environment}"
set :branch, 'master'
set :user, 'tcorps'

set :scm, :git
set :repository, "git@github.com:sunlightlabs/tcorps.git"
 
set :deploy_to, "/projects/tcorps/www/#{application}"
set :deploy_via, :remote_cache
 
role :app, domain
role :web, domain

set :sock, "#{user}.sock"

set :runner, user
set :admin_runner, runner
set :use_sudo, false
 
after "deploy", "deploy:cleanup"
after "deploy:update_code", "deploy:shared_links"
 
namespace :deploy do    
  desc "Migrate the database"
  task :migrate, :roles => [:web, :app] do
    run "cd #{deploy_to}/current && rake db:migrate RAILS_ENV=#{environment}"
    deploy.restart
  end
  
  task :start do
    run "cd #{current_path} && unicorn -D -l #{shared_path}/#{sock}"
  end
  
  task :stop do
    run "killall unicorn"
  end
  
  desc "Restart the server"
  task :restart, :roles => :app, :except => {:no_release => true} do
    run "killall -HUP unicorn"
  end
  
  desc "Get shared files into position"
  task :shared_links, :roles => [:web, :app] do
    run "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/mailer.rb #{release_path}/config/initializers/mailer.rb"
    run "ln -nfs #{shared_path}/system #{release_path}/public/system"
  end
  
  desc "Initial deploy"
  task :cold do
    deploy.update
    deploy.migrate
  end
end