	FROM node:alpine
	WORKDIR /usr/src/app
	COPY hello-bootcamp/package*.json /usr/src/app/
	RUN npm i
	COPY hello-bootcamp/. .
	CMD ["npm","start"]
