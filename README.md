# mecodify-docker

This is a GitHub repo for those wishing to create a functional Ubuntu-based server with [mecodify](https://github.com/wsaqaf/mecodify) readily installed without having to worry about the need to install dependencies and do other setup. If you don't know how Docker works, check out this [useful guide](https://prakhar.me/docker-curriculum/).

This repo is based on a repo [mattrayner/docker-lamp](https://github.com/mattrayner/docker-lamp), which itself is a fork of [tutumcloud/tutum-docker-lamp](https://github.com/tutumcloud/lamp) and was inspired by [dgraziotin-lamp](https://github.com/dgraziotin/osx-docker-lamp). I made a few modifications and added the mecodify-related files that are necessary for the application to work.

So far, this repo has been demonstrated to work on Mac OSx but not on Windows. If you wish to provide feedback on how to adjust it to work on a Windows machine, please [contact us](mailto:admin@mecodify.org).

### Requirements

##### 1) Get your Twitter API 2.0 BEARER token

To use Mecodify, you must have already generated a bearer token that can be used to access Twitter API 2.0 endpoints. This can either be for a free limited sandbox app or for an app that has received approval with a premium license, for example through the Academic track. See instructions [here]().

The most important information you will need is the bearer token, which you should protect and keep private since it is like a password that should never be shared.

##### 2) Install Docker

If you haven't done so, ensure you have installed and started running Docker. You can find the official downloadable packages [here](https://www.docker.com/products/docker-desktop).

##### 3) Download the Mecodify Docker repo

You can clone the repo or download the compressed files in [this repo](https://github.com/wsaqaf/mecodify-docker/archive/master.zip) and uncompress it on your device. Then you should use the command prompt (Terminal) to go inside the folder that is just created.

### Installation

Assuming that you already have docker installed (get it from [here](https://docs.docker.com/engine/installation/) if you haven't).

Run Terminal and change to the directory where you downloaded and uncompressed the Mecodify docker files. It should contain a file named 'Dockerfile'.

Once in the folder, run the following command:

    bash ./go.sh

Be ready to provide your BEARER token if you haven't done so in an earlier installation.

The above command may take a few minutes or more (depending on your connection and processor speed) and should create two docker images, one for wsaqaf/mecodify and one for the Ubuntu base image (phusion/baseimage). The total could taking just over 3GB storage since they include a lot of files for ubuntu, apache, php, phpmyadmin, mysql along with mecodify.

##### Running Mecodify

Once installation is complete, you will get a note saying that you can open the platform using the local address: [127.0.0.1](http://127.0.0.1) or [localhost](http://localhost) with your browser. In case you decided to use a port other than the default 80, don't forget to include it (e.g, if it is 8080, go to localhost:8080).
From this point onwards, you can follow the instructions found in the original [GitHub repo of Mecodify](https://github.com/wsaqaf/mecodify/blob/master/manual.md) to create accounts and add cases.

To learn how to navigate through Mecodify, you can check out [its documentation](https://github.com/wsaqaf/mecodify/blob/master/manual.md).

If you wish to work on the raw data collected by Mecodify, you should also be able to access the phpMyAdmin database entry at [localhost/phpmyadmin](http://localhost/phpmyadmin) to navigate and drill into the different tables under the *Mecodify* database. The default credentials are username *root* and without a password.

#####

##### Notes

###### Thanks to the great work by [mattrayner](https://github.com/mattrayner/docker-lamp) and [dgraziotin](https://github.com/dgraziotin), data in the folders mysql and app folders (in our case ./mecodify) are made so that they are persistent and updated in parallel both in the container and in the host. So whatever work you do on mecodify will be preserved. You can double check to make sure.

###### Apart from the Twitter API settings, the configurations.php file located in the ./mecodify directory has default values including the database and user name. If you are considering having this public, it is wise to not use docker but install each required components separately as explained in the official [GitHub repo](https://github.com/wsaqaf/mecodify).

###### In case Docker is restarted, all you need is to run the container again (from the interface or command prompt). The images, database and files are all preserved in the file system.

###### You can also access Mecodify's data directly on MySQL using phpMyAdmin by going to http://localhost/phpmyadmin and using the mysql credentials in the configuration file.

##### Be careful in handling the folder where you first installed the repo since losing the files there or overwriting them may mean that all your work is gone. You are recommended to keep backups in case.

###### You can also access Mecodify's data directly on MySQL using phpMyAdmin by going to http://localhost/phpmyadmin and using the mysql credentials in the configuration file.

##### Still experimental

This repo is in development and we hope to improve it over time. Feel free to contribute, test and support this work. Note that the docker version is meant to be run locally on your device and therefore it uses the 'root' username and no password for the mysql server. If you wish to use it on a server, it is *highly recommended* to update the mysql login credentials manually.

A special thank you goes to [pvanheus](https://github.com/pvanheus) for suggesting to create a docker for Mecodify. I also wish to thank members of the open-source community who have provided the community with the code that was used in this repo.

Mecodify developer: [Walid Al-Saqaf](https://github.com/wsaqaf)
