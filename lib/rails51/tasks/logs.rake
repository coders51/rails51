unless defined?(Capistrano) && defined?(:namespace)
  $stderr.puts\
    "WARNING: rails51/capistrano must be loaded by Capistrano in order to work.\n"\
    "Require this gem within your application's Capfile\n"
end

namespace :logs do
  desc 'Tailf production logs'
  task :tail do
    on roles(:app) do
      require 'pry'
      if defined?(Airbrussh)
        if Gem.loaded_specs['airbrussh'].version < Gem::Version.new('0.3.0')
          $stderr.write "*************************************************************************************************************************************\n"
          $stderr.write "* Airbrussh version lower than 0.3.0 suppress stdout. Please update airbrussh, or all the output will be in log/capistrano.log file *\n"
          $stderr.write "*************************************************************************************************************************************\n"
        else
          Airbrussh.configuration.command_output = true
        end
      end
      execute :tail, '-f', release_path.join('log', "#{fetch(:rails_env, 'production')}.log")
    end
  end
end
