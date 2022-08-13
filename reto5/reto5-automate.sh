#!/bin/bash

# Get folder with node app
if [[ ! -d hello-bootcamp ]]; then
	mkdir hello-bootcamp && mkdir hello-bootcamp/public
	cd hello-bootcamp  
	wget -q https://raw.githubusercontent.com/roxsross/bootcamp-3-challenge/master/reto5/hello-bootcamp/server.js
	wget -q https://raw.githubusercontent.com/roxsross/bootcamp-3-challenge/master/reto5/hello-bootcamp/package.json
	wget -q https://raw.githubusercontent.com/roxsross/bootcamp-3-challenge/master/reto5/hello-bootcamp/package-lock.json
	wget -q https://raw.githubusercontent.com/roxsross/bootcamp-3-challenge/master/reto5/hello-bootcamp/index.html
	cd public
	wget -q https://raw.githubusercontent.com/roxsross/bootcamp-3-challenge/master/reto5/hello-bootcamp/public/style.css
	wget -q https://raw.githubusercontent.com/roxsross/bootcamp-3-challenge/master/reto5/hello-bootcamp/public/site.js
	cd ../..
	echo -e "\e[95mCarpeta de app node hello-bootcamp\e[0m creada \e[32m$(printf "\u2714")\e[0m"
fi

# Create Dockerfile
if [[ ! -f Dockerfile ]]; then
	cat > Dockerfile << EOF
	FROM node:alpine
	WORKDIR /usr/src/app
	COPY hello-bootcamp/package*.json /usr/src/app/
	RUN npm i
	COPY hello-bootcamp/. .
	CMD ["npm","start"]
EOF
echo -e "\e[95mDockerfile\e[0m creado \e[32m$(printf "\u2714")\e[0m"
fi
echo

#Build image
if ! docker images | grep "node-bootcamp" > /dev/null ; then
	docker build -t node-bootcamp:1.0.0 .
	echo -e "\e[95mImagen node-bootcamp\e[0m creada \e[32m$(printf "\u2714")\e[0m"
else
		echo -e "\e[95mLa imagen node-bootcamp\e[0m ya existe"
fi

# Run container with app
if ! docker ps -a | grep "node-bootcamp-container" > /dev/null ; then
	docker run -d --rm  -p 4000:4000 --name node-bootcamp-container  node-bootcamp:1.0.0
	echo -e "\e[95mContenedor node-bootcamp-container\e[0m corriendo \e[32m$(printf "\u2714")\e[0m"
	echo -e "\e[95mPuede checarlo en el navegador con \e[0mlocalhost:4000"
	
	#Dockerhub registry
	echo -e "\e[95m¿Desea llevar su imagen al registro de Dockerhub? [y/n]:\e[0m "
	read -n 1 answer
	echo
	if [[ $answer == "y" ]]; then
		docker stop node-bootcamp-container
		echo -e "\e[95mIngrese su usuario de Dockerhub:\e[0m "
		read useer
		echo
		docker tag  node-bootcamp:1.0.0 $useer/node-app-bootcamp:1.0.0
		echo -e "\e[95mIngrese su contraseña de Dockerhub:\e[0m "
		read -s passs
		echo
		docker login -u $useer -p $passs
		docker push $useer/node-app-bootcamp:1.0.0
		echo -e "\e[95mImagen node-app-bootcamp\e[0m registrada en Dockerhub \e[32m$(printf "\u2714")\e[0m"
	elif [[ $answer == 'n' ]]; then
		echo -e "\e[95mDisfrutalo!\e[0m"
	fi
fi

