set :application, 'tcorps_staging'
set :environment, 'staging'
set :branch, 'master'
set :user, 'tcorps'

# Number of thin processes
set :instances, 2
 
set :scm, :git
 
set :repository, "git@github.com:sunlightlabs/tcorps.git"
 
set :deploy_to, "/home/tcorps/#{application}"
set :deploy_via, :remote_cache
 
set :domain, 'tcorps.sunlightlabs.com'
role :app, domain
role :web, domain
 
set :runner, user
set :admin_runner, runner
 
namespace :deploy do  
  desc "Start the server"
  task :start, :roles => [:web, :app] do
    run "cd #{deploy_to}/current && nohup thin -s #{instances} -C config/thin_#{environment}.yml start"
  end
 
  desc "Stop the server"
  task :stop, :roles => [:web, :app] do
    run "cd #{deploy_to}/current && nohup thin -s #{instances} -C config/thin_#{environment}.yml stop"
  end
  
  desc "Restart the server"
  task :restart, :roles => [:web, :app] do
    deploy.stop
    deploy.start
  end
  
  desc "Migrate the database"
  task :migrate, :roles => [:web, :app] do
    run "cd #{deploy_to}/current && rake db:migrate RAILS_ENV=#{environment}"
  end
  
  desc "Get shared files into position"
  task :after_update_code, :roles => [:web, :app] do
    run "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/#{environment}.sqlite3 #{release_path}/db/#{environment}.sqlite3"
  end
  
  desc "Deploy, and migrate the database"
  task :with_migrations do
    deploy.update
    deploy.migrate
    deploy.restart
  end
  
  desc "Initial deploy"
  task :cold do
    deploy.update
    deploy.migrate
    deploy.start
  end
end