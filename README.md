vagrant-centos-chef-lamp
========================

A lamp stack with chef, cents 6.5, vagrant, apache-2.2, php-5.5, mysql 5.6

Install
=======

1. install vagrant >= 1.6.3 (http://www.vagrantup.com/downloads.html)
2. install omnibus for vagrant
```
vagrant plugin install vagrant-omnibus
```

3. load git submodules
```
git submodule init
git submodule update
```
4. start vagrant
```
vagrant up
```
