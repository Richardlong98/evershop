# --- Stage 1: Build & Install Dependencies (Builder) ---
# Sử dụng Node 20 Alpine làm base image cho quá trình build (nhẹ và hiệu quả)
FROM node:20-alpine AS builder
WORKDIR /app

# Thiết lập môi trường là production để đảm bảo chỉ cài đặt dependency cần thiết
ENV NODE_ENV=production

# 1. Tối ưu caching: Copy file lock/package trước để cài đặt dependencies
COPY package.json package-lock.json ./

# Sử dụng 'npm ci' (clean install) và '--omit=dev' để chỉ cài đặt production dependencies
RUN npm ci --omit=dev

# 2. Copy mã nguồn (cấu trúc Evershop)
COPY packages ./packages
COPY extensions ./extensions
COPY translations ./translations
COPY config ./config

# 3. Build ứng dụng
RUN npm run build


# --- Stage 2: Minimal Runtime Image (Production Runner) ---
# Sử dụng lại Node 20 Alpine cho runtime để giữ image cuối cùng nhỏ gọn
FROM node:20-alpine
WORKDIR /app

# --- K8s Security Best Practice: Create and switch to a non-root user ---
# Tạo nhóm và người dùng 'nodejs' (UID/GID 1000 là tiêu chuẩn)
RUN addgroup -g 1000 nodejs && adduser -u 1000 -G nodejs -s /bin/sh -D nodejs
USER nodejs

# 1. Copy production node_modules và các file cần thiết (chỉ những thứ cần chạy)
# Sử dụng --chown để đảm bảo file thuộc về người dùng 'nodejs'
COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=nodejs:nodejs /app/package*.json ./

# 2. Copy các thư mục code đã được build
COPY --from=builder --chown=nodejs:nodejs /app/packages ./packages
COPY --from=builder --chown=nodejs:nodejs /app/extensions ./extensions
COPY --from=builder --chown=nodejs:nodejs /app/translations ./translations
COPY --from=builder --chown=nodejs:nodejs /app/config ./config

# Thiết lập biến môi trường
ENV NODE_ENV=production
ENV PORT=3000

# Expose cổng chuẩn của Node.js (tránh cổng 80/443 yêu cầu quyền root)
EXPOSE 3000

# K8s Ready CMD: Sử dụng định dạng exec form ([]) để xử lý tín hiệu tốt hơn
# Đây là lệnh khởi động ứng dụng
CMD ["npm", "run", "start"]
