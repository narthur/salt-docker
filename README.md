# hf-docker

## Basic Usage Instructions

1. Install [Docker](http://www.docker.com/).
2. Clone this repository to your local machine: `git clone https://github.com/narthur/salt-docker.git`
3. `cd` into your local copy.
4. Make shell files executable: `chmod +x *.sh`
5. Start the environment: `./restart-env.sh`
6. Load the site in a browser: [http://localhost:8080/](http://localhost:8080/)

## More Info

Prepare to start env:

    chmod +x setup-env.sh
    chmod +x teardown-env.sh
    chmod +x restart-env.sh

Start env:

    ./setup-env.sh

To access WordPress after starting the env, browse to http://localhost:8080/ in
a browser.

Stop env:

    ./teardown-env.sh

Running a command in container from host proof of concept:

    docker exec salt-wordpress /bin/bash -c 'cd /usr/src/wordpress && ls'

Jump into a machine:

    docker exec -it salt-wordpress bash

Inside WordPress machine, list plugins:

    wp plugin list --allow-root --path=/usr/src/wordpress

Inside WordPress machine, access MySQL database:

    mysql --host=mysql -pqwerqwer

Inside machine, see all environment variables, including ones created by Docker:

    printenv

Jump out of a machine:

    ctrl+p+q
