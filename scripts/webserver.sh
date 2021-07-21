#!/bin/bash
############################################################################
# Web:    https://multiply.network
# Source: https://github.com/Multiplity-in-Network/yiimp_install_raspberry
#
# ███╗   ███╗██╗   ██╗██╗  ████████╗██╗██████╗ ██╗     ██╗████████╗██╗   ██╗
# ████╗ ████║██║   ██║██║  ╚══██╔══╝██║██╔══██╗██║     ██║╚══██╔══╝╚██╗ ██╔╝
# ██╔████╔██║██║   ██║██║     ██║   ██║██████╔╝██║     ██║   ██║    ╚████╔╝
# ██║╚██╔╝██║██║   ██║██║     ██║   ██║██╔═══╝ ██║     ██║   ██║     ╚██╔╝
# ██║ ╚═╝ ██║╚██████╔╝███████╗██║   ██║██║     ███████╗██║   ██║      ██║
# ╚═╝     ╚═╝ ╚═════╝ ╚══════╝╚═╝   ╚═╝╚═╝     ╚══════╝╚═╝   ╚═╝      ╚═╝
#
#                            ██╗███╗   ██╗
#                            ██║████╗  ██║
#                            ██║██╔██╗ ██║
#                            ██║██║╚██╗██║
#                            ██║██║ ╚████║
#                            ╚═╝╚═╝  ╚═══╝
#
#      ███╗   ██╗███████╗████████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗
#      ████╗  ██║██╔════╝╚══██╔══╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝
#      ██╔██╗ ██║█████╗     ██║   ██║ █╗ ██║██║   ██║██████╔╝█████╔╝
#      ██║╚██╗██║██╔══╝     ██║   ██║███╗██║██║   ██║██╔══██╗██╔═██╗
#      ██║ ╚████║███████╗   ██║   ╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗
#      ╚═╝  ╚═══╝╚══════╝   ╚═╝    ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
#
############################################################################

# Creating webserver initial config file
echo
echo
echo -e "$CYAN => Creating webserver initial config file $COL_RESET"
echo

# Adding user to group, creating dir structure, setting permissions
sudo mkdir -p /var/www/$SERVER_NAME/html

if [[ ("$SUB_DOMAIN" == "y" || "$SUB_DOMAIN" == "Y") ]]; then
  echo 'include /etc/nginx/blockuseragents.rules;
server {
    if ($blockedagent) {
        return 403;
    }

    if ($request_method !~ ^(GET|HEAD|POST)$) {
        return 444;
    }

    listen 80;
    listen [::]:80;

    server_name '"${SERVER_NAME}"';
    root "/var/www/'"${SERVER_NAME}"'/html/web";
    index index.html index.htm index.php;
    charset utf-8;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location @rewrite {
        rewrite ^/(.*)$ /index.php?r=$1;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log /var/log/nginx/'"${SERVER_NAME}"'.app-access.log;
    error_log /var/log/nginx/'"${SERVER_NAME}"'.app-error.log;

    # allow larger file uploads and longer script runtimes
    client_body_buffer_size  50k;
    client_header_buffer_size 50k;
    client_max_body_size 50k;
    large_client_header_buffers 2 50k;
    sendfile off;

    location ~ ^/index\.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        return 404;
    }

    location ~ \.sh {
        return 404;
    }

    location ~ /\.ht {
        deny all;
    }

    location ~ /.well-known {
        allow all;
    }

    location /phpmyadmin {
        root /usr/share/;
        index index.php;
        try_files $uri $uri/ =404;
        location ~ ^/phpmyadmin/(doc|sql|setup)/ {
            deny all;
        }
        location ~ /phpmyadmin/(.+\.php)$ {
            fastcgi_pass unix:/run/php/php7.4-fpm.sock;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include fastcgi_params;
            include snippets/fastcgi-php.conf;
        }
    }
}
' | sudo -E tee /etc/nginx/sites-available/$SERVER_NAME.conf >/dev/null 2>&1

  sudo ln -s /etc/nginx/sites-available/$SERVER_NAME.conf /etc/nginx/sites-enabled/$SERVER_NAME.conf
  sudo ln -s /var/web /var/www/$SERVER_NAME/html
  sudo systemctl reload php7.4-fpm.service
  sudo systemctl restart nginx.service
  echo -e "$GREEN Done...$COL_RESET"

  if [[ ("$SSL_INSTALL" == "y" || "$SSL_INSTALL" == "Y" || "$SSL_INSTALL" == "") ]]; then

    # Install SSL (with SubDomain)
    echo
    echo -e "Install LetsEncrypt and setting SSL (with SubDomain)"
    echo

    sudo apt -y install letsencrypt
    sudo letsencrypt certonly -a webroot --webroot-path=/var/web --email "$EMAIL" --agree-tos -d "$SERVER_NAME"
    sudo rm /etc/nginx/sites-available/$SERVER_NAME.conf
    sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

    # I am SSL Man!
    echo 'include /etc/nginx/blockuseragents.rules;
