vagrant-centos-chef-lamp
========================

A lamp stack with chef, centos 7.0, vagrant, nginx, php-5.6, php-fpm, mysql 5.7 and composer. But instead of using apache, I switched to nginx

Install
=======

1. choose your virtualization product
 - install virtual-box >= 4.3.16
 - install parallels 10
2. install vagrant >= 1.6.5 (http://www.vagrantup.com/downloads.html) I suggest to install the latest version. I tested this project only with version 1.7.3
3. install the necessary plugins for vagrant, if not yet happened
```
vagrant plugin install vagrant-hostmaster
vagrant plugin install vagrant-cachier
```

Hostmaster is needed to add/remove entries in your local /etc/hosts file. To support development domains
Cachier is needed to prevent downloading rpm´s again. This is usefull during setting up a vm, when you have online internet via cellphone like inside a train :-)


4. do the git stuff
```
git clone https://github.com/ofeige/vagrant-centos-chef-lamp
cd vagrant-centos-chef-lamp
```

5. start vagrant with virtual box
```
vagrant up
```
or with parallels
```
vagrant up --provider=parallels
```

Config Option
=============

You can setup dedicated virtual hosts, when you change following line

```
node.hostmanager.aliases = %w(www.project1.local www.project2.local)
```

and

```
:lamp  => {
  vhosts: [ "project1.local", "project2.local" ]
}
```

here you can add more virtual hosts or change the name. Please always change both lines. The first one, will create entries in you /etc/hosts, without these entries you can´t access the virtual hosts with your local browser.

Change Log
==========
13. Nov. 2014
First release for this project

22. Jun. 2014
- Fix fileupload issues (ngnix & php-fpm related)
- Clean the project structure and remove unused stuff
- Use of only one chef cookbook "lamp" instead of "angi" + "lamp"
- remove all submodule and used now copy of official cookbooks

16. September 2015
- fix .dev dns problems
- provide correct example inside README
- rewrote the cookbooks, it is much cleaner now and no need for submodules
