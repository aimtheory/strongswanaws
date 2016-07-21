# connection.rb
#
# connection provider

def whyrun_supported?
  true
end

action :create do
  Chef::Log.info(
      "Adding connection info for '#{new_resource.name}' to StrongSwan"
  )

  converge_by("Creating #{new_resource.name}.conf connection config") do
    template "/etc/ipsec.connections/#{new_resource.name}.conf" do
      source 'connection.erb'
      cookbook 'strongswanaws'
      owner 'root'
      group 'root'
      mode '0644'
      variables('ip_address'        => node['ipaddress'],
                'connection_name'   => new_resource.connection_name,
                'local_network'     => new_resource.local_network,
                'remote_gateway'    => new_resource.remote_gateway,
                'remote_network'    => new_resource.remote_network,
                'startup_operation' => new_resource.startup_operation)
      notifies :restart, 'service[strongswan]', :delayed
      action :create
    end
  end
end

action :remove do
  Chef::Log.info "Removing connection '#{new_resource.name}' from StrongSwan"

  converge_by("Removing #{new_resource.name} connection config") do
    file "/etc/ipsec.connections/#{new_resource.name}.conf" do
      action :delete
    end

    file "/etc/ipsec.connections/#{new_resource.name}-auto.conf" do
      action :delete
    end
  end
end
