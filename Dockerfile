
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

# Build a react app, it will execute react-scripts build
RUN npm run build


# Stage 2 From image with Nginx webserver to run the application distribution files
FROM nginx:1.19.4-alpine

# Copy the output files from stage 1 into nginx folder with html files
COPY --from=build-step /app/build /usr/share/nginx/html