vagrant-centos-chef-lamp
========================

A lamp stack with chef, centos 7.0, vagrant, nginx, php-5.6, php-fpm, mysql 5.6

Install
=======

1. choose your virtualization product
 - install virtual-box >= 4.3.16
 - install parallels 10
2. install vagrant >= 1.6.5 (http://www.vagrantup.com/downloads.html)
3. install the necessary plugins for vagrant, if not yet happened
```
vagrant plugin install vagrant-omnibus
vagrant plugin install vagrant-cachier
vagrant plugin install nugrant
```

omnibus is needed to install chef on a clean new vm.
Cachier is needed to prevent downloading rpm´s again. This is usefull during setting up a vm, when you have online internet via cellphone like inside a train :-)

4. do the git stuff
```
git clone https://github.com/ofeige/vagrant-centos-chef-lamp
cd vagrant-centos-chef-lamp
git submodule init
git submodule update
```

5. start vagrant with virtual box
```
vagrant up
```
or with parallels
```
vagrant up --provider=parallels
```
