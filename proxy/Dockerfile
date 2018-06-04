FROM nginx:1.10
COPY nginx.template.conf /etc/nginx/nginx.template.conf

# Replace the nginx configuration with the environment variables set by the docker composition file
CMD ["/bin/bash", "-c", "envsubst '${WEB_SERVER_URL_AND_PORT} ${API_SERVER_URL_AND_PORT_AND_PATH}' <  /etc/nginx/nginx.template.conf > /etc/nginx/nginx.conf && env && cat /etc/nginx/nginx.conf && nginx -g 'daemon off;'"]

EXPOSE 80