# --- Stage 1: Build Node App ---
FROM node:20-alpine AS builder
WORKDIR /app

# Update npm
RUN npm install -g npm@11

# Copy package.json & package-lock.json và cài đặt dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy các thư mục tồn tại trên branch dev
COPY packages ./packages
COPY extensions ./extensions
COPY translations ./translations
COPY config ./config

# Build app
RUN npm run build

# --- Stage 2: Run App ---
FROM node:20-alpine
WORKDIR /app

# Copy từ stage builder
COPY --from=builder /app /app

# Expose port
EXPOSE 80

# Start ứng dụng
CMD ["npm", "run", "start"]
