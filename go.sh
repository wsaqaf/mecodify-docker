#!/bin/bash
clear

FILE="${PWD}/mecodify/configurations.php"

create_db=0;

  if [ ! -f "$FILE" ]; then
     printf "Creating a new configurations.php file\n";
     cp "${PWD}/mecodify/configurations_empty.php" $FILE;
     create_db=1;
  else
     printf "Using the current configurations.php file\n";
  fi

  if grep -Eq '"bearer"[[:space:]]*=>[[:space:]]*""' $FILE; then
     printf "It appears that you have not added the Twitter API 2.0 BEARER token into the configurations file.\n"
     while true; do
         read -rp "Do you have a Twitter API premium account (e.g., based on an Academic license)? [Y/n]: " yn
         case $yn in
      	  [Yy]* )
    			  printf "Setting the license type to premium...\n";
    			  sed -i '' 's/"is_premium"[[:blank:]]*=>[[:blank:]]*false/"is_premium" => true/' $FILE;
    			  break;;
          [Nn]* )
		          printf "Setting the license type to sandbox (limited)...\n";
            sed -i '' 's/"is_premium"[[:blank:]]*=>[[:blank:]]*true/"is_premium" => false/' $FILE;
            break;;
          "")
            sed -i '' 's/"is_premium"[[:blank:]]*=>[[:blank:]]*false/"is_premium" => true/' $FILE;
            break;;
      		* ) printf "Please answer with y or n.\n";
   		  esac
      done
      printf "Please copy the full BEARER token and paste it below. This will only be required once.\n"
      read -rp "BEARER token: " token
      if [ ${#token} -ge 10 ]; then
            etoken=$(printf '%s\n' "$token" | sed -e 's/[\/&]/\\&/g')
            sed -i '' 's/"bearer"[[:blank:]]*=>[[:blank:]]*""[[:blank:]]*,/"bearer" => "'"$etoken"'",/' $FILE;
      else
            printf "Invalid token. exiting...\n\n";
            exit;
      fi
  elif grep -Eq '"bearer"[[:space:]]*=>[[:space:]]*".+"' $FILE; then
    printf "Using the code BEARER token already in the configuration file. You can change it manually any time.\n"
  else
    printf "the configuration file is corrupted. Exiting...\n\n";
    exit;
  fi

  printf "Creating docker images and the Mecodify app container...\n";

  if [ -d "${PWD}/mysql" ]; then
      printf "You have an existing mysql Mecodify database.\n"
      while true; do
  	read -rp "Do you wish to keep or delete it? Enter y to keep, n to delete: [Y/n]" yn
  	case $yn in
  	   [Yn]* ) break;;
           [Nn]* ) rm -rf "${PWD}/mysql"; break;;
       	   "") break;;
  	   * ) printf "Please answer yes or no. \n";
      	esac
      done
  else
      printf "Creating mecodify mysql database...\n\n";
      create_db=1;
  fi

  docker buildx build --platform linux/amd64 -t wsaqaf/mecodify .

  docker kill `docker ps -aqf "name=mecodify"` &>/dev/null;
  docker rm `docker ps -aqf "name=mecodify"` &>/dev/null;
  docker run --platform linux/amd64 -d -i -t -p "80:80" -p "3306:3306" -v ${PWD}/mysql:/var/lib/mysql -v ${PWD}/mecodify:/mecodify --name mecodify wsaqaf/mecodify;
  docker cp mecodify/configurations.php `docker ps -aqf "name=mecodify"`:/var/www/html &>/dev/null;
  printf "Initializing and running server. Please wait.";

  i=60

  if [ $create_db=1 ]; then  
      docker exec -it mecodify service mysql start &>/dev/null;
      docker exec -it mecodify mysql -uroot -e "create database if not exists mecodify" &>/dev/null;
  fi

  while ! curl --output /dev/null --silent --head --fail localhost
          do printf "."
          sleep 1
          if [ $i -le 0 ]; then
            printf "Installation failed. Troubleshoot container's log files for errors.\n\n";
            exit;
      	 fi
	 ((i--)) 	 
  done
  printf " Installation complete!\n\nOpen http://127.0.0.1 with your browser to access the Mecodify platform.\n";
