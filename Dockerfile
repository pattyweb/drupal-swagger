# Use a imagem oficial do Drupal como base
FROM drupal:latest
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
