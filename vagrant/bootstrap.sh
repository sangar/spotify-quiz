#
# Common functions

function apt_update {
  echo "apt-get update..."
  apt-get update >/dev/null 2>&1
}

function install {
  echo installing $1
  shift
  apt-get -y install "$@" >/dev/null 2>&1
}

function gem_install {
  echo installing $1
  shift
  gem install "$@" >/dev/null 2>&1
}

# Provisioning sections
# 1. Add repositories / Configure apt
# 2. Update apt
# 3. Install software
# 4. Configure software
# 5. Install Gems

#
# 1. Add repositories / Configure apt
## Add ruby repository
apt-add-repository -y ppa:brightbox/ruby-ng >/dev/null 2>&1

## Passenger PGP key
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7

## Add nginx passenger repository
echo "deb https://oss-binaries.phusionpassenger.com/apt/passenger bionic main" > /etc/apt/sources.list.d/passenger.list

## Add postgresql repository
echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main" >> /etc/apt/sources.list.d/pgdg.list
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -

## Add nodejs & yarn
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

#
# 2. Update apt
apt_update


#
# 3. Install software
install Ruby ruby2.6 ruby2.6-dev
update-alternatives --set ruby /usr/bin/ruby2.6 >/dev/null 2>&1
update-alternatives --set gem /usr/bin/gem2.6 >/dev/null 2>&1

install 'dirmngr & gnupg' dirmngr gnupg
install 'apt-transport-https & ca-certificates' apt-transport-https ca-certificates
install build-essential build-essential

install Redis redis-server
install 'Nokogiri dependencies' libxml2 libxml2-dev libxslt1-dev zlib1g-dev
install 'ExecJS runtime' nodejs yarn
install Curl libcurl4-openssl-dev

install 'nginx & passenger' nginx libnginx-mod-http-passenger
install postgresql postgresql postgresql-contrib libpq-dev

#
# 4. Configure software
## Configure nginx
systemctl start nginx.service
systemctl enable nginx

if [ ! -f /etc/nginx/modules-enabled/50-mod-http-passenger.conf ]; then
  echo "nginx passenger module not loaded..."
  ln -s /usr/share/nginx/modules-available/mod-http-passenger.load /etc/nginx/modules-enabled/50-mod-http-passenger.conf
fi

sudo service nginx start

## Configure locale - Needed for docs generation.
update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

## Configure .bashrc
echo "cd /vagrant" >> /home/vagrant/.bashrc

#
# 5. Install Gems
gem_install Bundler bundler
cd /vagrant
bundle install
yarn install
