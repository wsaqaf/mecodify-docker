#!/bin/bash
clear

FILE="${PWD}/mecodify/configurations.php"

  if [ ! -f "$FILE" ]; then
     printf "Creating a new configurations.php file\n"
     cp "${PWD}/mecodify/configurations_empty.php" $FILE
  fi

  if grep -Eq '"bearer"[[:space:]]*=>[[:space:]]*""' $FILE; then
     printf "It appears that you have not added the Twitter API 2.0 BEARER token into the configurations file.\n"
     while true; do
         read -p "Do you have a Twitter API premium account (e.g., based on an Academic license)? [Y/n]: " yn
         case $yn in
      		[Yy]* )
    			  printf "Setting the license type to premium...\n";
    			  sed -i '' 's/"is_premium"[[:blank:]]*=>[[:blank:]]*false/"is_premium" => true/' $FILE;
    			  break;;
      		[Nn]* )
		          printf "Setting the license type to sandbox (limited)...\n";
            sed -i '' 's/"is_premium"[[:blank:]]*=>[[:blank:]]*true/"is_premium" => false/' $FILE;
            break;;
      		* ) printf "Please answer with y or n.\n";
   		  esac
      done
      printf "Please copy the full BEARER token and paste it below. This will only be required once.\n"
      read -rp "BEARER token: "token
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
  	read -rp "Do you wish to keep or delete it? Enter y to keep, n to delete: [Y/n]" -i "y" yn
  	case $yn in
  	   [Yy]* ) rm -rf "${PWD}/mysql"; break;;
  	   [Nn]* ) break;;
  	   * ) printf "Please answer yes or no. \n";
      	esac
      done
  else
      printf "Creating Mecodify mysql database...\n\n";
  fi

  docker build -t wsaqaf/mecodify .

  docker kill `docker ps -aqf "name=mecodify"` &>/dev/null;
  docker rm `docker ps -aqf "name=mecodify"` &>/dev/null;
  docker run -d -i -t -p "80:80" -p "3306:3306" -v ${PWD}/mysql:/var/lib/mysql -v ${PWD}/mecodify:/mecodify --name mecodify wsaqaf/mecodify;
  docker cp mecodify/configurations.php `docker ps -aqf "name=mecodify"`:/var/www/html &>/dev/null;
  printf "Initializing and running server. Please wait.";

  while ! curl --output /dev/null --silent --head --fail localhost
          do printf "."
          sleep 1
  done
  printf " Installation complete!\n\nOpen http://127.0.0.1 with your browser to access the Mecodify platform.\n";
