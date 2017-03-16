#!/bin/bash

docker kill `docker ps -aqf "name=mecodify"`;
docker rm `docker ps -aqf "name=mecodify"`;
docker run -d -i -t -p "80:80" -p "3306:3306" -v ${PWD}/mysql:/var/lib/mysql -v ${PWD}/app:/app --name mecodify wsaqaf/mecodify;
docker cp mecodify/configurations.php `docker ps -aqf "name=mecodify"`:/var/www/html
