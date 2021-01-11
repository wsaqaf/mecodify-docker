# mecodify-docker

This is a GitHub repo for those wishing to create a functional Ubuntu-based server with [mecodify](https://github.com/wsaqaf/mecodify) readily installed without having to worry about the need to install dependencies and do other setup. If you don't know how Docker works, check out this [useful guide](https://prakhar.me/docker-curriculum/).

This repo is based on a repo [osx-docker-lamp](https://github.com/dgraziotin/osx-docker-lamp), a.k.a dgraziotin/lamp, which itself is a fork of [tutumcloud/tutum-docker-lamp](https://github.com/tutumcloud/lamp). I made a few modifications and added the mecodify-related files that are necessary for the application to work.

So far, this repo has been demonstrated to work on Mac OSx but not on Windows. If you wish to provide feedback on how to adjust it to work on a Windows machine, please [contact us](mailto:admin@mecodify.org).

### Usage

##### 1) Download repo

You can clone the repo or download the compressed files in [this repo](https://github.com/wsaqaf/mecodify-docker/archive/master.zip) and uncompress it on your device. Then you should use the command prompt (Terminal) to go inside the folder that is just created.

##### 2) Create the docker images

Assuming that you already have docker installed (get it from [here](https://docs.docker.com/engine/installation/) if you don't), in the directory where the Dockerfile file is located, run the following:

        docker build -t wsaqaf/mecodify .

The above command may take a few minutes or more (depending on your connection and processor speed) and should create two docker images, one for wsaqaf/mecodify and one for the Ubuntu base image (phusion/baseimage). The total could taking just over 900MB storage since they include a lot of files for ubuntu, apache, php, phpmyadmin, mysql along with mecodify.

##### 3) Add Twitter API Settings

You will find the file configurations_empty.php in the mecodify folder. Rename it and fill in the website_url value and change any of the others if you need to. Additionally, you need to add values for the *twitter_api_settings* variable since it will not be possible for mecodify to extract tweets without doing so. You would then need to add the obtained information into *configurations.php*, namely the following four lines need to be filled. You don't need to create the app itself (don't move on to the next step of the tutorial):

    $twitter_api_settings=array(
            'bearer' => "",
            'is_premium' => true
        );

For the *bearer* value, enter the bearer token code you have for the Twitter app (usually starting with 'AAAA').
For the *is_premium* value, specify if the account is free (sandbox) or premium. Change to *false* if you don't have a premium account.

Everything else in the configuration file can remain the same.

##### 4) Create container (needed when docker is restared or configurations.php is modified)

Run the following command from on the terminal window while in the folder where Dockerfile is located:

    . go.sh

The above command would run the container and have it accessible via port 80. If the port is being used by another server, it can be changed by modifying the relevant line in the go.sh file.

##### 5) Start using mecodify

Open [localhost](http://localhost) with your browser. In case you decided to use a port other than the default 80, don't forget to include it (e.g, if it is 8080, go to localhost:8080).
From this point onwards, you can follow the instructions found in the original [GitHub repo of Mecodify](https://github.com/wsaqaf/mecodify/blob/master/manual.md) to create accounts and add cases.

##### Notes

###### Thanks to the great work by [dgraziotin](https://github.com/dgraziotin), data in the folders mysql and app folders (in our case ./mecodify) are made so that they are persistent and updated in parallel both in the container and in the host. So whatever work you do on mecodify will be preserved. You can double check to make sure.

###### Apart fromt he Twitter API settings, the configurations.php file located in the ./mecodify directory has default values including the database and user name. If you are considering having this public, it is wise to not use docker but install each required components separately as explained in the official [GitHub repo](https://github.com/wsaqaf/mecodify).

###### Only step (4) above is required when docker is restarted since the images are preserved in the file system. All the steps would need to be re-done if the files are removed or docker re-installed.  

##### Still experimental

This repo is in its early initiation stage and we hope to improve it over time. Feel free to contribute, test and support this work.

A special thank you goes to [pvanheus](https://github.com/pvanheus) for suggesting to create a docker for Mecodify. I also wish to thank members of the open-source community who have provided the community with the code that was used in this repo.

Mecodify developer: [Walid Al-Saqaf](https://github.com/wsaqaf)
