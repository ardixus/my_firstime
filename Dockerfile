# Use a lightweight web server image
FROM nginx:alpine

# Copy the HTML file to the nginx html directory
COPY src/index.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80

