FROM node:20-alpine AS builder

WORKDIR /app

RUN npm install -g npm@11

COPY package*.json ./
COPY packages ./packages
COPY babel.config.js ./

RUN npm install

FROM node:20-alpine

WORKDIR /app

COPY --from=builder /app /app

EXPOSE 3000

CMD ["npm", "run", "dev"]
