FROM node:20-alpine AS builder
WORKDIR /app

# Cài npm mới nhất
RUN npm install -g npm@11

# Copy file lock và package.json
COPY package.json package-lock.json ./

# Cài dependencies
RUN npm install

# Copy các thư mục cần thiết
COPY packages ./packages
COPY extensions ./extensions
COPY translations ./translations

# Build packages (thường dùng typescript hoặc lerna)
RUN npm run build:packages

# Build toàn bộ app
RUN npm run build

EXPOSE 80
CMD ["npm", "run", "start"]
