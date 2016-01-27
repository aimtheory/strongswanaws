# connection.rb
#
# connection resource

require 'resolv'

actions :create, :remove

default_action :create

attribute 'connection_name',   :kind_of  => String, :name_attribute => true
attribute 'local_network',     :kind_of  => String, :required => true
attribute 'remote_gateway',    :kind_of  => String, :required => true, :regex => Resolv::IPv4::Regex
attribute 'remote_network',    :kind_of  => String, :required => true
attribute 'startup_operation', :kind_of  => String, :default  => 'start', :equal_to => %w(ignore add route start)
