# 1. Stage build
FROM node:20-alpine AS builder
WORKDIR /app

# Update npm
RUN npm install -g npm@11

# Copy package.json và package-lock.json
COPY package.json package-lock.json ./

# Cài đặt dependencies
RUN npm install

# Copy toàn bộ thư mục cần thiết
COPY packages ./packages
COPY extensions ./extensions
COPY translations ./translations
COPY public ./public
COPY themes ./themes
COPY babel.config.js ./

# Build project (script 'build' ở root đã build tất cả packages)
RUN npm run build

# 2. Stage chạy
FROM node:20-alpine
WORKDIR /app

# Copy từ builder
COPY --from=builder /app .

EXPOSE 80

CMD ["npm", "run", "start"]

