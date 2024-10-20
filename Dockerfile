# Use the Drupal 11.0 image with PHP 8.3 and Apache
FROM drupal:11.0-php8.3-apache

# Habilitar output_buffering no PHP
RUN echo "output_buffering = 4096" >> /usr/local/etc/php/conf.d/99-custom.ini

# Install Redis and the MySQL client
RUN apt-get update && apt-get install -y libz-dev libpq-dev default-mysql-client \
    && pecl install redis \
    && docker-php-ext-enable redis

# Copie o script de inicialização para o contêiner
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

# Dê permissão de execução ao script
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expor a porta padrão do Apache
EXPOSE 80

# Use o script como entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
