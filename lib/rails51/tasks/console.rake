namespace :load do
  task :defaults do
    # add rails to rvm_map_bins
    rvm_map_bins = fetch(:rvm_map_bins) || []
    rvm_map_bins << :rails
    set(:rvm_map_bins, rvm_map_bins)
  end
end

namespace :rails do
  desc "Interact with a remote rails console"
  task console: ['deploy:set_rails_env'] do
    on primary :app do |host|
      ssh_cmd_options = []

      if host.ssh_options && host.ssh_options[:proxy]
        template = host.ssh_options[:proxy].command_line_template
        ssh_cmd_options << "-o ProxyCommand=\"#{template}\""
      end

      ssh_cmd_options_str = ssh_cmd_options.join(' ') if ssh_cmd_options.size > 0
      user_host = [host.user, host.hostname].compact.join('@')
      ssh_cmd = "ssh #{ssh_cmd_options_str} #{user_host} -p #{host.port || 22}"

      cmd = SSHKit::Command.new(:rails, "console #{fetch(:rails_env)}", host: host)
      SSHKit.config.output << cmd

      exec(%Q(#{ssh_cmd} -t "cd #{current_path} && (#{cmd.environment_string} #{cmd})"))
    end
  end
end
