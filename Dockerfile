FROM node:20-alpine

#create a dedicated non-root user (higher security for us)
RUN addgroup -S app && adduser -S -G app app

#set working directory
WORKDIR /app

#give the empty app directory to the app user
RUN chown app:app /app

#switch to the non-root user immediately
USER app

#copy package files and assign ownership during the copy step
COPY --chown=app:app package*.json ./

#install exactly the versions from package-lock
RUN npm ci

#copy the rest of the source code and assign ownership during the copy
COPY --chown=app:app . .

#build the production bundle into /dist
RUN npm run build

#preview server listens on this port
EXPOSE 4173

#bind to 0.0.0.0 so the server is reachable from outside the container
CMD ["npm", "run", "preview", "--", "--host", "0.0.0.0", "--port", "4173"]
