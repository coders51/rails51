require 'pry'
namespace :pg do
  desc "Import PostgreSQL database from remote server"
  task :import do
    on primary :db do |host|
      db = YAML.load(capture("cat #{release_path.join('config/database.yml')}")).fetch(fetch(:rails_env).to_s)
      db_name = db["database"]
      if db.key? "password"
        raise "This task does not yet implement password authentication"
      end

      local_file = "/tmp/#{now}.pg.dump"

      if File.exists?(local_file) || File.exists?("#{local_file}.gz")
        raise "#{local_file} or #{local_file}.gz exists in file system... Is another import running?"
      end

      remote_dump = capture("mktemp --suffix pg.dump.gz")
      if db.key? 'port'
        execute "pg_dump -p #{db['port']} --clean --no-owner #{db_name} | gzip > #{remote_dump}"
      else
        execute "pg_dump --clean --no-owner #{db_name} | gzip > #{remote_dump}"
      end
      download! remote_dump, "#{local_file}.gz"
      execute "rm -f #{remote_dump}"
      run_locally do
        local_db_data = YAML.load(File.read("config/database.yml"))['development']
        execute "gunzip #{local_file}.gz"
        execute "bundle exec rake db:drop; bundle exec rake db:create"
        execute "psql #{local_db_data['database']} < #{local_file}"
        execute "bundle exec rake db:migrate"
        execute "rm -f #{local_file}"
      end
    end
  end
end
