unless defined?(Capistrano) && defined?(:namespace)
  $stderr.puts\
    "WARNING: rails51/capistrano must be loaded by Capistrano in order to work.\n"\
    "Require this gem within your application's Capfile\n"
end

namespace :logs do
  desc 'Tailf production logs'
  task :tail do
    on roles(:app) do
      Airbrussh.configuration.log_level = :debug if defined?(Airbrussh)
      execute :tail, '-f', release_path.join('log', "#{fetch(:rails_env, 'production')}.log")
    end
  end
end
