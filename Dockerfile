FROM node:18-alpine
WORKDIR /app
RUN npm install -g npm@9

# COPY package.json + package-lock.json → install dependencies
COPY package*.json ./ 
RUN npm install

# COPY tất cả thư mục source code
COPY packages ./packages
COPY themes ./themes
COPY extensions ./extensions
COPY public ./public
COPY media ./media
COPY config ./config
COPY translations ./translations

RUN npm run build

EXPOSE 3000
CMD ["npm", "run", "start"]

