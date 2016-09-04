#!/bin/bash

docker build -t salt/salt-docker .

if [ ! -d "wp-salt-theme" ]; then
  git clone https://github.com/narthur/wp-salt-theme.git
fi

docker run --name salt-mysql -v `pwd`/data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=qwerqwer \
  -e MYSQL_DATABASE=salt \
  -e MYSQL_USER=salt \
  -e MYSQL_PASSWORD=saltpass \
  -d mysql

docker run --name salt-wordpress --link salt-mysql:mysql \
  -v `pwd`/wp-salt-theme:/var/www/html/wp-content/themes/wp-salt-theme \
  -v `pwd`/wp-salt-theme:/usr/src/wordpress/wp-content/themes/wp-salt-theme \
  -p 8080:80 -d salt/salt-docker

docker ps

echo 'Install WordPress'
NEXT_WAIT_TIME=0
MAX_WAIT_TIME=15
until docker exec salt-wordpress /bin/bash -c 'cd /usr/src/wordpress && wp core install --allow-root --url=http://localhost:8080 --title=SALT --admin_user=admin --admin_password=saltpass --admin_email=nathan@nathanarthur.com --skip-email' || [ $NEXT_WAIT_TIME -eq $MAX_WAIT_TIME ]; do
    docker start salt-wordpress
    sleep $(( NEXT_WAIT_TIME++ ))
done

echo 'Activate Plugins'
docker exec salt-wordpress /bin/bash -c 'chown www-data /var/www/html/wp-content/plugins/disable-canonical-redirects.php'
docker exec salt-wordpress /bin/bash -c 'wp plugin activate disable-canonical-redirects --allow-root --path=/usr/src/wordpress'

echo 'Activate Theme'
docker exec salt-wordpress /bin/bash -c 'wp theme activate wp-salt-theme --allow-root'

echo 'Update Options'
docker exec salt-wordpress /bin/bash -c 'wp option update default_comment_status close --allow-root'
docker exec salt-wordpress /bin/bash -c 'wp option update sidebars_widgets --format=json --allow-root < option-sidebar_widgets.txt'

echo 'Create Content'
# docker exec hf-wordpress /bin/bash -c "wp post create --allow-root --post_type=page --post_status=publish --post_title='Settings' --post_content='[hfSettings]'"
# docker exec hf-wordpress /bin/bash -c "wp post create --allow-root --post_type=page --post_status=publish --post_title='Authenticate' --post_content='[hfAuthenticate]'"
# docker exec hf-wordpress /bin/bash -c "wp post create --allow-root --post_type=page --post_status=publish --post_title='Goals' --post_content='[hfGoals]'"
# docker exec hf-wordpress /bin/bash -c "wp post create --allow-root --post_type=page --post_status=publish --post_title='Partners' --post_content='[hfManagePartners]'"
