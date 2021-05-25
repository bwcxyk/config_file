FROM nginx:stable-alpine

RUN rm -rf /usr/share/nginx/html/*

# file
COPY dist/tms /usr/share/nginx/html
COPY docker-entrypoint.sh /usr/local/bin/

#RUN chown -R nginx.nginx /usr/share/nginx/html

# listen
EXPOSE 80

# start
ENTRYPOINT ["sh","/usr/local/bin/docker-entrypoint.sh"]