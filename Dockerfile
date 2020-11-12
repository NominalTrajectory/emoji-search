# Step 1. Making an image from node.js runtime 
FROM node:12-alpine as build-step

# Create a directory for app
RUN mkdir /app

# Set it as a work directory, it will automatically cd into that directory
WORKDIR /app

# From the current directory copy package.json file that contains all app dependencies
COPY package.json /app

# Install all dependencies (node_modules)
RUN npm install

# Copy the rest of the application files into work directory
COPY . /app

# Build the app static assets
RUN npm run build


# Stage 2 From image with Nginx webserver to run the application distribution files
FROM nginx:stable-alpine

# Set working direcotry to nginx asset directory
WORKDIR /usr/share/nginx/html

# Remove all default nginx static assets
RUN rm -rf ./*

# Copy the asset files from stage 1 into nginx asset directory
COPY --from=build-step /app/build .

# Copy nginx server configuration
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Containers run nginx with global directives and daemon off
CMD ["nginx", "-g", "daemon off;"]