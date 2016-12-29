require 'mixlib/shellout'

use_inline_resources

action :add do
  if repo_exist?
    new_resource.updated_by_last_action false
  else
    unless new_resource.key.nil?
      install_curl
      import_key
    end
    command = 'zypper ar'
    command << ' -f' if new_resource.autorefresh
    command << " #{new_resource.uri} \"#{new_resource.repo_name}\""
    shellout = Mixlib::ShellOut.new(command, user: 'root').run_command
    if shellout.stderr.empty?
      new_resource.updated_by_last_action true
    else
      Chef::Log.error("Error adding repo: #{shellout.stderr}")
    end
  end
end

action :remove do
  if repo_exist?
    command = "zypper rr \"#{new_resource.repo_name}\""
    shellout = Mixlib::ShellOut.new(command, user: 'root').run_command
    if shellout.stderr.empty?
      new_resource.updated_by_last_action true
    else
      Chef::Log.error("Error removing repo: #{shellout.stderr}")
    end
  else
    new_resource.updated_by_last_action false
  end
end

def repo_exist?
  command = "zypper repos | grep \"#{new_resource.repo_name}\""
  shellout = Mixlib::ShellOut.new(command, user: 'root').run_command
  if shellout.stdout.empty?
    false
  else
    true
  end
end

def install_curl
  # Make sure curl is installed
  pkg = Chef::Resource::Package.new('curl', run_context)
  pkg.run_action :install
end

def import_key
  cmd = Chef::Resource::Execute.new("import key for #{new_resource.repo_name}",
                                run_context)
  cmd.command "rpm --import #{new_resource.key}"
  cmd.run_action :run
end
