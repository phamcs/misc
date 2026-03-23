FROM wordpress:latest

# install Composer
COPY ./composer /usr/local/bin/composer

# update Composer to latest version
RUN chmod +x /usr/local/bin/composer
RUN /usr/local/bin/composer self-update

COPY . .

EXPOSE 80
