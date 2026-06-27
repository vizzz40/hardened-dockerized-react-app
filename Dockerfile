FROM node:20-alpine

#create a dedicated non-root user
RUN addgroup -S app && adduser -S -G app app

#all app files under /app
WORKDIR /app

#"npm ci" to install the exact versions from package-lock.json
COPY package*.json ./
RUN npm ci

#now copy rest of the source and build the production bundle into /dist
COPY . .
RUN npm run build

#give non-root use ownership of the app, and then switch to it
RUN chown -R app:app /app
USER app

#preview server listens on this port
EXPOSE 4173

#bind to 0.0.0.0 so the server is reachable from outside the container
CMD ["npm", "run", "preview", "--", "--host", "0.0.0.0", "--port", "4173"]
