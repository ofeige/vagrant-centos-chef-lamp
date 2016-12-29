#
# Cookbook Name:: zypper
# Recipe:: smt_client
#
# Copyright 2014 - 2016, Jim Rosser
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
package 'smt-client'

client_setup = "#{Chef::Config[:file_cache_path]}/clientSetup4SMT.sh"
register_log = '/root/.suse_register.log'

remote_file client_setup do
  action :create
  source "http://#{node['zypper']['smt_host']}/repo/tools/clientSetup4SMT.sh"
  mode 0544
  owner 'root'
  not_if { ::File.exist? register_log }
end

execute 'register_smt' do
  command "yes | #{client_setup} --host #{node['zypper']['smt_host']}"
  user 'root'
  creates register_log
  notifies :run, 'execute[initial_smt_agent]', :immediately
end

execute 'initial_smt_agent' do
  user 'root'
  command 'smt-agent'
  action :nothing
end
