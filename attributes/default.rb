# attributes/default.rb

# Makes StrongSwan logs debug notices
default['awsstrongswan']['debug'] = false

# A list of IPSec tunnel configuration info
# Example:
# [
#   {
#     "name": "tunnel-to-other-vpc",
#     "local_network": "10.10.0.0/16",
#     "remote_network": "10.11.0.0/16",
#     "tunnel_ip": "1.2.3.4"
#   }
# ]
default['awsstrongswan']['tunnels'] = []