server {
    if ($blockedagent) {
            return 403;
    }

    if ($request_method !~ ^(GET|HEAD|POST)$) {
        return 444;
    }

    listen 80;
    listen [::]:80;
    server_name '"${SERVER_NAME}"';
    # enforce https
    return 301 https://$server_name$request_uri;
}

server {
    if ($blockedagent) {
        return 403;
    }

    if ($request_method !~ ^(GET|HEAD|POST)$) {
        return 444;
    }

    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name '"${SERVER_NAME}"';

    root /var/www/'"${SERVER_NAME}"'/html/web;
    index index.php;

    access_log /var/log/nginx/'"${SERVER_NAME}"'.app-access.log;
    error_log  /var/log/nginx/'"${SERVER_NAME}"'.app-error.log;

    # allow larger file uploads and longer script runtimes
    client_body_buffer_size  50k;
    client_header_buffer_size 50k;
    client_max_body_size 50k;
    large_client_header_buffers 2 50k;
    sendfile off;

    # strengthen ssl security
    ssl_certificate /etc/letsencrypt/live/'"${SERVER_NAME}"'/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/'"${SERVER_NAME}"'/privkey.pem;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:ECDHE-RSA-AES128-GCM-SHA256:AES256+EECDH:DHE-RSA-AES128-GCM-SHA256:AES256+EDH:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA:DES-CBC3-SHA:HIGH:!aNULL:!eNULL:!EXPORT:!DES:!MD5:!PSK:!RC4";
    ssl_dhparam /etc/ssl/certs/dhparam.pem;

    # Add headers to serve security related headers
    add_header Strict-Transport-Security "max-age=15768000; preload;";
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Robots-Tag none;
    add_header Content-Security-Policy "frame-ancestors 'self'";

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location @rewrite {
        rewrite ^/(.*)$ /index.php?r=$1;
    }

    location ~ ^/index\.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
        include /etc/nginx/fastcgi_params;
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        return 404;
    }

    location ~ \.sh {
        return 404;
    }

    location ~ /\.ht {
        deny all;
    }

    location /phpmyadmin {
        root /usr/share/;
        index index.php;
        try_files $uri $uri/ =404;
        location ~ ^/phpmyadmin/(doc|sql|setup)/ {
            deny all;
        }
        location ~ /phpmyadmin/(.+\.php)$ {
            fastcgi_pass unix:/run/php/php7.4-fpm.sock;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include fastcgi_params;
            include snippets/fastcgi-php.conf;
        }
    }
}

' | sudo -E tee /etc/nginx/sites-available/$SERVER_NAME.conf >/dev/null 2>&1
  fi

  sudo systemctl reload php7.4-fpm.service
  sudo systemctl restart nginx.service
  echo -e "$GREEN Done...$COL_RESET"

else

  echo 'include /etc/nginx/blockuseragents.rules;
