# Stage 1: Build
FROM node:20-alpine AS builder
WORKDIR /app

# Cập nhật npm
RUN npm install -g npm@11

# Copy file lock & package.json
COPY package.json package-lock.json ./

# Cài dependencies
RUN npm install

# Copy các thư mục tồn tại
COPY packages ./packages
COPY extensions ./extensions
COPY translations ./translations

# Build toàn bộ app
RUN npm run build

# Stage 2: Run
FROM node:20-alpine
WORKDIR /app

# Copy từ stage build
COPY --from=builder /app .

EXPOSE 80
CMD ["npm", "run", "start"]
