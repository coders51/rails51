require 'pry'

namespace :mysql do
  desc "Import MySQL database from remote server"
  task :import do
    on primary :db do |host|
      db = YAML.load(capture("cat #{release_path.join('config/database.yml')}")).fetch(fetch(:rails_env).to_s)

      local_file = "/tmp/#{now}.mysql.dump"

      if File.exists?(local_file) || File.exists?("#{local_file}.gz")
        raise "#{local_file} or #{local_file}.gz exists in file system... Is another import running?"
      end

      remote_dump = capture("mktemp --suffix mysql.dump.gz")

      cmd = "mysqldump "
      cmd << " -P #{db['port']}" if db.key? 'port'
      cmd << " -u#{db['username']}" if db.key? 'username'
      cmd << " -p#{db['password']}" if db.key? 'password'
      cmd << " -h #{db['host']}" if db.key? 'host'
      cmd << " #{db['database']} | gzip > #{remote_dump}"

      execute cmd
      download! remote_dump, "#{local_file}.gz"
      execute "rm -f #{remote_dump}"

      run_locally do
        local_db_data = YAML.load(ERB.new(File.read("config/database.yml")).result)['development']
        execute "gunzip #{local_file}.gz"
        execute "bundle exec rake db:drop; bundle exec rake db:create"
        execute "mysql #{local_db_data['database']} -u#{local_db_data['username']} -p#{local_db_data['password']} < #{local_file}"
        execute "bundle exec rake db:migrate"
        execute "rm -f #{local_file}"
      end
    end
  end
end
