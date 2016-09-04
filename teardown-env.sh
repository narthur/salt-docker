#!/bin/bash

docker stop hf-mysql hf-test-mysql hf-wordpress
docker rm hf-mysql hf-test-mysql hf-wordpress
sudo rm -r ./data/
sudo rm -r ./test-data/
