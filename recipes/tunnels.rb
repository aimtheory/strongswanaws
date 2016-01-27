# Cookbook Name:: strongswanaws
# Recipe:: tunnels
#

# There are a list of pre-shared keys indexed
# by chef environment in the vpn_keys data bag.
tunnel_keys = data_bag_item('strongswanaws', 'tunnel_keys')
key_configs = tunnel_keys['key_configs']


# StrongSwan will need a list of pre-shared keys
# and ip addresses to establish an IPSec session
template '/etc/ipsec.secrets' do
  source 'ipsec_secrets.erb'
  owner  'root'
  group  'root'
  mode   '0400'
  variables('keys' => key_configs)
end

# Each tunnel will need its own configuration
node['strongswanaws']['tunnels'].each do |tunnel|
  strongswanaws_connection tunnel['name'] do
    connection_name   tunnel['name']
    local_network     tunnel['local_network']
    remote_gateway    tunnel['tunnel_ip']
    remote_network    tunnel['remote_network']
    startup_operation 'start'
  end
end
