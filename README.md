vagrant-centos-chef-lamp
========================

A lamp stack with chef, cents 6.5, vagrant, apache-2.2, php-5.5, mysql 5.6

Install
=======

1. install vagrant >= 1.6.3 (http://www.vagrantup.com/downloads.html)
2. install the necessary plugins for vagrant, if not yet happened
```
vagrant plugin install vagrant-omnibus
vagrant plugin install vagrant-cachier
```

omnibus is needed to install chef on a clean new vm. Cachier is needed to prevent downloading rpm´s again. This is usefull during setting up a vm, when you have online internet via cellphone like inside a train :-)

3. do the git stuff
```
git clone https://github.com/ofeige/vagrant-centos-chef-lamp
cd vagrant-centos-chef-lamp
git submodule init
git submodule update
```

4. start vagrant
```
vagrant up
```
