FROM node:20-alpine AS builder
WORKDIR /app

# Update npm
RUN npm install -g npm@11

# Copy package files
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY packages ./packages
COPY extensions ./extensions
COPY translations ./translations
# Nếu folder config có trong repo

# Build
RUN npm run build

EXPOSE 80

CMD ["npm", "run", "start"]
