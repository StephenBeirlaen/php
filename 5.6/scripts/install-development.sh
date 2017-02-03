#!/bin/sh

set -e

apt-get update
apt-get install -y php-xdebug php-tideways git
apt-get clean -y
curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/local/lib --filename=composer

(
    cd /usr/lib/php/$(php -i | grep ^extension_dir | sed -e 's/.*\/\([0-9]*\).*/\1/')
    curl -O https://raw.githubusercontent.com/tideways/profiler/master/Tideways.php
)

printf "xdebug.remote_enable = 1\nxdebug.remote_connect_back = 1\nxdebug.max_nesting_level=400" \
    >> /etc/php/5.6/mods-available/xdebug.ini

printf "auto_prepend_file=/usr/share/tideways/prepend.php" \
    >> /etc/php/5.6/mods-available/tideways.ini

phpdismod xdebug
phpdismod tideways
