FROM wordpress:latest

# install Composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# update Composer to latest version
RUN composer self-update

COPY . .

EXPOSE 80
