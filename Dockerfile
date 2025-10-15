FROM node:20-alpine AS builder
WORKDIR /app

RUN npm install -g npm@11

COPY package.json package-lock.json ./
RUN npm install

# Copy các thư mục cần thiết
COPY packages ./packages
COPY extensions ./extensions
COPY translations ./translations

# Build TypeScript packages trước
RUN npm run build:ts

# Sau đó build toàn bộ Evershop
RUN npm run build

FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app .

EXPOSE 80
CMD ["npm", "run", "start"]
