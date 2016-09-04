#!/bin/bash

docker stop salt-mysql salt-wordpress
docker rm salt-mysql salt-wordpress
sudo rm -r ./data/
