sudo cat > /etc/nginx/sites-enabled/default << EOM
  server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name localhost;

    root /vagrant/public;

    # serve static content directly
    location ~* \.(ico|jpg|gif|png|css|js|swf|html)$ {
      if (-f \$request_filename) {
        expires max;
        break;
      }
    }

    client_max_body_size 250M;

    passenger_enabled on;
    rails_env development;

    location ~ /\.ht {
      deny  all;
    }
  }
EOM

sudo service nginx restart