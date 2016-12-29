# zypper Cookbook

Cookbook that provides a lwrp for zypper repositories and also a recipe to install and configure the smt-client for SLES.

## Requirements

### Platforms

- SLES 11+
- openSUSE 13+
- openSUSE Leap

### Chef

- Chef 11+

### Cookbooks

- none

## Attributes

### zypper::smt_client

Key                             | Type   | Description         | Default
------------------------------- | ------ | ------------------- | ------------
<tt>['zypper']['smt_host']</tt> | String | uri of the SMT host | <tt>nil</tt>

## Resource/Provider

## zypper_repo

### Actions

- **add** - adds a repo
- **delete** - removes a repo

### Attributes

- **repo_name** - repo alias (name attribute)
- **uri** - uri of the repo
- **autorefresh** - enable autorefresh
- **key** - location of repo key to import

## Example Usage

```ruby
zypper_repo 'remove_dvd_repo' do
  action :remove
  repo_name 'SLES11SP3-x64 DVD1 Online'
end

zypper_repo 'add_dvd_repo' do
  repo_name 'SLES11SP3-x64 DVD1 Online'
  uri 'http://demeter.uni-regensburg.de/SLES11SP3-x64/DVD1/'
end

zypper_repo 'jenkins' do
  key 'http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key'
  uri 'http://pkg.jenkins-ci.org/opensuse/'
end
```

### zypper::smt_client

Just include `zypper::smt_client` in your node's `run_list` and set the `smt_host` attribute to your smt server:

```json
{
  "name":"my_node",
  "normal": {
    "zypper": {
      "smt_host": "smt.example.com"
    }
  },
  "run_list": [
    "recipe[zypper]"
  ]
}
```

## Testing

To test with test kitchen you need to have a SLES Vagrant box already on your system(checkout github.com/opscode/bento). In order to test the smt recipe with your smt server set the SMT_HOST env variable to your smt host:

```shell
export SMT_HOST=smt.example.com
```

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

## License and Authors

- Author:: Jim Rosser(jarosser06@gmail.com)

```text
copyright (C) 2014-2016 Jim Rosser

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the “Software”), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Software,
and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
```
