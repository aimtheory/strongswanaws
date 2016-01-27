# StrongSwan AWS Cookbook

## Contents

* [Summary](#summary)
* [Requirements](#requirements)
* [Supported Platforms](#supported-platforms)
* [Cookbook Dependencies](#cookbook-dependencies)
* [Attributes](#attributes)
* [Data Bags](#data-bags)
* [Recipes](#recipes)
* [Usage](#usage)
* [Resources](#resources)


## Summary
The StrongSwan AWS Cookbook creates an AWS-compatible IPSec tunnel on a node.

## Requirements

This cookbook works with [StrongSwan](https://www.strongswan.org/), an open-source IPSec-based VPN solution.

It has been tested with StrongSwan `5.1.2`, as packaged for Ubuntu.

## Supported Platforms

<table>
  <tr>
    <th>Distribution</th>
    <th>Version</th>
  </tr>
  <tr>
    <td>Ubuntu</td>
    <td>14.04</td>
  </tr>
</table>

## Cookbook Dependencies

This cookbook does not depend on any other cookbooks.

## Attributes

This cookbook uses the following attributes.

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['awsstrongswan']['debug']</tt></td>
    <td>Boolean</td>
    <td>Cause charon to log debug information</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['awsstrongswan']['tunnels']</tt></td>
    <td>Array</td>
    <td>Tunnels to which to connect</td>
    <td>empty<tt>[]</tt></td>
  </tr>
</table>

These attributes can be set as below.

`['awsstrongswan']['debug']`:

```json
"default_attributes": {
  "strongswanaws": {
    "debug": true
  }
}
```

`['awsstrongswan']['tunnels']`:

```json
"default_attributes": {
  "strongswanaws": {
    "tunnels": [
      {
        "name": "tunnel-to-other-vpc",
        "local_network": "10.10.0.0/16",
        "remote_network": "10.11.0.0/16",
        "tunnel_ip": "1.2.3.4"
      }
    ]
  }
}
```

## Data Bags

This cookbook makes use of a data bag named `strongswanaws`.

The data bag should contain a single item named `tunnel_keys`.

The item `tunnel_keys` should look as shown below.

```json
{
  "id": "tunnel_keys",
  "key_configs": [
    {
      "name": "tunnel-to-other-vpc",
      "psk": "Ep53A1ZqY6f.KWO90LABLzfRZyf62GyM",
      "source_ips": [
        "1.2.3.4"
      ]
    }
  ]
}
```

There may be zero or more tunnels in the `tunnel_keys` list.

## Recipes

This cookbook contains the following recipes.

* `strongswanaws::default` - This recipe is empty.  It allows the cookbook to be included without running an action.

* `strongswanaws::server` - This recipe does the following.
  * Installs StrongSwan
  * Sets system-wide limits with `sysctl` 
  * Runs Charon
  * Sets StrongSwan start on boot

* `strongswanaws::tunnels` - This recipe does the following.
  * Writes PSK's to the secrets file
  * Configures tunnels to which StrongSwan will connect

## Usage

Include the `server` recipe to only install StrongSwan and set system limits.

```json
"run_list": [
  "recipe[strongswanaws::server]"
]
```

Include both `server` and `tunnels` recipes to configure StrongSwan to establish one or more IPSec sessions.

```json
"run_list": [
  "recipe[strongswanaws::server]",
  "recipe[strongswanaws::tunnels]",
]
```

## Resources

`strongswanaws::connection` - Add an IPSec session for StrongSwan to establish

Parameters:

* `connection_name` - A string to label an IPSec session (name attribute)
* `local_network` - A CIDR-formatted network address (required)
* `remote_network` - A CIDR-formatted network address (required)
* `remote_gateway` - An IPv4 address (required)
* `startup_operation` - A string to indicate the desired initial state of the tunnel (one of 'add', 'route', 'start')

Example:

```ruby
strongswanaws_connection 'remote_tunnel' do
  connection_name   'remote_tunnel'
  local_network     '10.10.0.0/16'
  remote_network    '10.11.0.0/16'
  remote_gateway    '1.2.3.4'
  startup_operation 'start'
end
```
