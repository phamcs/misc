FROM wordpress:latest

# install Composer
COPY ./composer /usr/bin/composer

# update Composer to latest version
RUN chmod +x /usr/bin/composer
RUN /usr/bin/composer self-update

COPY . .

EXPOSE 80
