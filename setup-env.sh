#!/bin/bash

docker build -t habitfree/hf-wp-docker .


if [ ! -d "wp-accountability" ]; then
  git clone https://github.com/HabitFree/wp-accountability.git
fi

if [ ! -d "wp-hf-theme" ]; then
  git clone https://github.com/HabitFree/wp-hf-theme.git
fi

docker run --name hf-mysql -v `pwd`/data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=qwerqwer \
  -e MYSQL_DATABASE=habitfree \
  -e MYSQL_USER=habitfree \
  -e MYSQL_PASSWORD=hfpass \
  -d mysql

docker run --name hf-test-mysql -v `pwd`/test-data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=qwerqwer \
  -e MYSQL_DATABASE=wp_test \
  -e MYSQL_USER=wp_test \
  -e MYSQL_PASSWORD=hftest \
  -p 3306:3306 -d mysql

docker run --name hf-wordpress --link hf-mysql:mysql \
  -v `pwd`/wp-accountability:/var/www/html/wp-content/plugins/wp-accountability \
  -v `pwd`/wp-accountability:/usr/src/wordpress/wp-content/plugins/wp-accountability \
  -v `pwd`/wp-hf-theme:/var/www/html/wp-content/themes/wp-hf-theme \
  -v `pwd`/wp-hf-theme:/usr/src/wordpress/wp-content/themes/wp-hf-theme \
  -p 8080:80 -d habitfree/hf-wp-docker

until nc -z localhost 3306; do
    echo "$(date) - waiting for mysql..."
    sleep 1
done

docker ps

echo 'Install WordPress'
NEXT_WAIT_TIME=0
MAX_WAIT_TIME=15
until docker exec hf-wordpress /bin/bash -c 'cd /usr/src/wordpress && wp core install --allow-root --url=http://localhost:8080 --title=HabitFree --admin_user=admin --admin_password=hfpass --admin_email=info@habitfree.org --skip-email' || [ $NEXT_WAIT_TIME -eq $MAX_WAIT_TIME ]; do
    docker start hf-wordpress
    sleep $(( NEXT_WAIT_TIME++ ))
done

echo 'Activate Plugins'
docker exec hf-wordpress /bin/bash -c 'chown www-data /var/www/html/wp-content/plugins/disable-canonical-redirects.php'
docker exec hf-wordpress /bin/bash -c 'wp plugin activate disable-canonical-redirects wp-accountability --allow-root --path=/usr/src/wordpress'

echo 'Activate Theme'
docker exec hf-wordpress /bin/bash -c 'wp theme activate wp-hf-theme --allow-root'

echo 'Update Options'
docker exec hf-wordpress /bin/bash -c 'wp option update default_comment_status close --allow-root'
docker exec hf-wordpress /bin/bash -c 'wp option update sidebars_widgets --format=json --allow-root < option-sidebar_widgets.txt'

echo 'Create Content'
docker exec hf-wordpress /bin/bash -c "wp post create --allow-root --post_type=page --post_status=publish --post_title='Settings' --post_content='[hfSettings]'"
docker exec hf-wordpress /bin/bash -c "wp post create --allow-root --post_type=page --post_status=publish --post_title='Authenticate' --post_content='[hfAuthenticate]'"
docker exec hf-wordpress /bin/bash -c "wp post create --allow-root --post_type=page --post_status=publish --post_title='Goals' --post_content='[hfGoals]'"
docker exec hf-wordpress /bin/bash -c "wp post create --allow-root --post_type=page --post_status=publish --post_title='Partners' --post_content='[hfManagePartners]'"
