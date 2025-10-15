FROM node:18-alpine

# Thư mục làm việc
WORKDIR /app

# Cập nhật npm
RUN npm install -g npm@9

# COPY package.json + package-lock.json
COPY package.json package-lock.json ./ 

# Cài dependencies
RUN npm install

# COPY source code
COPY packages ./packages
COPY themes ./themes
COPY extensions ./extensions
COPY public ./public
COPY media ./media
COPY config ./config
COPY translations ./translations

# Build app
RUN npm run build

# Expose port (theo app evershop mặc định là 3000)
EXPOSE 3000

# Command để chạy app
CMD ["npm", "run", "start"]
