FROM wordpress

VOLUME [ "/usr/src/wordpress/wp-content/plugins/wp-salt-theme" ]

COPY disable-canonical-redirects.php /usr/src/wordpress/wp-content/plugins/

COPY wp-cli.yml .

COPY wp-cli.phar .

COPY wp-config.php .
COPY wp-config.php /usr/src/wordpress

COPY option-sidebar_widgets.txt .

RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

RUN apt-get update

RUN apt-get install -y mysql-client nano

ENV TERM xterm
