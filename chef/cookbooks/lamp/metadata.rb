name               "lamp"
maintainer         "Oliver Feige"
maintainer_email   "oliver@feige.net"
license            "All rights reserved"
description        "Installs/Configures a LAMP Stack"
#long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version            "0.0.4"


depends 'php'
depends 'mysql', '~> 8.0'
depends 'chef_nginx'
