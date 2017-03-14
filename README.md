# mecodify-docker

This is a GitHub repo for those wishing to create a functional Ubuntu-based server with [mecodify](https://github.com/wsaqaf/mecodify) readily installed without having to worry about the need to install dependencies and do other setup. If you don't know how Docker works, check out this [useful guide](https://prakhar.me/docker-curriculum/).

This repo is based on a repo [osx-docker-lamp](https://github.com/dgraziotin/osx-docker-lamp), a.k.a dgraziotin/lamp, which itself is a fork of [tutumcloud/tutum-docker-lamp](https://github.com/tutumcloud/lamp). I made a few modifications and added the mecodify-related files that are necessary for the application to work. 

### Usage

##### 1) Create image

Assuming that you already have docker installed (get it from [here](https://docs.docker.com/engine/installation/) if you don't), go to the main directory where the Dockerfile file is and run (note: depending on your priviliges, you may need to run the below commans as admin):

        docker build -t wsaqaf/mecodify .

The above command may take a few minutes or more (depending on your connection and processor speed) and should create two docker images, one for wsaqaf/mecodify and one for the Ubuntu base image (phusion/baseimage). The total could taking just over 900MB storage since they include a lot of files for ubuntu, apache, php, phpmyadmin, mysql along with mecodify.

##### 2) Configure mecodify/configurations.php

You will find the file configurations.php in the mecodify folder. Go there and add the details as instructed. The only compulsory entry would be the email of the admin as well as the Twitter API credentials since it will not be possible for mecodify to extract tweets without them. Everything else can remain the same although it is good practice to change them to something that works for you.

##### 3) Create container

To create the docker container and run mecodify directly from the localhost, ensure that port 80 is free and if it is not, feel free to change "80:" to any available port such as "8080:", then run:

        docker run -d -i -t -p "80:80" -p "3306:3306" -v ${PWD}/mysql:/var/lib/mysql -v ${PWD}/app:/app -e MYSQL_USER_NAME="admin" -e MYSQL_ADMIN_PASS="mecodify_pw" -e MYSQL_USER_DB="MECODIFY" --name mecodify wsaqaf/mecodify

Notice that the above database name, user name and passwords are possible to alter to your liking but they have to match exactly what exists in the configurations.php file in the ./mecodify directory. The above settings should be working by default since they are what the configuration file contains by default.

Once the container is successfully created and is running in the background (you can check by running 'docker ps'), you are ready to test by opening localhost in your browser. You should then find Mecodify's main page if everything works fine.

##### 4) Start using mecodify

Open [localhost](http://localhost) with your browser. In case you decided to use a port other than the default 80, don't forget to include it (e.g, if it is 8080, go to localhost:8080).
From this point onwards, you can follow the instructions found in the original [GitHub repo of Mecodify](https://github.com/wsaqaf/mecodify/blob/master/manual.md) to create accounts and add cases.

##### Note about persistence

Thanks to the great work by [dgraziotin](https://github.com/dgraziotin), data in the folders mysql and app folders (in our case ./mecodify) are made so that they are persistent and updated in parallel both in the container and in the host. So whatever work you do on mecodify will be preserved. You can double check to make sure.

##### Still experimental

This repo is in its early initiation stage and we hope to improve it over time. Feel free to contribute, test and support this work.

A special thank you goes to [pvanheus](https://github.com/pvanheus) for suggesting to create a docker for Mecodify. I also wish to thank members of the open-source community who have provided the community with the code that was used in this repo.

Mecodify developer: [Walid Al-Saqaf](https://github.com/wsaqaf)