server {
    if ($blockedagent) {
        return 403;
    }

    if ($request_method !~ ^(GET|HEAD|POST)$) {
        return 444;
    }

    listen 80;
    listen [::]:80;

    server_name '"${SERVER_NAME}"' www.'"${SERVER_NAME}"';
    root "/var/www/'"${SERVER_NAME}"'/html/web";
    index index.html index.htm index.php;
    charset utf-8;

    location / {
    try_files $uri $uri/ /index.php?$args;
    }

    location @rewrite {
    rewrite ^/(.*)$ /index.php?r=$1;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log /var/log/nginx/'"${SERVER_NAME}"'.app-access.log;
    error_log /var/log/nginx/'"${SERVER_NAME}"'.app-error.log;

    # allow larger file uploads and longer script runtimes
    client_body_buffer_size  50k;
    client_header_buffer_size 50k;
    client_max_body_size 50k;
    large_client_header_buffers 2 50k;
    sendfile off;

    location ~ ^/index\.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        return 404;
    }

    location ~ \.sh {
        return 404;
    }

    location ~ /\.ht {
        deny all;
    }

    location ~ /.well-known {
        allow all;
    }

    location /phpmyadmin {
        root /usr/share/;
        index index.php;
        try_files $uri $uri/ =404;
        location ~ ^/phpmyadmin/(doc|sql|setup)/ {
            deny all;
        }
        location ~ /phpmyadmin/(.+\.php)$ {
            fastcgi_pass unix:/run/php/php7.4-fpm.sock;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include fastcgi_params;
            include snippets/fastcgi-php.conf;
        }
    }
}
' | sudo -E tee /etc/nginx/sites-available/$SERVER_NAME.conf >/dev/null 2>&1

  sudo ln -s /etc/nginx/sites-available/$SERVER_NAME.conf /etc/nginx/sites-enabled/$SERVER_NAME.conf
  sudo ln -s /var/web /var/www/$SERVER_NAME/html
  sudo systemctl reload php7.4-fpm.service
  sudo systemctl restart nginx.service
  echo -e "$GREEN Done...$COL_RESET"

  if [[ ("$SSL_INSTALL" == "y" || "$SSL_INSTALL" == "Y" || "$SSL_INSTALL" == "") ]]; then

    # Install SSL (without SubDomain)
    echo
    echo -e "Install LetsEncrypt and setting SSL (without SubDomain)"
    echo
    sleep 3

    sudo apt -y install letsencrypt
    sudo letsencrypt certonly -a webroot --webroot-path=/var/web --email "$EMAIL" --agree-tos -d "$SERVER_NAME" -d www."$SERVER_NAME"
    sudo rm /etc/nginx/sites-available/$SERVER_NAME.conf
    sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
    # I am SSL Man!
    echo 'include /etc/nginx/blockuseragents.rules;
server {
    if ($blockedagent) {
        return 403;
    }
    if ($request_method !~ ^(GET|HEAD|POST)$) {
        return 444;
    }
    listen 80;
    listen [::]:80;
    server_name '"${SERVER_NAME}"';
    # enforce https
    return 301 https://$server_name$request_uri;
}

server {
    if ($blockedagent) {
            return 403;
    }
    if ($request_method !~ ^(GET|HEAD|POST)$) {
        return 444;
    }

    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name '"${SERVER_NAME}"' www.'"${SERVER_NAME}"';

    root /var/www/'"${SERVER_NAME}"'/html/web;
    index index.php;

    access_log /var/log/nginx/'"${SERVER_NAME}"'.app-access.log;
    error_log  /var/log/nginx/'"${SERVER_NAME}"'.app-error.log;

    # allow larger file uploads and longer script runtimes
    client_body_buffer_size  50k;
    client_header_buffer_size 50k;
    client_max_body_size 50k;
    large_client_header_buffers 2 50k;
    sendfile off;

    # strengthen ssl security
    ssl_certificate /etc/letsencrypt/live/'"${SERVER_NAME}"'/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/'"${SERVER_NAME}"'/privkey.pem;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:ECDHE-RSA-AES128-GCM-SHA256:AES256+EECDH:DHE-RSA-AES128-GCM-SHA256:AES256+EDH:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA:DES-CBC3-SHA:HIGH:!aNULL:!eNULL:!EXPORT:!DES:!MD5:!PSK:!RC4";
    ssl_dhparam /etc/ssl/certs/dhparam.pem;

    # Add headers to serve security related headers
    add_header Strict-Transport-Security "max-age=15768000; preload;";
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Robots-Tag none;
    add_header Content-Security-Policy "frame-ancestors 'self'";

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location @rewrite {
        rewrite ^/(.*)$ /index.php?r=$1;
    }

    location ~ ^/index\.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
        include /etc/nginx/fastcgi_params;
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        return 404;
    }

    location ~ \.sh {
        return 404;
    }

    location ~ /\.ht {
        deny all;
    }

    location /phpmyadmin {
        root /usr/share/;
        index index.php;
        try_files $uri $uri/ =404;
        location ~ ^/phpmyadmin/(doc|sql|setup)/ {
            deny all;
        }
        location ~ /phpmyadmin/(.+\.php)$ {
            fastcgi_pass unix:/run/php/php7.4-fpm.sock;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include fastcgi_params;
            include snippets/fastcgi-php.conf;
        }
    }
}

' | sudo -E tee /etc/nginx/sites-available/$SERVER_NAME.conf >/dev/null 2>&1

    echo -e "$GREEN Done...$COL_RESET"

  fi

fi

sudo systemctl reload php7.4-fpm.service
sudo systemctl restart nginx.service
