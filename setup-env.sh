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
docker exec salt-wordpress /bin/bash -c "wp post create --post_title='Lay Training' --post_content='CONTENT' --allow-root --post_type=page --post_status=publish"
docker exec salt-wordpress /bin/bash -c "wp post create --post_title='Orphans' --post_content='CONTENT' --allow-root --post_type=page --post_status=publish"
docker exec salt-wordpress /bin/bash -c "wp post create --post_title='Children\'s Education' --post_content='CONTENT' --allow-root --post_type=page --post_status=publish"
docker exec salt-wordpress /bin/bash -c "wp post create --post_title='Multimedia Production' --post_content='CONTENT' --allow-root --post_type=page --post_status=publish"
docker exec salt-wordpress /bin/bash -c "wp post create --post_title='Butterfly Paradise' --post_content='CONTENT' --allow-root --post_type=page --post_status=publish"
docker exec salt-wordpress /bin/bash -c "wp post create --post_title='Hooftrek' --post_content='CONTENT' --allow-root --post_type=page --post_status=publish"

docker exec salt-wordpress /bin/bash -c "wp media import /root/images/thumb-1.jpeg --post_id=1 --featured_image --allow-root"
docker exec salt-wordpress /bin/bash -c "wp media import /root/images/thumb-2.jpeg --post_id=2 --featured_image --allow-root"
docker exec salt-wordpress /bin/bash -c "wp media import /root/images/thumb-3.jpeg --post_id=3 --featured_image --allow-root"
docker exec salt-wordpress /bin/bash -c "wp media import /root/images/thumb-4.jpeg --post_id=4 --featured_image --allow-root"
docker exec salt-wordpress /bin/bash -c "wp media import /root/images/thumb-5.jpeg --post_id=5 --featured_image --allow-root"
docker exec salt-wordpress /bin/bash -c "wp media import /root/images/thumb-6.jpeg --post_id=6 --featured_image --allow-root"
