#!/bin/bash

docker kill `docker ps -aqf "name=mecodify"` &>/dev/null;
docker rm `docker ps -aqf "name=mecodify"` &>/dev/null;
docker run -d -i -t -p "80:80" -p "3306:3306" -v ${PWD}/mysql:/var/lib/mysql -v ${PWD}/app:/app --name mecodify wsaqaf/mecodify;
docker cp mecodify/configurations.php `docker ps -aqf "name=mecodify"`:/var/www/html &>/dev/null;
printf "Initializing and running server. Please wait.";

while ! curl --output /dev/null --silent --head --fail localhost
        do printf "."
        sleep 1
done
printf " Installation complete!\n\nOpen http://127.0.0.1 with your browser to access the Mecodify platform.\n";
