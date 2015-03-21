namespace :pg do
  desc "Import PostgreSQL database from remote server"
  task import: :environment do
    on primary :db do |host|
      puts release_path
    end
  end
end
