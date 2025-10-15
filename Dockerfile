# --- Stage 1: Build Evershop app ---
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Cập nhật npm
RUN npm install -g npm@11

# Copy package.json và package-lock.json
COPY package.json package-lock.json ./

# Cài dependencies
RUN npm install

# Copy tất cả các thư mục cần thiết (bỏ themes nếu không có)
COPY packages ./packages
COPY extensions ./extensions
COPY public ./public
COPY media ./media
COPY config ./config
COPY translations ./translations

# Build app
RUN npm run build

# --- Stage 2: Run app ---
FROM node:20-alpine

WORKDIR /app

# Copy từ stage builder
COPY --from=builder /app /app

# Install production dependencies nếu cần (nếu có "optionalDependencies" trong package.json)
RUN npm ci --only=production

# Expose port 80
EXPOSE 80

# Chạy app
CMD ["npm", "run", "start"]
