# --- Stage 1: Build Node App ---
FROM node:20-alpine AS builder
WORKDIR /app

# Cập nhật npm
RUN npm install -g npm@11

# Copy package.json và lock file
COPY package.json package-lock.json ./

# Cài dependencies
RUN npm install

# Copy các folder có thật trong repo
COPY packages ./packages
COPY extensions ./extensions
COPY media ./media
COPY config ./config
COPY translations ./translations

# Build app
RUN npm run build

# --- Stage 2: Prepare Production Image ---
FROM node:20-alpine
WORKDIR /app

# Copy từ builder
COPY --from=builder /app /app

# Cài production dependencies
RUN npm ci --only=production

# Mở port
EXPOSE 80

# Chạy app
CMD ["npm", "run", "start"]
